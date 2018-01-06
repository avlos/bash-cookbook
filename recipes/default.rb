#
# Cookbook:: bash
# Recipe:: default
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

if (!node["bash"]["env_variables"][:tmp_dir])
  node.default["bash"]["env_variables"][:tmp_dir] = "#{home}/#{target}/tmp"
end
directory "#{home}/#{target}" do
  recursive true
  owner target_user
  group target_group
  mode default_file_mode
  action :create
end

directory target_dir do
  recursive true
  owner target_user
  group target_group
  mode default_file_mode
  action :create
end

include_recipe "bash::_profile"
include_recipe "bash::_bashrc"
include_recipe "bash::_bash_profile"
include_recipe "bash::_bash_logout"
include_recipe "bash::_config"
include_recipe "bash::_custom"
include_recipe "bash::_setup"
