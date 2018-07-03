!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: User

* Objective:
 * Create yourself a user
* Steps:
 * Create a manifest to manage your user
 * Declare your personal user including its shell
 * Set it to also manage your home directory
 * Apply the manifest

~~~SECTION:handouts~~~

****

Puppet's user management is primary designed for managing system users
or a small amount of administrative users. User management is still done
best by central authentication services like ldap and kerberos.

The file extension for files containing Puppet code is .pp, those files
are called manifests. A syntax validation for this files can be done with
"puppet parser validate".

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: User

## Objective:

****

* In this lab you will create yourself a user using puppet

## Steps:

****

* Create a manifest "user.pp" to manage your user
* Declare your personal user including its shell as "/bin/bash"
* Set it to also manage your home directory
* Apply the manifest with "puppet apply user.pp"

#### Expected result:

Your personal user and its home directory is created.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: User

## Create yourself a user

****

### Create a manifest "user.pp" to manage your user

Change to the directory "manifests" and create "user.pp"

    $ cd ~/puppet/manifests/
    $ vim user.pp

### Declare your user including its shell as "/bin/bash"

Declare your user with your typically username, ensure that he is present
and set its shell to "/bin/bash"

    $ ~/puppet/manifests/user.pp
    user { 'myuser':
      ensure => present,
      shell  => '/bin/bash',
    }
    

### Set it to also manage your home directory

Enforcing the user now would create your home directory depending on the default of your
operatingsystem, to enforce its creation set the attribute "managehome" to true.

    $ vim ~/puppet/manifests/user.pp
    user { 'myuser':
      ensure     => present,
      shell      => '/bin/bash',
      managehome => true,
    }

### Apply the manifest with "puppet apply user.pp"

Save the manifest and then use "puppet apply" to enforce it. Add "--noop" if you want to simulate
first, add "-d" if you want to see the commands executed. If you are not sure about the syntax run
the syntax validation before.

    $ puppet parser validate ~/puppet/manifests/user.pp
    $ sudo puppet apply --noop ~/puppet/manifests/user.pp
    $ sudo puppet apply -d ~/puppet/manifests/user.pp

To verify the user's existence you can use "id" or "getent", also verify the creation of the home directory
with "ls -la".

    $ sudo id myuser
    $ sudo getent passwd myuser
    $ sudo ls -la /home/myuser/


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Group

* Objective:
 * Manage the group membership of your user
* Steps:
 * Add a group definition for your user's private group to your manifest
 * Add a group definition for a administrative group to your manifest
 * Change your user definition to set its private group as its primary group and the administrative group as secondary
 * Apply the manifest

~~~SECTION:handouts~~~

****

The user attribute _groups_ is an array. Puppet uses the same notation for arrays like ruby, a comma separated list of
elements in square brackets.

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Group

## Objective:

****

* In this lab you will manage your users group membership

## Steps:

****

* Add a group definition for your user's private group to your manifest (a group with the same name)
* Add a group definition for a administrative group "admins" to your manifest 
* Change your user definition to set its private group as its primary group and the administrative group as secondary
* Apply the manifest with "puppet apply user.pp"

#### Expected result:

Your personal user is member of the newly created groups.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Group

****

## Manage the group membership of your user

****

### Add a group definition for your user's private group to your manifest (a group with the same name)

Open your manifest user.pp and add a group resource.

    $ vim ~/puppet/manifests/user.pp
    group { 'myuser':
      ensure => present,
    }

### Add a group definition for a administrative group "admins" to your manifest 

Add another group resource.

    $ vim ~/puppet/manifests/user.pp
    group { 'admins':
      ensure => present,
    }


### Change your user definition to set its private group as its primary group and the administrative group as secondary

Add the groups to your user definition

    $ vim ~/puppet/manifests/user.pp
    user { 'myuser':
      ensure     => present,
      shell      => '/bin/bash',
      gid        => 'myuser',
      groups     => [ 'admins' ],
      managehome => true,
    }

### Apply the manifest with "puppet apply user.pp"

Save the manifest and then use "puppet apply" to enforce it. Add "--noop" if you want to simulate
first, add "-d" if you want to see the commands executed.

    $ sudo puppet apply --noop ~/puppet/manifests/user.pp
    $ sudo puppet apply -d ~/puppet/manifests/user.pp

To verify the user's group membership you can use "id".

    $ sudo id myuser


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: SSH Authorized Key

* Objective:
 * Grant your user access to the system authenticated by a ssh key
* Steps:
 * Generate a ssh key on your laptop
 * Add a ssh_authorized_key resource to distribute your public key
 * Apply the manifest

~~~SECTION:handouts~~~

****

Make sure to use the proper attributes of the ssh_authorized_key resource. Type, key and comment are separated!

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: SSH Authorized Key

## Objective:

****

* You will grant your user access to the system authenticated by a ssh key

## Steps:

****

* Generate a ssh key on your laptop using "ssh-keygen"
* Add a ssh_authorized_key resource to distribute your public key
* Apply the manifest with "puppet apply user.pp"

#### Expected result:

Your personal user can login into your system without a password.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: SSH Authorized Key

****

## Grant your user access to the system authenticated by a ssh key

****

### Generate a ssh key on your laptop using "ssh-keygen"

Open a terminal on your laptop and execute "ssh-keygen". Keep the passphrase empty if you like.

    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/training/.ssh/id_rsa): /home/training/.ssh/training_ssh
    Created directory '/home/training/.ssh'.
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    Your identification has been saved in /home/training/.ssh/training_ssh.
    Your public key has been saved in /home/training/.ssh/training_ssh.pub.

    $ cat ~/.ssh/training_ssh.pub

### Add a ssh_authorized_key resource to distribute your public key

Add a ssh_authorized_key resource to distribute your public key. The first part of the output of
the command above is the type, the second one is the key itself and the third is the comment which
you are not required to keep.

    $ vim ~/puppet/manifests/user.pp
    ssh_authorized_key { 'myuser':
      ensure => present,
      type   => 'ssh-rsa',
      key    => '...',
      user   => 'myuser',
    }

### Apply the manifest with "puppet apply user.pp"

Save the manifest and then use "puppet apply" to enforce it. Add "--noop" if you want to simulate
first, add "-d" if you want to see the commands executed.

    $ sudo puppet apply --noop ~/puppet/manifests/user.pp
    $ sudo puppet apply -d ~/puppet/manifests/user.pp

To verify the login try to connect to the virtual machine from your laptop.

    $ ssh myuser@agent-centos.localdomain


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Sudoers

* Objective:
 * Grant your user administrative privileges using sudo
* Steps:
 * Ensure package "sudo" is installed
 * Manage a file in "/etc/sudoers.d" for your user allow to execute all commands as root
 * Apply the manifest

~~~SECTION:handouts~~~

****

File permissions on files on "/etc/sudoers.d" is as important as syntax. Make sure to have a session as
"root" open before doing any changes because you can deny access via sudo at all by failures.

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Sudoers

## Objective:

****

* You will grant your user administrative privileges using sudo

## Steps:

****

* Ensure package "sudo" is installed
* Manage a file in "/etc/sudoers.d" for your user allow to execute all commands as root

Permissions are read-only for owner "root", nothing for group "root" and other. Syntax is 'myuser ALL=(ALL) ALL'
and has to be followed by a newline. Password input is required by default which can be remove by including "NOPASSWD".

* Apply the manifest with "puppet apply user.pp"

#### Expected result:

Your personal user can run commands as root via sudo.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Sudoers

****

## Grant your user administrative privileges using sudo

****

### Ensure package "sudo" is installed

Edit your manifest to include a definition ensuring the package "sudo" is installed.

    $ vim ~/puppet/manifests/user.pp
    package { 'sudo':
      ensure => present,
    }

### Manage a file in "/etc/sudoers.d" for your user allow to execute all commands as root

Add a file resource "/etc/sudoers.d/myuser" with owner "root", group "root", mode "0400" and content
"myuser ALL=(ALL) NOPASSWD: ALL".

    $ vim ~/puppet/manifests/user.pp
    file { '/etc/sudoers.d/myuser': 
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => "myuser ALL=(ALL) NOPASSWD: ALL\n",
    }

### Apply the manifest with "puppet apply user.pp"

Save the manifest and then use "puppet apply" to enforce it. Add "--noop" if you want to simulate
first, add "-d" if you want to see the commands executed.

    $ sudo puppet apply --noop ~/puppet/manifests/user.pp
    $ sudo puppet apply -d ~/puppet/manifests/user.pp

You can verify the sudo permissions by displaying them with sudo or testing it as the user.

    $ sudo -U myuser -l

    myuser$ sudo -l
    myuser$ sudo id
