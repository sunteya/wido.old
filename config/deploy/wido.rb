set :deploy_to, "/var/www/wido/apps/#{application}"

set :user, "www-data"
server "wido.me", :app, :web, :db

