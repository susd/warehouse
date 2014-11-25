# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'warehouse'
set :repo_url, 'app2.saugususd.org:repos/warehouse'

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
set :linked_dirs, %w{bin log public/uploads tmp/pids tmp/cache tmp/sockets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :nginx do
  desc 'Enable site'
  task :enable do
    on roles(:app) do
      execute "ln -fs #{current_path}/config/nginx_#{fetch(:stage)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}-nginx.conf"
    end
  end
  
  after 'deploy:check', :enable
  
  desc 'Restart Nginx'
  task :restart do
    on roles(:app) do
      execute "systemctl restart nginx"
    end
  end
end

namespace :service do
  desc 'Copy service file in place'
  task :copy do
    on roles(:app) do
      execute "cp #{release_path}/config/#{fetch(:application)}.service /usr/lib/systemd/system/; systemctl --system daemon-reload"
    end
  end
  
  desc 'Restart systemd service'
  task :restart do
    on roles(:app) do
      execute "systemctl restart warehouse"
    end
  end
end

namespace :deploy do
  
  
  desc 'Push secrets'
  task :config do
    system "scp config/secrets.yml config/database.yml root@triprocker.com:/srv/rails/#{fetch(:application)}/shared/config/"
  end
  
  desc 'Create tmp dirs'
  task :dirs do
    on roles(:app) do
      execute "mkdir -p #{release_path}/tmp/puma"
    end
  end
  
  after :publishing, :config
  after :publishing, :dirs
  
  desc 'Restart application'
  task :restart do
    # on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    # end
    Rake::Task['service:copy'].invoke
    Rake::Task['service:restart'].invoke
    Rake::Task['nginx:restart'].invoke
  end
  
  after :dirs, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
  
end
