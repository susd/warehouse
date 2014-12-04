# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'warehouse'
set :repo_url, 'https://github.com/susd/warehouse.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/srv/rails/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log public/uploads tmp/pids tmp/cache tmp/sockets config/nginx}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :setup do
  desc 'Upload Nginx config'
  task :nginx do
    on roles(:app) do
      upload! "config/nginx/#{fetch(:stage)}.conf", "#{shared_path}/config/nginx/"
    end
  end

  desc 'Setup service'
  task :service do
    on roles(:app) do
      upload! "config/#{fetch(:application)}.service", "/lib/systemd/system/"
      execute "systemctl daemon-reload"
      execute "systemctl enable #{fetch(:application)}.service"
    end
  end

  desc 'Set permissions for created dirs'
  task :perms do
    on roles(:app) do
      execute "chown -R deployer: /srv/rails/#{fetch(:application)}"
    end
  end

  task all: [
    'deploy:check:directories',
    'deploy:check:linked_dirs',
    'deploy:check:make_linked_dirs',
    'perms',
    'nginx',
    'deploy:secrets',
    'deploy:db_config',
    'deploy:check:linked_files',
    'service',
    'nginx:enable'
  ]
end


namespace :nginx do

  desc 'Enable site'
  task :enable do
    on roles(:app) do
      execute "ln -fs #{shared_path}/config/nginx/#{fetch(:stage)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}-nginx.conf"
    end
  end

  desc 'Restart Nginx'
  task :restart do
    on roles(:app) do
      execute "systemctl restart nginx"
    end
  end

end

namespace :systemd do

  desc 'Start service'
  task :start do
    on roles(:app) do
      execute "systemctl start #{fetch(:application)}"
    end
  end

  desc 'Stop service'
  task :stop do
    on roles(:app) do
      execute "systemctl stop #{fetch(:application)}"
    end
  end

  desc 'Restart service'
  task :restart do
    on roles(:app) do
      execute "systemctl restart #{fetch(:application)}"
    end
  end

  desc 'Check service'
  task :status do
    on roles(:app) do
      execute "systemctl status #{fetch(:application)}"
    end
  end

end

namespace :deploy do

  desc 'Push secrets'
  task :secrets do
    on roles(:app) do
      upload! 'config/secrets.yml', "#{shared_path}/config/"
    end
    # system "scp config/secrets.yml #{fetch(:server)}:#{shared_path}/config/"
  end

  desc 'Push db config'
  task :db_config do
    on roles(:app) do
      upload! 'config/database.yml', "#{shared_path}/config/"
    end
    # system "scp config/database.yml #{fetch(:server)}:#{shared_path}/config/"
  end

  desc 'Setup PG gem'
  task :pg_gem do
    on roles(:app) do
      execute "cd #{release_path} ; bundle config build.pg --with-pg-config=/usr/pgsql-9.3/bin/pg_config"
    end
  end

  desc 'Restart application'
  task restart: ['systemd:restart', 'nginx:restart']

  after :publishing, :secrets
  # after :publishing, :db_config
  after :finishing, :restart
  after :finishing, :cleanup

end

before  'bundler:install', 'deploy:pg_gem'
before  'deploy:migrate', 'deploy:db_config'
