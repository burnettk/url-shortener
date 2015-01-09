require 'bundler/capistrano'

# if you haven't set the application name, it will default to url-shortener
if !exists?(:application)
  set :application, 'url-shortener'
end

set :user, 'deploy'

set(:deploy_to) { "/usr/website/#{fetch(:application)}" }
set :use_sudo, false

set :scm, :git

# if you haven't set the repository, it will default to the github address
if !exists?(:repository)
  set :repository, 'git@github.com:burnettk/url-shortener.git'
end

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

# if there's any deployment-related config you don't want in version control, put it in here
begin
  load 'config/deploy_secrets'
rescue LoadError
  puts '[RAILS_ROOT]/config/deploy_secrets.rb did not exist. This is fine, though if you want to override any cap configs, put your configs in there.'
end
