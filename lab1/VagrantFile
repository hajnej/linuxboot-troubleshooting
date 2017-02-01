# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_DEFAULT_PROVIDER']='libvirt'
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provider :libvirt do |libvirt|
    libvirt.graphics_ip = '0.0.0.0'
    libvirt.boot 'hd'
    libvirt.boot 'cdrom'
    libvirt.storage :file, :device => :cdrom, :path => '/var/lib/libvirt/boot/CentOS-7-x86_64-DVD-1511.iso' 
  end
  config.vm.provision "shell", path: 'script.sh'
end
