# ED Oculus Hotas
## Why?
I always found VR Cockpit too hard to install and sometimes it doesn't even work. In my case, having the game on Epic Store make it quite hard to get everything working accordingly and I actually never managed to get it working properly. Currently, Elite Dangerous includes keybinds for Oculus Touch, but those don't include motion movement. 

This system allows to use the right Controller motion movement as a mouse so that it can be used as a "hotas" variaiton. To do so it will also use a variation of the default Oculus Touch Keybinds with the included mouse control.

## Requirements
- [Auto Hot Key](https://www.autohotkey.com/): Used to map the motion control for vJoy
- [vJoy](https://sourceforge.net/projects/vjoystick/): Used to create the virtual controller for Elite Dangerous
- OculusHotasED.ahk: To launch the script for VJoy
- Elite Dangerous and Oculus Controllers

## How to?
1- Download Auto Hot Key and install
2- Download vJoy and install
3- Double click on OculusHotasED.ahk
4- Open Elite Dangerous in VR.
    4.1. If you are seeing Elite Dangerous in your headset, open vJoy Monitor to see graphs moving when moving the controller
5- Change your keybinds
    5.a- Automatic
        5.a.1- Download the Bindings folder on this repository
        5.a.2- Go to "C:\users\%username%\AppData\Local\Frontier Developments\Elite Dangerous\Options\Bindings" [From how to backup your bindings](https://customersupport.frontier.co.uk/hc/en-us/articles/4405955062802-How-to-back-up-your-custom-bindings)
        5.a.3- Paste the full folder into it

## References
This is basically a fork/clone of [this](https://drive.google.com/drive/folders/1FljsTPdzAP9uWNPEF4t96n4PDTlum4Mx) which is a system to make Oculus work as hotas for Star Citizen. In this case, I managed to adapt it for Elite Dangerous (with some really simple tweaks).

Original [video of star citizen](https://www.youtube.com/watch?v=t2Rnoo285qs)