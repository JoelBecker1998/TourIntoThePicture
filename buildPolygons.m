function planesCorners = buildPolygons(imageProp, p)
    % Initialize the output matrix to hold corners of all 5 planes
    % Each plane will have 4 corners, and we have 5 planes

    planesCorners = zeros(5, 5, 2);  % 5 planes, each with 4 points (x, y)

    planesCorners(1,:,:) = [p(7,:); p(8,:);  p(2,:); p(1,:); p(7,:)];
    planesCorners(2,:,:) = [p(9,:); p(10,:); p(8,:); p(7,:); p(9,:)];
    planesCorners(3,:,:) = [p(8,:); p(12,:); p(4,:); p(2,:); p(8,:)];
    planesCorners(4,:,:) = [p(1,:); p(2,:);  p(6,:); p(5,:); p(1,:)];
    planesCorners(5,:,:) = [p(11,:); p(7,:); p(1,:); p(3,:); p(11,:)];

    if imageProp.debug
        plotPolygonsInOriginalImage(planesCorners);
    end
end

function plotPolygonsInOriginalImage(planesCorners)
    figure;
    hold on;
    for i = 1:5
        planesCorners(i,5,:) = planesCorners(i,1,:);
        plot(planesCorners(i, :, 1), planesCorners(i, :, 2));
        set ( gca, 'ydir', 'reverse' ) % we need a reverse x axis for reasons idk
    end
    hold off;
end
