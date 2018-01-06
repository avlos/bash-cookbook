#
# Cookbook:: bash
# Recipe:: _bash_profile
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

file = "bash_profile"
template "#{target_dir}/#{file}" do
  source "#{file}.erb"
  owner target_user
  group target_group
  mode read_only
  action :create
end

if node["bash"]["user_type"] != "root"
  cookbook_file "#{target_dir}/git-prompt.sh" do
    source "git-prompt.sh"
    owner target_user
    group target_group
    mode read_only
    action :create
  end
end
