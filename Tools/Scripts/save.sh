echo rewind tape
mt -f /dev/st0 rewind

echo save /home/fridu
dump 0uBf 4194304 /dev/nst0 /home/fridu

echo save /
dump 0uBf 4194304 /dev/nst0 /

echo save /pMaster
dump 0uBf 4194304 /dev/nst0 /usr/pMaster

echo save /mnt/ide
dump 0uBf 4194304 /dev/nst0 /mnt/ide

sleep 360
mt -f /dev/st0 rewind
mt -f /dev/st0 off
echo echu 
