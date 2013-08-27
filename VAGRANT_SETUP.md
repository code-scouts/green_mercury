Using Vagrant to set up a virtual machine so you can contribute
===============================================================

We will walk through the steps, but at a high level, they are:

1. [Install git](#install-git)
1. [Install Vagrant](#install-vagrant)
1. [Clone the source](#clone-the-source)
1. [Start a Vagrant VM](#start-a-vagrant-vm)
1. [SSH to your Vagrant VM](#ssh-to-your-vagrant-vm)
1. [Migrate databases](#migrate-databases)
1. [Contribute!](#contribute)

Install Git
-----------
git is an extremely powerful source-code management tool. We use it in conjunction with Github to manage changes to the code that runs this project. You should install it according to [the instructions on git-scm.com](http://git-scm.com/downloads).

Install Vagrant
---------------
Vagrant is a tool for creating and managing [Virtual Machines](http://en.wikipedia.org/wiki/Virtual_machine). In this guide, we'll use it to create a virtual Ubuntu machine from which you'll run this project. You should install Vagrant according to [the instructions on vagrantup.com](http://downloads.vagrantup.com/tags/v1.2.7).

Clone the source
----------------
It is best to create your own fork of this project to contribute to it. You can do that by [clicking this here link](https://github.com/code-scouts/green_mercury/fork). Now that you have your own fork, you can use git to get a copy of the source for this site (remember to replace `<your-github-username>` with your actual Github username):
```
git clone git@github.com:<your-github-username>/green_mercury.git
cd green_mercury
git remote add upstream https://github.com/code-scouts/green_mercury.git
```
Note that the first command will fail if you have not yet set up ssh keys for Github. They provide [an excellent guide to this](https://help.github.com/articles/generating-ssh-keys), which you should follow if you need help.
The full range of things you can do to the code using Git and Github is outside the scope of this document, but it is extensive. If you're new to Git and Github, try [Github's interactive tutorial](http://try.github.io) for a crash course.

Start a Vagrant VM
------------------
This command will instruct Vagrant to create a new virtual machine for you that has all the requirements for Green Mercury already installed. This single command will do a lot of work on your behalf, so please be patient with the amount of time it can take:

```
vagrant up
```

SSH to your Vagrant VM
----------------------
This command will use [ssh](http://en.wikipedia.org/wiki/Secure_Shell) to start an interactive shell on your VM. After running this command you'll be "shelled in" to your virtual machine. Commands you type there will run in the VM, not on your real computer.

```
vagrant ssh
```

Migrate databases
-----------------
Now that you have the dependencies installed, it's time to set up the dev and test databases.
```
cd green_mercury
rake db:migrate
rake db:migrate RAILS_ENV=test
```

Contribute!
-----------
Once you have some changes that you think will improve the site, commit them with git:
```
git commit -a -m "A brief summary of what you did"
git push origin
```
Then use the [new-pull-request page](https://github.com/code-scouts/green_mercury/compare/) to create a pull request so we can see your great work!
