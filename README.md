chess-server
============

Back end for Ultimate Chess application.

setup
=====

Before running rails, copy .env.template into .env and follow instructions in it.


running locally
===============
Run in command line:
gem install foreman -v 0.61
foreman start
(Version 0.61 works normally on Windows platform, unlike 0.63, which causes errors)

To run foreman in debug mode from RubyMine:
1)Open "Edit configurations..."
2)Create new "Ruby" run configuration
3)Give the name for this configuration, like "Foreman-dev"
4)For "Ruby script:" field provide foreman installation location.
    For example: D:\bin\Ruby200\bin\foreman
5)Script arguments: start
6)Working directory: your_project_directory
7)Ensure, that correct SDK is selected for this run configuration.
8)Save and run project from debug.

It is also possible to run migrations every time you start server.
To do this, add according command in "Before make" section of the run/debug configuration.

running in heroku
=================

install heroku toolbelt from https://toolbelt.heroku.com/
```
heroku login
heroku help git:remote -a ultimate-chess
rake secret
heroku config:set SECRET_KEY_BASE=<copy value from previous command>
git push heroku master
```

