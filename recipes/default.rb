#
# Cookbook Name:: quirkafleeg-deployment
# Recipe:: default
#
# Copyright 2013, The Open Data Institute
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'odi-base'
include_recipe 'git'
include_recipe 'odi-ruby'

class Chef::Recipe
  include ODI::Deployment::Helpers
end

deploy_root = node['deployment']['root']
domain      = get_domain

[
    deploy_root,
    "/etc/nginx/sites-enabled"
].each do |dir|
  directory dir do
    action :create
    recursive true
  end
end

mysql_ip = nil
dbi      = nil
dbi      = data_bag_item node['databags']['primary'], 'databases'

if node['database']
  if dbi['host']
    mysql_ip = dbi['host']
  else
    mysql_ip = find_a 'mysql'
  end
end

if node['requires_memcached']
  memcached_ip = find_a 'memcached'
end

precompile_assets = node['deployment']['precompile_assets'].nil? ? true : node['deployment']['precompile_assets']
port              = node['deployment']['port']

fqdn = node['project_fqdn']
unless [nil, ''].include? node['prefix']
  fqdn = '%s.%s' % [
    node['prefix'],
    fqdn
  ]
end

root_dir          = "%s/%s" % [
    deploy_root,
    fqdn
]

make_shared_dirs root_dir

deploy_revision root_dir do
  user node['user']
  group node['user']

  environment(
      "RACK_ENV" => node['deployment']['rack_env'],
      "HOME"     => "/home/%s" % [
          user
      ]
  )

  keep_releases 10
  rollback_on_error false
  migrate           node.has_key? :migrate
  migration_command node['migrate']

  revision node['deployment']['revision']

  repo "git://github.com/theodi/%s.git" % [
      node['git_project']
  ]

  before_migrate do
    current_release_directory = release_path
    running_deploy_user       = new_resource.user
    shared_directory          = new_resource.shared_path
    bundler_depot             = new_resource.shared_path + '/bundle'

    begin
      mysql_password = dbi[node['database']][node.chef_environment]
    rescue
      mysql_password = 'ThisPasswordIntentionallyLeftBlank'
    end

    {
        'database.yml' => {
            :mysql_host     => mysql_ip,
            :mysql_database => node['database'],
            :mysql_username => node['database'],
            :mysql_password => mysql_password
        }
    }.each_pair do |name, params|
      template "%s/config/%s" % [
          shared_directory,
          name
      ] do

        source "%s.erb" % [
            name
        ]
        variables(
            params
        )
        user node['user']
        group node['user']
        mode "0644"
        action :create
      end

      db_conf_symlink name do
        shared_dir shared_directory
        current_dir current_release_directory
      end
    end

    script 'Symlink env' do
      interpreter 'bash'
      cwd current_release_directory
      user running_deploy_user
      code <<-EOF
        ln -sf /home/#{user}/env .env
      EOF
    end

    bundlify current_release_directory do
      user running_deploy_user
      depot bundler_depot
    end

    precompile_assets "Precompile assets" do
      user running_deploy_user
      cwd current_release_directory

      only_if node['precompile_assets']
    end
  end

  before_restart do

    current_release_directory = release_path
    running_deploy_user       = new_resource.user

    e = "%s/.env.%s" % [
      current_release_directory,
      node['deployment']['rack_env']
    ]

    f = File.open e, "a"

    if memcached_ip
      f.write "MEMCACHED_HOSTS: "
      f.write memcached_ip
      f.write "\n"
    end

    f.close
    FileUtils.chown running_deploy_user, running_deploy_user, e

    foremanise node['git_project'] do
      cwd current_release_directory
      user running_deploy_user
      root_dir root_dir
      port port
    end

    make_vhosts node['git_project'] do
      cwd current_release_directory
      user running_deploy_user
      fqdn fqdn
    end
  end

  restart_command "sudo service %s restart" % [
      node['git_project']
  ]
  notifies :restart, "service[nginx]"

  after_restart do
    running_deploy_user       = new_resource.user
    current_release_directory = release_path

    post_deploy_tasks node['post_deploy_tasks'] do
      cwd current_release_directory
      user running_deploy_user
    end
  end

  action :force_deploy

end
