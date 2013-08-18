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

1. Install Xcode
1. Install Xcode's Command Line Tools
1. Install Homebrew
1. Install [RVM (Ruby Version Manager)](http://rvm.io)
1. Install Ruby 1.9.3
1. Install PostgreSQL
1. Clone source
1. Create RVM gemset
1. Install required libraries
1. Create and migrate databases
1. Contribute!

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


Install PostgreSQL
------------------
This project relies on a PostgreSQL database. On a Mac the simplest way to install Postgres is with [Postgres.app](http://postgresapp.com/). Install it according to the guide on that website.


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
$ rake db:migrate
$ rake db:migrate RAILS_ENV=test
```
