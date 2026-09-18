# frozen_string_literal: true

require 'yaml'

module AjaxCanvasField
  # Configuration defaults
  @config = {
    default_height: 470,
    default_width: 470,
    default_left_color: '#ff0000',
    default_middle_color: '#00ff00',
    default_right_color: '#0000ff'
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k, v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    config = YAML.load_file(path_to_yaml_file)
    configure(config)
  rescue Errno::ENOENT
    warn "AjaxCanvasField: YAML configuration file couldn't be found. Using defaults."
  rescue Psych::SyntaxError
    warn 'AjaxCanvasField: YAML configuration file contains invalid syntax. Using defaults.'
  end

  def self.config
    @config
  end
end
