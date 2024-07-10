function create3DImage(~, imageProp, hAxes_newPlotCube, hAxes_newPlotStreetView)
    % Create a 3D image from the 2D image and user-defined points

    p_2D = imageProp.getProperty('p_2D');

    % Check if a rotated image is available and not empty
    %if isprop(imageProp, 'rotatedHandle') && ~isempty(imageProp.rotatedHandle)
    %    origImg = imageProp.getProperty('rotatedHandle');
    %end
    
    % if there are vantage lines for a second VP point, handle it
    % seperately.
    if ~isempty(imageProp.intersectionPoint2)
        p_2D = handleVanishingLines(p_2D, imageProp);
        imageProp.setProperty('p_2D', p_2D);
    end

    % Build polygons and calculate 3D points
    planesCorners = buildPolygons(imageProp, p_2D);

    % Calculate 3D depth points
    p_3D = get3DPoints(imageProp.p_2D, imageProp.fov, imageProp.imgSize);
    imageProp.setProperty('p_3D', p_3D);

    % Handle foreground objects
    foregroundImg = processForeground(imageProp, p_2D, p_3D, planesCorners, imageProp.origImg);

    % Transform planes and build 3D space
    transformedImages = transformPlanes(imageProp.noForegroundImg, planesCorners, p_3D);

    % Create Cube with outside view
    build3DSpace(imageProp, transformedImages, foregroundImg, false, hAxes_newPlotCube);

    % Create StreetView
    build3DSpace(imageProp, transformedImages, foregroundImg, true, hAxes_newPlotStreetView);
end




