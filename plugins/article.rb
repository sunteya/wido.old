require "pathname"

module Jekyll
  
  class Site
    
    def read_directories_with_articles(dir = "")
      self.load_articles(dir)
      self.read_directories_without_articles(dir)
    end
    alias_method_chain :read_directories, :articles
    
    def load_articles(dir)
      base = File.join(self.source, dir, '_articles')
      return unless File.exists?(base)
      
      entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }
      
      entries.each do |f|
        if Article.valid?(f)
          article = Article.new(self, self.source, dir, f)
          
          if article.published && (self.future || article.date <= self.time)
            self.posts << article
            # article.categories.each { |c| self.categories[c] << article }
            article.tags.each { |c| self.tags[c] << article }
            article.attachments.each { |attach| self.static_files << attach }
          end
        end
      end
      
      self.posts.sort!
      
      # limit the posts if :limit_posts option is set
      self.posts = self.posts[-limit_posts, limit_posts] if limit_posts
    end
  end
  
  class Article < Post
    MATCHER = %r|^(.+/)*(\d+-\d+-\d+)-([^/]*)(/index)?(\.[^.]+)$|
    def self.valid?(file)
      file =~ MATCHER
    end
    
    attr_accessor :folder
    
    def initialize(site, source, dir, name)
      super(site, source, dir, name)
      self.categories = [ self.data['author'] ]
    end
    
    def read_yaml(base, name)
      base.sub!("/_posts", "/_articles")
      super(base, name)
      
      common = File.join(base, "_data.yml")
      if File.exist?(common)
        common_data = YAML.load(File.read(common))
        self.data.deep_merge!(common_data)
      end
    end
    
    def folder?
      !!self.folder
    end
    
    def attachments
      return @attachments if defined?(@attachments)
      @attachments = []
      if folder?
        abs_folder = Pathname.new(@base).join(self.folder)
        Pathname.glob(abs_folder.join("**/*")).each do |pathname|
          next if Pathname.new(@base).join(name) == pathname
          relative_path = pathname.relative_path_from(abs_folder).to_s
          attach = Attachment.new(@site, @base, folder, relative_path, url)
          @attachments << attach
        end
      end
      
      @attachments
    end
    
    def process(name)
      m, cats, date, slug, is_folder, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
      
      self.folder = File.dirname(name) if is_folder
    rescue ArgumentError
      raise FatalException.new("Post #{name} does not have a valid date.")
    end
  end
  
  class Attachment < StaticFile
    attr_accessor :mount
    
    def initialize(site, base, dir, name, mount)
      super(site, base, dir, name)
      self.mount = mount
    end
    
    def destination(dest)
      File.join(dest, self.mount, @name)
    end
    
  end
  
end