# frozen_string_literal: true

require 'rails/generators'

class AjaxCanvasFieldGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  # An application has one of each of these at most, whichever preprocessor it
  # happens to use.
  JAVASCRIPT_MANIFESTS = %w[application.js application.coffee].freeze
  STYLESHEET_MANIFESTS = %w[application.scss application.scss.erb application.css.scss].freeze

  desc 'Copy the initializer for AjaxCanvasField'
  def copy_initializer_file
    copy_file 'initializer.rb', 'config/initializers/ajax_canvas_field.rb'

    JAVASCRIPT_MANIFESTS.each do |manifest|
      require_asset("app/assets/javascripts/#{manifest}", "//= require ajax_canvas_field\n", '//= require_tree .')
    end

    STYLESHEET_MANIFESTS.each do |manifest|
      require_asset("app/assets/stylesheets/#{manifest}", " *= require ajax_canvas_field\n", ' *= require_tree .')
    end
  end

  private

  def require_asset(path, line, before)
    inject_into_file(path, line, before: before)
  rescue Thor::Error
    # A manifest the application does not have is not an error.
    nil
  end
end
