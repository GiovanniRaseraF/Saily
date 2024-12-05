# 1，enable the ttyUSB ports:
```bash
lsusb
# on output you find the values of the producet for now is
# 05c6 90b6
sudo modprobe option
sudo sh -c 'echo 05c6 90b6 > /sys/bus/usb-serial/drivers/option1/new_id'
```
### afte these two at commands, use ls to check the ttyUSB: -->

```bash
ls /dev
```
### there should be some ttyUSBx device, then run: -->
```bash
sudo minicom -D /dev/ttyUSB0
```
<!-- if minicom not installed then:
sudo apt install minicom -y -->

# 2，AT commands：
### Check che SIM card: -->
at+cpin?
### check the signal: -->
at+csq
### should be 20+ -->
### check the operator: -->
at+cops?

# use
```bash
sudo apt install udhcpc
udhcpc -i enxcab.... # The inteface of the board
```
### 2, add nameserver in resolv.conf, such like 8.8.8.8 or something else which namserver used in your location -->

# or use
```bash
sudo udhcpc -i $(ifconfig -a > n.txt && grep 'enx' n.txt > m.txt && cut -c1-15 m.txt && sudo rm n.txt && sudo rm m.txt)
```
<img title="a title" alt="Alt text" src="./whattoexpext.png">