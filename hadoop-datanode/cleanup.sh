#!/bin/bash


# Clean up mounts created by prep_disks.sh
if [ -f hadoop-datanode/disk_list ]; then
    cp /etc/fstab fstab.tmp
    mount > mount.tmp
    while read i
    do
        # Skip empty line
        if [ -z $i ]; then continue; fi

        mount_dir=`cat mount.tmp | grep ^/dev/${i} | awk '{ print $3 }' | grep '/hdd[0-9][0-9]*'`
        if [ -z $mount_dir ]; then continue; fi

        echo "unmounting /dev/${i} from ${mount_dir}"
        # Remove from fstab
        sed -i '\|'${mount_dir}'|d' fstab.tmp
        # Unmount and remove mount point
        sudo umount ${mount_dir} -f
        sudo rm -rf ${mount_dir}
    done < hadoop-datanode/disk_list

    rm mount.tmp
    sudo mv fstab.tmp /etc/fstab
fi
