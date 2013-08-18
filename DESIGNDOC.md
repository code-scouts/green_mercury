Technology we use
=================

* Ruby 1.9.3
* Rails 4.0
* Rspec (see below for how to run the specs)
* Spork (see below for how to run the specs FAST)
* Cucumber
* JavaScript (not CoffeeScript; see below)
* Postgres
* Heroku

Rspec
-----
This project uses Rspec to test that everything is working as it should be. Once you have your environment set up as described in [CONTRIBUTING.md](https://github.com/code-scouts/green_mercury/blob/master/CONTRIBUTING.md), you should be able to run the specs by simply running `rspec` at the command line.

Spork
-----
You can optionally use Spork to make the specs ever so fast. Once you have your environment set up, run `spork &` at the command line. Wait a few seconds until you see "Spork is ready and listening on 8989!", run `rspec --drb` to run the specs. Remember that changing certain core files, such as `routes.rb`, will require restarting spork:

```
$ kill %1
$ spork &
```

JavaScript
----------

This project uses JavaScript by itself, without CoffeeScript. CoffeeScript is _great_, but adds to the list of things someone must learn before being able to contribute, so we've decided to eschew it.
