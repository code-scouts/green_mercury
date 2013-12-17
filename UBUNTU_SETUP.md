Setting up your Ubuntu computer so you can contribute
=====================================================

We will walk through the steps, but at a high level, they are:

1. [Install Git](#install-git)
1. [Install Curl](#install-curl)
1. [Install RVM (Ruby Version Manager)](#install-rvm)
1. [Install Ruby 1.9.3](#install-ruby-193)
1. [Install PostgreSQL](#install-postgresql)
1. [Clone the source](#clone-the-source)
1. [Create a gemset](#create-a-gemset)
1. [Install required libraries](#install-required-libraries)
1. [Create and migrate databases](#create-and-migrate-databases)
1. [Contribute!](#contribute)

Install Git
-----------
git is an extremely powerful source-code management tool. We use it in conjunction with Github to manage changes to the code that runs this project. You can install it with apt:
```
sudo apt-get install git
```

Install Curl
------------
Curl is a command-line tool for fetching data from remote servers. In a moment we'll use it to install RVM. For now, install it from apt:
```
sudo apt-get install curl
````

Install RVM
-----------
[RVM](http://rvm.io) is a tool for installing and managing different versions of Ruby, as well as creating "gemsets", self-contained environments for Ruby libraries that prevent subtle, hard-to-diagnose, hard-to-resolve problems when working on multiple Ruby projects. In short, RVM is a cheap solution to an expensive problem. You can install RVM by pasting a single line into your terminal:
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
This project relies on a PostgreSQL database. You can install PostgreSQL using apt:
```
sudo apt-get install postgresql libpq-dev
```

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
This project uses [Bundler](http://bundler.io/) to manage its dependencies. That means it takes only a single command to get all the code libraries you need:
```
bundle install
```

Create And Migrate Databases
----------------------------
Now that you have the dependencies installed, it's time to create the databases for the site.

At your terminal run the following commands which will create a user and a database. Replace `<user>` with a username of your choosing (try: greenmercury) and enter a password when prompted:

```
sudo -u postgres createuser -D -A -P <user>
sudo -u postgres createdb -O <user> green_mercury
sudo -u postgres createdb -O <user> green_mercury_test
```
In order to use these credentials you need to edit another file config/database.yml to add the username and password. First of all, though, you need to remove the file from git to make sure the password don't get accidently leaked.

```
git rm --cached config/database.yml
```

Don't worry the `--cached` option ensures the file won't actually get deleted.

Next edit the file .gitignore -- this is a special file that tells git to ignore certain file, and stops it bugging you about them. Go ahead and enter `config/database.yml' on an empty line.

Now  tell git about the changes
```
git add -u
git commit -m 'forget about database.yml'
```

The `-m` stands for message, so you can put your own message after it  if you like.

Now you can safely edit config.yml
 In the sections `development` and `test` uncomment the lines 
 ```
 #  username: [insert user name]
 #  password: [insert password]
 ```
 by removing the # sign and add in the username and password you created (remove [ ] as well).


So far the database you created is empty, so you just need to set it up with the proper tables:
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
