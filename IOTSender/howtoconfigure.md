```bash
# Create comunication with device
sudo modprobe option
sudo sh -c 'echo 05c6 90b6 > /sys/bus/usb-serial/drivers/option1/new_id'
sudo minicom -D /dev/ttyUSB0
# Will open a terminal
```

```bash
AT+CGDCONT?
# This will change the wrong configuration from IPV6 to IPV4 and
# configure the write APN for vodafone
AT+CGDCONT=,"IP","mobile.vodafone.it",,,,,

# unplug
# plug the device
```

Now you are done and you can use ipv4 on linux

```bash
# on ubuntu use 
nmcli device show 
# you will se the correct ipv4 configuration
```