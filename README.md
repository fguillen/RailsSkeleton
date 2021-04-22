# RailsSkeleton

## Usage

This application is meant to be
the basis for a new Rails application

### Includes

- front/admin scopes
- login in front and admin (authlogic)
- google oauth integration (in front and admin)
- bootstrap
- structure to manage a simple entity (blog posts)
- test suite (minitest)
- factory_bot
- faker


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