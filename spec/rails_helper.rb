# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/webkit/matchers'
# Add additional requires below this line. Rails is not loaded until this point!

Capybara.javascript_driver = :webkit
include Warden::Test::Helpers
Warden.test_mode!
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  config.before(:each) do
    WebMock.disable_net_connect!(:allow => [/api.stripe.com/, /maps.googleapis.com/], allow_localhost: true)
    # Stubbing out most common emails
    WebMock.stub_request(:post, "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
         with(:body => {"from"=>"postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", "subject"=>"Thanks!", "text"=>"Thank you for signing up to IgniteIt!", "to"=>"test@example.com"},
              :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'162', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
    WebMock.stub_request(:post, "https://api:key-d862abdfc169a5e8ba9b0a23ba5b9b78@api.mailgun.net/v2/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages").
         with(:body => {"from"=>"postmaster@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org", "subject"=>"Thanks!", "text"=>"Thank you for signing up to IgniteIt!", "to"=>"g@g.com"},
              :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'153', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
  end

  config.include(Capybara::Webkit::RspecMatchers, :type => :feature)

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
