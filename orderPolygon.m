function orderedPolygon = orderPolygon(polygon)
    % polygon: Nx2 matrix containing [x, y] coordinates of the corners of a
    % polygon
    % orderedPolygon: Nx2 matrix containing [x, y] coordinates of a
    % polygon, ordered clockwise, starting at left top.
    
    % Calculate the centroid (average of all points)
    centroid = mean(polygon);
    
    % Calculate angles of each point with respect to the centroid
    angles = atan2(polygon(:,2) - centroid(2), polygon(:,1) - centroid(1));
    
    % Find the index of the top-left point
    [~, topLeftIndex] = min(polygon(:,1) + polygon(:,2));
    
    % Shift angles so that the top-left point is at the start
    shiftedAngles = circshift(angles, -topLeftIndex + 1);
    shiftedPolygon = circshift(polygon, -topLeftIndex + 1, 1);
    
    % Sort points by angle
    [~, sortIdx] = sort(shiftedAngles);
    orderedPolygon = shiftedPolygon(sortIdx, :);
end
