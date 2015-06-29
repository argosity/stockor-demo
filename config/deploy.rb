set :application, 'stockor'
set :repo_url, 'git@github.com:argosity/stockor-demo-access.git'

set :deploy_to, '/srv/www/stockor-next-gen'

namespace :deploy do
    desc 'Restart application'
    task :restart do
        on roles(:app, :web), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end
end

after 'deploy:publishing', 'deploy:restart'
