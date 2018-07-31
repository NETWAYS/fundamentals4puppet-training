!SLIDE smbullets small
# Puppet master

* The master runs on a central server
* Includes a Certificate authority
* Authenticates agent connections
* Serves a compiled catalog with the desired configuration state on agent request
* Acts as file server
* Forwards reports to report handlers
* Two different implementations:
 * Puppet Master - Ruby (executed typically with Apache and Passenger)
 * Puppet Server - jRuby (executed in a JVM)
* Supported on most Linux distributions

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

Puppet runs on a central server as master which includes a internal certificate authority.
These certificates are distributed to the agents so the master can authenticate their connections and
then serve a compiled catalog with the desired configuration state on request. If managing static
files the master also acts as file server. If configured to do so the master takes reports from the
agents and forwards them to report handlers like sending them via mail or uploading them to a frontend
like the Puppet Explorer.

The Puppet master exists in two different implementations. The longer existing version is vanilla Ruby
which can be run with Ruby's own webserver or any webserver supporting executing of Ruby code but is 
typically run with Apache and Passenger. The newer alternative is Puppet Server which is jRuby executed
in a JVM as the vendor's approach on increasing the performance. More on the differences later on.

Running Puppet in master mode is supported on most Linux distributions.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Puppet agent

* Agent runs as service on all managed nodes
* Requests periodically the desired configuration state from the Puppet master
* Sends information about itself to determine the configuration state (facts)
* Enforces the retrieved configuration state (catalog)
* Report enforcement back to master
* Supported platforms:
 * most Linux distributions
 * Windows
 * many Unix distributions
 * Mac OS X
 * some Network devices

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

The Puppet agent runs as service on all managed nodes and requests periodically the desired configuration
state from the Puppet master for this it sends information about itself so called facts to the master so it
can determine the configuration state. The retrieved configuration state as a catalog is then enforced.
Configuration changes and metrics are then reported back to the master.

The agent is supported on most Linux distributions, Windows, Solaris, HP-UX, AIX, Mac OS X and some Network
devices.

~~~ENDSECTION~~~
