# RailsSkeleton

Simple application to deliver some appreciation to your colleges

# Set up the development environment

```
bundle
rake db:setup
rake test
```


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
