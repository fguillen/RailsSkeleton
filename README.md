# RailsSkeleton

## Usage

This application is meant to be
the basis for a new Rails application

### Includes

- front/admin scopes
- login in front and admin (authlogic)
- table index based on UUID field
- google oauth integration (in front and admin)
- bootstrap
- structure to manage a simple entity (blog posts)
- test suite (minitest)
- factory_bot
- faker
- cronjobs
- dokerization
- integration with SendGrid
- integration with Rollbar


### Creating a new App

Clone and renaming:

    mkdir MyNewAwesomeApp
    cd MyNewAwesomeApp
    git init
    git remote add skeleton git@github.com:fguillen/RailsSkeleton.git
    git pull skeleton main

    rake "railsskeleton:utils:renaming_project[MyNewAwesomeApp]"
    git add .
    git commit -m "Renaming Project"

Setting up App:

    bin/setup

#### Set up Rollbar

TODO

### Adding something to the Skeleton

Keep in mind that this project
should only host code that
is to be used by all Rails apps.

If one changes something in this project
the "based on this" apps can benefit from
those changes using:

    cd MyNewAwesomeApp
    git fetch skeleton
    git merge skeleton/main

#### ⚠️⚠️ Conflicts Happen! ⚠️⚠️

When merging with `skeleton/master`
you are probably going to face conflicts on files
that you don't expect.
Mainly the files that have the `RailsSekelton` placeholder.

Let's think about great ways of
making this better for everyone! \o/

## Security and Code Style checks

We have these tasks to check these things:

```
> bundle exec rails -T checks
rails checks:all           # Run all checks
rails checks:brakeman      # Check for vulns using brakeman
rails checks:bundle_audit  # Check for vulns using bundle_audit
rails checks:rubocop       # Check rubocop styles
```

The main one is:

    rails checks:all

It is already integrated with git hook and travis, check the configuration in:

    lefthook.yml
    .travis.yml

You need to install lefhook in you local dev:

    lefthook install -f

You can overpass the lefthook on commit:

    git commit -m "MESSAGE" --no-verify


# Production configuration

Check all the ENVARS in `.env.development` all of them have to be in your production envvars

## Heroku ClearDB

Check this post for the special envvar `DATABASE_URL`:

- https://medium.com/@emersonthis/running-rails-with-mysql-on-heroku-4765df033428

You can set all ENVVARS at once in heroku:

    heroku config:push -a railsskeleton -f .env.production -o

## Google Auth

We have to add the callbacks, check here:

- https://asktheteam.railsskeleton.com/t/cant-login-with-google-oauth-on-my-development-environment/425/2

## Amazon S3

We have to create the bucket, the IAM User, the Policy and the Group:

- https://medium.com/@shamnad.p.s/how-to-create-an-s3-bucket-and-aws-access-key-id-and-secret-access-key-for-accessing-it-5653b6e54337


## Docker and deploy

### Configure SSL certificates

Download the certificates
and put them on

- /etc/ssl/RailsSkeleton.crt
- /etc/ssl/RailsSkeleton.key

### Install server basics

Copy the `./server_setup.sh` on your server and execute it

    ./server_setup.sh

### Add the ENVVARS

You can take them from the `.env.development` and create the production file:

    .env.production

### Start the app

(Included in the server_setup.sh script)

cd /var/apps/RailsSkeleton
docker-compose build
docker-compose up -d
docker-compose exec app bundle exec rake db:create db:schema:load
(docker-compose exec app bundle exec rake db:seed) # Optional


### Restore backups

Go to S3 to get the backups

    docker-compose exec app bundle exec rake db:create
    docker exec -i DOCKER_PS mysql -uroot -proot railsskeleton < /tmp/cc_members.20180629.daily.sql
    # mv /tmp/public/paperclip/production/* /var/apps/RailsSkeleton/public/paperclip/production/

### Activate SweetyBacky

    vim /root/secret/.s3.passwd # set the S3 credentials
    chmod -R 600 /root/secret/
    apt-get install ruby-all-dev build-essential zlib1g-dev mysql-client
    gem install "sweety_backy"
    crontab -l | { cat; echo "50 22 * * * /bin/bash -l -c '/usr/local/bin/sweety_backy /var/apps/RailsSkeleton/config/sweety_backy.conf >> /tmp/sweety_backy.RailsSkeleton.log 2>&1'"; } | crontab -


### Redeploy

    cd /var/apps/RailsSkeleton
    git pull

Restart the app:

    docker-compose restart app
    docker-compose restart cron
    docker-compose restart web

Or maybe

    docker-compose down
    docker-compose up -d

### Consoling

    docker-compose exec app bundle exec rails c
    docker-compose exec db mysql -uroot -proot
