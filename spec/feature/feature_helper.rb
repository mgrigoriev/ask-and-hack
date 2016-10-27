require 'rails_helper'

RSpec.configure do |config|

  Capybara.javascript_driver      = :webkit
  Capybara.default_max_wait_time  = 5
  Capybara.ignore_hidden_elements = true
  Capybara.server_host            = "127.0.0.1"
  Capybara.server_port            = 5000

  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end  
end