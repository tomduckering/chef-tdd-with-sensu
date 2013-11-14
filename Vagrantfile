# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

box_name = 'packer_centos_6.4_virtualbox'        # Basic linux setup
#box_name = 'packer_centos_6.4_CIS_virtualbox'   # More Secure Linux Setup

#box_url = "./#{box_name}.box"  # For getting the box from local filesystem
box_url = "https://s3-eu-west-1.amazonaws.com/td-vagrant-boxes/#{box_name}.box"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = box_name

  config.vm.box_url = box_url
  config.vm.define :monitoring do |vm|
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["chef/external-cookbooks", "chef/cookbooks"]
      config.vm.network "forwarded_port", guest: 8080, host: 8080
      chef.data_bags_path = "chef/data_bags"
      chef.add_recipe "monitoring"
    end
  end

  config.vm.define :webserver do |vm|
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["chef/external-cookbooks", "chef/cookbooks"]
      config.vm.network "forwarded_port", guest: 80, host: 8081
      chef.data_bags_path = "chef/data_bags"
      chef.log_level = "debug"
      chef.add_recipe "webserver"
    end
  end
end
