clc

% reading and converting video
% v = VideoReader('CMR_infarct_cine.mp4');

% get details
% nFrames = v.NumberOfFrames;
% vidHeight = v.Height;
% vidWidth = v.Width;

% define colormap
% map = [(0:255)' (0:255)' (0:255)']/255;

% preallocate movie structure.
% mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 'uint8'),'colormap', map);

% read one frame at a time.
% for k = 1 : nFrames
%      mov(k).cdata = rgb2gray(read(v, k));
% end

%preallocate matrix
% frames = zeros(vidWidth,vidHeight,nFrames, 'uint8');

%populate frames matrix
% for i=1:nFrames
    frames(:,:,i) = mov(i).cdata;
end    

%add noise%
noisy = zeros(vidHeight, vidWidth, nFrames);
for i=1:nFrames
    noisy(:,:,i) = imnoise(frames(:,:,i), 'gaussian', 0, 0.01*i);
    imshow(frames(:,:,i))
end

%convert noised and un-noised videos to double
frames = double(frames); 
noisy = double(noisy);

% decompose the video using higher order singular value decomposition
[ S, U, sv, tol ] = hosvd(noisy);

%initialize arrays to store MSE, singular values chosen, PSNR, and PSNR for
%noised image
dispMSE = []; 
numSVals = [];
dispPSNR = [];
dispnoisyPSNR = [];

% try different levels of compression
for N=(5:10:vidHeight) 
    % store the singular values in a temporary var
    C = S;
    
    % discard the diagonal values not required for compression
    C(N+1:end,:,:)=0;
    C(:,N+1:end,:)=0;
    C(:,:,N+1:end)=0;

    % Construct an Image using the selected singular values
    D = tprod(C, U);
    
    % read images in a cell array
    imgs = cell(nFrames,1);
    for i=1:nFrames
        imgs{i} = uint8(D(:,:,i));
    end

    % show them in subplots
    figure;
    buffer = sprintf('Video output using %d singular values', N);
    title(buffer);
    for i=1:nFrames
        subplot(3,3,i);
        h = imshow(imgs{i}, 'InitialMag',100, 'Border','tight');
        title(num2str(i))
        set(h, 'ButtonDownFcn',{@callback,i})
    end
    
    % calculate MSE and PSNR
    MSError= sqrt(mean(mean(mean((frames-D).^2))));
    norm = sqrt(mean(mean(mean((frames).^2))));
    PSNR = -10*log10((MSError)/(255*255));
    noisyError = sqrt(mean(mean(mean((frames-noisy).^2))));
    noisyPSNR = -10*log10((noisyError)/(255*255));
    
    % store vals for display
    dispMSE = [dispMSE; MSError];
    numSVals = [numSVals; N];
    dispPSNR = [dispPSNR; PSNR];
    dispnoisyPSNR = [dispnoisyPSNR; noisyPSNR];
      
end

% display the MSE, PSNR and noisyPSNR graphs

figure; 
title('MSE in compression');
plot(numSVals, dispMSE);
grid on
xlabel('Number of Singular Values used');
ylabel('Error between compressed and original image');

figure;
title('PSNR in compression');
plot(numSVals, dispPSNR);
grid on
xlabel('Number of Singular Values used');
ylabel('PSNR between compressed and original image');

figure;
title('noisyPSNR in compression');
plot(numSVals, dispnoisyPSNR);
grid on
xlabel('Number of Singular Values used');
ylabel('PSNR between noisy and original image');

% display original images

imgs = cell(nFrames,1);
    for i=1:nFrames
        imgs{i} = uint8(frames(:,:,i));
    end
    
figure;
    buffer = sprintf('Video output using %d singular values', N);
    title(buffer);
    for i=1:nFrames
        subplot(3,3,i);
        h = imshow(imgs{i}, 'InitialMag',100, 'Border','tight');
        title(num2str(i))
        set(h, 'ButtonDownFcn',{@callback,i})
    end