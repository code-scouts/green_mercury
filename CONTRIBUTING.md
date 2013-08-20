Contributing
============

Code Scouts welcomes contributions to the code base for this site!

If you want to help work on a known issue/feature, see our [issue tracker](https://trello.com/b/pHnfhYyh/green-mercury-new-codescouts-website).

If you have another idea that you'd like to contribute, great! Please do [create an issue](https://github.com/code-scouts/green_mercury/issues/) or [send an email to technical lead Andrew Lorente](mailto://andrew.lorente@gmail.com) first, so we can know what your idea is and make sure it fits with our vision of a great Code Scouts resource.

In general, patches should be:
* tested
* commented, where appropriate
* Roughly compliant with [the unofficial Rails Style Guide](https://github.com/bbatsov/rails-style-guide)

We look forward to your pull requests!


How the heck do I get all the requirements to contribute?
=========================================================

Slowly, unfortunately, and it depends on whether you're running Windows, Mac OS X, or Linux.
The website uses a version of both Ruby and Rails that is not installed by default on most of these platforms.

Mac OS X
--------

We will walk through the steps, but at a high level, they are:

1. [Install Xcode](#install-xcode)
1. [Install Xcode's Command Line Tools](#install-xcodes-command-line-tools)
1. Install Homebrew
1. [Install RVM (Ruby Version Manager)](#install-rvm)
1. [Install Ruby 1.9.3](#install-ruby-193)
1. [Install PostgreSQL](#install-postgresql)
1. [Clone the source](#clone-the-source)
1. [Create a gemset](#create-a-gemset)
1. [Install required libraries](#install-required-libraries)
1. [Create and migrate databases](#create-and-migrate-databases)
1. [Contribute!](#contribute)

Now the detail.

Install Xcode
-------------
Xcode is Apple's development environment for native applications. We need it for two minor things: git and a compiler. Git is included with the Command Line Tools, which is the next step.

[Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) is free from the Mac App Store, you just need an Apple ID.

Install Xcode's Command Line Tools
----------------------------------
1. After Xcode is installed, open it and got to `Preferences...`.
2. Go to the Downloads section and select to install Command Line Tools (see screenshot below)

![Command Line Tools Screenshot](https://raw.github.com/jeffweiss/green_mercury/add_contribution_requirements_instructions/contributing_assets/xcode_commandline_tools.png)

Install RVM
-----------
[RVM](http://rvm.io) is a tool for installing and managing various versions of Ruby, as well as creating "gemsets", self-contained environments for Ruby libraries that prevent subtle, hard-to-diagnose, hard-to-resolve problems when working on multiple Ruby projects. In short, RVM is a cheap solution to an expensive problem. You can install RVM by pasting a single line into your terminal:
```
\curl -L https://get.rvm.io | bash -s stable
```
Now that RVM is installed, you need to import it into your shell:
```
source ~/.rvm/scripts/rvm
```

Install Ruby 1.9.3
------------------
The production environment runs Ruby 1.9.3, so you should use that version during development as well. Having installed RVM, installing this version of Ruby is easy:
```
rvm install 1.9.3
rvm use --default 1.9.3
```

Install PostgreSQL
------------------
This project relies on a PostgreSQL database. On a Mac the simplest way to install Postgres is with [Postgres.app](http://postgresapp.com/). Install it according to the guide on that website.

Clone the Source
----------------
It is best to create your own fork of this project to contribute to it. You can do that by [clicking this here link](https://github.com/code-scouts/green_mercury/fork). Now that you have your own fork, you can use git to get a copy of the source for this site (remember to replace `<your-github-username>` with your actual Github username):
```
git clone git@github.com:<your-github-username>/green_mercury.git
cd green_mercury
git remote add upstream https://github.com/code-scouts/green_mercury.git
```
Note that the first command will fail if you have not yet set up ssh keys for Github. They provide [an excellent guide to this](https://help.github.com/articles/generating-ssh-keys), which you should follow if you need help.
The full range of things you can do to the code using Git and Github is outside the scope of this document, but it is extensive. If you're new to Git and Github, try [Github's interactive tutorial](http://try.github.io) for a crash course.

Create a Gemset
---------------
Remember earlier, when we said RVM could create Gemsets, and they were important? Time to put that to work:
```
rvm gemset create green_mercury
rvm gemset use green_mercury
```

Install required libraries
--------------------------
This project uses [Bundler](http://bundler.io/) to manage its dependencies. That means it requires only a couple of commands to get all the code libraries you need:
```
gem install bundler
bundle install
```

Create And Migrate Databases
----------------------------
Now that you have the dependencies installed, it's time to create the databases for the site. At your terminal run `psql postgres`. This will open a Psql prompt, where you should enter:
```SQL
create database green_mercury;
create database green_mercury_test;
commit;
\q
```
That creates a pair of empty databases, so you just need to set them up with the proper tables:
```
rake db:migrate
rake db:migrate RAILS_ENV=test
```

Contribute!
-----------
Whew! That was quite a bit of setup. Fortunately, most of it was one-time-only: If you want to contribute to another project you'll be able to skip most of what you did this time around.

Once you have some changes that you think will improve the site, commit them with git:
```
git commit -a -m "A brief summary of what you did"
git push origin
```
Then use the [new-pull-request page](https://github.com/code-scouts/green_mercury/compare/) to create a pull request so we can see your great work!
