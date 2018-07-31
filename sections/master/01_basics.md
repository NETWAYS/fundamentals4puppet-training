!SLIDE smbullets small
# Master

* Master
 * Classic implementation in Ruby
 * Runs as standalone (up to ten nodes) or with a webserver
* Server
 * Newer implementation in jRuby
 * Runs in JVM
 * Higher resource requirements but scales better
* Share some configuration

~~~SECTION:handouts~~~

****

For the training we the master is already installed and running on a separate system.

We used for this the standalone version which runs under Webrick, a small ruby webserver.
Its performance is enough for up to ten nodes and it has the lowest requirements. But
it is declared deprecated with Puppet 4.

Another version would be to run the master with a webserver capable of serving ruby code,
in most setups this is Apache with Passenger. This scales very well both vertically and
horizontally. Build this setup without compiling components on your on got complicated with
the all-in-one packages provided by the vendor.

The vendors recommendation is to use the newest incarnation the Puppet server which executes
the code as jRuby in a JVM. This is typically the fastest approach for running Ruby code.
This results in higher resource requirements using Java but should scale even better than
Apache with Passenger or similar solutions. 

The server is nearly a drop-in replacement, using the same configuration from puppet.conf
and other master specific configuration files, but some small difference can be noticed.
Listed on https://docs.puppet.com/puppetserver/2.3/puppetserver_vs_passenger.html

While the vendor recommends the server, NETWAYS still recommends Apache and Passenger for
being a stable solution if you encounter problems with the server.

~~~ENDSECTION~~~
