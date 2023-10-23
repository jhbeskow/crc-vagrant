Vagrant.configure("2") do |config|
  config.vm.box = "fedora/38-cloud-base"
  config.vm.provider :libvirt do |domain|
    domain.cpus = 4
    domain.memory = 20972
    domain.machine_virtual_size = 100
    domain.management_network_name = 'default'
    domain.management_network_address = '192.168.122.0/24'
  end
  config.vm.define :vagrant_crc do |vagrant_host|
    vagrant_host.vm.hostname = "vagrant-crc.fishjump.com"

    # you need a publicly addressable ip to access crc remotely
    # this will create one in addition to the private one
    # the macvtap address won't be addressable from the host, that's why
    # you need two
    vagrant_host.vm.network "public_network", dev: "enp7s0", mode: "bridge"

    #take advantage of our new disk size
    vagrant_host.vm.provision "shell", privileged: true, inline: \
      "echo -e \"unit\n%\nresizepart\nFix\n5\nyes\n100%\" | parted /dev/vda ---pretend-input-tty"
    vagrant_host.vm.provision "shell", privileged: true, inline: \
      "btrfs filesystem resize max /"

    #prepare for attaching from remote
    vagrant_host.vm.provision "file", source: "./configure-remote.sh", destination: "configure-remote.sh"
    vagrant_host.vm.provision "file", source: "./configure-remote-priv.sh", destination: "configure-remote-priv.sh"
    vagrant_host.vm.provision "shell", privileged: false, inline: \
      "chmod u+x ~/configure-remote.sh ~/configure-remote-priv.sh"

    #get crc going
    vagrant_host.vm.provision "file", source: "./pull-secret", destination: "pull-secret"
    vagrant_host.vm.provision "file", source: "./setup-crc.sh", destination: "setup-crc.sh"
    vagrant_host.vm.provision "file", source: "./run-crc.sh", destination: "run-crc.sh", run: 'always'
    vagrant_host.vm.provision "shell", privileged: false, inline: \
      "chmod u+x ~/setup-crc.sh"
    vagrant_host.vm.provision "shell", privileged: false, inline: \
      "chmod u+x ~/run-crc.sh", run: 'always'
    vagrant_host.vm.provision "shell", privileged: false, inline: \
      "~/setup-crc.sh"
    vagrant_host.vm.provision "shell", privileged: false, inline: \
      "~/run-crc.sh", run: 'always'
  end
end


