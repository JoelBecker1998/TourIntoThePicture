function simpleImageUI()
    % Initialize image properties
    imageProp = ImageProperties();

    % Create main figure
    hFig = figure('Name', 'Simple Image Viewer', 'Position', [100, 100, 1200, 900]);

    % Create UI components
    createUIComponents(hFig, imageProp);
end

function createUIComponents(hFig, imageProp)
    % Create a tab group
    tabGroup = uitabgroup('Parent', hFig, 'Position', [0, 0, 1, 1]);
    g = gcf; % Get handle to the current (last) figure
    g.WindowState = 'maximized';

    % Create tabs
    tab0 = uitab('Parent', tabGroup, 'Title', 'Intro');
    tab1 = uitab('Parent', tabGroup, 'Title', 'Instructions');
    tab2 = uitab('Parent', tabGroup, 'Title', 'Image Processing');
    tab3 = uitab('Parent', tabGroup, 'Title', '3D Reconstruction');
    tab4 = uitab('Parent', tabGroup, 'Title', 'Tour into the Picture');

    % Create instruction text label on the first tab
      instructionText = {
        'This project enables a "Tour into the Picture" by reconstructing a 2D image into a 3D space. Similar to Google Street View, the user can navigate within the reconstructed 3D environment.', ...
        'The project is divided into three sections (tabs): "Image Processing", "3D Reconstruction" and "Tour into the Picture", which can be operated one after the other.', ...
        '', ...
        'GUI Instructions:', ...
        '', ...
        '1. Image Processing', ...
        '     - Select Image: select an image to be viewed; if another image is to be selected, press again ', ...
        '     - Reset: reset all selected functions and return inmage to its original unprocessed state', ...
        '     - Rotate Image: rotate the image, if necessary, by defining one of the two side walls by drawing a line ', ...
        '     - Delete Rotation: reset the rotation to be able to perform a rotation again', ...
        '     - Select Rectangle: drag a rectangle to define the back wall of the image, to reset the rectangle, press again. ', ...
        '     - Select Vanishing Point (VP): manually position a VP on the image, press again to reset the vanishing point', ...
        '     - Advanced Properties: check the box to activate the Advanced Properties Toolbox for more complex images', ...
        '           Draw Vanishing Lines (VL): if the image has a 2nd VP that lies outside the image area, add two VLs', ...
        '                do so by selecting 2x2 points that are on two VLs leading to the 2nd VP', ...
        '                only applicable it the 2nd VP is on the upper part of the image', ...
        '           Draw Foreground: use this function to cut out objects in the foreground and add them again after the 3D reconstruction', ...
        '           Auto Object Detection: use this function for automatic object detection', ...
        '           Adjust the Field of View (FOV): adjust the estimated FOV; this function modifies the depth of the image', ...
        '                high FOV: create shallow rooms, low FOV: elongated rooms, value range: 60 to 150 degrees', ...
        '     - Create 3D Image: press to perform the 3D reconstruction', ...
        '2. 3D Reconstruction', ...
        '     - switch to this tab to view the 3D reconstruction ', ...
        '     - the 3D image can be rotated and twisted, side walls that prevent a view into the interior are hidden for a better overview ', ...
        '3. Tour into the Picture', ...
        '     - switch to this tab to start the Tour into the Picture  ', ...
        '     - first press once with the mouse or another button to start the tour', ...
        '     - move around the room using the W, A, S, D keys, rotations are possible using the arrow keys --> Enjoy yourself!', ...
        'Warning: If the mouse vanishes, please restart the program.'
    };
      
    % Create instruction text label on the first tab
    uicontrol('Parent', tab1, 'Style', 'text', ...
        'String', instructionText, ...
        'FontSize', 16, 'FontWeight', 'normal', ...
        'HorizontalAlignment', 'left', ...
        'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);

    % Create panel for buttons on the second tab with increased height
    buttonPanel2 = uipanel('Parent', tab2, 'Position', [0, 0.8, 1, 0.2]);

    % Create buttons for the second tab
    createButtons(buttonPanel2, imageProp);

    % Create axes for image display on the first tab
    hAxes = axes('Parent', tab2, 'Position', [0.15, 0.1, 0.7, 0.6]);
    hAxes2 = axes('Parent', tab3, 'Position', [0.15, 0.1, 0.7, 0.7]);
    hAxes3 = axes('Parent', tab4, 'Position', [0.15, 0.1, 0.7, 0.7]);

    % Remove x and y ticks from both axes
    set(hAxes, 'XTick', [], 'YTick', []);
    set(hAxes2, 'XTick', [], 'YTick', []);
    set(hAxes3, 'XTick', [], 'YTick', []);

    % Store axes handles in imageProp for later use
    imageProp.setProperty('hAxes', hAxes);
    imageProp.setProperty('hAxes2', hAxes2);
    imageProp.setProperty('hAxes3', hAxes3);

    % Create text label on the second tab
    instructionText = uicontrol('Parent', tab2, 'Style', 'text', 'String', 'Select an image to process', ...
        'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
        'Units', 'normalized', 'Position', [0.1, 0.7, 0.8, 0.1], 'Tag', 'InstructionText');

    % Store the handle to this text object in imageProp for later use
    imageProp.setProperty('instructionTextHandle', instructionText);

    % Create UI components for other tabs
    create3DViewComponents(tab3, imageProp);
    createStreetViewComponents(tab4, imageProp);
    % Call the function to create and set up the intro tab
    createIntroTab(tab0, imageProp);
    % Add functionality for the new 1st tab (tab1) here if needed
end

function createButtons(buttonPanel, imageProp)
    buttonWidth = 0.22; % Adjusted button width for 4 columns
    buttonHeight = 0.2; % Adjusted button height for 3 rows
    yPosition = [0.6, 0.35, 0.1]; % Adjusted positions for three rows
    xPosition = [0.02, 0.26, 0.50, 0.74]; % Positions for four columns

    fontsize = 14;
    
    % Text label positions and sizes
    labelWidth = buttonWidth;
    labelHeight = 0.15; % Height of the text label
    labelYPosition = 0.82; % Y position for the text labels (adjust as necessary)
    
    % Add text labels on top of the buttons
    uicontrol('Parent', buttonPanel, 'Style', 'text', 'String', 'Image Selection', ...
        'Units', 'normalized', 'Position', [xPosition(1), labelYPosition, labelWidth, labelHeight], ...
        'FontSize', fontsize, 'HorizontalAlignment', 'center');
    
    uicontrol('Parent', buttonPanel, 'Style', 'text', 'String', 'Image Preprocessing', ...
        'Units', 'normalized', 'Position', [xPosition(2), labelYPosition, labelWidth, labelHeight], ...
        'FontSize', fontsize, 'HorizontalAlignment', 'center');
    
    uicontrol('Parent', buttonPanel, 'Style', 'text', 'String', 'Image Processing', ...
        'Units', 'normalized', 'Position', [xPosition(4), labelYPosition, labelWidth, labelHeight], ...
        'FontSize', fontsize, 'HorizontalAlignment', 'center');

    buttons = {
        {'Select Image', @(~,~) selectImage(imageProp), 1, 1},
        {'Reset', @(~,~) reset(imageProp), 2, 1},
        {'Rotate Image (optional)', @(~,~) rotateImage(imageProp), 1, 2},
        {'Delete Rotation', @(~,~) deleteRotation(imageProp), 1, 2},
        {'Select Vanishing Points', @(~,~) selectVanishingPoints(imageProp), 3, 2},
        {'Select Rectangle', @(~,~) drawRectangle(imageProp), 2, 2},
        {'Draw Vanishing Lines', @(~,~) drawVanishingLines(imageProp), 1, 3},
        {'Draw Foreground', @(~,~) drawForeground(imageProp), 2, 3},
        {'Create 3D Image', @(~,~) calculatePlanes(imageProp), 1, 4},
        {'Delete Vanishing Lines', @(~,~) clearVanishingLines(imageProp), 1, 3},
        {'Delete Foreground', @(~,~) deleteForeground(imageProp), 2, 3}
    };
    
    % Adjusted button width for the 3rd column (half of normal width)
    buttonWidthThirdColumn = buttonWidth / 2;

    for i = 1:length(buttons)
        % Determine if the button should be enabled or disabled
        if strcmp(buttons{i}{1}, 'Delete Foreground') || ...
           strcmp(buttons{i}{1}, 'Select Vanishing Points') || ...
           strcmp(buttons{i}{1}, 'Select Rectangle') || ...
           strcmp(buttons{i}{1}, 'Draw Foreground') || ...
           strcmp(buttons{i}{1}, 'Create 3D Image') || ...
           strcmp(buttons{i}{1}, 'Delete Vanishing Lines') || ...
           strcmp(buttons{i}{1}, 'Draw Vanishing Lines') || ...
           strcmp(buttons{i}{1}, 'Rotate Image (optional)')|| ...
           strcmp(buttons{i}{1}, 'Delete Rotation')
            enableState = 'off';
        else
            enableState = 'on';
        end
        
        row = buttons{i}{3};
        col = buttons{i}{4};

        % Determine button width based on column
        if col == 3 || col == 2 && row == 1
            currentButtonWidth = buttonWidthThirdColumn;
        else
            currentButtonWidth = buttonWidth;
        end
        
        % Adjust position for buttons in the 3rd and 2nd column
        if strcmp(buttons{i}{1}, 'Delete Vanishing Lines') || strcmp(buttons{i}{1}, 'Delete Foreground')
            % For 'Delete Vanishing Lines' and 'Delete Foreground' buttons,
            % adjust xPosition to place them in the second half of the third column
            xPos = xPosition(3) + buttonWidthThirdColumn;
        elseif strcmp(buttons{i}{1}, 'Delete Rotation')
            xPos = xPosition(2) + buttonWidthThirdColumn;
        else
            % For other buttons, use their respective xPosition
            xPos = xPosition(col);
        end
        
        uicontrol('Parent', buttonPanel, 'Style', 'pushbutton', 'String', buttons{i}{1}, ...
            'Units', 'normalized', 'Position', [xPos, yPosition(row), currentButtonWidth, buttonHeight], ...
            'Callback', buttons{i}{2}, 'Tag', buttons{i}{1}, 'Enable', enableState, 'FontSize', fontsize);
    end

    % Position for the Advanced Properties checkbox
    checkboxXPosition1 = xPosition(3) + 0.05;
    checkboxYPosition1 = yPosition(1) + buttonHeight + 0.05;  % Adjust Y position above the first row

    % Create the Advanced Properties checkbox for advanced properties
    advancedPropertiesCheckbox = uicontrol('Parent', buttonPanel, 'Style', 'checkbox', 'String', 'Advanced Properties', ...
        'Units', 'normalized', 'Position', [checkboxXPosition1, checkboxYPosition1, buttonWidth * 0.7, buttonHeight / 2], ...
        'HorizontalAlignment', 'center', 'Tag', 'AdvancedPropertiesCheckbox', 'FontSize', fontsize);

    % Position for the Automatic Object Detection checkbox
    checkboxXPosition2 = xPosition(3);
    checkboxYPosition2 = yPosition(3) + 0.07;  % Adjust Y position below the third row

    % Position for the Numerical Edit Field
    editFieldXPosition = checkboxXPosition2 + buttonWidth + 0.02;
    editFieldYPosition = checkboxYPosition2;

    % Define common Y position for alignment
    commonYPosition = editFieldYPosition;
    
    % Create the Numerical Edit Field
    numericalEditField = uicontrol('Parent', buttonPanel, 'Style', 'edit', 'String', '80', ...
        'Units', 'normalized', 'Position', [editFieldXPosition - 0.05, commonYPosition, buttonWidth * 0.15, buttonHeight*0.6], ...
        'HorizontalAlignment', 'center', 'Tag', 'NumericalEditField', 'FontSize', fontsize, ...
        'Callback', @(src,~) validateNumericInput(src, imageProp), 'Enable', 'off');
    
    % Text label "FOV:"
    fovTextLabel = uicontrol('Parent', buttonPanel, 'Style', 'text', 'String', 'FOV:', ...
    'Units', 'normalized', 'Position', [editFieldXPosition - 0.07 - buttonWidth * 0.12, commonYPosition + 0.004, buttonWidth * 0.17, buttonHeight / 1.5], ...
    'HorizontalAlignment', 'right', 'FontSize', fontsize, 'Enable', 'off');
    
    % Create the Automatic Object Detection checkbox
    objectDetectionCheckbox = uicontrol('Parent', buttonPanel, 'Style', 'checkbox', 'String', 'Auto Object Detection', ...
        'Units', 'normalized', 'Position', [checkboxXPosition2, commonYPosition, buttonWidth - 0.075, buttonHeight / 2], ...
        'HorizontalAlignment', 'center', 'Tag', 'ObjectDetectionCheckbox', 'Enable', 'off', 'FontSize', fontsize, ...
        'Callback', @(src, event) toggleObjectDetection(src, imageProp));

    % Set the callback for the Advanced Properties checkbox now that both checkboxes are defined
    set(advancedPropertiesCheckbox, 'Callback', @(src,~) toggleAdvancedProperties(src, imageProp, objectDetectionCheckbox));
end

function validateNumericInput(src, imageProp)
    % Validate input to ensure it's numerical
    str = get(src, 'String');
    if isempty(str2num(str)) || isnan(str2double(str))
        % If input is not numerical, revert to default value
        set(src, 'String', '0');
        imageProp.fov = 80;
        set(imageProp.instructionTextHandle, 'String', 'Invalid input. Please enter a number between 60 and 150.');
    else
        % If valid, update the fov property
        numValue = str2double(str);
        if numValue < 60
            numValue = 60;
            set(imageProp.instructionTextHandle, 'String', 'Input too low. FOV set to the minimum value of 60.');
        elseif numValue > 150
            numValue = 150;
            set(imageProp.instructionTextHandle, 'String', 'Input too high. FOV set to the maximum value of 150.');
        else
            set(imageProp.instructionTextHandle, 'String', ['FOV set to ' num2str(numValue) '.']);
        end
        imageProp.fov = numValue;
        set(src, 'String', num2str(numValue));  % Update the edit field with the constrained value
    end
end

function toggleAdvancedProperties(src, imageProp, objectDetectionCheckbox)
    if src.Value
        % give instruction to help the user
        set(imageProp.instructionTextHandle, 'String', ['Select foreground ' ...
            'rectangle and/or vanishing lines, activate the ' ...
            'automatic object detection, and select the FOV of the 3D ' ...
            'reconstruction']);
        % Enable advanced buttons
        set(objectDetectionCheckbox, 'Enable', 'on');
        set(findobj('Tag', 'Draw Vanishing Lines'), 'Enable', 'on');
        set(findobj('Tag', 'Draw Foreground'), 'Enable', 'on');
        % Enable the Numerical Edit Field and FOV Text Label
        set(findobj('Tag', 'NumericalEditField'), 'Enable', 'on');
        set(findobj('Style', 'text', 'String', 'FOV:'), 'Enable', 'on');
    else
        % disable advanced buttons
        set(objectDetectionCheckbox, 'Enable', 'off');
        set(findobj('Tag', 'Draw Vanishing Lines'), 'Enable', 'off');
        set(findobj('Tag', 'Draw Foreground'), 'Enable', 'off');
        set(findobj('Tag', 'Delete Vanishing Lines'), 'Enable', 'off');
        set(findobj('Tag', 'Delete Foreground'), 'Enable', 'off');
        % Disable the Numerical Edit Field and FOV Text Label
        set(findobj('Tag', 'NumericalEditField'), 'Enable', 'off');
        set(findobj('Style', 'text', 'String', 'FOV:'), 'Enable', 'off');
    end
end

function reset(imageProp)
    % disable all the enabled buttons
    set(findobj('Tag', 'Delete Rotation'), 'Enable', 'off');
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'off');

    % delete all the changes made 
    deleteRectangle(imageProp);
    deleteRotation(imageProp);
    clearVanishingLines(imageProp);
    deleteForeground(imageProp);
    clearVanishingPoints(imageProp);
    
    % Set its String property to 80 (default value)
    numericalEditField = findobj('Tag', 'NumericalEditField');  % Find the numericalEditField by its Tag
    numericalEditField(1).String = '80';  
    imageProp.objectDet = 0;
    % change instructions text
    set(imageProp.instructionTextHandle, 'String', 'Settings reset. Select background rectangle and rotate the image if needed');

    % Clear axes in tab3 and tab4
    cla(imageProp.hAxes2);
    set(imageProp.hAxes2, 'XTick', [], 'YTick', []);
    
    cla(imageProp.hAxes3);
    set(imageProp.hAxes3, 'XTick', [], 'YTick', []);
end


function toggleObjectDetection(src, imageProp)
    if get(src, 'Value')
        disp('Object detection ON');
        % Call function to enable object detection
        imageProp.objectDet = 1;
    else
        disp('Object detection OFF');
        % Call function to disable object detection
        imageProp.objectDet = 0;
    end
end

function createIntroTab(tab, imageProp)
    % Create one large axes for the image display on the intro tab
    hAxesIntro = axes('Parent', tab, 'Position', [0.05, 0.1, 0.9, 0.8]);
    set(hAxesIntro, 'XTick', [], 'YTick', []);
    imageProp.setProperty('hAxesIntro', hAxesIntro);

    % Load and display the image on the intro tab
    imageFilePath = 'ImageIntro.jpg'; % Specify the path to your image file
    img = imread(imageFilePath); % Load the image
    imshow(img, 'Parent', hAxesIntro); % Display the image within the specified axes
end

function create3DViewComponents(tab, imageProp)
    % Add components for the second tab
    threeD_tab_text = uicontrol('Parent', tab, 'Style', 'text', 'String', 'Create a 3D image to see the 3D view', ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
        'Units', 'normalized', 'Position', [0.3, 0.8, 0.4, 0.03], 'Tag', 'threeD_tab_text');
    imageProp.setProperty('threeDview_tab_text', threeD_tab_text);
    
end

function createStreetViewComponents(tab, imageProp)
    % Add components for the third tab (movement instructions)
    uicontrol('Parent', tab, 'Style', 'text', 'String', ...
        'W + A + S + D Movement: forward, left, backward, right', ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', ...
        'Units', 'normalized', 'Position', [0.02, 0.94, 0.33, 0.03]);

    uicontrol('Parent', tab, 'Style', 'text', 'String', ...
        'E and Q Movement: up, down', ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', ...
        'Units', 'normalized', 'Position', [0.02, 0.91, 0.2, 0.03]);

    uicontrol('Parent', tab, 'Style', 'text', 'String', ...
        'Arrow Keys Rotation: up, down, left, right', ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', ...
        'Units', 'normalized', 'Position', [0.02, 0.88, 0.25, 0.03]);

    tourIntoImageText = uicontrol('Parent', tab, 'Style', 'text', 'String', ...
        'Create the 3D image to get a Tour.', ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', ...
        'Units', 'normalized', 'Position', [0.02, 0.85, 0.2, 0.03], ...
        'Tag', 'tourIntoImageText');
    imageProp.setProperty('tourIntoImageText', tourIntoImageText);
end

% Image selection callback
function selectImage(imageProp)
    % disable all buttons, this should occure if its the second time the
    % user clicks on this button to create a new image
    set(findobj('Tag', 'Select Rectangle'), 'Enable', 'off');
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'off');
    set(findobj('Tag', 'Delete Rotation'), 'Enable', 'off');
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'off');

    % Open file selection dialog for image files
    [fileName, filePath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.gif', 'Image Files'}, 'Select an Image');    % Check if a file is selected
    if fileName ~= 0
        % Read the selected image
        img = imread(fullfile(filePath, fileName));
        
        % Store the original image in the imageProp object
        imageProp.setProperty('origImg', img);
        
        % Display the original image in the specified axes
        imshow(imageProp.origImg, 'Parent', imageProp.hAxes);

        % Reset image-related properties
        imageProp.setProperty('rectangleHandle', []);
        imageProp.setProperty('vanishingPointMarkers', []);
        imageProp.setProperty('vanishingLineHandles', []);
        imageProp.setProperty('intersectionPoint2', []);
        imageProp.setProperty('lineHandle', []);
        imageProp.setProperty('foregroundHandle', []);
        imageProp.setProperty('p_FG2D', []);
        imageProp.setProperty('fov', 80);

        % Store image size
        imgAxes = findobj(imageProp.hAxes, 'Type', 'image');
        imageProp.setProperty('imgAxes', imgAxes);
        imageProp.setProperty('imgSize', size(get(imgAxes, 'CData')));

        % Enable the buttons after an image is selected
        set(findobj('Tag', 'Select Rectangle'), 'Enable', 'on');
        set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'on');

        % Find the tab and text object for instructions
        tab1 = findobj('Type', 'uitab', 'Title', 'Image Processing');
        textObj = findobj(tab1, 'Style', 'text');
        
        % Set the instruction text for the user
        set(imageProp.instructionTextHandle, 'String', 'Select background rectangle and rotate the image if needed');
    end
end

function [intersectionPoint, linePoints] = drawTwoLinesAndIntersect(axesHandle, imageProp)
    % Use the provided axes handle or create a new one if not provided
    if nargin < 1 || isempty(axesHandle)
        axesHandle = gca;
    end

    % Make sure we're drawing on the correct axes
    axes(axesHandle);

    % Set up the axes if they're empty
    if isempty(axesHandle.Children)
        axis([0 10 0 10]);
    end

    title('Click 2 points for each line (4 points total)');
    hold(axesHandle, 'on');

    linePoints = zeros(4, 2);
    for i = 1:4
        [x, y] = ginput(1);
        % Force focus back to the figure window to ensure cursor visibility
        figure(gcf);
        linePoints(i, :) = [x, y];
        lineHandle = plot(axesHandle, x, y, 'ro');
        imageProp.append('lineHandle' ,lineHandle);
        if mod(i, 2) == 0
            lineHandle = line(axesHandle, [linePoints(i-1, 1), x], [linePoints(i-1, 2), y], 'Color', 'r');
            imageProp.append('lineHandle' ,lineHandle);
        end
    end

    % Calculate intersection point
    x1 = linePoints(1,1); y1 = linePoints(1,2);
    x2 = linePoints(2,1); y2 = linePoints(2,2);
    x3 = linePoints(3,1); y3 = linePoints(3,2);
    x4 = linePoints(4,1); y4 = linePoints(4,2);

    % Calculate slopes and y-intercepts
    m1 = (y2 - y1) / (x2 - x1);
    b1 = y1 - m1 * x1;

    m2 = (y4 - y3) / (x4 - x3);
    b2 = y3 - m2 * x3;

    % Check if lines are parallel
    if m1 == m2
        intersectionPoint = [NaN, NaN];
    else
        % Calculate intersection point
        intersectionX = (b2 - b1) / (m1 - m2);
        intersectionY = m1 * intersectionX + b1;
        intersectionPoint = [intersectionX, intersectionY];

        % Extend lines to show intersection
        axLimits = axis(axesHandle);
        xRange = axLimits(2) - axLimits(1);
        yRange = axLimits(4) - axLimits(3);
        extendFactor = 2;  % Extend lines beyond axis limits

        xExtended = [axLimits(1)-xRange*extendFactor, axLimits(2)+yRange*extendFactor];
        y1Extended = m1 * xExtended + b1;
        y2Extended = m2 * xExtended + b2;

        lineHandle = line(axesHandle, xExtended, y1Extended, 'Color', 'b', 'LineStyle', '--');
        imageProp.append('lineHandle' ,lineHandle);
        lineHandle = line(axesHandle, xExtended, y2Extended, 'Color', 'b', 'LineStyle', '--');
        imageProp.append('lineHandle' ,lineHandle);
    end

    hold(axesHandle, 'off');
end


function drawVanishingLines(imageProp)
    % disable button to avoid clicking simultaneously on them
    set(findobj('Tag', 'Draw Foreground'), 'Enable', 'off');
    % clear old vanishing lines
    clearVanishingLines(imageProp);
    % helper instruction for the user
    set(imageProp.instructionTextHandle, 'String', 'Pick two vanishing lines that run to a second vanishing point');
    set(imageProp.instructionTextHandle, 'String', 'Vanishing lines selected');

    intPoint = drawTwoLinesAndIntersect(imageProp.hAxes, imageProp);
    imageProp.setProperty('intersectionPoint2', intPoint);
    % Enable next buttons
    set(findobj('Tag', 'Delete Vanishing Lines'), 'Enable', 'on');
    set(findobj('Tag', 'Draw Foreground'), 'Enable', 'on');
end

function clearVanishingLines(imageProp)
    imageProp.setProperty('intersectionPoint2', []);
    imageProp.setProperty('lineHandle', []);
    % disable button to prevent the user to click multiple times on it
    set(findobj('Tag', 'Delete Vanishing Lines'), 'Enable', 'off');
end

% Rectangle drawing callback
function drawRectangle(imageProp)
    % disable Select Vanishing Points button and  to avoid that you can click
    % them simultaneously and disable delete 
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'off');
    set(findobj('Tag', 'Delete Rotation'), 'Enable', 'off');
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'off');

    deleteRectangle(imageProp); % Delete any existing rectangle first
    clearVanishingPoints(imageProp); % Delete any existing vanishing points
    hRect = drawrectangle(imageProp.hAxes);
    imageProp.setProperty('rectangleCorners', RectanglePositionToCorners(hRect.Position));
    imageProp.setProperty('rectangleHandle', hRect);
    
    % Enable delete Select Vanishing Points and Rotate Image button 
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'on');
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'on');

    % Choose the text to indicate the next step
    tab1 = findobj('Type', 'uitab', 'Title', 'Image Processing');
    textObj = findobj(tab1, 'Style', 'text');
    set(imageProp.instructionTextHandle, 'String', 'Select Vanishing Points');
    
    % Add text label to the bottom left corner of the rectangle
    rectColor = hRect.Color;
    rectPos = hRect.Position;
    xPos = rectPos(1) + 6;
    yPos = rectPos(2) + rectPos(4) - 7; % Align text to the bottom edge of the rectangle
    % Calculate a suitable font size based on the height of the rectangle
    fontSize = round(rectPos(4) * 100); % Adjust multiplier as needed
    if fontSize < 8
        fontSize = 8; % Minimum font size to prevent being too small
    elseif fontSize > 16
        fontSize = 16; % Maximum font size to prevent being too large
    end
    % write Background in the bottom left corner
    hText = text(xPos, yPos, 'Background', 'FontSize', fontSize, ...
        'EdgeColor', rectColor, ...
        'Color', rectColor, ...
        'LineWidth', 2, ...
        'FontWeight', 'bold', ...
        'String', 'Background', ...
        'Parent', imageProp.hAxes, ...
        'VerticalAlignment', 'bottom'); % Align text to bottom
    imageProp.textHandle = hText;

    % Add listener to update text position when rectangle is moved
    addlistener(hRect, 'MovingROI', @(src, evt) updateTextPosition(src, hText));
    addlistener(hRect, 'ROIMoved', @(src, evt) updateTextPosition(src, hText)); % Ensure it updates after the move too
end

function updateTextPosition(rect, textHandle)
    % Get the new position of the rectangle
    rectPos = rect.Position;
    % Update the text position to the new bottom-left corner of the rectangle
    xPos = rectPos(1);
    yPos = rectPos(2) + rectPos(4) + 0.02; % Bottom-left corner y position
    set(textHandle, 'Position', [xPos, yPos, 0]);
end

% Rectangle deletion callback
function deleteRectangle(imageProp)
    if ~isempty(imageProp.rectangleHandle)
        delete(imageProp.rectangleHandle);
        imageProp.setProperty('rectangleHandle', []);
    end
    % Set the text label to an empty string if it exists
    if ~isempty(imageProp.textHandle)
        if isvalid(imageProp.textHandle)
        set(imageProp.textHandle, 'String', '');
        end
    end
    % Disable delete rectangle button
    set(findobj('Tag', 'Delete Rectangle'), 'Enable', 'off');
end

% Vanishing point selection callback
function selectVanishingPoints(imageProp)
    % disable Select Vanishing Points button and  to avoid that you can click
    % them simultaneously
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'off');
    set(findobj('Tag', 'Select Rectangle'), 'Enable', 'off');

    imageProp.setProperty('vanishingPointMarkers', []);
    imageProp.setProperty('vanishingLineHandles', []);
    hold(imageProp.hAxes, 'on');

    [x, y] = ginput(1);
    axLimits = axis(imageProp.hAxes);
    h = plot(imageProp.hAxes, x, y, 'ro');
    imageProp.setProperty('vanishingPoint', [x, y]);
    imageProp.setProperty('vanishingPointMarkers', h);

    % don't move this hold off or matlab gets super shitty with you for
    % some reason...
    hold(imageProp.hAxes, 'off');


    if ~isempty(imageProp.rectangleHandle)
        calculateIntersections(imageProp);
        h = drawLines(imageProp.hAxes, imageProp);
        imageProp.setProperty('vanishingLineHandles', h);
    else
        warning('Define a rectangle before selecting vanishing points.');
    end

    hold(imageProp.hAxes, 'off');

    % Enable next buttons and the previous ones 
    set(findobj('Tag', 'Create 3D Image'), 'Enable', 'on');
    set(findobj('Tag', 'Clear Vanishing Points'), 'Enable', 'on');
    set(findobj('Tag', 'Select Rectangle'), 'Enable', 'on');
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'on');
    % Set the to guide the user
    set(imageProp.instructionTextHandle, 'String', 'Select advanced properties if needed, else the image is ready to process');
end

% Clear vanishing points callback
function clearVanishingPoints(imageProp)
    imageProp.setProperty('vanishingPointMarkers', []);
    imageProp.setProperty('vanishingPoint', []);
    imageProp.setProperty('vanishingLineHandles', []);
    % Dis
    set(findobj('Tag', 'Clear Vanishing Points'), 'Enable', 'off');
end

% Calculate 3D planes callback
function calculatePlanes(imageProp)
    if imageProp.allNecessaryInfoAvailable()
        imageProp.resetStuff();
        create3DImage(imageProp.hAxes, imageProp, imageProp.hAxes2, imageProp.hAxes3); 
    end
    
    set(imageProp.instructionTextHandle, 'String', 'Image Processed, select tab to see the processed Image');
    set(imageProp.threeDview_tab_text, 'String', 'This is the 3D view');
    set(imageProp.tourIntoImageText, 'String', 'click once on the image to start.');
end

% Draw foreground callback
function drawForeground(imageProp)
    % disable buttons to avoid click on them sim
    set(findobj('Tag', 'Draw Vanishing Lines'), 'Enable', 'off');
    
    % Draw the rectangle with specified color
    h = drawrectangle(imageProp.hAxes, 'Color', 'r');  % Change 'r' to any valid color
    
    % Append the rectangle handle and position information to imageProp
    imageProp.append('foregroundHandle', h);
    imageProp.append('p_FG2D', RectanglePositionToCorners(h.Position));
    
    % Enable the 'Delete Foreground' and 'Select Vanishing Lines' buttons
    set(findobj('Tag', 'Delete Foreground'), 'Enable', 'on');
    set(findobj('Tag', 'Draw Vanishing Lines'), 'Enable', 'on');

    % Add text label to the top left corner of the rectangle
    rectColor = h.Color;
    rectPos = h.Position;
    xPos = rectPos(1) + 6;
    yPos = rectPos(2) + rectPos(4) - 20; % Top-left corner y position

    % Calculate font size based on the height of the rectangle
    fontSize = round(rectPos(4) * 80); % Adjust multiplier as needed
    if fontSize < 8
        fontSize = 8; % Minimum font size to prevent being too small
    elseif fontSize > 16
        fontSize = 16; % Maximum font size to prevent being too large
    end
    % Set the Foreground Text in bottom left corner of the rectangle 
    hText = text(xPos, yPos, 'Foreground', 'FontSize', fontSize, ...
                 'EdgeColor', rectColor, ...
                 'Color', rectColor, ...
                 'LineWidth', 2, ...
                 'FontWeight', 'bold', ...
                 'String', 'Foreground', ...
                 'Parent', imageProp.hAxes);
    imageProp.textHandle = hText;

    % Add listener to update text position and font size when rectangle is moved
    addlistener(h, 'MovingROI', @(src, evt) updateTextProperties(src, hText));
    addlistener(h, 'ROIMoved', @(src, evt) updateTextProperties(src, hText)); % Ensure it updates after the move too
end

function updateTextProperties(rect, textHandle)
    % Get the new position of the rectangle
    rectPos = rect.Position;
    % Update the text position to the new top-left corner of the rectangle
    xPos = rectPos(1) + 10;
    yPos = rectPos(2) + rectPos(4) + 5; % Top-left corner y position
    
    % Calculate font size based on the height of the rectangle
    fontSize = round(rectPos(4) * 80); % Adjust multiplier as needed
    if fontSize < 8
        fontSize = 8; % Minimum font size to prevent being too small
    elseif fontSize > 16
        fontSize = 16; % Maximum font size to prevent being too large
    end
    
    % Update text properties
    set(textHandle, 'Position', [xPos, yPos, 0], ...
                    'FontSize', fontSize);
end

% Delete Foreground callback
function deleteForeground(imageProp)
    imageProp.setProperty('foregroundHandle', []);
    imageProp.setProperty('p_FG2D', []);
    % Set the text label to an empty string if it exists
    if ~isempty(imageProp.textHandle)
        if isvalid(imageProp.textHandle)
        set(imageProp.textHandle, 'String', '');
        end
    end
    % disable Delete Foreground
    set(findobj('Tag', 'Delete Foreground'), 'Enable', 'off');
end

% Utility function to convert rectangle position to corners
function Corners = RectanglePositionToCorners(Position)
    Corners = [Position(1), Position(2);  % Top-left
               Position(1) + Position(3), Position(2);  % Top-right
               Position(1) + Position(3), Position(2) + Position(4);  % Bottom-right
               Position(1), Position(2) + Position(4)]; % Bottom-left
end

% Function to draw vanishing lines
function lineHandles = drawLines(axHandle, imageProp)
    % Clear previous lines
    delete(findobj(axHandle, 'Type', 'line', 'Color', 'm'));

    intersectionPoints = [imageProp.p_2D(9,:); imageProp.p_2D(10,:); imageProp.p_2D(6,:); imageProp.p_2D(5,:)];
    vanishingPoint = imageProp.vanishingPoint;
    rectangleCorners = imageProp.rectangleCorners;

    hold(axHandle, 'on');
    lineHandles = gobjects(size(rectangleCorners, 1), 1);

    for j = 1:size(rectangleCorners, 1)
        lineHandles(j) = line(axHandle, [vanishingPoint(1), intersectionPoints(j, 1)], ...
                              [vanishingPoint(2), intersectionPoints(j, 2)], ...
                              'Color', 'm', 'LineWidth', 2);
    end

    hold(axHandle, 'off');
end


% Delete Rotation and set origin_img without Rotation
function deleteRotation(imageProp)
    % Check if rotatedHandl exists, if so, show origin_img
    if ~isempty(imageProp.getProperty('rotatedHandle'))
        origImg = imageProp.getProperty('origImg');
        imshow(origImg, 'Parent', imageProp.hAxes);
        imageProp.setProperty('rotatedHandle', []);
        set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'on');
    end
    % change instruction text
    set(imageProp.instructionTextHandle, 'String', 'Select background rectangle and rotate the image if needed');
    set(findobj('Tag', 'Create 3D Image'), 'Enable', 'off');
end

% Rotate Image via drawn line, if pressed again, previous line will be
% deleted
function rotateImage(imageProp)
    % disable buttons to avoid clicking them simultaneously 
    set(findobj('Tag', 'Select Rectangle'), 'Enable', 'off');
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'off');
    img = imageProp.getProperty('origImg');
    % Draw interactive line
    h = drawline(imageProp.hAxes, 'Color', 'red', 'LineWidth', 2);
    % wait(h);
    % Coordinates of the line
    pos = h.Position;
    x1 = pos(1,1);
    y1 = pos(1,2);
    x2 = pos(2,1);
    y2 = pos(2,2);
    % Calculate angle
    dy = y2-y1;
    dx = x2-x1;
    % Calculate Slope of the line
    slope = dy/dx;
    angle_rad = atan2(dy,dx); % in radians
    angle_deg = rad2deg(angle_rad); % in degree

    % Use slope and angle to determinate rotating angle
    if slope < 0
        %variable = 'negativ'; 
        if angle_deg < 0
            angle_deg = 90 - abs(angle_deg);
        else
            angle_deg = abs(angle_deg) - 90;
        end
    else
        %variable = 'positiv';
        if angle_deg < 0
            angle_deg = - (abs(angle_deg) - 90);
        else
            angle_deg = - (90 - angle_deg);
        end
    end
    
    rotated_img = imrotate(img, angle_deg, 'bilinear', 'crop');
    delete(h)
    imshow(rotated_img, 'Parent', imageProp.hAxes);
    imageProp.setProperty('rotatedHandle', rotated_img);
    imageProp.setProperty('rotatelineHandle', h);
    % Enable and disable buttons to avoid problems and guide the user
    set(findobj('Tag', 'Rotate Image (optional)'), 'Enable', 'off');
    set(findobj('Tag', 'Select Rectangle'), 'Enable', 'on');
    set(findobj('Tag', 'Delete Rotation'), 'Enable', 'on');
    set(findobj('Tag', 'Select Vanishing Points'), 'Enable', 'on');
end