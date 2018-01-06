module Bash
  def tool
    "bash"
  end
  def target_user
    node[tool]["user"]
  end
  def target_group
    if mac_os_x?
      "staff"
    else
      target_user
    end
  end
  def target
    node[tool]["target"]
  end
  def target_dir
    "#{home}/#{target}/#{tool}"
  end
  def config_dir
    "#{target_dir}/config"
  end
  def custom_dir
    "#{target_dir}/custom"
  end
  def is_root?
    target_user.eql? "root"
  end
  def platform
    node[:platform]
  end
  def mac_os_x?
    platform.eql? "mac_os_x"
  end
  def home
    if mac_os_x?
      if is_root?
        "/var/root"
      else
        "/Users/#{target_user}"
      end
    else
      if is_root?
        "/root"
      else
        "/home/#{target_user}"
      end
    end
  end
  def default_file_mode
    0755
  end
  def read_only
    0444
  end
end
