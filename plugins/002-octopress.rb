octopress = File.expand_path("../../octopress", __FILE__)

Dir.chdir(octopress) do
  Dir[File.join("plugins", "**/*.rb")].each do |f|
    require File.absolute_path(f)
  end
end
