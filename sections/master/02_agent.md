!SLIDE smbullets small
# Communication

* Agent is configured to connect to a server
 * Explicitly set in configuration
 * DNS service record
 * FQDN puppet.domain
* Certificate used for authentication
 * Agent will create a certificate request on first run
 * Puppet CA signs the requested certificate

~~~SECTION:handouts~~~

****

To point the agent to a server you have to configure it in its
configuration file. If not explicitly configured it will search
for an DNS service record and if not found falls back to use a
server puppet with the same domain as the agent.

~~~PAGEBREAK~~~

On its run the agent will download the certificate authority's 
certificate and create a certificate request and send it to the
master. On the master you have to sign the request and the agent
get its certificate on the next run. Managing the Puppet CA is done
with the command 'puppet cert'.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Communication

* Objective:
 * Establish the communication between agent and master
* Steps:
 * Configure the agent to connect to the master
 * Execute a puppet agent run
 * Sign the certificate
 * Execute another run


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Communication

## Objective:

****

* Establish the communication between agent and master

## Steps:

****

* Configure the agent to connect to the master 

Set the server parameter in the agent section of the configuration.

* Execute a puppet agent run

Use parameter -t on the agent run for one-time, non-daemonized, verbose run.

* Sign the certificate

Use 'puppet cert list' to display pending requests and 'puppet cert sign' to
sign a request.

* Execute another run

#### Expected Result:

Agent gets a catalog from the master without errors.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Communication

****

## Establish the communication between agent and master

****

### Configure the agent to connect to the master

Set the server parameter in the agent section of the configuration `/etc/puppetlabs/puppet/puppet.conf`

    $ sudo vim /etc/puppetlabs/puppet/puppet.conf
    ...
    [agent]
    server = puppet.localdomain

### Execute a puppet agent run

On the first run it will inform you about creation of key and certificate request and that it
failed to retrieve certificate.

    $ sudo puppet agent -t

### Sign the certificate

Login to the master and run the following command to sign the certificate.

    $ sudo puppet cert list
    $ sudo puppet cert sign agent-centos.localdomain

### Execute another run

On this run it will get the certificate and an empty catalog which applies without errors.

    $ sudo puppet agent -t


!SLIDE smbullets small
# Agent as service

* Agent runs as a service
 * Interval is configureable
 * Splay can be added for spread agent runs
 * Default interval is 30 minutes
* Cronjob can be used as alternative
* On demand is also possible

~~~SECTION:handouts~~~

****

Typically you want to enable the agent as a service which will execute a run every 30 minutes.
This interval could be changed in the agents configuration and it could also be randomized
but enabling splay which is best used in enviroments starting a huge amount of systems at once.

Instead of running the agent as service you can run it as cronjob which allows for a more detailed
configuration like only executing runs during workhours.

Running Puppet only on demand is also a valid option for some enviroments but typically you will
want to remediate drifts in a regular manor. Instead of login to every system for manually executing
the agent establishing an orchestation solution like MCollective or Foreman's remote execution plugin
is recommended for this setups.

~~~ENDSECTION~~~
