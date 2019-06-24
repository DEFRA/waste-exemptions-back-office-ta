# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.4.2"

# Use Airbrake for error reporting to Errbit
# Version 6 and above cause errors with Errbit, so use 5.8.1 for now
gem "airbrake", "5.8.1"
# Allows us to automatically generate the change log from the tags, issues,
# labels and pull requests on GitHub. Added as a dependency so all dev's have
# access to it to generate a log, and so they are using the same version.
# New dev's should first create GitHub personal app token and add it to their
# ~/.bash_profile (or equivalent)
# https://github.com/skywinder/github-changelog-generator#github-token
# Then simply run `bundle exec rake changelog` to update CHANGELOG.md
# Should be in the :development group however when it is it breaks deployment
# to Heroku. Hence moved outside group till we can understand why.
gem "github_changelog_generator", require: false

# GOV.UK styling
gem "govuk_elements_rails", "~> 3.1"
gem "govuk_template", "~> 0.23"
# Use jquery as the JavaScript library
gem "jquery-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.18.4"
# Automatically kills connections to Postgres when running rake tasks that
# involve a database drop. Stops the error
# PG::ObjectInUse: ERROR:  database "wex_db" is being accessed by other users
gem "pgreset"
# Bundle edge Rails instead: gem "rails', github: 'rails/rails'
gem "rails", "~> 4.2.11"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Automatically apply http headers that are related to security
gem "secure_headers", "~> 5.0"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Use CanCanCan for user roles and permissions
gem "cancancan", "~> 2.0"

# Use Devise for user authentication
gem "devise", ">= 4.4.3"
gem "devise_invitable", "~> 1.7.0"

# Use Kaminari for pagination
gem "kaminari", "~> 1.1"

# Use Whenever to manage cron tasks
gem "whenever", "~> 0.10.0"

# Used for auditing and version control
gem "paper_trail", "~> 10.2.0"

# Use the waste exemptions engine for the user journey
gem "waste_exemptions_engine",
    git: "https://github.com/DEFRA/waste-exemptions-engine",
    branch: "master"

# Use the Defra Ruby Aws gem for loading files to AWS buckets
gem "defra_ruby_aws",
    git: "https://github.com/DEFRA/defra-ruby-aws",
    branch: "master"

# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

group :production do
  # Web application server that replaces webrick. It handles HTTP requests,
  # manages processes and resources, and enables administration, monitoring
  # and problem diagnosis. It is used in production because it gives us an ability
  # to scale by creating additional processes, and will automatically restart any
  # that fail. We don't use it when running tests for speed's sake.
  gem "passenger", "~> 5.0", ">= 5.0.30", require: "phusion_passenger/rack_handler"
end

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem "pry-byebug"
  # Manages our rubocop style rules for all defra ruby projects
  gem "defra_ruby_style"
  # Shim to load environment variables from a .env file into ENV in development
  # and test
  gem "dotenv-rails"
  # Project uses RSpec as its test framework
  gem "rspec-rails", "~> 3.8"
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"
end

group :test do
  # Database Cleaner is a set of strategies for cleaning your database in Ruby.
  gem "database_cleaner"
  # Fixtures replacement
  gem "factory_bot_rails"
  # Generates a test coverage report on every `bundle exec rspec` call. We use
  # the output to feed CodeClimate's stats and analysis
  gem "simplecov", require: false
  # A gem providing "time travel" and "time freezing" capabilities, making it
  # dead simple to test time-dependent code.
  gem "timecop"
  # Register external requests in cassettes and re-play them
  gem "vcr"
  # Validate HTTP5 content
  gem "w3c_validators"
  # Mock HTTP requests
  gem "webmock", "~> 3.5"

  # Allow automated testing of the whenever schedule
  gem "whenever-test", "~> 1.0"

  # Use Bullet to find unoptimised querries
  gem "bullet", "~> 5.9"
end
