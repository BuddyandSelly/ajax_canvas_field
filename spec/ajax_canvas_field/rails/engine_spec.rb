# frozen_string_literal: true

RSpec.describe AjaxCanvasField::Rails::Engine do
  # The initializer ran when the spec application booted, see
  # spec/support/rails_app.rb.
  let(:assets) { ::Rails.application.config.assets }

  it 'adds the asset paths of the gem' do
    root = described_class.root

    expect(assets.paths).to include(root.join('app/assets/stylesheets').to_s,
                                    root.join('app/assets/javascripts').to_s,
                                    root.join('app/assets/images').to_s)
  end

  it 'precompiles the mouse button images' do
    expect(assets.precompile).to include('mouse_left.png', 'mouse_middle.png', 'mouse_right.png')
  end
end
