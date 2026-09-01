# frozen_string_literal: true

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'haml'

require 'ajax_canvas_field'

# The helpers are view helpers of a Rails engine, so the specs need an
# application: the engine adds the asset paths of the gem in an initializer, and
# the legend helper renders a haml partial out of app/views.
module AjaxCanvasFieldSpec
  class Application < ::Rails::Application
    config.eager_load = false
    config.logger = Logger.new(File::NULL)
    config.secret_key_base = 'ajax-canvas-field-specs'
    config.root = __dir__
    config.hosts.clear
  end
end

Rails.application.initialize!

Rails.application.routes.draw do
  root to: 'canvas#show'
end

# A controller is the shortest way to a view context that can render the partial
# of the engine and knows about the session the helper reads its token from.
class CanvasController < ActionController::Base
  include CanvasFieldHelper
end

require_relative 'view_helpers'
