# bash

## Introduction

This Chef cookbook sets up a Bash configuration in a target directory of your choice within your user's home folder. The recipe assumes the user already exists on the target system. Currently the recipe works for macOSX and Ubuntu/Debian operating systems.

## Requirements

Make sure you have the following installed:
* [rvm](https://rvm.io/rvm/install)
* [nvm](https://github.com/creationix/nvm/blob/master/README.md)
* [virtualenv](https://virtualenv.pypa.io/en/stable/installation/)
* [direnv](https://direnv.net/)
* [colordiff](https://www.colordiff.org/)

The following attributes will determine the user whose bash environment you are configuring and the target folder mentioned above.

```
  default["bash"]["user"] = "johnny"
  default["bash"]["target"] = ".config"
```

So if you are on an Ubuntu machine and configure the recipe attributes as shown above, the user `johnny` will have their bash dotfiles configured and placed within `/home/johnny/.config/bash`.
The home directory of the user is determined based on helper methods found in the `libraries` folder. It also supports the root user as an input in which case (for Ubuntu) the home folder will be `/var/root` and the target directory will be`/var/root/.config/bash`.

### Recipes

#### default

The default recipe runs all the other recipes in the recipes folder. Every recipe configures one file and at the end a recipe named `_setup` creates symlinks in your home folder to all the dotfiles configured by the Chef run and creates a shell script called `setup.sh`. The shell script allows you to do the same manually, i.e. to symlink the files from the target directory to your home folder.

The following is the structure of the target directory:

```
bash
├── bash_logout
├── bash_profile
├── bashrc
├── config
│   ├── aliases
│   ├── exports
│   ├── extra
│   ├── functions
│   └── path
├── custom
│   ├── custom_aliases
│   ├── custom_functions
│   └── custom_path
├── git-prompt.sh
├── profile
└── setup.sh
```

Most of the file names are self explanatory about their contents. In the custom directory you will find empty files where you can customize configuration for aliases, functions and path overrides according to your preferences.

#### the bash environment and file contents

##### profile

The `profile` file sources `bashrc` in the target directory.

##### bashrc

The `bashrc` file sources `bash_profile` in the target directory.

##### bash_profile

The `bash_profile` file contains all the configuration. It starts by cleaning the environment and sourcing `/etc/environment`, it then moves on to pick up some `bash_completion` configuration based on your operating system (Mac or ubuntu).

It exports a variable called `$MY_BASH` which points to the target directory mentioned above, and acts as a helper for the rest of the `bash_profile` script.

It moves on to source the `path,exports,extra,aliases,functions` files, setup some useful history settings and a practical git-prompt, not written by us (check the contents of `files/git-prompt.sh`)

Lastly, depending on whether you are setting up a development environment of a
production server it will create a PROMPT that makes sense for each
environment. The main difference between the two is that in a
development environment the user gets the python, ruby and javascript
version currently at the front of their path printed out on the right
side of their terminal. In production the PROMPT does not contain the version printouts.

Some notes on the prompt functions:
* The python version will also include the virtualenv you are currently
  on. This will override the way virtualenv actually amends your prompt.
* The ruby version printing relies on rvm (to be amended in future versions)
* There is no failover if the language is not found on the system and the printouts look ugly.

## Install

### Clone
`git clone git://github.com/avlos/bashenv-cookbook.git`

### Setup attributes
Go into attributes/default.rb and set the `default["bash"]["user"]` and `default["bash"]["target"]` to the user you wish to configure the files for and the target directory you want the files to live in, respectively.

If you want to setup a development environment which includes helper functions and aliases, path ammendments and a fancy printout of the language versions you are using on the right side of the terminal, set `default["bash"]["user_type"] = "developer"`. If you are configuring a minimal bash env, for example for an admin user, set `default["bash"]["user_type"] = "admin"`. If you are configuring the bash env for a root user the recipe will take care of the user_type attribute itself and set it to `root`, which will configure a very minimal environment.

Choose the default versions of ruby and node you would like to load once entering the shell by setting
`default["bash"]["nodejs"]["version"]` and ` default["bash"]["ruby"]["version"]`.

The `default["bash"]["desktop"]` attribute currently only sets up an xmodmap file.

In the default recipe at `recipes/default.rb` we set:
```
node.default["bash"]["env_variables"] = {
  tmp_dir: "#{home}/#{target}/tmp",
  editor: "nvim"
}
```

This creates a tmp directory in the target directory. It also sets your shell default editor. We use neovim! You can override these within the attributes file (which currently sets them to `nil`). For example if you would like to choose the system's `tmp` directory and the Sublime editor you could set:
```
default["bash"]["env_variables"] = {
  tmp_dir: "/tmp",
  editor: "subl"
}
```

in the `attributes/default.rb` file.

### Run the recipe
If you do not have the Chef development kit (chefdk) you should bundle to fetch the appropriate gems:
Run
```
bundle install
bundle exec chef-client -z -c config.rb -o "bash"
```

If you do have the chefdk installed:
```
chef-client -z -c config.rb -o "bash"
```

If you want to see what files will be changed without actually applying
those changes you can pass the `-W` flag, i.e:
```
bundle install
bundle exec chef-client -W -z -c config.rb -o "bash"
```
chefdk version:
```
chef-client -W -z -c config.rb -o "bash"
```

### Tests

We run our tests with test-kitchen configured with the docker provisioner. To run them:
without the chefdk:
```
bundle exec kitchen test
```

with the chefdk:
```
kitchen test
```


## Thanks


## License

bash may used and redistributed under the terms specified in the LICENSE file.

## About Avlos

bash is maintained by [Avlos, LLC.](https://avlos.io)
