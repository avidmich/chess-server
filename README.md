chess-server
============

Back end for Ultimate Chess application.

setup
=====

Before running rails, copy .env.template into .env and follow instructions in it.

Google Auth setup
=================
1)Registering the app in Google infrastructure:
    a)Go to the Google Cloud Console.
    b)Select a project, or create a new one.
    c)In the sidebar on the left, select APIs & auth. In the displayed list of APIs, make sure the Google+ API status is set to ON.
    d)In the sidebar on the left, select Registered apps.
    e)At the top of the page, select Register App.
    f)Fill out the form and select Register. Choose Web Application type.
    g)Register the origins where your app is allowed to access the Google APIs. The origin is the unique combination of protocol, hostname, and port. You can enter multiple origins to allow for your app to run on different protocols, domains or subdomains. Wildcards are not allowed.
        Expand the OAuth 2.0 Client ID section.
        In the Web origin field, enter your origin:
        Examples: http://localhost:8080
                  http://ultimate-chess.herokuapp.com
        Press ENTER to save your origin. You can then click the + symbol to add additional origins.
    h)Copy the client ID and client secret that your app will need to use to access the APIs.
    i)Paste in appropriate fields in  /client_secrets.json file in the root directory of the project

SSL Setup
==============
On some machines it is possible that CA Certificates are not installed properly (you will see an exception when trying to authorize at Google)
In that case you have to download .pem file from  http://curl.haxx.se/ca/cacert.pem
Set environment variable in Rails configuration: SSL_CERT_FILE=<your cacert.pem location>, so that it will be available from ENV[SSL_CERT_FILE]



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

