!SLIDE smbullets small
# Deploying code to Puppet Master

* Ensure code is valid
 * Syntax validation
 * Style guide conformity
* Use environments for staging
 * No direct deployment in production
* Use version control system
 * History of changes
 * Enables Collaboration 
 * Hooks enable automatic validation and deployment

~~~SECTION:handouts~~~

****

Your workflow for deploying code to the Puppet Master should include steps
to ensure only valid code is deployed. This includes validation against
syntax and style guide conformity. Also changes should be tested before
deploying them in production. Best is to use some kind of staging which could
mean using well-established stages also for your puppet environment or creating
new ones only for puppet. This stages can be represented by separate environments.

It is recommended to use a version control system to help with this. It will
also allow you to view the history of changes with the possiblity to revert
specific problematic changes and define a changeset which should move to the
next stage. Most version control systems allows to add hooks to automate
validation and deployment.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Git

* Open Source
* Distributed
 * Most operations are local
 * Central repository for collaboration
* Cryptographic integrity of content and history

~~~SECTION:handouts~~~

****

The recommended version control system is **git**. Git is an open source distributed
version control system. Most operations are performed locally which results in a very
fast performance and a central repository enables collaboration which git supports with
easy branching, staging and enabling different workflows. Git also ensure integrity not
only on the content but also on commit history.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Git Commands

* `git status` - print the state of the working directory
* `git add` - add changes to the staging area to build a commit
* `git commit` - takes a snapshot, saves a checkpoint and a message as one commit
* `git push` - push a commit from local working directory to central repository
* `git pull` - pull from a central repository to local working directory
* `git diff` - show local changes in diff format
* `git log` - print the log of commits
* `git show` - print content of a commit
* `git blame` - show author and date of specified content
* `git branch` - list, create, delete local branches
* `git checkout` - change to specific branch
* and many more

~~~SECTION:handouts~~~

****

Git enables you to do many different things with your version control system, but
for your basic workflow you will require a small set of commands and others just
enable advanced workflow and error handling.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Git Workflow

* Objective:
 * Bring your puppet code under version control
* Steps:
 * Use git status to find pending changes
 * Add them with git add to the staging area
 * Create your initial commit
 * Push it to the Puppet Master


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Git Workflow

## Objective:

****

* Bring your puppet code under version control

## Steps:

****

* Use `git status` to find pending changes
* Add them with `git add` to the staging area
* Create your initial commit using `git commit`
* Push it to the Puppet Master with `git push`

#### Expected Result:

Pushing your code to the master generates no error.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Git Workflow

****

## Bring your puppet code under version control

****

### Use `git status` to find pending changes

Git status will show you which files have changes no already commited which will be all files,
but it will only print to top most directory.

    $ git status

### Add them with `git add` to the staging area

Run git add on the files printed.

    $ git add modules

### Create your initial commit using `git commit`

Running git commit will create a commit with all content of the staging area and ask you for a
commit message which you can also directly add with parameter -m.

    $ git commit -m "initial commit"

### Push it to the Puppet Master with `git push`

You should always tell git what exactly it should push if you do not want to accidently push
some local pending changes.

    $ git push origin master

In this case we only have one remote target named "origin" and only one branch "master". This
represents the "production" environment on the Puppet master.

If you get some error message from the validation hooks, fix them in the files, add them again
and create a new commit to push.


!SLIDE smbullets small
# Background information

* Preparation on your master
 * A shared repository for your puppet code
 * A git hook doing syntax validation
 * A git hook populating your puppet environment
* On your development system
 * A local clone of the repository
 * Access to the central repository

~~~SECTION:handouts~~~

****

For the workflow from the exercise to work there are some preparations already done.

On the master a shared repository is created and then some git hooks for Puppet are added
using git.

    $ sudo useradd -G puppet git
    $ su - git
    $ git init --bare puppet.git
    $ git clone https://github.com/drwahl/puppet-git-hooks.git puppet-validation-hooks
    $ ln -s /home/git/puppet-validation-hooks/pre-receive /home/git/puppet.git/hooks/pre-receive
    $ vi /home/git/puppet-validation-hooks/commit_hooks/config.cfg
    CHECK_PUPPET_LINT="permissive"

    $ git clone https://github.com/adrienthebo/puppet-git-hooks.git puppet-deployment-hooks
    $ ln -s /home/git/puppet-deployment-hooks/post-receive/dynamic-environments /home/git/puppet.git/hooks/post-receive
    $ vi /home/git/puppet.git/hooks/post-receive
    ...
    ENVIRONMENT_BASEDIR = "/etc/puppetlabs/code/environments"
    ...
    BRANCH_MAP = {
      "master" => "production",
    }
    ...
    $ sudo rm -rf /etc/puppetlabs/code/environments/production
    $ sudo chown git.puppet /etc/puppetlabs/code/environments

On your development system the repository was cloned and a ssh key without passphrase was
created and added to the keys authorized to access the git repository.

    $ git clone git@puppet.localdomain:puppet.git

~~~ENDSECTION~~~
