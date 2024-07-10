function p_2D = handleVanishingLines(p_2D, imageProp)
    vp =imageProp.vanishingPoint;
    intPoint = imageProp.intersectionPoint2;

    imgTL = [0 0];
    imgTR = [imageProp.imgSize(2) 0];
    imgBR = [imageProp.imgSize(2) imageProp.imgSize(1)];
    imgBL = [0 imageProp.imgSize(1)];

    p = p_2D;

    %adjust points based on the second interception point

    [p(3,1), p(3,2)]   = findIntersection(vp, p(1,:), imgTL, intPoint);
    [p(4,1), p(4,2)]   = findIntersection(vp, p(2,:), imgTR, intPoint);
    [p(5,1), p(5,2)] = findIntersection(vp, p(1,:), imgBL, imgBR);
    [p(6,1), p(6,2)] = findIntersection(vp, p(2,:), imgBL, imgBR);
    [p(11,1), p(11,2)] = findIntersection(vp, p(7,:), p(3,:), intPoint);
    [p(12,1), p(12,2)] = findIntersection(vp, p(8,:), p(4,:), intPoint);
    [p(9,1), p(9,2)] = findIntersection(vp, p(11,:), imgTL, imgTR);
    [p(10,1), p(10,2)] = findIntersection(vp, p(12,:), imgTL, imgTR);    

    message = false;
    while p(4,1) < imageProp.imgSize(2) || p(3,1) > 0
        %This happens when the intersection is not on the bottom but rather at the top
        message = true;
        imgTL = [imgTL(1) + 10, imgTL(2)];
        imgTR = [imgTR(1) - 10, imgTR(2)];
        [p(3,1), p(3,2)]   = findIntersection(vp, p(1,:), imgTL, intPoint);
        [p(4,1), p(4,2)]   = findIntersection(vp, p(2,:), imgTR, intPoint);
        [p(11,1), p(11,2)] = findIntersection(vp, p(7,:), p(3,:), intPoint);
        [p(12,1), p(12,2)] = findIntersection(vp, p(8,:), p(4,:), intPoint);
        [p(9,1), p(9,2)] = findIntersection(vp, p(11,:), imgTL, imgTR);
        [p(10,1), p(10,2)] = findIntersection(vp, p(12,:), imgTL, imgTR);  
    end


    if message
        msgbox("Unfortunately, some vanishing lines don't cross where we would like. " + ...
        "The result may not be accurate. Sorry to disappoint :(")
        message = 0;
    end

    %modify top of background rectangle
    [p(7,1), p(7,2)] = findIntersection(intPoint, p(1,:), p_2D(7,:), p_2D(8,:));
    [p(8,1), p(8,2)] = findIntersection(intPoint, p(2,:), p_2D(7,:), p_2D(8,:));

    p_2D = p;

    if imageProp.debug
        figure;
        hold on;
        for i = 1:12
            scatter(p(i, 1), p(i, 2));
            text(p(i, 1), p(i, 2), string(i));
            set ( gca, 'ydir', 'reverse' ) % we need a reverse x axis for reasons idk
        end
        hold off;
    end
end
