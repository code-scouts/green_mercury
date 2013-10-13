Contributing
============

Code Scouts welcomes contributions to the code base for this site!

If you want to help work on a known issue/feature, see our [issue tracker](https://trello.com/b/pHnfhYyh/green-mercury-new-codescouts-website).

If you have another idea that you'd like to contribute, great! Please do [create an issue](https://github.com/code-scouts/green_mercury/issues/) or [send an email to technical lead Andrew Lorente](mailto:andrew.lorente@gmail.com) first, so we can know what your idea is and make sure it fits with our vision of a great Code Scouts resource.

In general, patches should be:
* Tested
* Commented, where appropriate
* Roughly compliant with [the unofficial Rails Style Guide](https://github.com/bbatsov/rails-style-guide)

We look forward to your pull requests!


How the heck do I get all the requirements to contribute?
=========================================================

Slowly, unfortunately, and it depends on whether you're running Windows, Mac OS X, or Linux.
The website uses a version of both Ruby and Rails that is not installed by default on most of these platforms.

See [OSX_SETUP.md](OSX_SETUP.md) for instructions on getting set up on Mac OS X.

See [UBUNTU_SETUP.md](UBUNTU_SETUP.md) for instructions on getting set up on Ubuntu.

See [WINDOWS_SETUP.md](WINDOWS_SETUP.md) for instructions on getting set up on Windows.

Instructions for getting set up on Windows are coming soon!

You could optionally use [VAGRANT_SETUP.md](VAGRANT_SETUP.md) on any platform for a quicker, easier setup with some minor downsides.

How should I format and submit my changes?
==========================================

You should [create a fork of this repo](https://help.github.com/articles/fork-a-repo) and then [create a topic branch](http://git-scm.com/book/en/Git-Branching-Branching-Workflows#Topic-Branches) on your fork where you'll do your work. Once you have some commits that you think are good to go, push them up to your fork and then [create a pull request](https://help.github.com/articles/using-pull-requests) against the `master` branch. At this time, this project doesn't use any complicated branching strategy like feature or release branches.

We also welcome bug reports if you've encountered problems with the site! Please feel free to [submit an issue](https://github.com/code-scouts/green_mercury/issues/new).

We encourage you to create an issue before starting work on something--even if it's a new feature. Another way of putting this is "you should only work on things that have issues," but since you're welcome to create an issue and then start right away, it's not a restrictive rule like that sounds.

It is helpful, but not mandatory, if you include issue numbers in your commit messages. That way, a future maintainer who's trying to understand the context of your changes can look up the issue that originally prompted them. We like this format:

```
Fix Janrain/Turbolinks interaction [#26]
```

I still have questions about contributing.
==========================================

Well that's great; this is a Code Scouts project and we welcome questions! Try asking in the #codescouts channel [on Freenode](https://webchat.freenode.net/). If nobody seems to be around or you're not able to access IRC, you can also send an email to [technical lead Andrew Lorente](mailto:andrew.lorente@gmail.com).
