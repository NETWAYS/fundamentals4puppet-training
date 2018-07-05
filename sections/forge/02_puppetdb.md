!SLIDE smbullets small
# PuppetDB

* Data store:
 * Facts (last run)
 * Catalog (last run)
 * Reports (optional, timeframe configurable)
* Enables:
 * Features like exported resources
 * API to query the data
* Uses:
 * Clojure (dialect of Lisp run in JVM)
 * PostgreSQL

~~~SECTION:handouts~~~

****

The PuppetDB is a data store developed from Puppet to store facts, catalogs and reports and
enables features like exported resources in Puppet and other tools to easily access this data.
For performance reasons it was written in Clojure, a dialect of Lisp run in JVM, using PostgreSQL
as backend.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: PuppetDB

* Objective:
 * Install PuppetDB using the Puppet module
* Steps:
 * Install the PuppetDB module
 * Assign it to your master
 * Run the puppet agent to install it


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: PuppetDB

## Objective:

****

* Install PuppetDB using the Puppet module

## Steps:

****

* Install the PuppetDB module

The agent on the master runs in a separate environment **master**

We will explicitly avoid touching environment **production** here.

* Assign it to your master

It requires not only the PuppetDB class, but also some config for the Master. Bind it to your public address to access also its status dashboard.

* Run the puppet agent to install it

#### Expected Result:

You can query the PuppetDB using curl like: curl -X GET http://192.168.56.101:8080/pdb/query/v4   --data-urlencode 'query=nodes [ certname ]{ }'

You can access the dashboard, pointing your browser to http://192.168.56.101:8080.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: PuppetDB

****

## Install PuppetDB using the Puppet module

****

### Install the PuppetDB module

On the puppet master use the puppet module tool to install "puppetlabs-puppetdb" into environment **master**.

    $ sudo puppet module install puppetlabs-puppetdb --modulepath /etc/puppetlabs/code/environments/master/modules

### Assign it to your master

Disable the module firewall management and bind it to your public ip address. The master is named "puppetmaster"
and we want to have reports stored in puppetdb.

    $ sudo vim /etc/puppetlabs/code/environments/master/manifests/site.pp
    node 'puppet.localdomain' {
      class { 'puppetdb':
        manage_firewall => false,
        listen_address  => '192.168.56.101',
      }
      class { 'puppetdb::master::config':
        puppet_service_name     => 'puppetmaster',
        manage_report_processor => true,
        enable_reports          => true,
      }
    }

Instead of typing all the configuration use the documentation of the module to copy most of it.

### Run the puppet agent to install it

    $ sudo puppet agent -t
