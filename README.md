chess-server
============

Back end for Ultimate Chess application.

setup
=====

Before running rails, copy .env.template into .env and follow instructions in it.


running locally
===============

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

