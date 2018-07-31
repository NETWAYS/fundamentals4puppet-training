!SLIDE smbullets small noprint
# Puppet Workflow

<center><img src="./_images/puppet_workflow.png" style="width:516px;height:456px;" alt="Workflow"/></center>

!SLIDE smbullets small printonly
# Puppet Workflow

<center><img src="./_images/puppet_workflow.png" style="width:470px;height:418px;" alt="Workflow"/></center>

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

The picture above shows the workflow of a Puppet agent run.

1. The Puppet agent tells the master information about itself collected by a tool called Facter.
1. The Puppet master uses this information to compile a catalog of the intended configuration and sends it back to the agent.
1. The Puppet agent uses Puppet resource abstract layer to bring the system to this configuration state and reports all
actions back to the master.
1. The Puppet master executes all configured Report handlers to send reports to users or provide a visualisation.

All this communication is secured by x.509 certificates and requires client authentication.

~~~ENDSECTION~~~

