# # encoding: utf-8

target_user = 'obi-wan'
target_group = 'obi-wan'
home = "/home/obi-wan"
target_dir = "#{home}/.config/bash"
default_file_mode = "0755"
read_only = "0444"
config_files = %w(bash_logout bash_profile bashrc profile inputrc)

describe user(target_user), :skip do
  it { should exist }
end

describe directory(target_dir) do
  its('owner') { should eq target_user }
  its('group') { should eq target_group }
  its('mode') { should cmp default_file_mode }
end

config_files.each do |f|
  describe file("#{target_dir}/#{f}") do
    its('owner') { should eq target_user }
    its('group') { should eq target_group }
    its('mode') { should cmp read_only }
  end
  describe file("#{home}/.#{f}") do
    its('link_path') { should eq "#{target_dir}/#{f}" }
  end
end
