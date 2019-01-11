# Waste Exemptions Back Office (TA)

[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

If your business produces waste or emissions that pollute you may require an environmental permit. However you may also be able to get an exemption if your business activities are considered to be easily controlled and only create low risks of pollution.

The waste exemptions service is used by organisations to apply for an exemption.

This service is currently beta public and has been developed in accordance with the [Digital by Default service standard](https://www.gov.uk/service-manual/digital-by-default), putting user needs first and delivered iteratively.

This project is the back office application which internal staff use to register an exemption via the assisted digital route. It uses the [waste-exemptions-engine](https://github.com/DEFRA/waste-exemptions-engijne).

## Prequisites

You'll need [Ruby 2.4.2](https://www.ruby-lang.org/en/) installed plus the [Bundler](http://bundler.io/) gem.

## Installation

First clone the repository and then drop into your new local repo

```bash
git clone https://github.com/defra/waste-exemptions-back-office-ta.git && cd waste-exemptions-back-office-ta
```

Next download and install the dependencies

```bash
bundle install
```

## Running locally

A [Vagrant](https://www.vagrantup.com/) instance has been created allowing easy setup of the waste exemptions service. It includes installing all applications, databases and dependencies. This is located within GitLab (speak to the Ruby team).

Download the Vagrant project and create the VM using the instructions in its README.

However, if you intend to work with the app locally (as opposed to on the Vagrant instance) and just use the box for dependencies, you'll need to:

- Log in into the Vagrant instance
- Using `ps ax`, identify the pid of the running back office app
- Kill it using `kill [pid id]`
- Exit the vagrant instance

Once you've created a `.env` file (see below) you should be ready to work with and run the project locally.

## Configuration

Any configuration is expected to be driven by environment variables when the service is run in production as per [12 factor app](https://12factor.net/config).

However when running locally in development mode or in test it makes use of the [Dotenv](https://github.com/bkeepers/dotenv) gem. This is a shim that will load values stored in a `.env` file into the environment which the service will then pick up as though they were there all along.

Check out [.env.example](/.env.example) for details of what you need in your `.env` file, and what environment variables you'll need in production.

## Databases

If you are running the waste exemptions Vagrant VM, you have nothing to do! All databases are already created and the appropriate ports opened for access from the host to the VM.

If you intend to run it standalone, you'll need to have [PostgreSQL](https://www.postgresql.org/) installed and can then use `bundle exec rake db:create:all` to create the databases for the develop and test environments.

## Running the app

Simply start the app using `bundle exec rails s`. If you are in an environment with other Rails apps running you might find the default port of 3000 is in use and so get an error.

If that's the case use `bundle exec rails s -p 8000` swapping `8000` for whatever port you want to use.

## Testing the app

The test suite is written in RSpec.

To run all the tests, use `bundle exec rspec` or `bundle exec rake`.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
