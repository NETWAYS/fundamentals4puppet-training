!SLIDE smbullets small
# Facter

* Facter returns key value pairs named facts
* It is used by Puppet to gather information about the node
* You can also run it on command line to list facts

   <pre>
   augeas => {
     version => "1.4.0"
   }
   disks => {
     vda => {
       size => "10.00 GiB",
       size_bytes => 10737418240,
       vendor => "0x1af4"
     }
   }
   ...
   system_uptime => {
     days => 0,
     hours => 2,
     seconds => 8378,
     uptime => "2:19 hours"
   }
   timezone => UTC
   virtual => kvm
   </pre>

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

Facter returns key value pairs named facts. In older versions these were simple string representations, newer versions
also structured facts are possible which means a array or hash is returned.

The facts are used as Puppet's inventory tool and are generated before requesting a catalog from the master. The master
can use facts in conditionals or templates during catalog compilation but it is impossible to change its values during
a run or change the agents behaviour directly on the node based on facts.

Facter includes many different built-in facts and allows to add additional facts in several ways which allows to provide
them by Puppet modules requiring this information.

~~~ENDSECTION~~~
