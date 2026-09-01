# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ajax_canvas_field/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'ajax_canvas_field'
  spec.version       = AjaxCanvasField::Rails::VERSION
  spec.authors       = ['datyv']
  spec.email         = ['yvesgoizet@gmail.com']

  spec.summary       = 'HTML5 CanvasField Support'
  spec.description   = 'Add a CanvasField to point out errors in three different colors'
  spec.homepage = 'https://github.com/Datyv/ajax_canvas_field'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|src)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[app lib]

  spec.required_ruby_version = '>= 3.2'

  # The engine, the generator, the view helpers and the haml partial they render.
  spec.add_dependency 'actionview', '>= 7.0'
  spec.add_dependency 'activesupport', '>= 7.0'
  spec.add_dependency 'haml', '>= 6.0'
  spec.add_dependency 'railties', '>= 7.0'

  spec.add_development_dependency 'bundler', '>= 2.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.90'
  spec.add_development_dependency 'simplecov', '~> 1.1'
  # The engine adds the asset paths of the gem, which only exist with sprockets.
  spec.add_development_dependency 'sprockets-rails', '>= 3.4'
end
