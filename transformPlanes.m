
function transformedImages = transformPlanes(origImg, planesCorners, p_3D)
    % origImg: original Image
    % planesCorners: Nx5x2 matrix containing all corners of all planes
    % 

    elements = size(planesCorners, 1);

    transformedImages = cell(elements);   

    for i = 1:elements

        output_points = calculateOutputPoints(i, p_3D);
        currentCorners = squeeze(planesCorners(i, :, :));
 
        % Define the border width
        borderWidth = 100;
        
        % Pad the original image with zeros
        paddedImg = padarray(origImg, [borderWidth borderWidth], 0, 'both');
        
        % Update the polygon coordinates by adding the border width
        updatedCorners = currentCorners + borderWidth;
        
        % Create binary mask using roipoly on the padded image
        [mask, ~, ~] = roipoly(paddedImg, updatedCorners(:,1), updatedCorners(:,2));
        
        % Initialize maskedImg with zeros with the same class as paddedImg
        maskedImg = paddedImg;
        maskedImg(repmat(~mask, [1 1 size(paddedImg, 3)])) = 0;
        
        % Define input and output image corners to stretch the mask region
        input_points = [updatedCorners(1:4,1) updatedCorners(1:4,2)];
        
        % Calculate projective transformation from masked region to full image size
        tform = fitgeotform2d(input_points, output_points, 'projective');
        
        % Apply the transformation
        transformed_img = imwarp(maskedImg, tform, 'OutputView', imref2d(size(paddedImg)));

        minX = min(output_points(:, 1));
        maxX = max(output_points(:, 1));
        minY = min(output_points(:, 2));
        maxY = max(output_points(:, 2));

        % Ensure indices are valid integers within image bounds (always
        % remove 1 pixel so we don't have a black border
        minX = max(1, floor(minX)) + 1;
        maxX = min(size(transformed_img, 2), ceil(maxX)) -1;
        minY = max(1, floor(minY)) + 1;
        maxY = min(size(transformed_img, 1), ceil(maxY)) -1;
        transformed_img = transformed_img(minY:maxY, minX:maxX, :);

        transformedImages{i} = transformed_img;

        if 0
            figure;
            disp(size(transformed_img));
            % Display the transformed image
            subplot(1, elements, i);
            imshow(transformed_img);
            axis image;  % Maintain the correct aspect ratio
            axis tight;  % Fit the axes tightly around the image
            hold on;
            title(sprintf('%d', i));
        end
    end
end



