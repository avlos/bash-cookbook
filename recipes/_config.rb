#
# Cookbook:: bash
# Recipe:: _config
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

directory config_dir do
  recursive true
  owner target_user
  group target_group
  mode default_file_mode
  action :create
end


include_recipe "bash::_aliases"
include_recipe "bash::_functions"
include_recipe "bash::_exports"
include_recipe "bash::_inputrc"
if node["bash"]["user_type"] != "root"
  include_recipe "bash::_extra"
  include_recipe "bash::_path"
end
