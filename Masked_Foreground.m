% Read the image
img = imread('C:\Users\alyba\OneDrive\Desktop\uhren-turm.jpg');
%img = imread('C:\Users\alyba\OneDrive\Desktop\oil-painting.png');
%img = imread('C:\Users\alyba\OneDrive\Desktop\simple-room.png');

% Convert to Lab color space for better luminance and color separation
labImg = rgb2lab(img);

% Extract L, a, and b channels
L = labImg(:,:,1);  % Luminance channel
a = labImg(:,:,2);  % a channel (green-red)
b = labImg(:,:,3);  % b channel (blue-yellow)

% Adaptive thresholding on Luminance to better cope with different light conditions
levelL = graythresh(L); % Otsu's method to find optimal threshold
Lmask = imbinarize(L, levelL);

% Color thresholds in a-b color space
% These ranges are selected based on the common color of the foreground
aRange = [-20, 20]; % Adjust these based on your foreground color
bRange = [-20, 20];

% Create binary masks based on color thresholds in a-b space
aMask = (a >= aRange(1)) & (a <= aRange(2));
bMask = (b >= bRange(1)) & (b <= bRange(2));

% Combine masks: Luminance and color masks
combinedMask = Lmask & aMask & bMask;

% Morphological operations to refine the mask
seClose = strel('disk', 10);
seOpen = strel('disk', 3);
cleanMask = imclose(combinedMask, seClose);
cleanMask = imopen(cleanMask, seOpen);  % Removes small objects
cleanMask = imfill(cleanMask, 'holes');  % Fill holes in the objects

% Edge enhancement using a high-pass filter or edge detection
edges = edge(L, 'Canny', [], 1);  % Increase sensitivity by reducing the threshold
edgeDilated = imdilate(edges, strel('disk', 2));
finalMask = cleanMask & edgeDilated;  % Incorporate edges to refine the mask

% Display the original and masked images
subplot(1, 2, 1), imshow(img), title('Original Image');
subplot(1, 2, 2), imshow(finalMask), title('Refined Foreground Mask');

% Apply the refined mask to the original image
maskedImg = img;
maskedImg(repmat(~finalMask, [1 1 3])) = 0;
figure, imshow(maskedImg), title('Masked Foreground Objects');