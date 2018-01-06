#
# Cookbook:: bash
# Recipe:: custom
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

directory custom_dir do
  recursive true
  owner target_user
  group target_group
  mode default_file_mode
  action :create
end

%w(aliases functions path).each do |f|
  file "#{custom_dir}/#{f}" do
    content ''
    mode default_file_mode
    owner target_user
    group target_group
  end
end
