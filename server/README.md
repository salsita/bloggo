Habanero Server
===============

This is the codebase for the Habanero server.

It's based on the [express.js](http://expressjs.com) framework.

### Habanero, huh, yeah, what is it good for?
Well, it's absolutely good for something - it gathers and stores information from various sources and integrates them in a single searchable feed.


### Now, how do I run that?
We're using [Vagrant](http://vagrantup.com) and [Chef](http://wiki.opscode.com/display/chef/Home) to run Habanero in a virtual box and deploy it automatically.

The usual drill is:

 1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://vagrantup.com/).

 1. `cd habanero/server/deployment`

 1. `vagrant up dev`.

 1. That's it! Habanero server should be running. You can access the server at `http://localhost:56790` (or another port if you configured it differently).

### How do I configure the ports and such?
The file `habanero/server/deployment/default_config.rb` contains the default settings for the virtualbox port forwarding and stuff.

__Don't edit it!__

Instead, copy its contents into a new `config.rb` file and modify this one. It will be detected by the Vagrantfile and used instead. The original file is versioned and you don't want to modify it.
