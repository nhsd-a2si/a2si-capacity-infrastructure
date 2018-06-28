# Install sftp if we havent done it already
if [ ! -d /sftp ]
then
   sudo apt-get update -y
   sudo apt-get install vsftpd
   sudo mkdir /sftp
   sudo chmod 755 /sftp
   sudo groupadd sftpusers
   mkdir /home/ubuntu/files
fi

# We want to amend sshd_config - but if it's already been done, don't do it again
if ! grep -Fxq "Subsystem sftp internal-sftp" /etc/ssh/sshd_config
then
   sudo sed -e '/Subsystem sftp \/usr\/lib\/openssh\/sftp-server/ s/^#*/#/' -i /etc/ssh/sshd_config
   sudo sh -c "echo ' ' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'Subsystem sftp internal-sftp' >> /etc/ssh/sshd_config"
   sudo sh -c "echo ' ' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'Match group sftpusers' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'ChrootDirectory /sftp/' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'X11Forwarding no' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'AllowTcpForwarding no' >> /etc/ssh/sshd_config"
   sudo sh -c "echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config"
   sudo /etc/init.d/ssh restart
fi

# Create a script to add a new user (if it doesnt exist)
if [ ! -f /home/ubuntu/addnewuser.sh ]
then
   echo '# Add a new sftp user if they dont exist'    > /home/ubuntu/addnewuser.sh
   echo 'if ! id -u $1 > /dev/null 2>&1; then'       >> /home/ubuntu/addnewuser.sh
   echo '   sudo adduser --disabled-password --gecos "" $1 ' >> /home/ubuntu/addnewuser.sh
   echo '   sudo adduser $1 sftpusers'               >> /home/ubuntu/addnewuser.sh
   echo '   sudo mkdir /home/$1/.ssh'                >> /home/ubuntu/addnewuser.sh

   echo '   sudo ssh-keygen -t rsa -f /home/$1/.ssh/$1 -q -N ""' >> /home/ubuntu/addnewuser.sh
   echo '   sudo mv /home/$1/.ssh/$1.pub /home/$1/.ssh/authorized_keys' >> /home/ubuntu/addnewuser.sh
   echo '   sudo mv /home/$1/.ssh/$1 /home/ubuntu/files/$1.pem' >> /home/ubuntu/addnewuser.sh
   echo '   sudo chmod 644 /home/ubuntu/files/$1.pem' >> /home/ubuntu/addnewuser.sh

   echo '   if [ "$2" != "NO_FOLDER" ]; then'        >> /home/ubuntu/addnewuser.sh
   echo '      sudo mkdir /sftp/$1'                  >> /home/ubuntu/addnewuser.sh
   echo '      sudo chown $1:sftpusers /sftp/$1'     >> /home/ubuntu/addnewuser.sh
   echo '      sudo chmod 750 /sftp/$1'              >> /home/ubuntu/addnewuser.sh
   echo '   fi'                                      >> /home/ubuntu/addnewuser.sh
   echo 'fi'                                         >> /home/ubuntu/addnewuser.sh

   chmod 500 /home/ubuntu/addnewuser.sh
fi

/home/ubuntu/addnewuser.sh "capacity_reader" "NO_FOLDER"
/home/ubuntu/addnewuser.sh "dhu"



exit
