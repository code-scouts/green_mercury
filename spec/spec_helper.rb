require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'cancan/matchers'
  require 'shoulda/matchers/integrations/rspec'
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
  
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
  end
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  ActiveSupport::Dependencies.clear
  FactoryGirl.reload
  require 'user'
end

def new_member 
  user = FactoryGirl.build(:user)
  FactoryGirl.create(:approved_member_application, user_uuid: user.uuid)
  user
end

def new_mentor
  user = FactoryGirl.build(:user)
  FactoryGirl.create(:approved_mentor_application, user_uuid: user.uuid)
  user
end

def fill_in_ckeditor(locator, opts)
  browser = page.driver.browser
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
  SCRIPT
end









