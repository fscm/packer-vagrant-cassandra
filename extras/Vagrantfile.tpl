# encoding: utf-8

# -*- mode: ruby -*-
# vi: set ft=ruby :

# For network calculation...
require 'ipaddr'

# Internal Network CIDR
$cassandra_network_cidr ||= "172.16.0.16/28"

# Number of Cassandra servers
$cassandra_instances_number ||= 1

# Override default values if defined
CONFIG ||= File.join(File.dirname(__FILE__), "config.rb")
if File.exist?(CONFIG)
  require CONFIG
end

# Calculate the list of cluster seeds
cassandra_seeds ||= (1..$cassandra_instances_number).inject([IPAddr.new($cassandra_network_cidr)]){ |l, i| l << l.last.succ.to_s }[1..-1]

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION ||= "2"

# Vagrant version.
# version 1.8.0 is required due to issue https://github.com/mitchellh/vagrant/issues/5497
Vagrant.require_version ">= 1.8.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "fscm/cassandra"

  config.ssh.forward_agent = false
  config.ssh.forward_x11 = false
  config.ssh.keep_alive = true
  config.ssh.username = "pollywog"

  config.vm.box_check_update = true

  config.vm.network "forwarded_port", guest: 7000, host: 7000, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 7001, host: 7001, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 7199, host: 7199, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 9042, host: 9042, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 9142, host: 9142, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 9160, host: 9160, protocol: "tcp", auto_correct: true

  config.vm.communicator = "ssh"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/shared", create: true

  (1..$cassandra_instances_number).each do |instance|
    config.vm.define instance_name = "cassandra%02d" % instance do |config|
      config.vm.hostname = instance_name
      config.vm.network "private_network", ip: cassandra_seeds[instance - 1], auto_config: true
      config.vm.provision :shell, privileged: true, inline: "systemctl stop cassandra.service && echo service stoped"
      config.vm.provision :shell, privileged: true, inline: "rm -rf /srv/cassandra/data/* /srv/cassandra/logs/* && echo data cleaned up"
      config.vm.provision :shell, privileged: true, inline: "sed -i -r -e '/- seeds:/s/:.*/: \"" + cassandra_seeds.join(',') + "\"/' /srv/cassandra/conf/cassandra.yaml"
      config.vm.provision :shell, privileged: true, inline: "sed -i -r -e '/^listen_address:/s/:.*/: " + cassandra_seeds[instance - 1] + "/' /srv/cassandra/conf/cassandra.yaml"
      config.vm.provision :shell, privileged: true, inline: "sed -i -r -e '/^broadcast_address:/s/:.*/: " + cassandra_seeds[instance - 1] + "/' /srv/cassandra/conf/cassandra.yaml"
      config.vm.provision :shell, privileged: true, inline: "systemctl start cassandra.service && echo service started"
    end
  end
end
