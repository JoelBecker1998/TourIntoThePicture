function output_points = calculateOutputPoints(planeNr, p_3D)

    output_points = zeros(4,2);
    i = planeNr;
    planes = [7 8 2 1 ; 7 8 10 9 ; 8 12 4 2; 1 2 6 5; 7 11 3 1];
    
    % create correct plane for 2D projection
    if i==3 || i == 5 % all x coordinates equal (sides)
        p = zeros(4,2);
        for j = 1:4
            p(j, 1) = p_3D(planes(i, j), 3);
            p(j, 2) = p_3D(planes(i, j), 2);
        end
        output_points = [p(1,:); p(2,:); p(3,:); p(4,:)];
    end
    if i==2 || i == 4 % all y coordinates equal (top and bottom)
        p = zeros(4,2);
        for j = 1:4
            p(j, 1) = p_3D(planes(i, j), 1);
            p(j, 2) = p_3D(planes(i, j), 3);
        end
        output_points = [p(1,:); p(2,:); p(3,:); p(4,:)];
    end
    if i==1 % all z coordinates equal (backwall)
        p = zeros(4,2);
        for j = 1:4
            p(j, 1) = p_3D(planes(i, j), 1);
            p(j, 2) = p_3D(planes(i, j), 2);
        end
        output_points = [p(1,:); p(2,:); p(3,:); p(4,:)];
    end

    if output_points == zeros(4,2)
        warning('No valid 3D points found');
    end
end