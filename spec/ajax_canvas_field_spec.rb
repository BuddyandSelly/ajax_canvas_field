# frozen_string_literal: true

RSpec.describe AjaxCanvasField do
  it 'has a version' do
    expect(AjaxCanvasField::Rails::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  it 'loads the engine of the gem' do
    expect(AjaxCanvasField::Rails::Engine.superclass).to eq(::Rails::Engine)
  end

  it 'ships an initializer that configures the gem' do
    template = File.expand_path('../lib/generators/ajax_canvas_field/templates/initializer.rb', __dir__)

    expect { load template }.to change { AjaxCanvasField.config[:default_height] }.from(470).to(400)
    expect(AjaxCanvasField.config).to include(default_width: 340,
                                              default_left_color: '#ff0000',
                                              default_middle_color: '#00ff00',
                                              default_right_color: '#0000ff')
  end
end
