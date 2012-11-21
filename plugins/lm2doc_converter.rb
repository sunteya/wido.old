require "lm2doc"

module Jekyll
  
  class MarkdownConverter < Converter
    def matches_with_lm2doc_support(ext)
      return false if @config['markdown'] == "lm2doc"
      matches_without_lm2doc_support(ext)
    end
    
    alias_method_chain :matches, :lm2doc_support
  end
  
  class Lm2docConverter < Converter
    safe true

    pygments_prefix "\n"
    pygments_suffix "\n"

    def setup
      return if @setup
      @setup = true
      
      if @config['markdown'] == "lm2doc"
        begin
          require "lm2doc"
        rescue LoadError
          raise FatalException.new("Missing dependency: lm2doc")
        end
      end
    end
    
    def matches(ext)
      rgx = '(' + @config['markdown_ext'].gsub(',','|') +')'
      ext =~ Regexp.new(rgx, Regexp::IGNORECASE)
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      converter = Lm2doc::Markdown.new
      converter.content = content
      converter.as_html
    end
  end

end
