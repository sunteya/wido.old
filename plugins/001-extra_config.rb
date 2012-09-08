class Jekyll::Site

  def process_with_load_extra_config
    self.load_extra_config
    self.process_without_load_extra_config
  end
  alias_method_chain :process, :load_extra_config
  
  def load_extra_config
    root = File.expand_path("../..", __FILE__)
    file = File.join(root, "_config.extra.rb")
    return if !File.exist?(file)

    content = File.read(file)
    config = eval(content, binding, file)
    
    self.config.deep_merge!(config) if config.is_a?(Hash)
  end

end
