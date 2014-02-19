include_recipe "yum::epel"
include_recipe "rvm::system_install"

version = node['newrelic_mongodb_agent']['version']
install_root = node['newrelic_mongodb_agent']['install_root']

user node['newrelic_mongodb_agent']['user'] do
  system true
end

# create rvm bundle wrapper for use in deployment
rvm_wrapper 'mongodb_agent' do
  ruby_string   node['newrelic_mongodb_agent']['rvm_ruby']
  binary        "bundle"
end

directory install_root

tar_extract "#{node['newrelic_mongodb_agent']['download_root']}/#{version}.tar.gz" do
  target_dir install_root
  creates "#{install_root}/mongodb_agent.rb"
  tar_flags [ '--strip-components 1' ]
end

template "#{install_root}/config/newrelic_plugin.yml" do
  source "newrelic_plugin.yml.erb"
  user node['newrelic_mongodb_agent']['user']
  mode '0644'
end
