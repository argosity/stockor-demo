set :application, 'stockor'
set :repo_url, 'https://github.com/argosity/stockor-demo.git'
set :ssh_options, {forward_agent: true}
set :passenger_restart_with_touch, true
set :deploy_to, '/srv/www/stockor-demo'
set :linked_files, %w(config/secrets.rb config/database.yml)

namespace :deploy do
    desc 'Restart application'
    task :restart do
        on roles(:app, :web), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end
end

after 'deploy:publishing', 'deploy:restart'
