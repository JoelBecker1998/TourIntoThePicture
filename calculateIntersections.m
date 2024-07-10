
function calculateIntersections(imageProp)

    vp = imageProp.vanishingPoint;
    rectangleCorners = imageProp.rectangleCorners;

    p = zeros(12, 2);
    p(7,:) = rectangleCorners(1,:);
    p(8,:) = rectangleCorners(2,:);
    p(2,:) = rectangleCorners(3,:);
    p(1,:) = rectangleCorners(4,:);


    imgTL = [0 0];
    imgTR = [imageProp.imgSize(2) 0];
    imgBR = [imageProp.imgSize(2) imageProp.imgSize(1)];
    imgBL = [0 imageProp.imgSize(1)];
 
    % find all intersection points
    [p(3,1), p(3,2)]   = findIntersection(vp, p(1,:), imgTL, imgBL);
    [p(4,1), p(4,2)]   = findIntersection(vp, p(2,:), imgTR, imgBR);
    [p(5,1), p(5,2)]   = findIntersection(vp, p(1,:), imgBL, imgBR);
    [p(6,1), p(6,2)]   = findIntersection(vp, p(2,:), imgBL, imgBR);
    [p(9,1), p(9,2)]   = findIntersection(vp, p(7,:), imgTR, imgTL);
    [p(10,1), p(10,2)] = findIntersection(vp, p(8,:), imgTR, imgTL);
    [p(11,1), p(11,2)] = findIntersection(vp, p(7,:), imgTL, imgBL);
    [p(12,1), p(12,2)] = findIntersection(vp, p(8,:), imgTR, imgBR);

     imageProp.p_2D = p(:,:);

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

