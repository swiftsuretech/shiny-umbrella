mkdir -p ~/lvs/0{0,1,2,3,4,5,6,7}
sudo mkdir -p /mnt/disks/volume-0{0,1,2,3,4,5,6,7}
sudo mount --bind ~/lvs/00 /mnt/disks/volume-00
sudo mount --bind ~/lvs/01 /mnt/disks/volume-01
sudo mount --bind ~/lvs/02 /mnt/disks/volume-02
sudo mount --bind ~/lvs/03 /mnt/disks/volume-03
sudo mount --bind ~/lvs/04 /mnt/disks/volume-04
sudo mount --bind ~/lvs/05 /mnt/disks/volume-05
sudo mount --bind ~/lvs/06 /mnt/disks/volume-06
sudo mount --bind ~/lvs/07 /mnt/disks/volume-07
sudo bash -c 'cat <<EOF >> /etc/fstab
/home/centos/lvs/00 /mnt/disks/volume-00 none bind
/home/centos/lvs/01 /mnt/disks/volume-01 none bind
/home/centos/lvs/02 /mnt/disks/volume-02 none bind
/home/centos/lvs/03 /mnt/disks/volume-03 none bind
/home/centos/lvs/04 /mnt/disks/volume-04 none bind
/home/centos/lvs/05 /mnt/disks/volume-05 none bind
/home/centos/lvs/06 /mnt/disks/volume-06 none bind
/home/centos/lvs/07 /mnt/disks/volume-07 none bind
EOF'