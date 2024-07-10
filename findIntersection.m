function [x, y] = findIntersection(p1, p2, p3, p4)

    x1 = p1(1);
    x2 = p2(1);
    x3 = p3(1);
    x4 = p4(1);

    y1 = p1(2);
    y2 = p2(2);
    y3 = p3(2);
    y4 = p4(2);


    m1 = (y2 - y1) / (x2 - x1);
    b1 = y1 - m1 * x1;
    
    m2 = (y4 - y3) / (x4 - x3);
    b2 = y3 - m2 * x3;

    x = 0;
    y = 0;

    if isnan(m1) || isinf(m1)
        x = x1;
        y = m2*x + b2;
    elseif isnan(m2) || isinf(m2)
        x = x3;
        y = m1*x + b1;
    elseif m1 == m2
        title('Lines are parallel, no intersection');
    else
        % Calculate intersection point
        intersectionX = (b2 - b1) / (m1 - m2);
        intersectionY = m1 * intersectionX + b1;

        x = intersectionX;
        y = intersectionY;
    end
    
end
