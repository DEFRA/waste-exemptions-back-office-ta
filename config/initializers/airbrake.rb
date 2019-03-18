# frozen_string_literal: true

# Airbrake is an online tool that provides robust exception tracking in your Rails
# applications. In doing so, it allows you to easily review errors, tie an error
# to an individual piece of code, and trace the cause back to recent
# changes. Airbrake enables for easy categorization, searching, and prioritization
# of exceptions so that when errors occur, your team can quickly determine the
# root cause.
#
# Configuration details:
# https://github.com/airbrake/airbrake-ruby#configuration

# Unfortunately the airbrake initializer errors if project_key is not set. The
# problem is that the initializer is fired in scenarios where we are not
# actually using the app, for example when running a rake task.
#
# In production when we run rake tasks it's in an environment where environment
# variables have not been  set. As such we need a way to disable using airbrake
# unless we actually need it.
if ENV["USE_AIRBRAKE"] == "true"
  Airbrake.configure do |c|
    # By default, it is set to airbrake.io As we use our own hosted instance of
    # Errbit we need to set this value
    c.host = ENV["AIRBRAKE_HOST"]
    # You must set both project_id & project_key. To find your project_id and
    # project_key navigate to your project's General Settings and copy the values
    # from the right sidebar.
    # https://github.com/airbrake/airbrake-ruby#project_id--project_key
    c.project_id = 1
    c.project_key = ENV["AIRBRAKE_BO_PROJECT_KEY"]

    # Configures the root directory of your project. Expects a String or a
    # Pathname, which represents the path to your project. Providing this option
    # helps us to filter out repetitive data from backtrace frames and link to
    # GitHub files from our dashboard.
    # https://github.com/airbrake/airbrake-ruby#root_directory
    c.root_directory = Rails.root

    # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
    # use the Rails' logger.
    # https://github.com/airbrake/airbrake-ruby#logger
    c.logger = Rails.logger

    # Configures the environment the application is running in. Helps the Airbrake
    # dashboard to distinguish between exceptions occurring in different
    # environments.
    # NOTE: This option must be set in order to make the 'ignore_environments'
    # option work.
    # https://github.com/airbrake/airbrake-ruby#environment
    c.environment = Rails.env

    # Setting this option allows Airbrake to filter exceptions occurring in
    # unwanted environments such as :test.
    # NOTE: This option *does not* work if you don't set the 'environment' option.
    # https://github.com/airbrake/airbrake-ruby#ignore_environments
    c.ignore_environments = %w[test]

    # A list of parameters that should be filtered out of what is sent to
    # Airbrake. By default, all "password" attributes will have their contents
    # replaced.
    # https://github.com/airbrake/airbrake-ruby#blacklist_keys
    c.blacklist_keys = [/password/i, /authorization/i]

    # Alternatively, you can integrate with Rails' filter_parameters.
    # Read more: https://goo.gl/gqQ1xS
    # c.blacklist_keys = Rails.application.config.filter_parameters
  end
end
