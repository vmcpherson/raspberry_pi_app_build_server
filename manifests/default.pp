
# The following module must be installed
#
# puppet module install puppetlabs-vcsrepo
#

# Create raspberry pi application build server for use by jenkins.
#

exec { "apt-get update":
  path => "/usr/bin",
}

user { "builder":
  ensure     => "present",
  managehome => true,
}

# Install QEMU
package { 'qemu-system':
    ensure =>installed,
}

package { 'git':
    ensure =>installed,
}

# Create directory 
file { "/mnt/2013-02-09-wheezy-raspbian-rootfs":
    ensure => "directory",
    owner  => "root"
}

# Todo - Make this a module.
#
class known_hosts( $username = 'root' ) {
   $group = $username
   $server_list = [ 'github.com', '192.168.2.108' ]
 
   file{ '/root/.ssh' :
     ensure => directory,
     group => $group,
     owner => $username,
     mode => 0600,
   }

   file{ '/root/.ssh/known_hosts' :
     ensure => file,
     group => $group,
     owner => $username,
     mode => 0600,
     require => File[ '/root/.ssh' ],
   }
 
   file{ '/tmp/known_hosts.sh' :
     ensure => present,
#     source => 'puppet:///modules/known_hosts/known_hosts.sh',

     content => '#!/bin/bash
array=( \'github.com\', \'192.168.2.108\' )
for h in "${array[@]}"
do
    ip=$(dig +short $h)
    ssh-keygen -R $h
    ssh-keygen -R $ip
    ssh-keyscan -H $ip >> /root/.ssh/known_hosts
    ssh-keyscan -H $h >> /root/.ssh/known_hosts
done',
     mode => 0700,
   }

   exec{ 'add_known_hosts' :
     command => "/tmp/known_hosts.sh",
     path => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
     provider => shell,
     user => 'root',
     require => File[ '/root/.ssh/known_hosts', '/tmp/known_hosts.sh' ]
   }
}

include known_hosts


# Clone tools from repo
#
vcsrepo { '/opt/code/project':
  ensure   => present,
  provider => git,
  source   => 'git@192.168.2.108:git_server/project.git',
}





# Create directory 

# mount --bind /proc proc
# mount --bind /dev dev
# mount --bind /sys sys
# mount --bind /tmp tmp

