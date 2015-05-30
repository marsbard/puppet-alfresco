# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # http://www.miniwebtool.com/mac-address-generator/
  config.vm.network "public_network", :mac => 'B8B2253CFD00'

  config.vm.provider "virtualbox" do |v|
    v.memory = 2500 
    v.cpus = 2
  end

 # config.vm.box = "ubuntu/trusty64"
config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end

  config.vm.network :forwarded_port, guest: 8443, host: 8443

  config.vm.provision :shell do |shell|
    shell.inline = "OS=`cat /etc/issue | head -n1 | cut -f1 -d' '`; if [ \"$OS\" == \"Debian\" -o \"$OS\" == \"Ubuntu\" ]; then apt-get update; else yum -y update; fi; cd /vagrant; install/modules-for-vagrant.sh"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "."
    puppet.manifest_file  = "go.pp"
    puppet.module_path = ["modules"]
  end

end
