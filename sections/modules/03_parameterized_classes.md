!SLIDE smbullets small
# Parameterized Classes

* Classes can take parameters to change their behaviour
* The parameters can have a defined data type with Puppet 4
* Also with parameters a class is still a singleton

<pre>
class apache (
  Enum['running','stopped'] $ensure        = 'present',
  Boolean                   $enable        = true,
  Boolean                   $default_vhost = false,
  Hash[String, String]      $vhosts        = {},
) {
  ...
}
</pre>

~~~SECTION:handouts~~~

****

In Puppet classes can take parameters to change their behaviour to represent different
configurations. The parameters can have a defined data type with Puppet 4 which allows
for an easy validation, in Puppet 3 you had to stick to the validate functions provided
by puppetlabs/stdlib module.

Keep in mind also with parameters you can only handle one use case on one node because
classes are still singletons and can not be applied multiple times with different parameter
sets.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Declaring Parameterized Classes

* `include` function takes a class with all its defaults
* you can declare a class like every resource with parameters

<pre>
class {'apache':
  ensure        => running,
  default_vhost => true,
}
</pre>

~~~SECTION:handouts~~~

****

To declare a parameterized class you can use the `include` function if you are fine
with all the defaults. This allows for including the class multiple times because
the include function will on declare a class not already declared.

Declaring a class like a resource can not be done multiple times but allows to
set parameters in the same way you set attributes of other resources.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Parameterized Class

* Objective:
 * Parameterize your apache class
* Steps:
 * Promote the variable "$ensure" to be a parameter that handles the apache service
 * Add a parameter "$enable" to set the behaviour during the system start
 * Add a boolean parameter "$ssl" managing ssl support
 * Write some smoke tests


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Parameterized Class

## Objective:

****

* Parameterize your apache class

## Steps:

****

* Promote the variable "$ensure" to be a parameter that handles the apache service
* Add a parameter "$enable" to set the behavoir during the system start
* Add a boolean parameter "$ssl" managing ssl support

To add ssl support on CentOS installing the package mod_ssl and reloading the apache
web service is enough. Optionally you can add Debian support.

* Add a smoke test for a stopped webserver
* And a smoke test to test "$enable" for ssl


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Parameterized Class

****

## Parameterize your apache class

****

### Promote the variable "$ensure" to be a parameter

Change your class to provide a parameter "$ensure" which takes "running" and "stopped" with
a default of "running". And a Boolean parameter named "$enable" with a default to "true". Both
have to manage the service.

    $ vim ~/puppet/modules/apache/manifests/init.pp
    class apache (
      Enum['running','stopped'] $ensure = 'running',
      Boolean                   $enable = true,
    ) {
      ...
      #$ensure = 'present'

      if $ensure == 'absent' {
        ...
        #$enable_service = false
      } else {
        ...
        #$enable_service = true
      }

      service { 'httpd':
        ensure => $ensure_service,
        enable => $enable,
      }
    }

### Add a boolean parameter "$ssl" managing ssl support

Add a boolean parameter "$ssl". Its default is "false", but if changed to "true" on CentOS
the package "mod_ssl" should be installed and the service "httpd" should be notified. You
can also handle the case of "absent" but package dependencies would be enough in this simple
setup.

    $ vim ~/puppet/modules/apache/manifests/init.pp
    class apache (
      ...
      Boolean                   $ssl = false,
    ) {
      if $::osfamily == 'RedHat' {
        package { 'mod_ssl':
          ensure => $ssl ? {
            true    => installed,
            default => absent,
          }
        }
      }
      ...
    }

### Add a smoke test for running and to enable ssl

Creating a smoke test allows you to validate your parameterized class.

    $ vim ~/puppet/modules/apache/examples/init_stopped.pp 
    class { 'apache':
      ensure => stopped,
    }

    $ sudo puppet apply --modulepath ~/puppet/modules/ ~/puppet/modules/apache/examples/init_stopped.pp

    $ vim ~/puppet/modules/apache/examples/init_ssl.pp 
    class { 'apache':
      ssl => true,
    }

    $ sudo puppet apply --modulepath ~/puppet/modules/ ~/puppet/modules/apache/examples/init_ssl.pp
