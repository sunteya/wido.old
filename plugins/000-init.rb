require "pry-nav"

octopress = File.expand_path("../../octopress", __FILE__)
Dir.chdir(octopress) do
  Dir[File.join("plugins", "**/*.rb")].each do |f|
    file = File.absolute_path(f)
    puts file
    require file
  end
end


