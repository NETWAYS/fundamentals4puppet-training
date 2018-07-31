!SLIDE smbullets small
# Environments

* Environments allow to serve different code to different stages
* Directory enviroments
 * Path set on the master to serve an environment per directory
 * Directory contains a main manifest and modules
* Assignment
 * Node configuration requests an environment
 * Server can override it
* Default environment: *production*

~~~SECTION:handouts~~~

****

Puppet Master can handle multiple environments to separate agents and
serve them different versions of the Puppet code.

~~~PAGEBREAK~~~

With Puppet 3.7 so called Directory enviroments were added which are now
the only supported option. This means only the environment path is set
on the master and simply every directory in this path represents an
environment. This directory contains a main mainfest and modules and allows
some addition configuration.

An environment is assigned to a node in its local configuration. Although if
the agent requests a specific environment when the server is configured to
serve another one for the host it will override the agents configuration. If
nothing is configured an environment *production* is used per default.

~~~ENDSECTION~~~
