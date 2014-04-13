Vagrant::Config.run do |config|

  config.vm.provision :shell, :path => "shell/main.sh"

  config.vm.box = "fadenb/ubnt-quantal-puppet3"
  config.vm.forward_port 80, 3000
  config.vm.provision :puppet

  config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
  config.ssh.forward_agent = true

end


