app = 'warehouse'
bind "unix:///srv/rails/#{app}/current/tmp/sockets/puma.sock"
pidfile "/srv/rails/#{app}/current/tmp/puma/pid"
state_path "/srv/rails/#{app}/current/tmp/puma/state"
environment 'production'
rackup "/srv/rails/#{app}/current/config.ru"
activate_control_app