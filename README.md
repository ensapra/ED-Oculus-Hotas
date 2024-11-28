# ED Oculus Hotas

https://github.com/user-attachments/assets/099b1c17-6579-4ca0-9acd-e438acc8dc31

## Why?
I always found VR Cockpit too hard to install, and sometimes it doesn't even work. In my case, having the game on Epic Store make it quite hard to get everything working accordingly, and I actually never managed to get it working properly. Currently, Elite Dangerous includes key binds for Oculus Touch, but those don't include motion movement. 

This system allows using the right Controller motion movement as a mouse so that it can be used as a "Hotas" variation. To do so, it will also use a variation of the default Oculus Touch Keybinds with the included mouse control.

## Requirements
- [Auto Hot Key](https://www.autohotkey.com/): Used to map the motion control for vJoy
- [vJoy](https://sourceforge.net/projects/vjoystick/): Used to create the virtual controller for Elite Dangerous
- OculusHotasED.ahk: To launch the script for VJoy
- Elite Dangerous and Oculus Controllers

## How to?
1. Download Auto Hot Key and install.
2. Download vJoy and install
3. Double click on OculusHotasED.ahk
4. Open vJoy
5. Open Elite Dangerous in VR.
    1. If you are seeing Elite Dangerous in your headset, open vJoy Monitor to see graphs moving when moving the controller
   
   ![JoyMonitor_Lc0nrMkkqa](https://github.com/user-attachments/assets/25bfa576-cdd1-42a7-afb5-bf9424f3f9f3)
7. Change your keybinds
    1. Automatic
        1. Download the Bindings folder on this repository
        2. Go to "C:\users\%username%\AppData\Local\Frontier Developments\Elite Dangerous\Options\Bindings" [From how to backup your bindings](https://customersupport.frontier.co.uk/hc/en-us/articles/4405955062802-How-to-back-up-your-custom-bindings)
        3. Paste the full folder into it
        ![explorer_M3Ko3CD4ST](https://github.com/user-attachments/assets/252dfcce-f4d6-46c1-abb5-ea7beadf20b5)
        4. Launch Elite Dangerous and select
    2. Manual: In case you want full control of the keybinds
        1. Laucn Elite Dangerous and select Oculus Touch
        2. In Mouse Controls.
            - Set Mouse X-Axis to Roll
            - Sety Mouse Y-Axis to Pitch
            - I like having the Show Mouse Widget On (but you can set that to off if you prefer it
              
       ![image](https://github.com/user-attachments/assets/2db314d8-6da3-4f5d-a2ed-0e63cee5c0e2)
       
        4. (Optional) In Flight Rotation
            - Set Yaw Axis to Oculus Left Stick X
              
        ![image](https://github.com/user-attachments/assets/d1605d54-62e8-4286-8ce3-04d889ddfadd)

**DISCLAIMER: The keybinds option will only appear if the OculusTouch controllers are connected to the computer. Otherwise it will not be shown.**
No controllers connected           |  With controllers actually connected
:-------------------------:|:-------------------------:
![](https://github.com/user-attachments/assets/bb5c5cab-a8e2-454e-95f4-e0c392fff8de)  |  ![](https://github.com/user-attachments/assets/d76ee42e-6c83-41e1-bde1-299b4d448bb7)



## References
This is basically a fork/clone of [this](https://drive.google.com/drive/folders/1FljsTPdzAP9uWNPEF4t96n4PDTlum4Mx) which is a system to make Oculus work as hotas for Star Citizen. In this case, I managed to adapt it for Elite Dangerous (with some really simple tweaks).

Original [video of star citizen](https://www.youtube.com/watch?v=t2Rnoo285qs)
