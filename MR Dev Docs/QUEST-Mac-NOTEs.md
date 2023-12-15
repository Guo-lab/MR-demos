# NOTEs for Meta MR Game

tips 1. [How to turn on Developer Mode on Meta Quest3 on MacOS Meta Quest App](https://medium.com/sidequestvr/how-to-turn-on-developer-mode-for-the-quest-3-509244ccd386)

##### Meta Quest Settings in Unity:

Edit > Project Settings > XR Plug-in Management
Add Controller Profiles.

Then.
tips 2. [Setup Quest Android Config on Mac Unity without Deprecated Oculus Integration](https://www.youtube.com/watch?v=7mAAkB1WGpk)

Build and Run.

At the end, we need .apk file!

<br>

##### First Game Scene:

Main Camera needs a Tracked Pose Driver.

1. XR Interaction toolkit to speed up the development process. With this, we can replace the former camera with a XR Origin (higher level camera component).

   XR Origin has tracking origin mode to simulate users' height.XR Origin: Camera Offset > (1)Main Camera (2)Left Controller (3)Right Controller

   - XR Interaction toolkit should import Start Assets.

     > Assets to streamline setup of behaviors, including a default set of input actions and presets for use with XR Interaction Toolkit behaviors that use the Input System.
     >

     This could add the XRI Default quickly.
   - Add XRI Default Input Actions.

tips 3. When Window > Animation > Animator, the end has to be selected. Option + Click to move. Clicking the nodes to see models in the preview.

2. How to read and use a input
   Create a custom component(New Script with a specific name).

   Mac had test Debug.Log Problems. - 2023.12  

   
