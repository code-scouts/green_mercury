Technology we use
=================

* Ruby 1.9.3
* Rails 4.0 (see below for how to run a development server)
* Rspec (see below for how to run the specs)
* Cucumber (see below for how to run the features)
* Spork (see below for how to make the specs and features FAST)
* JavaScript (not CoffeeScript; see below)
* Postgres
* Heroku
* Janrain (see below for some developer info)
* Meetup (see below for some developer info)

Rails
-----
This is a Rails 4.0 project, which means it's set up to run a local version of the site for development with one command. Set up your environment as described in [CONTRIBUTING.md](CONTRIBUTING.md), then enter `rails server` at the command line. Wait a couple of seconds for the server to start, then point your browser at http://localhost:3000. If you want to stop the server, hit control-c in the terminal where it's running.

Rspec
-----
This project uses Rspec to test that everything is working as it should be. Once you have your environment set up as described in [CONTRIBUTING.md](https://github.com/code-scouts/green_mercury/blob/master/CONTRIBUTING.md), you should be able to run the specs by running `rspec` at the command line.

Cucumber
--------
This project uses Cucumber to test that pages are working as they shoud be. Once you have your environment set up as described in [CONTRIBUTING.md](https://github.com/code-scouts/green_mercury/blob/master/CONTRIBUTING.md), you should be able to run the features by running `cucumber` at the command line.

Spork
-----
You can optionally use Spork to make the specs and features ever so fast. Once you have your environment set up, run `spork &` at the command line. Wait a few seconds until you see "Spork is ready and listening on 8989!", and then run `rspec --drb` to run the specs. Similarly, to use Spork with Cucumber, run `spork cucumber &`, wait until you see "Spork is ready and listening on 8990!", and run `cucumber --drb`.

Remember that changing certain core files, such as `routes.rb`, will require restarting spork:

```
$ kill %1
$ spork &
```

JavaScript
----------
This project uses JavaScript by itself, without CoffeeScript. CoffeeScript is _great_, but adds to the list of things someone must learn before being able to contribute, so we've decided to eschew it.

Janrain
-------
This project uses Janrain Capture for signin and storing its user database. That has some implications when making additions to the user model or making models that reference a user (created-by, for example). See [the notes on user migrations](https://github.com/code-scouts/green_mercury/blob/master/user_migrations/README.md) for more on this.

You should be able to sign into a development site with an out-of-the-box development page. However, you won't be able to e.g. view users' profile pages without a client_secret for the Dev Capture App. [Get in touch with technical lead Andrew Lorente](mailto:andrew@codescouts.org) if you need a client_secret.

Meetup
------
Events management is coupled to the Meetup API. You can run the development server without an API key, but the events-management pages will require you to get one. Go to [the Oauth Consumers page on Meetup](http://www.meetup.com/meetup_api/oauth_consumers/), and create a new Consumer. Now when you run the development server, you should invoke it with `MEETUP_API_KEY=<yourApiKey> MEETUP_API_SECRET=<yourApiSecret> rails server`.
