---
layout: default
title:  "Disabling the Integrated Webcam on Ubuntu and use Blackmagiv ATEM Mini for Facebook videochats with Chromium"
---

# Problem

If your life is like my life there are nagging issues like:

- you want to use the nice camera connected to an Blackmagic ATEM Mini for videchats
- but Chromium does not let you choose it
- and web research brings a lot of confusing results about browser support without actially solving the issue

# Solution

Here is what worked for me:

1. I closed Chromium (version 85 at the time of writing)
2. Found the USB bus address of the device identifying as Integrated Webcam
3. Disabled this until next reboot

Here is how that worked in detail:

Run `lsusb` to find the Bus and Device identifier for the 

lsusb
...
Bus 001 Device 004: ID 04f2:b2ea Chicony Electronics Co., Ltd Integrated Camera [ThinkPad]
...

Find the Port with the tree option to lsusb, watching for Class=Video devices with a matching Device ID:

```
lsusb -t
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/3p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/6p, 480M
        |__ Port 1: Dev 3, If 0, Class=Chip/SmartCard, Driver=, 12M
        |__ Port 6: Dev 4, If 1, Class=Video, Driver=uvcvideo, 480M
        |__ Port 6: Dev 4, If 0, Class=Video, Driver=uvcvideo, 480M
```

This will let you find the device under `sys/bus/usb/devices/1-1.6` in the next step:

A working webcam will have the value `1` in its bConfigurationValue file:

```
cat /sys/bus/usb/devices/1-1.6/bConfigurationValue ```

To disable this device until the next reboot issue

```
sudo sh -c "echo 0 >/sys/bus/usb/devices/1-1.6/bConfigurationValue"
```

In the same folder the files idProduct and idVendor contain the strings visible with `lsusb` -- 


To make this permament is maybe not a good idea, but could be done via e.g. systemd.

Restarting Chromium will not show the Integrated Webcam unter chrome://settings/content/camera anymore, and videochats with e.g. Facebook will use the USB-connected ATEM Mini. So don't accidentally disable this device!

