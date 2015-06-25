set :application,                       "imperiumdesign"
set :domain,                            "46.101.57.96"
set :user,                              "drolya"
set :deploy_to,                         "/var/www/#{application}.co.uk"
set :app_path,                          "app"

set :clear_controllers,                 false

set :deploy_via,                        :remote_cache

set :model_manager,                     "doctrine"

set :repository,                        "git@github.com:rdenes93/imperiumdesign.git"
set :scm,                               :git
set :branch,                            "develop"
set :core_branch,                       "develop"

role :web,                              domain                         # Your HTTP server, Apache/etc
role :app,                              domain, :primary => true       # This may be the same as your `Web` server

set :keep_releases,                     5

set :clear_controllers,                 false

logger.level = Logger::MAX_LEVEL
default_run_options[:pty] = true