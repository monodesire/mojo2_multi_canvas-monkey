Strict

Import brl.databuffer

Public

' Preprocessor related:
#GLFW_WINDOW_TITLE = "Canvas Test Application"
#GLFW_WINDOW_WIDTH = 640
#GLFW_WINDOW_HEIGHT = 480

#GLFW_WINDOW_RESIZABLE = True
#GLFW_WINDOW_DECORATED = True
#GLFW_WINDOW_FLOATING = False
#GLFW_WINDOW_FULLSCREEN = False

' Imports:
Import mojo2

' Classes:
Class Application Extends App
	' Constant variable(s):
	Const VWIDTH:Int = 640
	Const VHEIGHT:Int = 360
	
	Const VASPECT:= (Float(VWIDTH) / Float(VHEIGHT))
	
	' Constructor(s):
	Method OnCreate:Int()
		SetUpdateRate(0) ' 60
		
		canvasA = New Canvas(Null)
		canvasB = New Canvas(Null)

		mojo2.Image.SetFlagsMask(mojo2.Image.Managed)
		myImage = mojo2.Image.Load("myimage.png", 0.0, 0.0)
		screenGrab = Null

		Return 0
	End
	
	' Methods:
	Method OnRender:Int()
		canvasA.SetAlpha(1.0)
		canvasA.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		canvasA.Clear(1.0, 0.0, 0.0)
		
		canvasA.Flush()
		
		Local virtualAspectRatio:Float = VASPECT
		Local deviceAspectRatio:Float = (Float(DeviceWidth()) / Float(DeviceHeight()))
		
		Local X:= 0
		Local Y:= 0
		
		' These will represent our inner viewport.
		Local vx:Int, vy:Int, vw:Int, vh:Int
		
		If (deviceAspectRatio > virtualAspectRatio) Then
			' Calculate the scaled width.
			vw = Int(Float(DeviceHeight()) * virtualAspectRatio)
			
			' Grab the current device-height.
			vh = DeviceHeight()
			
			' Using our previously scaled width, subtract from the
			' current device-width, then add our X-offset.
			vx = (((DeviceWidth() - vw) / 2) + X)
			
			' Grab the Y-offset specified above.
			vy = Y
		Else ' Elseif (virtualAspectRatio < deviceAspectRatio) Then
			' Grab the current device-height.
			vw = DeviceWidth()
			
			' Calculate the scaled height.
			vh = Int(DeviceWidth() / virtualAspectRatio)
			
			' Grab the X-offset specified above.
			vx = X
			
			' Using our previously scaled height, subtract from the
			' current device-height, then add our Y-offset.
			vy = (((DeviceHeight() - vh) / 2) + Y)
		Endif
		
		canvasB.SetViewport(vx, vy, vw, vh)
		
		canvasB.SetProjection2d(0, VWIDTH, 0, VHEIGHT)
		
		canvasB.Clear(0.0, 1.0, 0.0)
		
		canvasB.DrawImage(myImage, 0, 0)
		
		If screenGrab = Null
			screenGrab = ScreenGrab(canvasB, 0, 0, myImage.Width(), myImage.Height())
		Else
			canvasB.DrawImage(screenGrab, myImage.Width() + 50, 50)
		End If

		canvasB.Flush()

		Return 0
	End

	Method ScreenGrab:Image(canvas:Canvas, x:Int, y:Int, width:Int, height:Int)
	  Local screenShot:mojo2.Image = New mojo2.Image(width, height, 0.0, 0.0)
		Local pixels:DataBuffer = New DataBuffer(width*height*4)

		canvas.SetAlpha(1.0)
	  canvas.ReadPixels(x, y, width, height, pixels)
	  screenShot.WritePixels(0, 0, width, height, pixels)

	  Return screenShot
	End Method
	
	' Fields:
	Field canvasA:Canvas
	Field canvasB:Canvas
	Field myImage:mojo2.Image
	Field screenGrab:mojo2.Image
End

' Functions:
Function Main:Int()
	New Application()
	
	Return 0
End