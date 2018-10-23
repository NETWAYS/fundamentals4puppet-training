# Setup

The original project for these files is the version of [NETWAYS](https://github.com/NETWAYS/fundamentals4puppet-training). All others are forks and might be used to create pull requests and patches.

# Requirements

* Vagrant, recommended version >1.8
* Virtualbox
* r10k, version depends on ruby version (optional)

On the over hand you can use puppet module install instead of r10k to install all modules in the version described in puppet/environments/production/Puppetfile.

Example for OSX:

    $ sudo gem install r10k

Example for CentOS 7:

    $ sudo gem install r10k --version 2.2.0

# Setup

    $ cd puppet/environments/production
    $ r10k puppetfile install

# Run

    $ vagrant up --provider virtualbox

Three virtual machines are started. The puppet master is named 'puppet.localdomain', an agent based on CentOS 'agent-centos.localdomain' and the other agent based on Debian 'agent-debian.localdomain'. You can use a SSH connection to all virtual machines like described in the training or via:

    $ vagrant ssh puppet.localdomain

After the succesful connect you are allowed to go to root.

    $ sudo -i

Note: The root password is different to the one in the training, it's 'vagrant' of course.
