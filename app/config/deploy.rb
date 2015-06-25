set :application, "imperiumdesign"
set :domain,      "#{application}.co.uk"
set :deploy_to,   "/var/www/#{domain}"
set :app_path,    "app"

set :repository,  "#{domain}:/var/repos/#{application}.git"
set :scm,         :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `subversion`, `mercurial`, `perforce`, or `none`

set :model_manager, "doctrine"
# Or: `propel`

role :web,        domain                         # Your HTTP server, Apache/etc
role :app,        domain, :primary => true       # This may be the same as your `Web` server

set  :keep_releases,  3

# Be more verbose by uncommenting the following line
# logger.level = Logger::MAX_LEVEL

set   :application,   "My App"
set   :deploy_to,     "/var/www/my-app.com"
set   :domain,        "my-app.com"

set   :scm,           :git
set   :repository,    "ssh-gitrepo-domain.com:/path/to/repo.git"

role  :web,           domain
role  :app,           domain, :primary => true

set   :use_sudo,      false
set   :keep_releases, 3