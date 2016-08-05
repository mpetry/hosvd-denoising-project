clc

original = PET_to_matrix;

% computing PSNR and hosvd/reconstruction of a matrix

[ x, y, z, frames ] = size(original);

% decompose the video using higher order singular value decomposition
[ S, U, sv, tol ] = hosvd(original);

%initialize arrays to store MSE, singular values chosen, PSNR
dispMSE = []; 
numSVals = [];
dispPSNR = [];

% try different levels of compression
for N=(5:10:x) 
    % store the singular values in a temporary var
    C = S;
    
    % discard the diagonal values not required for compression
    C(N+1:end,:,:,:)=0;
    C(:,N+1:end,:,:)=0;
    C(:,:,N+1:end,:)=0;
    C(:,:,:,N+1:end)=0;

    % Construct an Image using the selected singular values
    D = tprod(C, U);
    
    % read images in a cell array
    imgs = cell(frames,1);
    for i=1:frames
        imgs{i} = uint8(D(:,:,i));
    end
    
    % show them in subplots
    % figure;
    % buffer = sprintf('Video output using %d singular values', N);
    % title(buffer);
    % for i=1:frames
    %     subplot(3,3,i);
    %     h = imshow(imgs{i}, 'InitialMag',100, 'Border','tight');
    %     title(num2str(i))
    %     set(h, 'ButtonDownFcn',{@callback,i})
    % end
    
    % calculate MSE and PSNR
    MSError= sqrt(mean(mean(mean(mean((original-D).^2)))));
    norm = sqrt(mean(mean(mean(mean((original).^2)))));
    PSNR = -10*log10((MSError)/(255*255));
        
    % store vals for display
    dispMSE = [dispMSE; MSError];
    numSVals = [numSVals; N];
    dispPSNR = [dispPSNR; PSNR];

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
ylabel('PSNR between denoised and original image');

% display original images

% imgs = cell(frames,1);
%     for i=1:frames
%        imgs{i} = uint8(x(:,:,i));
%     end
    
% figure;
%     buffer = sprintf('Video output using %d singular values', N);
%     title(buffer);
%     for i=1:frames
%         subplot(3,3,i);
%         h = imshow(imgs{i}, 'InitialMag',100, 'Border','tight');
%         title(num2str(i))
%         set(h, 'ButtonDownFcn',{@callback,i})
%     end