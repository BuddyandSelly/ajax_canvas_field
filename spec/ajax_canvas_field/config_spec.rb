# frozen_string_literal: true

require 'tmpdir'

RSpec.describe AjaxCanvasField do
  describe '.config' do
    it 'starts from the defaults of the gem' do
      expect(AjaxCanvasField.config).to eq(default_height: 470,
                                           default_width: 470,
                                           default_left_color: '#ff0000',
                                           default_middle_color: '#00ff00',
                                           default_right_color: '#0000ff')
    end
  end

  describe '.configure' do
    it 'takes a known setting' do
      AjaxCanvasField.configure(default_height: 123)

      expect(AjaxCanvasField.config[:default_height]).to eq(123)
    end

    it 'takes a string key' do
      AjaxCanvasField.configure('default_width' => 321)

      expect(AjaxCanvasField.config[:default_width]).to eq(321)
    end

    it 'ignores a setting it does not know' do
      AjaxCanvasField.configure(nonsense: true)

      expect(AjaxCanvasField.config).not_to have_key(:nonsense)
    end

    it 'changes nothing when called without arguments' do
      expect { AjaxCanvasField.configure }.not_to(change { AjaxCanvasField.config.dup })
    end
  end

  describe '.configure_with' do
    around do |example|
      Dir.mktmpdir { |dir| example.run(dir) }
    end

    def write_yaml(dir, contents)
      File.join(dir, 'ajax_canvas_field.yml').tap { |path| File.write(path, contents) }
    end

    it 'reads the settings out of a yaml file' do
      path = write_yaml(Dir.tmpdir, "default_height: 300\ndefault_width: 200\n")

      AjaxCanvasField.configure_with(path)

      expect(AjaxCanvasField.config).to include(default_height: 300, default_width: 200)
    ensure
      File.delete(path)
    end

    it 'warns and keeps the defaults when the file is not there' do
      expect { AjaxCanvasField.configure_with('/nowhere/ajax_canvas_field.yml') }
        .to output(/couldn't be found/).to_stderr

      expect(AjaxCanvasField.config[:default_height]).to eq(470)
    end

    it 'warns and keeps the defaults when the file is not valid yaml' do
      path = write_yaml(Dir.tmpdir, "default_height: [1,\n  2\n")

      expect { AjaxCanvasField.configure_with(path) }.to output(/invalid syntax/).to_stderr

      expect(AjaxCanvasField.config[:default_height]).to eq(470)
    ensure
      File.delete(path)
    end
  end
end
