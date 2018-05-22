# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
num_workers = 2

vmmemory = 1024
numcpu = 1

instances = []

(1..num_workers).each do |n| 
  instances.push({:name => "worker#{n}", :ip => "192.168.10.#{n+2}"})
end

manager_ip = "192.168.10.2"

prometheus_ip = "192.168.10.100"

File.open("./hosts", 'w') { |file| 
  instances.each do |i|
    file.write("#{i[:ip]} #{i[:name]} #{i[:name]}\n")
  end
}

Vagrant.require_version ">= 1.8.4"

Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |v|
     	v.memory = vmmemory
  	  v.cpus = numcpu
    end
    
    config.vm.define "manager" do |box|
        box.vm.box = "ubuntu/bionic64"
        box.vm.hostname = "manager"
        box.vm.network "private_network", ip: "#{manager_ip}"
        box.vm.provision "shell", path: "./setup.sh"
        box.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
        box.vm.provision "shell", inline: "cat /tmp/hosts >> /etc/hosts", privileged: true
        box.vm.provision "shell", inline: "docker swarm init --advertise-addr #{manager_ip}"
        box.vm.provision "shell", inline: "docker swarm join-token -q worker > /vagrant/token"
        box.vm.provision "file", source: "daemon.json", destination: "/tmp/daemon.json"
        box.vm.provision "shell", inline: "cat /tmp/daemon.json >> /etc/docker/daemon.json", privileged: true
        box.vm.provision "shell", inline: "service docker restart"
    end

    config.vm.define "prometheus" do |box|
      box.vm.box = "ubuntu/bionic64"
      box.vm.hostname = "prometheus"
      box.vm.network "private_network", ip: "#{prometheus_ip}"
      box.vm.provision "shell", path: "./setup.sh"
      box.vm.provision "file", source: "daemon.json", destination: "/tmp/daemon.json"
      box.vm.provision "shell", inline: "cat /tmp/daemon.json >> /etc/docker/daemon.json", privileged: true
    end

    instances.each do |instance| 
      config.vm.define instance[:name] do |box|
          box.vm.box = "ubuntu/bionic64"
          box.vm.hostname = instance[:name]
          box.vm.network "private_network", ip: "#{instance[:ip]}"
          box.vm.provision "shell", path: "./setup.sh"
          box.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
          box.vm.provision "file", source: "daemon.json", destination: "/tmp/daemon.json"
          box.vm.provision "shell", inline: "cat /tmp/daemon.json >> /etc/docker/daemon.json", privileged: true
          box.vm.provision "shell", inline: "cat /tmp/hosts >> /etc/hosts", privileged: true
          box.vm.provision "shell", inline: "docker swarm join --advertise-addr #{instance[:ip]} --listen-addr #{instance[:ip]}:2377 --token `cat /vagrant/token` #{manager_ip}:2377"
          box.vm.provision "shell", inline: "service docker restart"
      end 
    end
end