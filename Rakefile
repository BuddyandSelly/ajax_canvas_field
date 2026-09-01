# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

# The specs are always measured with SimpleCov, see spec/spec_helper.rb
task default: %i[spec rubocop]
