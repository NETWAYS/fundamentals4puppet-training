!SLIDE smbullets small
# Puppet's model based approach

Describe the desired state and let Puppet enforce it

1. **Describe** your infrastructure and its desired state
1. **Simulate** the enforcement of the defined resources
1. **Enforce** the desired state of your infrastructure
1. **Report** on the state of enforcement

~~~SECTION:handouts~~~

****

1. Describe your infrastructure and its desired state
  * Use Puppet to describe the resource and their attributes. Puppet allows you to manage as much or little as you like
    and let you grow coverage of the configuration management.
1. Simulate the enforcement of the defined resources
  * Simulation of the configuration changes allows to verify it and understand the impact before enforcing it.
1. Enforce the desired state of your infrastructure
  * Each node is brought to the desired state periodically to be compliant and maintain consistency.
1. Report on the state of enforcement
  * Reports can be send or visualized in many different ways containing all information about agent runs.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Puppet's composable configuration

Build configuration from small components

1. Declare resources as modules
1. Assign configuration modules to nodes
1. Reusable and composable configuration


~~~SECTION:handouts~~~

****

The domain specific language of Puppet allows to specify and manage your infrastructure with defined models instead of
procedures. With this DSL complete services and applications can be modelled in a reusable and composable way which 
supports multiple platforms. Because of the central management you can make changes once and then test and deploy them
in a consistent fashion to multiple nodes.

Puppet (the company behind Puppet formerly Puppet Labs) hosts the Puppet Forge which contains thousands of freely
downloadable modules for resources, applications and services managed by the community: 
[http://forge.puppet.com](http://forge.puppet.com)

~~~ENDSECTION~~~
