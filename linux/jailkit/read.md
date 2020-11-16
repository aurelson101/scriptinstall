
Jailkit is a set of utilities that can limit user accounts to a specific directory tree and to specific commands. Setting up a jail is much easier using the Jailkit utilities that doing so 'by hand'. A jail is a directory tree that you create within your file system; the user cannot see any directories or files that are outside the jail directory. The user is jailed in that directory and it subdirectories.

Enable bash :
By using jk_cp the bash libraries are copied to the jail:

jk_cp -v -f /var/jail /bin/bash
nano /var/jail/etc/passwd

replace this line:
jailtest:x:1001:1001::test:/usr/sbin/jk_lsh

with this:
jailtest:x:1001:1001::/var/xxxx:/bin/bash

Maintenance

By using jk_update updates on the real system can be updated in the jail.

A dry-run will show what’s going on:
jk_update -j /var/jail -d

Without the -d argument the real update is performed. More maintenance operations can be found here.

(In case /var/jail/opt is missing, create it with mkdir -p /var/jail/opt/ And run jk_update -j /var/jail again)
Give access to other directories

You can mount special folders, that the jail user may acces now. E.g.:

mount --bind /media/$USER/Data/ /var/jail/home/jailtest/test/

If you dont have bash :
jk_cp  -v -j /var/jail /bin/bash