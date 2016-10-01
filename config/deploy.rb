require 'bundler/capistrano'

set :application, "glowfori"
set :repository,  "git@github.com:malagodia/glowcon.git"

server '184.164.147.27', :app, :web, :db, primary: true

set :scm, :git

set :scm_username, 'deployer'
set :use_sudo, false

set :branch, 'master'
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

set :default_shell, 'bash -l'
set :keep_releases, 5

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

task :staging do
  set :rails_env, 'staging'
  set :user, 'glowfori'
  set :deploy_to, "/home/#{user}/#{application}"
end

after "deploy:update", "deploy:cleanup"
after "deploy:create_symlink", "deploy:migrate"
after "deploy", "passenger:restart"

namespace :deploy do
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc 'Cold update for code'
  task :cold_update do
    run "cd #{current_path} && git pull origin #{fetch(:branch)} && touch tmp/restart.txt"
  end
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
