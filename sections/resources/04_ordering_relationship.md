!SLIDE smbullets small
# Ordering

* Default order depends on order of declaration and implicit dependencies
* Ordering can be changed to:
 * Hash based ordering which was default in older versions
 * Random ordering to ensure all necessary dependencies are declared
* Dependencies can be set explicitly

~~~SECTION:handouts~~~

****

Puppet 4 applies unrelated resources in the order of declaration only taking implicit
dependencies into account. The default ordering before Puppet 4 was hash based which
was random but predictable accross agent runs and systems. The configuration also allows
to set it explicitly to random which always randomizes the order of unrelated resources
on every run. This mode is helpful to find necessary dependencies which are not declared
explicitly.

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Implicit Dependencies

<img src="./_images/implicit_dependencies.png" style="float: center; margin-left: 50px; width: 800px; height: 492px;" alt="Implicit Dependencies">

!SLIDE smbullets small printonly
# Implicit Dependencies

<center><img src="./_images/implicit_dependencies.png" style="width: 480px; height: 295px;" alt="Implicit Dependencies"></center>

~~~SECTION:handouts~~~

****

The picture above shows an overview of the most important implicit dependencies.
A dependency is only created if both resources are managed by Puppet.

Two more detailed examples are shown on the next sides. To find all implicit dependencies 
have a look on the Autorequires description of the resources on:
https://docs.puppet.com/puppet/latest/reference/type.html

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Implicit Dependencies - User

<img src="./_images/implicit_dependencies_user.png" style="float: center; margin-left: 50px; width: 800px; height: 448px;" alt="Implicit Dependencies - User">

!SLIDE smbullets small printonly
# Implicit Dependencies - User

<center><img src="./_images/implicit_dependencies_user.png" style="width: 480px; height: 269px;" alt="Implicit Dependencies - User"></center>

~~~SECTION:handouts~~~

****

In this case the order of the resources will be group before user before the other resources in order of writing.
This is because of the user depending on the group configured as its gid. The file depends on its owner which is
the managed user and its group which is also the group of the user. The ssh authorized key and the cronjob depend
on their configured user.

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Implicit Dependencies - Exec

<img src="./_images/implicit_dependencies_exec.png" style="float: center; margin-left: 50px; width: 800px; height: 419px;" alt="Implicit Dependencies - Exec">

!SLIDE smbullets small printonly
# Implicit Dependencies - Exec

<center><img src="./_images/implicit_dependencies_exec.png" style="width: 480px; height: 251px;" alt="Implicit Dependencies - Exec"></center>

~~~SECTION:handouts~~~

****

The exec resource will autorequire a file if it is the command to be executed, the directory if it should be used
as working directory, the user and group which are used to execute the command.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Explicit Dependencies

* 4 types of relationship
* Defined by metaparameter of all resources
* Simple Ordering:
 * *require* - referenced resource will be applied first
 * *before* - apply this resource before the reference
* Refresh Events:
 * *subscribe* - if reference is changed refresh this resource
 * *notify* - if this resource is changed refresh the reference

~~~SECTION:handouts~~~

****

Explicit Dependencies can be defined in four different ways by adding the corresponding metaparameter.
This metaparameter attributes exist for all resources.

Syntax examples will be shown on the next pages.

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Explicit Dependencies - Ordering

<img src="./_images/explicit_dependencies_ordering.png" style="float: center; margin-left: 50px; width: 800px; height: 300px;" alt="Explicit Dependencies - Ordering">

!SLIDE smbullets small printonly
# Explicit Dependencies - Ordering

<center><img src="./_images/explicit_dependencies_ordering.png" style="width: 450px; height: 169px;" alt="Explicit Dependencies - Ordering"></center>

~~~SECTION:handouts~~~

****

In the picture above the underlined parameters show the dependency which will in both cases result
in a installation of the package "openssh-server" before deploying the configuration file "sshd_config".

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Explicit Dependencies - Refresh

<img src="./_images/explicit_dependencies_refresh.png" style="float: center; margin-left: 50px; width: 800px; height: 300px;" alt="Explicit Dependencies - Refresh">

!SLIDE smbullets small printonly
# Explicit Dependencies - Refresh

<center><img src="./_images/explicit_dependencies_refresh.png" style="width: 450px; height: 169px;" alt="Explicit Dependencies - Refresh"></center>

~~~SECTION:handouts~~~

****

In case of the example above the underlined parameters will trigger a refresh event on the service "sshd"
if the configuration file "sshd_config" is changed. For services a refresh event will restart the service,
on other resources the behaviour differs, for example an exec resource can run a different command on
refresh than on a normal run or can be configured to run only on refresh.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Reference Syntax

Allows to reference other managed resources

<pre>
Type['title']
</pre>

<pre>
Service['sshd']
</pre>

~~~SECTION:handouts~~~

****

Another new syntax was introduced in the example for dependencies: the reference of a resource.

The syntax schema is the resource type as uppercase and the title in square brackets for example
`Service['sshd']`.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Dependency Chains

* Alternative syntax for explicit dependency
* Works great with references
* Simple Ordering:
 * *before*: Package['openssh-server'] **->** File['sshd_config']
 * *require*: Package['openssh-server'] **<-** File['sshd_config']
* Refresh Events:
 * *notify*: File['sshd_config'] **~>** Service['sshd']
 * *subscribe*: File['sshd_config'] **<~** Service['sshd']
* For readability use *before* (**->**) and *notify* (**~>**)!

~~~SECTION:handouts~~~

****

The chaining arrow syntax is an alternative syntax for explicit dependencies which works great
with references. According to the style guide you should prefer the metaparameters but in case
of interdependent or order-specific items it is quite helpful.

In these cases using the references to declare the dependencies outside of the declaration of
resources increases the readability and also allows to change ordering depending on parameters.

Also if both directions exist you should avoid the arrows pointing backwards because of readability
and stick to those pointing left to right.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Package-File-Service Pattern

* Objective:
 * Install and run the Apache webserver
* Steps:
 * Ensure package "httpd" is installed
 * Manage its configuration file "/etc/httpd/conf/httpd.conf"
 * Enable and start the service "httpd"
 * Add dependencies to make sure it is installed before you configure it and config changes restart the service
 * Apply the manifest
 * Add the "Servername" to the configuration and apply again

~~~SECTION:handouts~~~

****

This design of Puppet code is known as Package-File-Service pattern. If a service depends on multiple files
they are typically grouped in a separate class and dependencies are enforced on this level. We will do this
later after introducing the concept of classes.

~~~ENDSECTION~~~

!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Package-File-Service Pattern

## Objective:

****

* In this lab you will install, configure and run the Apache webserver

## Steps:

****

* Ensure package "httpd" is installed
* Manage its configuration file "/etc/httpd/conf/httpd.conf", copy the original file to your home directory as a source
* Enable and start the service "httpd"
* Add dependencies to make sure it is installed before you configure it and config changes restart the service
* Apply the manifest
* Add the "Servername" to the configuration and apply again to see the service being restarted

#### Expected Result:

Pointing your browser to http://agent-centos.localdomain/ will show you the test page of Apache on CentOS.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Package-File-Service Pattern

****

## Install and run the Apache webserver

****

### Ensure package "httpd" is installed

Create a new manifest "apache.pp" and declare a package resource "httpd" to be installed.

    $ cd ~/puppet/manifests/
    $ vim apache.pp
    package {'httpd':
      ensure => present,
    }

### Manage its configuration file "/etc/httpd/conf/httpd.conf", copy the original file to your home directory as a source

Copy the original configuration file to the "puppet/files" directory in your home directory as a source and then add a file resource managing "/etc/httpd/conf/httpd.conf"
to your manifest. To get the file install the apache package manually oder run the apply command on your manifest before doing this step.

    $ cp /etc/httpd/conf/httpd.conf ~/puppet/files/httpd.conf
    $ vim apache.pp
    file {'/etc/httpd/conf/httpd.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => '/home/training/puppet/files/httpd.conf',
    }

### Enable and start the service "httpd"

Add a service resource which enables and starts "httpd".

    $ vim apache.pp
    service {'httpd':
      ensure    => running,
      enable    => true,
    }

### Add dependencies to make sure it is installed before you configure it and config changes restart the service

With Puppet 4's manifest based ordering the three resource would already be applied in correct order, but no refresh
would happen. Also understanding the code is easier if dependencies are explicitly declared.

    $ vim apache.pp
    package {'httpd':
      ...
    }
    
    file {'/etc/httpd/conf/httpd.conf':
      ...
      require => Package['httpd'],
    }
    
    service {'httpd':
      ...
      subscribe => File['/etc/httpd/conf/httpd.conf'],
    }


### Apply the manifest

Save the manifest and then enforce it.

    $ puppet apply apache.pp

### Add the "Servername" to the configuration and apply again to see the service being restarted

Open your copy of the configuration file and add the "Servername" directive, then apply again to if the service gets restarted
after changing its configuration.

    $ vim ~/puppet/files/httpd.conf
    Servername agent-centos.localdomain:80

    $ sudo puppet apply apache.pp


!SLIDE smbullets small
# Exec Resource

* Resource to execute commands
* Avoid if possible
* If required use an attribute for idempotence
 * creates
 * onlyif / unless
 * refreshonly
* Use full path or provide path as attribute

<!-- -->
    exec { 'command':
      path        => '/usr/sbin/:/sbin/',
      refreshonly => true,
      timeout     => 60,
    }

~~~SECTION:handouts~~~

****

The exec resource is used to execute commands so it should be avoided if possible.

If it is required use an attribute to ensure idempotence. The "creates" attribute points to a file which is created by the
command and the command will not be executed as long as the file exists. "Onlyif" or "unless" can be used to run a script
before the execution of the defined command and depending of their exit code the command will be executed. "Refreshonly"
can be used to execute a command only if it gets a refresh event from another resource.

The command has to be defined with the full path or the attribute "path" has to provide a list seperated by ":" or an array.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Exec Resource

* Objective:
 * Add an exec resource to change restart behaviour
* Steps:
 * Add an exec resource to restart apache
 * Change the service resource to reload instead of restart
 * Change the file resource to notify the exec instead of the service
 * Apply the manifest

~~~SECTION:handouts~~~

****

This adjustment is common for services which loose information during restart but not during reload like Apache loosing sessions.

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Exec Resource

## Objective:

****

* Add an exec resource to change restart behaviour

## Steps:

****

* Add an exec resource to restart apache using systemctl
* Change the service resource to reload instead of restart with a systemctl command in the restart attribut
* Change the file resource to notify the exec instead of the service
* Apply the manifest

!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Exec Resource

****

## Add an exec resource to change restart behaviour

****

### Add an exec resource to restart apache using systemctl

    $ vim ~/puppet/manifests/apache.pp
    exec { 'apache-restart':
      command     => 'systemctl restart httpd',
      path        => '/usr/bin:/usr/sbin:/bin:/sbin',
      refreshonly => true,
    }

### Change the service resource to reload instead of restart with a systemctl command in the restart attribut

    $ vim ~/puppet/manifests/apache.pp
    service {'httpd':
      ...
      #subscribe => File['/etc/httpd/conf/httpd.conf'],
      restart   => '/usr/bin/systemctl reload httpd',
    }

### Change the file resource to notify the exec instead of the service

    $ vim ~/puppet/manifests/apache.pp
    file {'/etc/httpd/conf/httpd.conf':
      ...
      require => Package['httpd'],
      notify  => Exec['apache-restart'],
    }

### Apply the manifest

Change something in the configuration file and apply the manifest.

    $ sudo puppet apply apache.pp

Now you can decide in which cases a restart is required and when a reload is enough.
