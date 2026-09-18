# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
  primary_coverage :branch

  # Everything the gem ships has to be covered, whether it was loaded or not.
  cover '{app,lib}/**/*.rb'
  skip 'lib/ajax_canvas_field/rails/version.rb'

  minimum_coverage line: 100, branch: 100
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require_relative 'support/rails_app'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.include ViewHelpers

  # AjaxCanvasField.config is one hash on the module, so every example starts
  # from the defaults the gem ships.
  config.around do |example|
    defaults = AjaxCanvasField.config.dup
    example.run
    AjaxCanvasField.config.replace(defaults)
  end
end
