# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "askandhack"
set :repo_url, "git@github.com:mgrigoriev/ask-and-hack.git"

set :deploy_to, "/home/deployer/askandhack"
set :deploy_user, "deployer"

# set :rvm_ruby_version, 'ruby-2.3.1@ask-and-hack'
# set :rvm_ruby_version, '2.3.1@ask-and-hack'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/production.sphinx.conf", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
