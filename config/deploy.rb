# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'stockor'
set :repo_url, 'git@github.com:argosity/stockor-demo-access.git'

set :deploy_to, '/srv/www/stockor-next-gen'
