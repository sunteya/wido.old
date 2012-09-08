# modify by https://gist.github.com/2874934

require 'sass'
require 'pathname'
require 'compass'
require 'compass/exec'

module Jekyll

  class CompassGenerator < Generator
    safe true
    
    def generate(site)
      Dir["**/_scss"].each do |dir|
        Dir.chdir(dir) do
          Compass::Exec::SubCommandUI.new(%w(compile)).run!
        end
      end
    end
    
  end
  
end