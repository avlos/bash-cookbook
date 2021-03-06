#
# Cookbook:: bash
# Recipe:: _inputrc
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

file = "inputrc"
cookbook_file "#{target_dir}/#{file}" do
  source "#{file}"
  owner target_user
  group target_group
  mode read_only
  action :create
end
