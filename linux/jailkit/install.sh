#!/bin/sh
###############################################################################
## This script will install jailkit on Debian/Ubuntu as follows:             ##
###############################################################################

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Install Jailkit"
apt-get install build-essential autoconf make automake libtool flex bison debhelper binutils-gold python -y
VERSION="2.20"
cd /tmp
wget https://olivier.sessink.nl/jailkit/jailkit-$VERSION.tar.gz
tar -zxvf jailkit-$VERSION.tar.gz
cd jailkit-$VERSION/
echo 5 > debian/compat
./debian/rules binary
cd ..
dpkg -i jailkit*.deb

echo "configure jailkit for NewUser"
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi
echo "create folder and jail user"
mkdir /var/$username
jk_init -v /var/$username jailroot basicshell editors netutils ssh jk_lsh sftp
jk_jailuser -m -j /var/$username $username

echo "Don't forget to read help.md to connect user with sftp/ssh"