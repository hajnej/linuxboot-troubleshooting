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

1. Boot as normal, supply root password in prompt
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

        # chroot /mnt/sysimage
        
3. Generate new initrd files for all present kernels

        # dracut --regenrate-all
        
4. Reboot system

## lab4

#### How system was damaged

System was damaged by zeroing bootstrap area using dd command

        # dd if=/dev/zero of=/dev/vda bs=446 count=1
        
#### How to fix this issue

1. Boot rescue DVD of CentOS and mount system partitions to /mnt/sysimage
2. Chroot into /mnt/sysimage

        # chroot /mnt/sysimage
        
3. Install GRUB2 into MBR of /dev/vda

        # grub2-install /dev/vda

4. Reboot system

## lab5

#### How system was damaged

System was damaged by removing files from /boot FS - kernel image, initrd and grub2 files

#### How to fix this issue

1. Boot rescue DVD of CentOS and mount system partitions to /mnt/sysimage
2. Chroot into /mnt/sysimage

        # chroot /mnt/sysimage
        
3. Enable your network interface and configure networking

        # ip link set eth0 up
        # dhclient eth0
        
4. Now remote repositories should be fully operational, so you can reinstall kernel and grub2 packages

        # yum reinstall kernel grub2*
        
5. In case previous command fails issue following command:

        # yum remove kernel grub2*
        # yum install kernel grub2
        
6. Reinstall GRUB2 into bootloader - it also populates /boot directory

        # grub2-install /dev/vda

7. Check the content of /boot directory, in case initramfs is missing gererate it

        # dracut --regenerate-all
        
8. All needed files should be back so generate GRUB2 configuration file

        # grub2-mkconfig -o /boot/grub2/grub.cfg
        
9. Reboot your system

## lab6

#### How system was damaged

System was damaged by zeroing first 512 bytes of HDD - MBR + partition table

        # dd if=/dev/zero of=/dev/vda bs=512 count=1
        
#### How to fix this issue

1. Boot rescue DVD of CentOS - you won't be able to mount /mnt/sysimage as partitions are gone
2. Download testdisk external program using curl, extract and run this program on /dev/vda

        # curl -o testdisk.tar.bz2 https://www.cgsecurity.org/testdisk-7.0.linux26-x86_64.tar.bz2
        # tar -xvjf testdisk.tar.bz2; cd testdisk-7.0; ./testidisk.static /dev/vda
        
3. Restore partition table - using testdisk is really straightforward

4. Reboot system but still use rescue DVD

5. As MBR was also zeroed you need to reinstal GRUB2 to MBR user procedure from [lab4](https://github.com/hajnej/linuxboot-troubleshooting#lab4)

