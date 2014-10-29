require 'bundler/capistrano'

# if there's any deployment-related config you don't want in version control, put it in here
require 'config/deploy_secrets' rescue nil

# if you haven't set the application name, it will default to url-shortener
set :application, fetch(:application, 'url-shorter')

set :user, 'deploy'

set :deploy_to, "/usr/website/#{application}"
set :use_sudo, false

set :scm, :git

# if you haven't set the repository, it will default to the github address
set :repository,  fetch(:repository, "git@github.com:burnettk/url-shortener.git")

set :branch, 'master'
set :deploy_via, :remote_cache

# set this up in config/deploy_secrets.rb
# server "poniesandrainbows.lan.exampledomain", :app, :web, :db, :primary => true

namespace :deploy do
  task :create_shared_config do
    run "mkdir #{shared_path}/config"
  end

  task :symlink_shared_config_files do
    run "ln -sf #{shared_path}/config/cas.yml #{latest_release}/config/cas.yml"
    run "ln -sf #{shared_path}/config/config.yml #{latest_release}/config/config.yml"
    run "ln -sf #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

  task :start do; end
  task :stop do; end
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after 'deploy:setup', 'deploy:create_shared_config'
after 'deploy:finalize_update', 'deploy:symlink_shared_config_files'
after 'deploy:finalize_update', 'deploy:migrate'
