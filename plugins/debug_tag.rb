module Liquid
  class Debug < Tag
    def render(context)
      binding.pry
      ''
    end
  end
  
  Template.register_tag('debug', Debug)
end

