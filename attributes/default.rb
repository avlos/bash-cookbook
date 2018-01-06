#
# Cookbook:: bash
# Recipe:: default
#
# Copyright:: 2019, avlos, llc, All Rights Reserved

# Don't forget to set the bash user on the parent cookbook
default["bash"]["user"] = "obi-wan"
default["bash"]["target"] = ".config"
default["bash"]["env_variables"] = {
  # a temporary file directory
  tmp_dir: nil,
  # Your default editor command here
  editor: "nvim"
}

# developer, admin or root
default["bash"]["user_type"] = "developer"
# if the user is root always configure the admin tier
if node["bash"]["user"] == "root"
  node.default["bash"]["user_type"] = "root"
end

if node["bash"]["user_type"] == "developer"
  # attribute to determine wether we are configuring a desktop machine with a gui
  # for an xmodmap configuration
  default["bash"]["desktop"] = false
  # For nvm load a default node version
  default["bash"]["nodejs"]["version"] = "10"
  # For rvm load a default ruby version
  default["bash"]["ruby"]["version"] = "2.6.1"
end
