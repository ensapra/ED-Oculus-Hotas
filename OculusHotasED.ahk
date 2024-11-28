#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#include auto_oculus_touch.ahk  ;To enable the Oculus auto script and button enums.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; See !!!User Options!!! below for scalars and deadzones

InitOculus()
InitvJoy(1)

DllCall("auto_oculus_touch\poll")
DllCall("vJoyInterface\poll")

ResetFacing(0)
ResetFacing(1)

SetTrackingOrigin(OriginFloor)

; !!!User Options!!!
; All Roll, Pitch and Yaw dead zones(DZ) DEGREES and scale available to adjust, 1 = 1 to 1 sensitivity
; Change only the first number in each line, keep them EVEN numbers except the positional DZs !DO NOT REMOVE "static"!

	; Trigger dead zones (DZ) fully pressed is 1
leftTriggerDZ:= static 0.6
leftHandTriggerDZ:= static 0.9
rightTriggerDZ:= static 0.6
rightHandTriggerDZ:= static 0.9

	; Left thumb stick dead zones (DZ) fully up/down/left/right is 1
leftXDZ:= static 0.6
leftYDZ:= static 0.3

	; Right thumb stick Scalars
rightXScale:= static 0
rightYScale:= static 0

	; Left controller dead zones (DZ) and Scalars
leftRollDZ:= static 14 ; Degrees out of 180 from Origin
leftRollScale:= static 0 ; Not currently used, as it sends buttons for FPS lean and EVA roll
leftPitchDZ:= static 10 ; Degrees out of 90 from Origin
leftPitchScale:= static 8 ; to 1
leftYawDZ:= static 10 ; Degrees out of 180 from Origin
leftYawScale:= static 8 ; to 1
leftPosZDZ:= static 2.5 ; 2 inches forward and 2 inches back Z axis is Forward/Back
leftPosZScale:= static 12 ; to 1

	; Right controller dead zones (DZ) and Scalars
rightRollDZ:= static 6.4 ; Degrees out of 180 from Origin
rightRollScale:= static 10 ; to 1
rightPitchDZ:= static 0.2 ; Degrees out of 90 from Origin
rightPitchScale:= static 10 ; to 1
rightYawDZ:= static 0.2 ; Degrees out of 180 from Origin
rightYawScale:= static 10 ; to 1
rightPosZDZ:= static 2.5 ; 2.5 inches forward and 2.5 inches back Z axis is Forward/Back
rightPosZScale:= static 10 ; to 1

	; AirMouse Sensitivity Scalar can be whatever feels right
airMouseYawScale:= static 16 ; Up/Down turning for Airmouse sensitivity, see in-game "Controls" options
rightPosXScale:= static 841 ; Left/Right PositionMouse Ratio to view space in pixels
airMousePitchScale:= static 16 ; Left/Right turning for Airmouse sensitivity, see in-game "Controls" options
rightPosYScale:= static 841 ; Up/Down PositionMouse Ratio to view space in pixels
airMouseWheelDelay:= static 10 ; Delay between clicks when holding, 100 = 1 second
airMouseWheelClicks:= static 2 ; Amount of clicks when holding
pointFingerDelay:= static 200 ; Delay for pointing finger to activate, 100 = 1 second

; !DO NOT TOUCH REST OF SCRIPT OR IT WILL CEASE TO OPERATE!

	; Equations for converting user scalars and dead zones (DZ)
leftPitchValue:= static (90/leftPitchScale)
leftYawValue:= static (180/leftYawScale)
leftPosZValue:= static (leftPosZScale/36)
leftPosZDZValue:= static (leftPosZDZ/36)
rightRollValue:= static (180/rightRollScale)
rightPitchValue:= static (90/rightPitchScale)
rightYawValue:= static (180/rightYawScale)
rightPosZValue:= static (rightPosZScale/36)
rightPosZDZValue:= static (rightPosZDZ/36)
leftRollOrigin:= static (GetRoll(0))
leftRollOld:=0
leftPitchOrigin:= static (GetPitch(0))
leftPitchNew:=0
leftYawNew:=0
leftPosZOrigin:= static (GetPositionZ(0))
leftPosZNew:=0
rightRollOrigin:= static (GetRoll(1))
rightRollNew:=0
rightPitchOrigin:= static (GetPitch(1))
rightPitchOld:=0
rightPitchNew:=0
rightYawOld:=0
rightYawNew:=0
rightPosXOrigin:= static (GetPositionX(1))
rightPosXOld:=0
rightPosYOrigin:= static (GetPositionY(1))
rightPosYOld:=0 
rightPosZOrigin := static (GetPositionZ(1))
rightPosZOld:=0
rightPosZNew:=0
rightXNew:=0
rightYNew:=0
leftXDZL:= static (leftXDZ*-1)
leftXDZR:= static (leftXDZ)
leftYDownDZ:= static (leftYDZ*-1)
leftYUpDZ:= static (leftYDZ)
airMouseX:=(A_ScreenWidth // 2)
airMouseY:=(A_ScreenHeight // 2)
indexOldWheelR:= 1
indexOldWheelL:= 1
indexOldPointFingerR:= 1
indexOldPointFingerL:= 1

Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Get the various analog values. Triggers are 0.0 to 1.0, thumbsticks are -1.0 to 1.0
    leftIndexTrigger  := GetAxis(AxisIndexTriggerLeft)
    leftHandTrigger   := GetAxis(AxisHandTriggerLeft)
    rightIndexTrigger := GetAxis(AxisIndexTriggerRight)
    rightHandTrigger  := GetAxis(AxisHandTriggerRight)
    leftX             := GetAxis(AxisXLeft)
    leftY             := GetAxis(AxisYLeft)
    rightX            := GetAxis(AxisXRight)
    rightY            := GetAxis(AxisYRight)

	leftYaw 		  := (GetYaw(0))
	leftPitch		  := (GetPitch(0))
	leftRoll		  := (GetRoll(0))
	rightYaw 		  := (GetYaw(1))
	rightPitch		  := (GetPitch(1))
	rightRoll		  := (GetRoll(1))

		headYaw 		  := (GetYaw(2))
		headPitch		  := (GetPitch(2))
		headRoll		  := (GetRoll(2))
		headPosX := (GetPositionX(2))
		headPosY := (GetPositionY(2))
		headPosZ := (GetPositionZ(2))
		leftPosX := (GetPositionX(0))
		leftPosY := (GetPositionY(0))
		leftPosZ := (GetPositionZ(0))
		rightPosX := (GetPositionX(1))
		rightPosY := (GetPositionY(1))
		rightPosZ := (GetPositionZ(1))

; Origin Reset.
	if IsDown(ovrEnter) and GetAxis(AxisHandTriggerLeft) > leftHandTriggerDZ and GetAxis(AxisHandTriggerRight) > rightHandTriggerDZ
		{
		SetvJoyAxis(HID_USAGE_X, 0)
		SetvJoyAxis(HID_USAGE_Y, 0)
		SetvJoyAxis(HID_USAGE_Z, 0)
		SetvJoyAxis(HID_USAGE_RX, 0)
		SetvJoyAxis(HID_USAGE_RY, 0)
		SetvJoyAxis(HID_USAGE_RZ, 0)
		ResetFacing(0)
		ResetFacing(1)
		leftRollOrigin:= static leftRoll
		leftPitchOrigin:= static leftPitch
		leftPosZOrigin:= static leftPosZ
		rightRollOrigin:= static rightRoll
		rightPitchOrigin:= static rightPitch
		rightPosXOrigin := static rightPosX
		rightPosYOrigin := static rightPosY
		rightPosZOrigin:= static rightPosZ
		}

; Index pointing gesture.
	if IsTouchDown(ovrTouch_LIndexPointing) and (A_Index>indexOldPointFingerL)
		{
		Send, {[ down}
		indexOldPointFingerL:= static (A_Index+pointFingerDelay)
		Send, {[ up}
		}
	else if IsTouchDown(ovrTouch_RIndexPointing) and (A_Index>indexOldPointFingerR)
		{
		Send, {] down}
		indexOldPointFingerR:= static (A_Index+pointFingerDelay)
		Send, {] up}
		}
	else if IsTouchPressed(ovrTouch_LIndexPointing)
		indexOldPointFingerL:= static (A_Index+pointFingerDelay)
	else if IsTouchPressed(ovrTouch_RIndexPointing)
		indexOldPointFingerR:= static (A_Index+pointFingerDelay)
    else
		{
		
		}

; Index trigger right.
	if (Reached(AxisIndexTriggerRight, rightTriggerDZ) and rightHandTrigger > rightHandTriggerDZ) == 1
		SetvJoyButton(40,1)
	if Reached(AxisIndexTriggerRight, rightTriggerDZ) == 1
		SendRawMouseButtonDown(0)
	if Reached(AxisIndexTriggerRight, rightTriggerDZ) == -1
		{
		SendRawMouseButtonUp(0)
		SetvJoyButton(40,0)
		}

; Index trigger left.
	if (Reached(AxisIndexTriggerLeft, leftTriggerDZ) and rightHandTrigger > rightHandTriggerDZ) == 1
		SetvJoyButton(39,1)
	if Reached(AxisIndexTriggerLeft, leftTriggerDZ) == 1
		SendRawMouseButtonDown(1)
	if Reached(AxisIndexTriggerLeft, leftTriggerDZ) == -1
		{
		SendRawMouseButtonUp(1)
		SetvJoyButton(39,0)
		}

; ThumbStick Left Push.
	if IsDown(ovrLThumb)
		SetvJoyButton(27,1)
	if IsReleased(ovrLThumb)
		SetvJoyButton(27,0)

; ThumbStick Right Push.
	if IsDown(ovrRThumb)
		SetvJoyButton(28,1)
	if IsReleased(ovrRThumb)
		SetvJoyButton(28,0)

; Left Controller Axis X,Y,Y,SL0.
	; Left Controler Roll.
	if ((leftRoll <= leftRollOrigin+leftRollDZ) and (leftRollOld > leftRollOrigin+leftRollDZ)) == 1
		SetvJoyButton(35,0)
	else if ((leftRoll > leftRollOrigin+leftRollDZ) and (leftRollOld <= leftRollOrigin+leftRollDZ)) == 1
		SetvJoyButton(35,1)
	else
		{

		}
	if ((leftRoll >= leftRollOrigin-leftRollDZ) and (leftRollOld < leftRollOrigin-leftRollDZ)) == 1
		SetvJoyButton(36,0)
	else if ((leftRoll < leftRollOrigin-leftRollDZ) and (leftRollOld >= leftRollOrigin-leftRollDZ)) == 1
		SetvJoyButton(36,1)
	else
		{

		}
	leftRollOld:= leftRoll

	; Left Controler Pitch.
	if (leftPitch > leftPitchOrigin + leftPitchDZ)
		leftPitchNew:=((leftPitch-leftPitchOrigin - leftPitchDZ)/leftPitchValue) + trimY
	else if (leftPitch < leftPitchOrigin - leftPitchDZ)
		leftPitchNew:=((leftPitch-leftPitchOrigin + leftPitchDZ)/leftPitchValue) + trimY
	else
		leftPitchNew:=0 + trimY
	SetvJoyAxis(HID_USAGE_Y, leftPitchNew)

	; Left Controler Yaw.
	if (leftYaw > 0 + leftYawDZ)
		leftYawNew:=((leftYaw - leftYawDZ)/leftYaw) + trimZ
	else if (leftYaw < 0 - leftYawDZ)
		leftYawNew:=(((leftYaw + leftYawDZ)/leftYaw)*-1) + trimZ
	else
		leftYawNew:=0 + trimZ
	SetvJoyAxis(HID_USAGE_Z, leftYawNew)

	;Left Controller Z position Axis.
	if (leftPosZ > leftPosZOrigin + leftPosZDZValue)
		leftPosZNew:=((leftPosZ-leftPosZOrigin - leftPosZDZValue)*-10)
	else if (leftPosZ < leftPosZOrigin - leftPosZDZValue)
		leftPosZNew:=((leftPosZ-leftPosZOrigin + leftPosZDZValue)*-10)
	else
		leftPosZNew:=0 + trimX
	SetvJoyAxis(HID_USAGE_X, leftPosZNew)

; Right Controller Axis RX,RY,RZ,SL1.
	; Right Controler Roll.
	if (rightRoll > (rightRollOrigin + rightRollDZ))
		rightRollNew:=((rightRoll - rightRollOrigin - rightRollDZ)/rightRollValue)
	else if (rightRoll < (rightRollOrigin - rightRollDZ))
		rightRollNew:=((rightRoll - rightRollOrigin + rightRollDZ)/rightRollValue)
	else
		rightRollNew:=0
	SetvJoyAxis(HID_USAGE_RX, rightRollNew)

	; Right Controler Pitch.
	if (rightPitch > (rightPitchOrigin + rightPitchDZ))
		rightPitchNew:=((rightPitch - rightPitchOrigin - rightPitchDZ)/rightPitchValue)
	else if (rightPitch < (rightPitchOrigin - rightPitchDZ))
		rightPitchNew:=((rightPitch - rightPitchOrigin + rightPitchDZ)/rightPitchValue)
	else
		rightPitchNew:=0
	SetvJoyAxis(HID_USAGE_RY, rightPitchNew)

	; Right Controler Yaw.
	if (rightYaw > 0 + rightYawDZ)
		rightYawNew:=((rightYaw - rightYawDZ)/rightYawValue)
	else if (rightYaw < 0 - rightYawDZ)
		rightYawNew:=((rightYaw + rightYawDZ)/rightYawValue)
	else
		rightYawNew:=0
	SetvJoyAxis(HID_USAGE_RZ, rightYawNew)

	;Right Controller Z position Axis.
	if (rightPosZ > rightPosZOrigin + rightPosZDZValue)
		rightPosZNew:=((rightPosZ-rightPosZOrigin - rightPosZDZValue)*-1)
	else if (rightPosZ < rightPosZOrigin - rightPosZDZValue)
		rightPosZNew:=((rightPosZ-rightPosZOrigin + rightPosZDZValue)*-1)
	else
		rightPosZNew:=0
	SetvJoyAxis(HID_USAGE_SL1, rightPosZNew)

; Mouse Movement.
	;Mouse Wheel
	if IsTouchDown(ovrTouch_RThumbRest) and (A_Index>indexOldWheelR)
		{
		MouseClick, WheelUp,,, airMouseWheelClicks
		indexOldWheelR:= static (A_Index+airMouseWheelDelay)
		}
	else if IsTouchDown(ovrTouch_LThumbRest) and (A_Index>indexOldWheelL)
		{
		MouseClick, WheelDown,,, airMouseWheelClicks
		indexOldWheelL:= static (A_Index+airMouseWheelDelay)
		}
	else if IsTouchPressed(ovrTouch_RThumbRest)
		{
		MouseClick, WheelUp,,, 1
		indexOldWheelR:= static (A_Index+10)
		}
	else if IsTouchPressed(ovrTouch_LThumbRest)
		{
		MouseClick, WheelDown,,, 1
		indexOldWheelL:= static (A_Index+10)
		}

		
	;Right Controller X position.
	if (rightPosX-rightPosXOrigin > rightPosXOld)
		rightPosXNew:=((rightPosX-rightPosXOrigin-rightPosXOld)*rightPosXScale)
	else if (rightPosX-rightPosXOrigin < rightPosXOld)
		rightPosXNew:=((rightPosX-rightPosXOrigin-rightPosXOld)*rightPosXScale)
	else
		rightPosXNew:=0

	;Right Controller Y position.
	if (rightPosY-rightPosYOrigin > rightPosYOld)
		rightPosYNew:=(((rightPosY-rightPosYOrigin-rightPosYOld)*rightPosYScale)*-1)
	else if (rightPosY-rightPosYOrigin < rightPosYOld)
		rightPosYNew:=(((rightPosY-rightPosYOrigin-rightPosYOld)*rightPosYScale)*-1)
	else
		rightPosYNew:=0

	;Right Controller Yaw.
	if (rightYaw > rightYawOld)
		rightYawNew:=((rightYaw-rightYawOld)*airMouseYawScale)
	else if (rightYaw < rightYawOld)
		rightYawNew:=((rightYaw-rightYawOld)*airMouseYawScale)
	else
		rightYawNew:=0

	;Right Controller Pitch.
	if (rightPitch-rightPitchOrigin > rightPitchOld)
		rightPitchNew:=(((rightPitch-rightPitchOrigin-rightPitchOld)*airMousePitchScale)*-1)
	else if (rightPitch-rightPitchOrigin < rightPitchOld)
		rightPitchNew:=(((rightPitch-rightPitchOrigin-rightPitchOld)*airMousePitchScale)*-1)
	else
		rightPitchNew:=0

	rightXNew:=(rightX*rightXScale)
	rightYNew:=((rightY*rightYScale)*-1)

	airMouseX:=(rightPosXNew+rightYawNew+rightXNew)
	airMouseY:=(rightPosYNew+rightPitchNew+rightYNew)
	SendRawMouseMove(airMouseX, airMouseY, 0)

	rightPitchOld:= static rightPitch-rightPitchOrigin
	rightYawOld:= static rightYaw
	rightPosXOld:= static rightPosX-rightPosXOrigin
	rightPosYOld:= static rightPosY-rightPosYOrigin

; Bind using the left thumb stick.
	;up/down.
	if Reached(AxisYLeft, leftYUpDZ) == 1
		SetvJoyButton(41,1)
	if Reached(AxisYLeft, leftYUpDZ) == -1
		SetvJoyButton(41,0)
	if Reached(AxisYLeft, leftYDownDZ) == -1
		SetvJoyButton(42,1)
	if Reached(AxisYLeft, leftYDownDZ) == 1
		SetvJoyButton(42,0)

	if (GetAxis(AxisHandTriggerLeft) > leftHandTriggerDZ) and (leftY > leftYUpDZ)
		SetvJoyButton(37,1)
	else if (GetAxis(AxisHandTriggerLeft) > leftHandTriggerDZ) and (leftY < leftYDownDZ)
		SetvJoyButton(38,1)
	else
		{
		SetvJoyButton(37,0)
		SetvJoyButton(38,0)
		}


	;left/right.
	if Reached(AxisXLeft, leftXDZR) == 1
		SetvJoyButton(44,1)
	if Reached(AxisXLeft, leftXDZR) == -1
		SetvJoyButton(44,0)
	if Reached(AxisXLeft, leftXDZL) == -1
		SetvJoyButton(43,1)
	if Reached(AxisXLeft, leftXDZL) == 1
		SetvJoyButton(43,0)

	if (GetAxis(AxisHandTriggerLeft) > leftHandTriggerDZ) and (leftX < leftXDZL)
		SetvJoyButton(49,1)
	else if (GetAxis(AxisHandTriggerLeft) > leftHandTriggerDZ) and (leftX > leftXDZR)
		SetvJoyButton(50,1)
	else
		{
		SetvJoyButton(49,0)
		SetvJoyButton(50,0)
		}

	; Nested functions for HotKey/Menu and vJoy/FPS modes.
	if (leftHandTrigger > leftHandTriggerDZ and rightHandTrigger > rightHandTriggerDZ) == 1
		{
		Send, {f down}
		SetvJoyAxis(HID_USAGE_RX, 0)
		SetvJoyAxis(HID_USAGE_RY, 0)
		SetvJoyAxis(HID_USAGE_RZ, 0)
		if IsPressed(ovrA)
			SetvJoyButton(29,1)
		if IsReleased(ovrA)
			SetvJoyButton(29,0)
		if IsPressed(ovrB)
			SetvJoyButton(30,1)
		if IsReleased(ovrB)
			SetvJoyButton(30,0)
		if IsPressed(ovrX)
			SetvJoyButton(31,1)
		if IsReleased(ovrX)
			SetvJoyButton(31,0)
		if IsPressed(ovrY)
			SetvJoyButton(32,1)
		if IsReleased(ovrY)
			SetvJoyButton(32,0)
		}
	if (Reached(AxisHandTriggerLeft, leftHandTriggerDZ) == -1 or Reached(AxisHandTriggerRight, rightHandTriggerDZ) == -1)
		{
		SetvJoyButton(29,0)
		SetvJoyButton(30,0)
		SetvJoyButton(31,0)
		SetvJoyButton(32,0)
		Send, {f up}
		}
	if (leftHandTrigger < leftHandTriggerDZ or rightHandTrigger < rightHandTriggerDZ) == 1
		{
		if (leftHandTrigger > leftHandTriggerDZ) == 1
			{
			if IsPressed(ovrA)
				SetvJoyButton(19,1)
			if IsReleased(ovrA)
				SetvJoyButton(19,0)
			if IsPressed(ovrB)
				SetvJoyButton(20,1)
			if IsReleased(ovrB)
				SetvJoyButton(20,0)
			if IsPressed(ovrX)
				SetvJoyButton(21,1)
			if IsReleased(ovrX)
				SetvJoyButton(21,0)
			if IsPressed(ovrY)
				SetvJoyButton(22,1)
			if IsReleased(ovrY)
				SetvJoyButton(22,0)
			if IsPressed(ovrEnter)
				Send, {F1 down}
			if IsReleased(ovrEnter)
				Send, {F1 up}
			if IsTouchPressed(ovrTouch_A)
				SetvJoyButton(23,1)
			else
				SetvJoyButton(23,0)
			if IsTouchPressed(ovrTouch_B)
				SetvJoyButton(24,1)
			else
				SetvJoyButton(24,0)
			if IsTouchPressed(ovrTouch_X)
				SetvJoyButton(25,1)
			else
				SetvJoyButton(25,0)
			if IsTouchPressed(ovrTouch_Y)
				SetvJoyButton(26,1)
			else
				SetvJoyButton(26,0)
			if leftY > 0.65
				SetvJoyButton(37,1)
			else if leftY < -0.65
				SetvJoyButton(38,1)
			else
				{
				SetvJoyButton(37,0)
				SetvJoyButton(38,0)
				}
			if leftX < -0.65
				SetvJoyButton(49,1)
			else if leftX > 0.65
				SetvJoyButton(50,1)
			else
				{
				SetvJoyButton(49,0)
				SetvJoyButton(50,0)
				}
			}
		if Reached(AxisHandTriggerLeft, leftHandTriggerDZ) == -1
			{
			SetvJoyButton(19,0)
			SetvJoyButton(20,0)
			SetvJoyButton(21,0)
			SetvJoyButton(22,0)
			SetvJoyButton(23,0)
			SetvJoyButton(24,0)
			SetvJoyButton(25,0)
			SetvJoyButton(26,0)
			SetvJoyButton(37,0)
			SetvJoyButton(38,0)
			SetvJoyButton(49,0)
			SetvJoyButton(50,0)
			Send, {F1 up}
			}
		if (rightHandTrigger > rightHandTriggerDZ) == 1
			{
			if IsPressed(ovrA)
				SetvJoyButton(11,1)
			if IsReleased(ovrA)
				SetvJoyButton(11,0)
			if IsPressed(ovrB)
				SetvJoyButton(12,1)
			if IsReleased(ovrB)
				SetvJoyButton(12,0)
			if IsPressed(ovrX)
				SetvJoyButton(13,1)
			if IsReleased(ovrX)
				SetvJoyButton(13,0)
			if IsPressed(ovrY)
				SetvJoyButton(14,1)
			if IsReleased(ovrY)
				SetvJoyButton(14,0)
			if IsTouchPressed(ovrTouch_A)
				SetvJoyButton(15,1)
			else
				SetvJoyButton(15,0)
			if IsTouchPressed(ovrTouch_B)
				SetvJoyButton(16,1)
			else
				SetvJoyButton(16,0)
			if IsTouchPressed(ovrTouch_X)
				SetvJoyButton(17,1)
			else
				SetvJoyButton(17,0)
			if IsTouchPressed(ovrTouch_Y)
				SetvJoyButton(18,1)
			else
				SetvJoyButton(18,0)
			if IsPressed(ovrEnter)
				SetvJoyButton(34,1)
			if IsReleased(ovrEnter)
				SetvJoyButton(34,0)
			if rightY > 0.65
				SetvJoyButton(45,1)
			else if rightY < -0.65
				SetvJoyButton(46,1)
			else
				{
				SetvJoyButton(45,0)
				SetvJoyButton(46,0)
				}
			if rightX > 0.65
				SetvJoyButton(47,1)
			else if rightX < -0.65
				SetvJoyButton(48,1)
			else
				{
				SetvJoyButton(47,0)
				SetvJoyButton(48,0)
				}
			}
		if Reached(AxisHandTriggerRight, rightHandTriggerDZ) == -1
			{
			SetvJoyButton(11,0)
			SetvJoyButton(12,0)
			SetvJoyButton(13,0)
			SetvJoyButton(14,0)
			SetvJoyButton(15,0)
			SetvJoyButton(16,0)
			SetvJoyButton(17,0)
			SetvJoyButton(18,0)
			SetvJoyButton(34,0)
			SetvJoyButton(45,0)
			SetvJoyButton(46,0)
			SetvJoyButton(47,0)
			SetvJoyButton(48,0)
			}
		if (leftHandTrigger < leftHandTriggerDZ and rightHandTrigger < rightHandTriggerDZ) == 1
			{	
			if IsPressed(ovrA)
				SetvJoyButton(3,1)
			if IsReleased(ovrA)
				SetvJoyButton(3,0)
			if IsPressed(ovrB)
				SetvJoyButton(4,1)
			if IsReleased(ovrB)
				SetvJoyButton(4,0)
			if IsPressed(ovrX)
				SetvJoyButton(5,1)
			if IsReleased(ovrX)
				SetvJoyButton(5,0)
			if IsPressed(ovrY)
				SetvJoyButton(6,1)
			if IsReleased(ovrY)
				SetvJoyButton(6,0)
			if IsTouchPressed(ovrTouch_A)
				SetvJoyButton(7,1)
			else
				SetvJoyButton(7,0)
			if IsTouchPressed(ovrTouch_B)
				SetvJoyButton(8,1)
			else
				SetvJoyButton(8,0)
			if IsTouchPressed(ovrTouch_X)
				SetvJoyButton(9,1)
			else
				SetvJoyButton(9,0)
			if IsTouchPressed(ovrTouch_Y)
				SetvJoyButton(10,1)
			else
				SetvJoyButton(10,0)
			if IsPressed(ovrEnter)
				SetvJoyButton(33,1)
			if IsReleased(ovrEnter)
				SetvJoyButton(33,0)
			}
	}
; End nested modes and ensure default buttons release.

	if IsReleased(ovrA)
		SetvJoyButton(3,0)
	if IsReleased(ovrB)
		SetvJoyButton(4,0)
	if IsReleased(ovrX)
		SetvJoyButton(5,0)
	if IsReleased(ovrY)
		SetvJoyButton(6,0)
	if IsTouchReleased(ovrTouch_A)
		SetvJoyButton(7,0)
	if IsTouchReleased(ovrTouch_B)
		SetvJoyButton(8,0)
	if IsTouchReleased(ovrTouch_X)
		SetvJoyButton(9,0)
	if IsTouchReleased(ovrTouch_Y)
		SetvJoyButton(10,0)
	if IsReleased(ovrEnter)
		SetvJoyButton(33,0)

;Set wearing
	if Wearing()
	{
		;touchtext := "Wear"
		wearingText := "Wearing headset: True"
		;Vibrate(0, 1, 255, 0)
		;Vibrate(1, 1, 255, 0)
	}
	else
	{
		wearingText := "Wearing headset: False"
	} 

	Sleep, 10
	
}
return

f8::Pause,Toggle

ButtonVibrateOn:
	Vibrate(0, 1, 255, 0)
	Vibrate(1, 1, 255, 0)
	return

ButtonVibrateOff:
	Vibrate(0, 1, 0, 0)
	Vibrate(1, 1, 0, 0)
	return

ButtonVibratePulse:
	Vibrate(0, 1, 255, 0.5)
	Vibrate(1, 1, 255, 0.5)
	return