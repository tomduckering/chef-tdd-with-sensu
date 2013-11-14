#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

ark 'libyaml' do
	version '0.1.4'
	url 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
	action :install_with_make
end

package 'openssl-devel'

package 'zlib-devel'

ark 'ruby' do
	version '1.9.3-p448'
	url 'http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz'
	action :install_with_make
end

include_recipe 'sensu'

directory "/etc/sensu" do
	mode '0755'
	owner 'root'
	group 'root'
end

ark "sensu-community-plugins" do
  url "https://github.com/sensu/sensu-community-plugins/archive/master.zip"
  action :put
  path "/etc/sensu"
end

# execute "unpack sensu plugins" do
# 	command "unzip -o #{Chef::Config['file_cache_path']}/sensu-community-plugins.zip"
# 	cwd Chef::Config['file_cache_path']
# end

%w(plugins mutators handlers extensions).each do |type|
	execute "move #{type} into place" do
		command "rsync -r /etc/sensu/sensu-community-plugins/#{type}/ /etc/sensu/#{type}/"
	end

	execute "set perms on #{type}" do
		command "chmod -R 755 *"
		cwd "/etc/sensu/#{type}"
	end
end

cookbook_file "#{Chef::Config['file_cache_path']}/mixlib-cli-1.3.0.gem" do
	source 'mixlib-cli-1.3.0.gem'
end

gem_package "mixlib-cli" do
	gem_binary '/usr/local/bin/gem'
	action :install
	source "#{Chef::Config['file_cache_path']}/mixlib-cli-1.3.0.gem"
end

cookbook_file "#{Chef::Config['file_cache_path']}/sensu-plugin-0.2.1.gem" do
	source 'sensu-plugin-0.2.1.gem'
end

gem_package "sensu-plugin" do
	gem_binary '/usr/local/bin/gem'
	action :install
	source "#{Chef::Config['file_cache_path']}/sensu-plugin-0.2.1.gem"
end



include_recipe 'apache2'