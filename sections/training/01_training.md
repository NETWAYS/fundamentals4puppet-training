!SLIDE subsection
# ~~~SECTION:MAJOR~~~ Introduction


!SLIDE smbullets small
# Training

This training will introduce the basic functionality behind Puppet's abstraction layer, the structure
of Puppet modules and development from local prototype to deployment on Puppet Master. Furthermore
usage of modules provided by the Puppet forge and adding a graphical interface for monitoring the 
infrastructure is covered.

The material is based on Puppet 5.

~~~SECTION:handouts~~~

****

This training will introduce the basic functionality behind Puppet's abstraction layer, the structure
of Puppet modules and development from local prototype to deployment on Puppet Master. Furthermore
usage of modules provided by the Puppet forge and adding a graphical interface for monitoring the 
infrastructure is covered.

## Puppet Open Source

This chapter will cover the concept, architecture and functionality behind Puppet and Facter. It will
also show the difference between the Open Source and Enterprise version.

~~~PAGEBREAK~~~

## Modules and Classes

In this chapter the basic resource types are introduced and language constructs like dependencies,
resource defaults, variables and variable types and programmatic constructs. These resource types will
be combined to classes and modules which will be used in the common roles-profiles-pattern.

## Puppet Master

Last but not least we will focus on the Puppet Master. The modules developed will be deployed on it using
git, assigned to nodes and parameterized using hiera. Differences between the Puppet Master and Puppet
Server will be shown before modules provided by the Puppet forge will be used to extend it with the
PuppetDB as reporting backend and Puppet Explorer as graphical interface.

~~~ENDSECTION~~~
