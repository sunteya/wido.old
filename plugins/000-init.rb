require "pry-nav"
require "active_support/all"
require "coderay_bash"

octopress = File.expand_path("../../octopress", __FILE__)
Dir.chdir(octopress) do
  Dir[File.join("plugins", "**/*.rb")].each do |f|
    require File.absolute_path(f)
  end
end
