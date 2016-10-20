set :application,                       "imperiumdesign"
set :domain,                            "46.101.57.96"
set :deploy_to,                         "/var/www/#{application}.co.uk"
set :app_path,                          "app"

set :use_sudo,                          false
set :user,                              "drolya"
set :writable_dirs,                     ["app/cache", "app/logs", "app/sessions"]
set :webserver_user,                    "drolya"
set :permission_method,                 :acl
set :use_set_permissions,               true


set :clear_controllers,                 false

set :deploy_via,                        :remote_cache

set :model_manager,                     "doctrine"
a
set :repository,                        "git@github.com:rdenes93/imperiumdesign.git"
set :scm,                               :git
set :branch,                            "develop"
set :core_branch,                       "develop"

role :web,                              domain                         # Your HTTP server, Apache/etc
role :app,                              domain, :primary => true       # This may be the same as your `Web` server
role :db,                               domain, :primary => true

set :keep_releases,                     5

set :clear_controllers,                 false

set :dump_assetic_assets,               true
set :use_composer,                      true
set :shared_files,                      ["app/config/parameters.yml"]
set :shared_children,                   [app_path + "/logs", web_path + "/uploads", "vendor", app_path + "/sessions"]

logger.level = Logger::MAX_LEVEL
default_run_options[:pty] = true