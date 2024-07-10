function foregroundImg = processForeground(imageProp, p_2D, p_3D, planesCorners, img)
    foregroundImg = {};
    imageProp.setProperty('p_FG3D', []);
    
    if ~isempty(imageProp.p_FG2D)

        % do the same for all foreground objects
        for i = 1:length(imageProp.p_FG2D)
            
            % calculate the 3D points of FG objects
            p_FG3D = getFG3DPoints(p_2D, imageProp.p_FG2D{i}, p_3D, planesCorners);

            % cutout these parts from the original image, and save them
            % seperately
            [img, foregroundImg{i}] = cutoutFGPoints(img, imageProp.p_FG2D{i}, imageProp.objectDet);
            imageProp.append('p_FG3D', p_FG3D);
        end
    end

    imageProp.setProperty('noForegroundImg', img);
end


function [newImg, foregroundImg] = cutoutFGPoints(img, p_FG2D, doAutoCutout)
    % Cut out the foreground from the image and fill the resulting hole

    corners = round([p_FG2D(1,:); p_FG2D(2,:); p_FG2D(3,:); p_FG2D(4,:)]);

    % Get image dimensions
    [imgHeight, imgWidth, ~] = size(img);

    % Ensure corners are within image boundaries
    corners(1,1) = max(1, min(imgWidth, corners(1,1)));
    corners(1,2) = max(1, min(imgHeight, corners(1,2)));
    corners(3,1) = max(1, min(imgWidth, corners(3,1)));
    corners(3,2) = max(1, min(imgHeight, corners(3,2)));

    mask = false(imgHeight, imgWidth);
    mask(corners(1,2):corners(3,2), corners(1,1):corners(3,1)) = true;

    if doAutoCutout
        [corners, img_rgba, mask] = autoFGCutout(img, mask);
        corners = round(corners);
        foregroundImg = img_rgba(corners(1,2):corners(3,2), corners(1,1):corners(3,1), :);
    else
        foregroundImg = img(corners(1,2):corners(3,2), corners(1,1):corners(3,1), :);

        % Create mask and fill the hole with region fill
        mask = false(imgHeight, imgWidth);
        mask(corners(1,2):corners(3,2), corners(1,1):corners(3,1)) = true;
    end

    filledImg = img;
    for channel = 1:3
        filledImg(:,:,channel) = regionfill(img(:,:,channel), mask);
    end
    newImg = filledImg;
end

function [corners, img_rgba, mask] = autoFGCutout(img, mask)

    % Get image dimensions
    [imgHeight, imgWidth, ~] = size(img);

    refinedMask = refine_mask(mask);
    cc = bwconncomp(refinedMask);
    props = regionprops(cc, 'BoundingBox', 'Image');

    % Find the index of the prop with the largest bounding box
    [~, largestIdx] = max(cellfun(@(x) prod(x(3:4)), {props.BoundingBox}));
    
    objectImage = imcrop(img, props(largestIdx).BoundingBox);
    
    % Convert to grayscale for processing
    grayImage = rgb2gray(objectImage);
    
    % Initialize the snake close to the object's edges
    croppedMask = activecontour(grayImage, ones(size(grayImage)), 300, 'Chan-Vese');
    
    xOffset = round(props(largestIdx).BoundingBox(1));
    yOffset = round(props(largestIdx).BoundingBox(2));

    rows = yOffset:yOffset+size(croppedMask, 1)-1;
    cols = xOffset:xOffset+size(croppedMask, 2)-1;
    
    % Check bounds to avoid indexing errors
    if rows(end) > size(mask, 1)
        rows = rows(1):size(mask, 1);
    end
    if cols(end) > size(mask, 2)
        cols = cols(1):size(mask, 2);
    end
    
    mask(rows, cols) = croppedMask;
        
    % Apply the refined mask to extract the object
    %extractedObject = objectImage;
    %extractedObject(repmat(~mask, [1, 1, 3])) = 0;
    % Create RGBA image
    img_rgba = CreateRGBAImage(img, mask);

    % Calculate the corners from the bounding box
    bbox = props(largestIdx).BoundingBox;
    corners = zeros(4,2); % Initialize to store the corners
    corners(1,:) = bbox(1:2); % Top-left corner
    corners(2,:) = [bbox(1) + bbox(3), bbox(2)]; % Top-right corner
    corners(3,:) = [bbox(1) + bbox(3), bbox(2) + bbox(4)]; % Bottom-right corner
    corners(4,:) = [bbox(1), bbox(2) + bbox(4)]; % Bottom-left corner
        
    corners = round(corners);

    % Ensure corners are within image boundaries
    corners(1,1) = max(1, min(imgWidth, corners(1,1)));
    corners(1,2) = max(1, min(imgHeight, corners(1,2)));
    corners(3,1) = max(1, min(imgWidth, corners(3,1)));
    corners(3,2) = max(1, min(imgHeight, corners(3,2)));
end 

function img_rgba = CreateRGBAImage(objectImage, mask)
    % Initialize RGBA image
    img_rgba = zeros(size(objectImage, 1), size(objectImage, 2), 4, 'uint8');
    
    % Assign RGB channels
    img_rgba(:, :, 1:3) = objectImage;
    
    % Assign alpha channel based on mask
    img_rgba(:, :, 4) = uint8(mask * 255); % Alpha channel ranges from 0 (transparent) to 255 (opaque)
end

function refinedMask = refine_mask(initialMask)
    % Enhance mask using adaptive morphological operations
    mask = imclose(initialMask, strel('disk', 10));
    mask = imopen(mask, strel('disk', 10));
    iterations = 0;
    changed = true;
    
    while changed && iterations < 10 % Limit the number of iterations
        prevMask = mask;
        mask = imclose(mask, strel('disk', 1)); % Closing small gaps
        mask = imopen(mask, strel('disk', 1)); % Removing small noise
        changed = ~isequal(mask, prevMask);
        iterations = iterations + 1;
    end
    refinedMask = mask;
end


function p_FG3D = getFG3DPoints(p_2D, p_FG2D, p_3D, planesCorners)
    % Calculate 3D points for foreground objects

    borderWidth = 100;
    planeReferenceFG = 4; % floor

    % Calculate transformation to determine the points on the floor. This
    % is done so that we know where to put the FG in the 3D space
    output_points = calculateOutputPoints(planeReferenceFG, p_3D);
    currentCorners = squeeze(planesCorners(planeReferenceFG, :, :)) + borderWidth;
    input_points = [currentCorners(1:4,1) currentCorners(1:4,2)];
    tform = fitgeotform2d(input_points, output_points, 'projective');

    % Transform points
    p_FG3D = transformForegroundPoints(p_FG2D, p_2D, p_3D, tform, borderWidth);
 
end


function p_FG3D = transformForegroundPoints(p_FG2D, p_2D, p_3D, tform, borderWidth)

    % These are the points we are interested in where they end up after the
    % transformation

    % the Foreground must be at the bottom image, otherwise it is behind
    % the background. Worst case there will be no Foreground as it is
    % exactly one pixel in front of the backwall
    p_FG2D(3,2) = max(p_FG2D(3,2), p_2D(1,2)+1);
    p_FG2D(4,2) = max(p_FG2D(4,2), p_2D(1,2)+1);


    xdata = [p_FG2D(4,1), p_FG2D(3,1), p_2D(1,1), p_2D(6,1)] + borderWidth;
    ydata = [p_FG2D(4,2), p_FG2D(3,2), p_2D(1,2), p_2D(6,2)] + borderWidth;

    % do the image transform
    [xdataT, ydataT] = transformPointsForward(tform, xdata, ydata);

    % the coordinates are important for x and z
    p_FG3D = zeros(4, 3);
    p_FG3D(:,1) = [xdataT(1), xdataT(2), xdataT(2), xdataT(1)];
    p_FG3D(:,3) = [ydataT(1), ydataT(1), ydataT(1), ydataT(1)];

    ScalingFactor = mean(xdataT(1:2)./xdata(1:2));

    % Adjust height of object accordingly to how we adjusted width.
    SpaceYHeight = mean(p_3D(5:6, 2));
    foregroundHeight = (p_FG2D(3,2) - p_FG2D(1,2)) * ScalingFactor;
    p_FG3D(:,2) = [SpaceYHeight-foregroundHeight; SpaceYHeight-foregroundHeight; SpaceYHeight; SpaceYHeight];
end