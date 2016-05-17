
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
#  you can also use the  vagrant box add ubuntu/trusty64 --provider virtualbox
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.proxy.http     = "http://foo:b\\$r@myproxy.com:3128"
  config.proxy.https    = "http://foo:b\\$r@myproxy.com:3128"
  config.proxy.no_proxy = "localhost,127.0.0.1,/var/run/docker.sock"
  # workaround for \\$ not working for apt
  # for apt the password special char $ must not be escaped with \\
  # side note: apt get can also use http_proxy(s) env vars but they MUST be lowercase
  config.apt_proxy.http = "http://foo:b$r@myproxy.com:3128"
  config.apt_proxy.https = "http://foo:b$r@myproxy.com:3128"

  
  #port forwarding:
  config.vm.network :forwarded_port, guest: 9300, host: 9300
  config.vm.network :forwarded_port, guest: 9200, host: 9200


  config.vm.synced_folder  ".", "/share", create:true
  #config.vm.synced_folder ".\\winshare", "/windowsshare", type: "smb" , create:true
  
  config.vm.box = "phusion-open-ubuntu-14.04-amd64"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"
    config.vm.network "private_network", type: "dhcp"


  config.vm.provider "virtualbox" do |v|
    #v.gui =true     user interface
    v.name = "my_phusion_ubuntu"
    v.memory = 1024
    v.cpus = 2
  end
  
  # Or, for Ubuntu 12.04:
  #config.vm.box = "phusion-open-ubuntu-12.04-amd64"
  #config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-12.04-amd64-vbox.box"

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box"
    #override.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-12.04-amd64-vmwarefusion.box"
  end

  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Install Docker
    pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
      "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
      "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
    # Add vagrant user to the docker group
    pkg_cmd << "usermod -a -G docker vagrant; "
    config.vm.provision :shell, :inline => pkg_cmd
  end
end


#list running virtual machines
# vboxmanage list runningvms
#reload configuration of the machine
#vagrant reload
