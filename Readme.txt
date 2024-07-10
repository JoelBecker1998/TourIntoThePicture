


README.txt
==========

Content:
-------
1. Project Description
2. Authors
3. Overall Structure
4. GUI Description
5. Toolboxen

1. Project Description: Tour into the Picture
-------------
This project enables a "Tour into the Picture" by reconstructing a 2D image into a 3D space. Similar to Google Street View, the user can navigate within the reconstructed 3D environment. The implementation is done using Matlab, and the user interacts with the program through a graphical user interface (GUI).
The following sections describe the various components of the code and the toolboxes used.
The project was carried out as part of the lecture "Computer Vision" within a group of six students in the summer semester 2024 at the Technical University of Munich (TUM).


2. Authors
-------------
Aly Barakat, Cornelius Welling, Malik Dakhli, Maxe Henghuber, Joel Becker, Thomas Blomeyer


3. Overall Structure:
-----------------
1. Main Function(main):
* Calls simpleImageUI() to initialize the GUI
* Contains all essential program modules
2. simpleImageUI 
* Initializes imageProp using ImageProperties()
* Creates the main figure (hFig) and sets up the UI components using createUIComponents()
3. createUIComponents Function:
* Creates a tab group (tabGroup) within hFig
* Creates four tabs (tab1, tab2, tab3, tab4) for different functionalities: Instructions, Image Processing, 3D Reconstruction, Tour into the Picture
* Creates buttons and UI components for Image Processing tab using createButtons()
4. createButtons Function
* Creates various push buttons and checkboxes with specific callbacks and enables/disables them based on conditions
* Manages button positions and sizes dynamically
* Provides callbacks for functionalities like image selection, drawing rectangles, and toggling advanced properties
5. Button Callbacks
* Each button has a corresponding callback function (selectImage, drawRectangle, drawVanishingLines, etc.) that executes specific actions when clicked
* For example, selectImage opens a file selection dialog, reads the image, and displays it in the GUI.
6. Additional Functions:
* Functions like toggleAdvancedProperties, toggleObjectDetection, validateNumericInput, reset, etc., provide additional logic for handling GUI states, input validation, and resetting functionalities


4. GUI Description:
-----------------

1. Tab: Instructions
In the Instructions tab, the structure of the GUI is explained and the user is shown how to use the GUI. The following graphic shows a screenshot of the tab.


2. Tab: Image Processing
The Image Processing tab shows all the essential functions that need to be carried out at the start. The GUI is structured in such a way that the user is guided through the application step by step by activating buttons. First, an image is loaded into the GUI using "Select Image". Then, if the image is rotated, it can be aligned using "Rotate Image". This is done by allowing the user to draw a side line in the image to represent the wall of the room. Both the left and the right side wall can be defined. It is important that it is a side wall and not the ceiling or the floor. The back wall of the picture is then defined by "Select Rectangle". Finally, a vanishing point can be defined within the rectangle. The corresponding vanishing lines are calculated automatically. This concludes the preprocessing and the image is reconstructed in three dimensions using the "Create 3D Image" button.
For more complex images, a specially created "Adavanced Properties" toolbox can be used. Here it is possible to draw vanishing lines using "Draw Vanishing Lines" instead of a vanishing point. In addition, the foreground can be determined using "Draw Foreground". The toolbox also allows automatic object recognition and the field of view can be adjusted at the same time.


3. Tab: 3D Space Reconstruction
Once the 2D image has been reconstructed in three dimensions, it can be viewed in the third tab "3D Space Reconstruction". The user has the option of rotating the 3D image and viewing it from all sides. To ensure better displayability, side walls that block the view into the 3D space are hidden.


4. Tab: Tour into the Picture
The fourth tab allows the final "Tour into the Picture". The user can now move freely around the reconstructed room. The movement is controlled via the keyboard (keys: W, A, S, D, E, Q and arrow keys).



5. Toolboxen:
-----------------
Only the "Image Processing Toolbox" from Mathworks was used to implement the project.
