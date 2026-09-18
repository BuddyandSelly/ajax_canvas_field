# frozen_string_literal: true

module AjaxCanvasField # :nodoc:
  module Rails # :nodoc:
    class Engine < ::Rails::Engine
      initializer 'ajax_canvas_field.assets.precompile' do |app|
        # config.assets only exists with sprockets-rails, and an application can
        # just as well be on propshaft or have no asset pipeline at all.
        # simplecov:disable branch - runs once per application boot
        next unless app.config.respond_to?(:assets)

        %w[stylesheets javascripts images].each do |sub|
          app.config.assets.paths << root.join('app/assets', sub).to_s
        end
        app.config.assets.precompile += %w[mouse_left.png mouse_right.png mouse_middle.png]
        # simplecov:enable branch
      end
    end
  end
end
