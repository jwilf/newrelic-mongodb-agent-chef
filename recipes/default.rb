include_recipe "yum::epel"
include_recipe "rvm::system_install"
include_recipe "runit"

name = 'mongodb_agent'

version = node['newrelic_mongodb_agent']['version']
install_root = node['newrelic_mongodb_agent']['install_root']
user = node['newrelic_mongodb_agent']['user']

user user do
  supports :manage_home => true
  home '/var/lib/mongo'
  system true
end

# create rvm bundle wrapper for use in deployment
rvm_wrapper name do
  ruby_string   node['newrelic_mongodb_agent']['rvm_ruby']
  binary        "bundle"
end

bundle_command = "/usr/local/rvm/bin/#{name}_bundle"

directory "#{install_root}/shared/config" do
  recursive true
  owner user
end

template "#{install_root}/shared/config/newrelic_plugin.yml" do
  source "newrelic_plugin.yml.erb"
  user node['newrelic_mongodb_agent']['user']
  mode '0644'
end

application name do
  repository node['newrelic_mongodb_agent']['repository']
  revision version
  owner user
  path install_root
  action 'force_deploy'
  symlink_before_migrate(
    "config/newrelic_plugin.yml" => "config/newrelic_plugin.yml",
  )
  rails do
    bundler true
    bundle_command bundle_command
  end
end

runit_service name do
  subscribes :restart, resources("application[mongodb_agent]"), :delayed
  subscribes :restart, resources("template[#{install_root}/shared/config/newrelic_plugin.yml]"), :delayed
end
