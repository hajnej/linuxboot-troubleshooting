# linuxboot-troubleshooting
Vagrantfiles for building damaged CentOS 7 installation for troubleshooting purposes

## Lab index:
* [lab1](https://github.com/hajnej/linuxboot-troubleshooting#lab1)
* [lab2](https://github.com/hajnej/linuxboot-troubleshooting#lab2)
* [lab3](https://github.com/hajnej/linuxboot-troubleshooting#lab3)
* [lab4](https://github.com/hajnej/linuxboot-troubleshooting#lab4)
* [lab5](https://github.com/hajnej/linuxboot-troubleshooting#lab5)
* [lab6](https://github.com/hajnej/linuxboot-troubleshooting#lab6)

## lab1

#### How system was damaged
System was damaged by moving bash binary

        # mv /bin/bash /bin/bash-bkp
    
#### How to fix this issue

1. Boot rescue DVD of CentOS and mount system partitions to /mnt/sysimage 
2. Rename file to its origin name

        # mv /mnt/sysimage/bin/bash-bkp /mnt/sysimage/bin/bash
   
   You won't be able to chroot due missing /bin/bash in chroot environment so you need to perform this action outside chroot 
       
3. Reboot

## lab2

#### How system was damaged
System was damaged by changing default target the system boots to from multi-user.target to emergency.target

    # systemctl set-default emergency.target
 
 #### How to fix this issue
 
 ##### Method 1: Using rescue DVD
 
 1. Boot rescue DVD of CentOS and mount system partitions to /mnt/sysimage
 2. Chroot into /mnt/sysimage
 
        # chroot /mnt/sysimage
        
 3. Set multi-user.target as default systemd target
 
        # systemctl set-default multi-user.target
        
 4. Reboot system
 
##### Method 2: Without using rescue DVD - entering emergency mode

1. Boot as normal, supply root password in promt
2. Remount / filesystem as read-write

        # mount -o remount,rw /
        
3. Set multi-user.target as default systemd.target

        # systemctl set-default multi-user.target
        
 4. Reboot system

##### Method 3: Without using rescue DVD - amending boot parameters

1. Edit boot parameters in GRUB2 stage

   Press 'e' to edit GRUB2 boot entry and add following to boot parameters:
   
        systemd.unit=multi-user.target
        
2. Set multi-user.target as default boot target

        # systemctl set-default multi-user.target
 
## lab3

#### How system was damaged

System was damaged by deleting initrd files

    # rm -rf /boot/initramfs*
    
#### How to fix this issue

1. Boot rescue DVD of CentOS and mount system partitions to /mnt/sysimage
2. Chroot into /mnt/sysimage
