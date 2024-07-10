
function build3DSpace(imageProp, transformedImages, foregroundImg, enable_moving_viewpoint, hAxes)

    % this defines corner points of the planes
    planes = [7 8 2 1 ; 9 10 8 7 ; 8 12 4 2; 1 2 6 5; 11 7 1 3];

    %set axes to correct plot
    axes(hAxes);
    cla(hAxes);
    % disable for moving_viewpoint
    if enable_moving_viewpoint == false
        view(3);
    end

    hold on;
    axis equal;  % Ensure the scaling is even in all dimensions

    p_3D = imageProp.p_3D;

    numImages = 5;

    % Initialize variables to hold surface handles and normal vectors
    surfaces = gobjects(numImages, 1);
    surfaceNormals = zeros(numImages, 3);

    % Function to calculate surface normals
    calculateSurfaceNormals = @(X, Y, Z) cross([X(1,2)-X(1,1), Y(1,2)-Y(1,1), Z(1,2)-Z(1,1)], [X(2,1)-X(1,1), Y(2,1)-Y(1,1), Z(2,1)-Z(1,1)]) / 2;

    % build a cube with 5 sides that represent our 3D room
    for i = 1:numImages
        % Extract X, Y, Z coordinates of the corners
        X = [p_3D(planes(i, 1), 1), p_3D(planes(i, 2), 1); p_3D(planes(i, 4), 1), p_3D(planes(i, 3), 1)];
        Y = [p_3D(planes(i, 1), 2), p_3D(planes(i, 2), 2); p_3D(planes(i, 4), 2), p_3D(planes(i, 3), 2)];
        Z = [p_3D(planes(i, 1), 3), p_3D(planes(i, 2), 3); p_3D(planes(i, 4), 3), p_3D(planes(i, 3), 3)];

        % Calculate surface normal vector
        surfaceNormals(i, :) = calculateSurfaceNormals(X, Y, Z);

        % Plot the image on a 3D surface
        surfaces(i) = surf(X, Y, Z, 'CData', transformedImages{i}, 'FaceColor', 'texturemap');
    end

    % Function to update surface visibility based on view angle
    function updateSurfaceVisibility(~, ~)
        % Get the current view angle
        [az, el] = view;

        % Iterate over each surface and update visibility
        for j = 1:numImages
            % Check angle with surface normal
            cosAngle = dot(surfaceNormals(j, :), [sind(az)*cosd(el), cosd(az)*cosd(el), -sind(el)]) / norm(surfaceNormals(j, :));
            angle = acosd(cosAngle);

            % Adjust visibility based on angle
            if angle < 40
                surfaces(j).Visible = 'off';
            else
                surfaces(j).Visible = 'on';
            end
        end
    end

    % set FG objects inside our cube
    for i = 1:length(imageProp.p_FG3D)
        coord = imageProp.p_FG3D{i};
        X = [coord(1,1), coord(2,1) ; coord(4, 1), coord(3,1)];
        Y = [coord(1,2), coord(2,2) ; coord(4, 2), coord(3,2)];
        Z = [coord(1,3), coord(2,3) ; coord(4, 3), coord(3,3)];

        %surf(X, Y, Z, 'CData', foregroundImg{i}, 'FaceColor', 'texturemap');

        % Create the surface plot with RGB data
        h = surf(X, Y, Z, 'CData', foregroundImg{i}(:,:,1:3), 'FaceColor', 'texturemap');

        % Check if the image has an alpha channel
        if size(foregroundImg{i}, 3) == 4
            % Set transparency data from the alpha channel
            set(h, 'AlphaData', foregroundImg{i}(:,:,4), 'FaceAlpha', 'texturemap');
        end

    end

    % Only add the listener and update visibility if moving viewpoint is disabled
    if enable_moving_viewpoint == false
        % Set up listener for view change
        addlistener(gca, 'View', 'PostSet', @updateSurfaceVisibility);

        % Call update once to initialize visibility based on initial view
        updateSurfaceVisibility();
    end

    % Additional settings for axes and labels
    set(gca, 'xdir', 'reverse');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(180, 90);
    camproj('perspective');
    axis tight;

    hold off;

    % we need a reverse x axis (because technically z and y are inverted)
    set ( gca, 'xdir', 'reverse' )

    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    % 3D-Rekonstruktion:
    if enable_moving_viewpoint == false
        camproj('perspective');
        axis tight;

        xticks('auto');
        yticks('auto');

        hold off;
    end

    % Moving_viewpoint
    if enable_moving_viewpoint == true
       moving_viewpoint(imageProp)
    end

end
