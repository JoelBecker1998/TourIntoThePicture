function p_3D = get3DPoints(p_2D, fov, imgSize)
    
    p_3D = zeros(12, 3);
   
    %Let's assume a calibration matrix with f = 1
    FOV = deg2rad(fov);

    z = imgSize(2)/(2*tan(FOV/2));
    z = abs(z);

    %modify 7 and 8 to have the same x coordinate as 1 and 2, this is
    %needed if the background is a polygon (due to two vanishing lines), this is a local change only!
    a = p_2D(7,1);
    b = p_2D(8,1);

    p_2D(7,1) = p_2D(1,1);
    p_2D(8,1) = p_2D(2,1);


    for i = [1 2 7 8]
        p_3D(i,:) = [p_2D(i,:), 0];
    end

    for i = [3 4 9 10]
        p_3D(i,:) = [p_2D(i-2,:), 0];
    end

    for i = [5 6 11 12]
        p_3D(i,:) = [p_2D(i-4,:), 0];
    end

    p_2D(7,1) = a;
    p_2D(8,1) = b;

    lr1 = norm(p_2D(8, 2) - p_2D(2, 2));
    lr2 = norm(p_2D(12, 2) - p_2D(4, 2));

    factor_r = lr2/lr1;
    depth_r = abs(z/factor_r - z);

    ll1 = norm(p_2D(7, 2) - p_2D(1, 2));
    ll2 = norm(p_2D(11, 2) - p_2D(3, 2));

    factor_l = ll2/ll1;
    depth_l = abs(z/factor_l - z);

    lt1 = norm(p_2D(7, :) - p_2D(8, :));
    lt2 = norm(p_2D(9, :) - p_2D(10, :));

    factor_t = lt2/lt1;
    depth_t = abs(z/factor_t - z);

    lb1 = norm(p_2D(1, :) - p_2D(2, :));
    lb2 = norm(p_2D(5, :) - p_2D(6, :));

    factor_b = lb2/lb1;
    depth_b = abs(z/factor_b - z);

    p_3D(12,:) = [p_3D(12,1:2), depth_r];
    p_3D(4,:) =  [p_3D(4,1:2),  depth_r];
    p_3D(11,:) = [p_3D(11,1:2), depth_l];
    p_3D(3,:) = [p_3D(3,1:2), depth_l];
    p_3D(9,:) = [p_3D(9,1:2), depth_t];
    p_3D(10,:) = [p_3D(10,1:2), depth_t];
    p_3D(5,:) = [p_3D(5,1:2), depth_b];
    p_3D(6,:) = [p_3D(6,1:2), depth_b];

end