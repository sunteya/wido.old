module Liquid

  #   {% content_for sidebar %}
  #     Monkeys!
  #   {% endcontent_for %}
  #   ...
  #   <h1>{{ content_for_sidebar }}</h1>
  #
  #
  class ContentFor < Block
    Syntax = /(\w+)/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @to = $1
      else
        raise SyntaxError.new("Syntax Error in 'capture' - Valid syntax: capture [var]")
      end

      super
    end

    def render(context)
      output = super
      name = "content_for_#{@to}"
      (context.environments.first[name] ||= "") << output
      ''
    end
  end

  Template.register_tag('content_for', ContentFor)
end
