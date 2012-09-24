octopress = File.expand_path("../../octopress", __FILE__)

Dir.chdir(octopress) do
    # haml.rb
    # category_generator.rb
    # blockquote.rb
    # image_tag.rb
    # video_tag.rb
  %w[ 
    backtick_code_block.rb
    code_block.rb
    include_code.rb
    pagination.rb
    pullquote.rb
    render_partial.rb
    titlecase.rb
    date.rb
    jsfiddle.rb
    post_filters.rb
    pygments_code.rb
    rubypants.rb
    gist_tag.rb
    include_array.rb
    octopress_filters.rb
    preview_unpublished.rb
    raw.rb
    sitemap_generator.rb
  ].each do |file|
    path = File.join("plugins", file)
    require File.absolute_path(path)
  end
  
  # Dir[File.join("plugins", "**/*.rb")].each do |f|
    # require File.absolute_path(f)
  # end
end
