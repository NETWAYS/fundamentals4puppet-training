!SLIDE smbullets small
# Variables

* Syntax
<pre>
$variable = 'value'<br>
$httpd_confdir = '/etc/httpd/conf.d'
</pre>
* Can be used in expressions, functions and resource attributes
* Some naming conventions enforced, some keywords reserved
* Depending on scope
* Different data types
* Actually are _constants_!

~~~SECTION:handouts~~~

****

In Puppet variables are prefixed with '$' and can be used in expressions, functions and resource attributes
including the title. In variable names only uppercase and lowercase letters, numbers and underscores are allowed.
The names have to start with lowercase letter or underscore indicating internal use only. Also the style guide
does not allow uppercase letters for inconsistency in style.

~~~PAGEBREAK~~~

They have to be defined before using them and this definition depends on the scope also Puppet 4 introduced
an optional data type system for some specific use cases. In older versions all data types were simply handled
internally and converted automatically if possible. More on scope and data types on the next pages.

One very important thing about variables in Puppet to know is that they are actually constants as you can not
reassign values.

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Scope

<center><img src="./_images/scope-euler-diagram.png" style="width: 687px; height: 560px;" alt="Scope"></center>

!SLIDE smbullets small printonly
# Scope

<center><img src="./_images/scope-euler-diagram.png" style="width: 450px; height: 367px;" alt="Scope"></center>

~~~SECTION:handouts~~~

****

The picture above shows the different scopes. For all except the Top Scope we will learn the required
definition later. In our simply manifest only Top Scope is available for now.

~~~PAGEBREAK~~~

The **Top Scope** contains all variables and defaults declared outside of class, type or node definitions.
Those are available everywhere.

The **Node Scope** contains all code inside a node definition. Because only one node definition will be
matched by a node this scope is node specific. Variables in this scope can be accessed everywhere expect
the Top Scope.

The **Local Scope** of a class is only available in this class and children.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Accessing Variables in a specific scope

* Shortname accesses Local Scope
 * Static scope in Puppet 4
 * Dynamic scope in older versions
<pre>$httpd_confdir</pre>
* Qualified name accesses scope defined by namespace
 * Top Scope (also contains facts) and Node Scope
<pre>$::osfamily</pre>
 * Out-of-Scope
<pre>$apache::params::confdir</pre>

~~~SECTION:handouts~~~

****

Puppet allows to access variables in a specific scope. If the shortname of a variable is used it will
be using the value defined in the Local Scope. If the variable is not defined in Local Scope it will
searched in a static scope build on inheritance of the classes, node and top scope. This is much more
predictable then the dynamic scope used in older versions creating a scope graph by inheritance and
declaration.

Facts provided by Facter are available from the Top Scope and can be used like every other variable.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Data Types

* **Completely optional**
* Simple Data Types
 * Strings
 * Numbers
 * Booleans
 * Arrays
 * Hashes
 * Regular Expressions
 * Undef
 * Resource References
 * Default
* Abstract Data Types
 * Flexible Data Types
 * Parent Types

~~~SECTION:handouts~~~

****

Puppet 4 introduced a data type system which allows the user to define a variable of a specific data type.
In older versions all data types were simply handled internally and converted automatically if possible,
if you do not specify a data type for a variable in Puppet 4 it will still use this behaviour. These data
types can only be used parameter lists, match expressions, case statements and selector expressions and **not**
for variables.

~~~PAGEBREAK~~~

There are the typical simple data types like Strings, Numbers, Booleans, Arrays and Hashes and others are more
specific to Puppet. In addition there are abstract data types which can be used to enforce a more specfic
value or allow to validate more flexible without having to deal with something weird.

All details on https://docs.puppet.com/puppet/latest/reference/lang_data.html

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Variables

* Objective:
 * Rework your vhost manifest to include variables
* Steps:
 * Add variables for hostname, fqdn, ip address of your vhost
 * Add variables for apache's configuration directory and your vhost's document root
 * Incorporate the variables in your resource declarations


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Variables

## Objective:

****

* Rework your vhost manifest to include variables

## Steps:

****

* Add variables for hostname, fqdn, ip address of your vhost
* Add variables for apache's configuration directory and your vhost's document root
* Incorporate the variables in your resource declarations

#### Expected Result:

Applying your reworked manifest does not change anything on your system.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Variables

****

## Rework your vhost manifest to include variables

****

### Add variables for hostname, fqdn, ip address of your vhost

Because of the facts hostname, fqdn and ipaddress you can not use these names for your variables.

    $ vim ~/puppet/manifests/vhost.pp
    $shortname = 'vhost'
    $fullname = "${shortname}.localdomain"
    $ip = '127.0.0.1'

### Add variables for apache's configuration directory and your vhost's document root

    $ vim ~/puppet/manifests/vhost.pp
    $confdir = '/etc/httpd'
    $documentroot = "/var/www/${fullname}"

### Incorporate the variables in your resource declarations

    $ vim ~/puppet/manifests/vhost.pp
    host { $fullname:
      ip           => $ip,
      host_aliases => [ $shortname ],
    }
    
    file { "${confdir}/conf.d/${shortname}.conf":
      ensure => file,
      source => "/home/training/puppet/files/${shortname}.conf",
    }
    
    file { $documentroot:
      ensure => directory,
    }
    
    file { "${documentroot}/index.html":
      ensure  => file,
      content => '<h1>Hello World</h1>',
    }
