# frozen_string_literal: true

require 'tmpdir'
require 'generators/ajax_canvas_field/ajax_canvas_field_generator'

RSpec.describe AjaxCanvasFieldGenerator do
  # The generator writes relative to its destination root and prints what it
  # does, so every example gets a throwaway application and a quiet shell.
  def run_generator(root)
    generator = described_class.new([], [], destination_root: root)
    original = $stdout
    $stdout = StringIO.new
    generator.invoke_all
    $stdout = original
  ensure
    $stdout = original
  end

  def write(root, path, contents)
    full = File.join(root, path)
    FileUtils.mkdir_p(File.dirname(full))
    File.write(full, contents)
    full
  end

  around do |example|
    Dir.mktmpdir { |dir| @root = dir and example.run }
  end

  attr_reader :root

  it 'copies the initializer' do
    run_generator(root)

    initializer = File.read(File.join(root, 'config/initializers/ajax_canvas_field.rb'))
    expect(initializer).to include('AjaxCanvasField.configure(default_height: 400,')
  end

  it 'requires the javascript of the gem in the asset manifests' do
    write(root, 'app/assets/javascripts/application.js', "//= require rails-ujs\n//= require_tree .\n")
    write(root, 'app/assets/javascripts/application.coffee', "#= require rails-ujs\n//= require_tree .\n")

    run_generator(root)

    expect(File.read(File.join(root, 'app/assets/javascripts/application.js')))
      .to eq("//= require rails-ujs\n//= require ajax_canvas_field\n//= require_tree .\n")
    expect(File.read(File.join(root, 'app/assets/javascripts/application.coffee')))
      .to include("//= require ajax_canvas_field\n//= require_tree .\n")
  end

  it 'requires the stylesheet of the gem in every manifest flavour' do
    %w[application.scss application.scss.erb application.css.scss].each do |name|
      write(root, "app/assets/stylesheets/#{name}", " *= require_tree .\n")
    end

    run_generator(root)

    %w[application.scss application.scss.erb application.css.scss].each do |name|
      expect(File.read(File.join(root, "app/assets/stylesheets/#{name}")))
        .to eq(" *= require ajax_canvas_field\n *= require_tree .\n")
    end
  end

  it 'copies the initializer even when there is no asset manifest to inject into' do
    expect { run_generator(root) }.not_to raise_error

    expect(File).to exist(File.join(root, 'config/initializers/ajax_canvas_field.rb'))
    expect(File).not_to exist(File.join(root, 'app/assets/javascripts/application.js'))
  end
end
