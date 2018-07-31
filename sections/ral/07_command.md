!SLIDE smbullets small
# Puppet Resource Command

* Puppet provides a command to directly interact with the Resource Abstraction Layer
* Querying all or one resource of a type returns Puppet code representation of current state
* Setting attributes will change state using available provider

    <pre>
    # puppet resource package vim-enhanced
    package { 'vim-enhanced':
      ensure => 'purged',
    }<br>
    # puppet resource package vim-enhanced ensure=present
    Notice: /Package[vim-enhanced]/ensure: created
    package { 'vim-enhanced':
      ensure => '7.4.160-1.el7',
    }
    </pre>

~~~SECTION:handouts~~~

****

Puppet provides a command to directly interact with the Resource Abstraction Layer. `puppet resource` can be
used to query all or one resource of a specified type which will return current state represented as Puppet
code. It furthermore allows to set attributes to a desired state and then Resource Abstraction Layer will
find an available provider to enforce the state.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Resource

* Objective:
 * Use Puppet Resource Command to query and change resources
* Steps:
 * Query all users
 * Query state of the file "/etc/passwd"
 * Ensure package "vim-enhanced" is installed


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Resource

## Objective:

****

* In this lab you will use `puppet resource` to learn about Puppet's Resource Abstraction Layer.

## Steps:

****

* Query all users
* Query state of the file "/etc/passwd"
* Ensure package "vim-enhanced" is installed

#### Optional:

Run the commands with debug output to get a deeper look insight.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Resource

****

## Use Puppet Resource Command to query and change resources

****

### Query all users

    $ sudo puppet resource user

### Query state of the file "/etc/passwd"

    $ sudo puppet resource file /etc/passwd 

### Ensure package "vim-enhanced" is installed

    $ sudo puppet resource package vim-enhanced ensure=present
