# RailsSkeleton

## Usage

This application is meant to be
the basis for a new Rails application

### Includes

- Rails 7.0
- admin/front/guest scopes
- login in front and admin (authlogic)
- table index based on UUID field
- pagination with kaminari
- google oauth integration (in front and admin)
- bootstrap 5
- structure to manage a simple entity (Articles)
- test suite (minitest)
- factory_bot
- strip_attributes
- faker
- data_migrate
- cronjobs
- dokerization
- integration with SendGrid
- integration with Rollbar
- Upload images (Storage/S3)


### Creating a new App

Clone and renaming:

    mkdir MyNewAwesomeApp
    cd MyNewAwesomeApp
    git init -b main
    git remote add skeleton git@github.com:fguillen/RailsSkeleton.git
    git pull skeleton main

    rake "railsskeleton:utils:renaming_project[MyNewAwesomeApp]"
    git add .
    git commit -m "Renaming Project"

Setting up App:

    bin/setup



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

## Set API Tokens

For the envvars:

- SECRET_API_FRONT_TOKEN
- SECRET_API_ADMIN_TOKEN
- SECRET_APP_TOKEN

You can run

    rails secret

For each one of the envvars and set the values

## Set the secret key

Run

    rails secret

and set the value for the `SECRET_RAILS_SECRET_KEY_BASE` envvar.

## Set up Rollbar

- https://rollbar.com/settings/accounts/fguillen.mail/projects/#create-new-project-container
- Set the access token in the `SECRET_ROLLBAR_TOKEN` envvar

#### Set up Sendgrid

- https://app.sendgrid.com/settings/api_keys
- Set partial permission > Email Sent
- Copy the API key
- Set it in the `SECRET_SENDGRID_API_KEY` envvar

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

- Create the bucket
- Create the IAM Group
- Create the IAM User

Group permissions:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:GetBucketLocation",
                    "s3:ListAllMyBuckets"
                ],
                "Resource": "arn:aws:s3:::*"
            },
            {
                "Effect": "Allow",
                "Action": "s3:*",
                "Resource": [
                    "arn:aws:s3:::my-s3-bucket",
                    "arn:aws:s3:::my-s3-bucket/*"
                ]
            }
        ]
    }

Get the API credentials from the IAM User and set them in the envvars:

- SECRET_AWS_S3_ACCESS_KEY_ID
- SECRET_AWS_S3_SECRET_ACCESS_KEY

Check that the _region_ is properly set in `storage.yml` config file


## OVH server setup

- https://docs.google.com/document/d/1i5uJkdxm-eFWEkSnYMbDHrND9Se0L-4fryQzv9zbWDM/edit#

## Configure SSL certificates

### Installing SSL with Letsencrypt

Follow instructions here: https://pentacent.medium.com/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71

The script is already there it should work. Configure variables `domains`, `email`, and `staging`:

    ./init-letsencrypt.sh

If failing check that the `nginx.conf` file has been copied properly into the Docker container.


# Docker and deploy


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
    docker exec -i DOCKER_PS mysql -uroot -proot railsskeleton < /tmp/mysql_dump.sql
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

Running migrations:

    docker-compose exec app bundle exec rake db:migrate data:migrate assets:precompile

Restart the app:

    docker-compose restart app
    docker-compose restart cron
    docker-compose restart web

Or maybe

    docker-compose down
    docker-compose up -d

### Docker

#### Consoling

    docker-compose exec app bundle exec rails c
    docker-compose exec app bash
    docker-compose exec db mysql -uroot -proot
    docker-compose exec web bash
    docker-compose run --rm --entrypoint "/bin/sh" certbot
    docker-compose run --rm --entrypoint "/bin/bash" web

#### Logs

    docker-compose logs

#### Nginx reload

    docker-compose exec web nginx -s reload
