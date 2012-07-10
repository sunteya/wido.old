module Jekyll
  class BundlePage < Page
    
    def initialize(site, base, title, rules)
      @site = site
      @base = base

      
      @name = 'index.html'
      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), 'bundle_index.html')
      
      @rules = rules
      posts = self.parse_posts
      self.data['title'] = title
      @dir = @site.bundle_url(title) #"bundles/#{title.downcase}"

      # self.data['category']    = category
      # self.data['posts']       = posts
      # Set the title for this page.
      # title_prefix             = site.config['category_title_prefix'] || 'Category: '
      # self.data['title']       = "#{title_prefix}#{category}"
      # Set the meta-description for this page.
      # meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
      # self.data['description'] = "#{meta_description_prefix}#{category}"
    end

    def parse_posts
      @posts ||= []
      site.posts.each do |post|
        if follow_rules?(post)
          @posts << post
        end
      end

      self.data['posts'] = @posts
    end

    def follow_rules?(post)
      return false if ((@rules["not"] || []).flatten & post.tags).any?

      matchs = @rules["any"].map do |tags|
        (tags & post.tags).any?
      end

      matchs.all?
    end
    
  end
  
  class Site
    def write_bundle_pages
      self.config["bundles"].each_pair do |name, value|
        rules = convert_bundle_rules(value)
        bundle_page = BundlePage.new(self, self.source, name, rules)
        self.pages << bundle_page
      end
    end

    def arrayize(data)
      case data
      when String
        data.split(/ |,/)
      else
        data.to_a
      end
    end

    def convert_bundle_rules(list)
      list.inject({}) do |hash, item|
        item.each_pair do |key, value|
          hash[key] ||= []
          hash[key] << arrayize(value)
        end
        hash
      end
    end

    def bundle_url(name)
      "/bundles/#{name.downcase}"
    end
  end
  
  module Filters
    def bundle_url(name)
      site = @context.registers[:site]
      site.bundle_url(name)
    end
  end

  class BundlesGenerator < Generator
    safe true
    priority :low
    
    def generate(site)
      site.write_bundle_pages
    end
  end
  
end