!SLIDE smbullets small
# Classes

* Classes define a collection of resources

   <pre>
   class ssh {
     package  { 'openssh':
       ensure => present,
     }<br>
     file { '/etc/ssh/sshd_config':
       ensure  => file,
       owner   => 'root',
       group   => 'root',
       mode    => '0644',
       require => Package['openssh'],
     }<br>
     service { 'sshd':
       ensure  => running,
       enable  => true,
       require => File['/etc/ssh/sshd_config'],
     }
   }
   </pre>

~~~SECTION:handouts~~~

****

In Puppet Classes define a collection of resources. This is used to encapsulate related resources.
A good design is to create small classes only containing related resources grouped in a logic that
allows to be stack together in multiple ways.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Classes

* Objective:
 * Rework your apache manifest to provide a class apache
* Steps:
 * Rework your apache manifest to provide a class apache
 * During apply have a look on what Puppet is actually doing


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Classes

## Objective:

****

* Rework your apache manifest to provide a class apache

## Steps:

****

* Rework your apache manifest to provide a class apache
* During apply have a look on what Puppet is actually doing

#### Expected Result:

You will notice Puppet is not managing your resources when applying your class definition.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Classes

****

## Rework your apache manifest to provide a class apache

****

### Rework your apache manifest to provide a class apache

Simply add the class definition around your Puppet code.

    $ vim ~/puppet/manifests/apache.pp 
    class apache {
      ...
    }

### During apply have a look on what Puppet is actually doing

Use the debug option to have a look on what Puppet is actually doing while you try to apply
your class definition. You will notice it is not managing your resources.

    $ sudo puppet apply --debug ~/puppet/manifests/apache.pp 


!SLIDE smbullets
# Defining vs. Declaring

* Define:

To specify the contents and behavior of a class. Defining a class doesn't automatically 
include it in a configuration; it simply makes it available to be declared.

* Declare:

To direct Puppet to include or instantiate a given class. To declare classes, use the include
function. This tells Puppet to evaluate the class and manage all the resources declared within it.

~~~SECTION:handouts~~~

****

Puppet differentiates between defining and declaring a class. With the class syntax we only
defined it, to also declare it we could use the include or contain function or declare it
in the same syntax like other resources. The difference between these options will be shown
later.

~~~ENDSECTION~~~


!SLIDE smbullets
# Declaring Classes

* with `include` Function
<pre>
include apache
</pre>
* like any other resources
<pre>
class { 'apache': }
</pre>


!SLIDE smbullets
# Idempotency of include

* The function `include` is idempotent. That means you can use the include of the same class several times in your code.
<pre>
include apache
include apache
</pre>
* The class is declared just once, the first time it was used.
* Notice: A mix between the declaration with include and class doesn't work and passes to a duplicate declaration error. 
