#
# Cookbook:: bash
# Recipe:: _setup
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

Chef::Recipe.send(:include, Bash)
Chef::Resource.send(:include, Bash)
Chef::Mixin::Template::TemplateContext.send(:include, Bash)

# Setup the symbolic links to the bash config files.
config_files = %w(bash_logout bash_profile bashrc profile inputrc)
config_files.each do |file|
  link "#{home}/.#{file}" do
    owner target_user
    group target_user
    to "#{target_dir}/#{file}"
  end
end

# configures a setup.sh file, which symbolically links the configured files
file = "setup.sh"
template "#{target_dir}/#{file}" do
  source "#{file}.erb"
  owner target_user
  group target_group
  mode default_file_mode
  action :create
  variables(config_files: config_files)
end
