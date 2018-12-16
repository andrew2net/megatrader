require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'mgtr2'
set :user, 'deploy'    # Username in the server to SSH to.
set :deploy_to, "/home/#{fetch :user}/megatrader"
set :shared_path, 'shared'
set :repository, 'https://github.com/andrew2net/megatrader.git'
set :branch, 'master'
set :rvm_use_path, '/usr/share/rvm/bin/rvm'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_dirs, [ 'bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/images', 'public/help', 'public/help-en', 'lib/chart', 'Download', 'public/assets']
set :shared_files, ['config/database.yml', 'config/secrets.yml']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
  ruby_version = File.read('.ruby-version').strip
  raise "Couldn't determine Ruby version: Do you have a file .ruby-version in your project root?" if ruby_version.empty?
  ruby_gemset = File.read('.ruby-gemset').strip
  raise "Couldn't determine Ruby gemset: Do you have a file .ruby-gemset in your project root?" if ruby_gemset.empty?
  # invoke :'rvm:use', "#{ruby_version}@#{ruby_gemset}"

  command %{
    source /usr/share/rvm/scripts/rvm
    rvm use #{ruby_version}@#{ruby_gemset} || exit 1
  }
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  command %[mkdir -p "#{fetch :deploy_to}/#{fetch :shared_path}/log"]
  command %[chmod g+rx,u+rwx "#{fetch :deploy_to}/#{fetch :shared_path}/log"]

  command %[mkdir -p "#{fetch :deploy_to}/#{fetch :shared_path}/config"]
  command %[chmod g+rx,u+rwx "#{fetch :deploy_to}/#{fetch :shared_path}/config"]

  command %[touch "#{fetch :deploy_to}/#{fetch :shared_path}/config/database.yml"]
  command %[touch "#{fetch :deploy_to}/#{fetch :shared_path}/config/secrets.yml"]
  command  %[echo "-----> Be sure to edit '#{fetch :deploy_to}/#{fetch :shared_path}/config/database.yml' and 'secrets.yml'."]

  if fetch :repository
    repo_host = fetch(:repository).split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(fetch :repository) && /:([0-9]+)/.match(fetch :repository)[1] || '22'

    command %[
      if ! ssh-keygen -H -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  on :before_hook do
    # Put things to run locally before ssh
    command 'sudo systemctl stop sidekiq.service'
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    # command 'sudo reload sidekiq'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      command 'sudo service nginx reload'
      command 'sudo systemctl start sidekiq.service'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
