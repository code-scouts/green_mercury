Technology we use
=================

* Ruby 1.9.3
* Rails 4.0
* Rspec (see below for how to run the specs)
* Cucumber (see below for how to run the features)
* Spork (see below for how to make the specs and features FAST)
* JavaScript (not CoffeeScript; see below)
* Postgres
* Heroku
* Janrain (see below for some developmer info)

Rspec
-----
This project uses Rspec to test that everything is working as it should be. Once you have your environment set up as described in [CONTRIBUTING.md](https://github.com/code-scouts/green_mercury/blob/master/CONTRIBUTING.md), you should be able to run the specs by simply running `rspec` at the command line.

Cucumber
--------
This project uses Cucumber to test that pages are working as they shoud be. Once you have your environment set up as described in [CONTRIBUTING.md](https://github.com/code-scouts/green_mercury/blob/master/CONTRIBUTING.md), you should be able to run the features by simply running `cucumber` at the command line.

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
Social sign-in is coupled to the Janrain API. Currently you will be able to run the development server, but you will not be able to use the social sign-in functions without the Code Scouts Janrain API key (which you don't have). We are working on a solution to this.
