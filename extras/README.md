**[DEPRECATED] This repository is no longer maintained**
> While this project is fully functional, the content is no longer maintained and therefore is no longer up to date. You are still welcome to explore, learn, and use the code provided here.

# Cassandra Box Extras

![No longer maintained](https://img.shields.io/badge/maintenance-OFF-red.svg?&style=flat-square)

Extra files and templates for the Cassandra box.

## Synopsis

The files, scripts and templates found on this folder can be used to extend the
features of the Cassandra Vagrant box.

## Getting Started

Download the files required for the extra feature that you want and use them
as described on this documentation.

## Features

### Cassandra Cluster

It is possible to use the Cassandra box, built with the main recipe, to create
a Cassandra cluster.

#### Required Files

To create a Cassandra cluster the following files have to be downloaded and
copied to a local folder:

- `Vagrantfile`
- `config.rb.sample`

#### Usage

In order to instantiate a Cassandra cluster a few steps are required.

- Copy the required files to a folder.
- Change the name of the `config.rb.sample` file to `config.rb`.
- Edit the `config.rb` file.

Change the value of the variable `cassandra_instances_number` to the number of
instances that the cluster should have.

You can also change the internal cluster network addressing space by setting a
new one. To change the default network addressing space change the value of the
`cassandra_network_cidr` variable to the desired CIDR notation address.

After all the editing have been done, start the Cassandra cluster with the
following command (execute it on the same folder as the files):

```
vagrant up
```

**Note:** If you added the Cassandra box, created with the main recipe, to
Vagrant with a different name or if you build your own box with a custom name
you also have to edit the `Vagrantfile.tpl` file and change the value of the
`config.vm.box` variable to the correct name of the vagrant box.

## Contributing

Contributing to this project is no longer possible since the project is no
longer maintained.

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/packer-vagrant-cassandra/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/packer-vagrant-cassandra/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE)
file for details
