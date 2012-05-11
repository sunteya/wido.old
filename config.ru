require 'rack/contrib/try_static'

public_folder = "public"
use Rack::TryStatic, root: public_folder, urls: %w[/], try: ['.html', 'index.html', '/index.html']
run Rack::URLMap.new(
  "/" => Rack::Directory.new(public_folder)
)