% function for reading in 3d PET in Mayo clinic (.hdr/.img) format
% returns a 4d matrix

function m = PET_to_matrix

    myDir = uigetdir; %gets directory
    myHdrs = dir(fullfile(myDir,'*.hdr')); %gets all .hdr files in struct
    myImgs = dir(fullfile(myDir, '*.img')); %gets all .img files in struct
    m = zeros(128,128,63,20);
    
    for k = 1:length(myHdrs)
        baseHdrName = myHdrs(k).name;
        fullHdrName = fullfile(myDir, baseHdrName);
        baseImgName = myImgs(k).name;
        fullImgName = fullfile(myDir, baseImgName);
        fprintf(1, 'Now reading %s\n', fullHdrName);
        h = read_headerfile(fullHdrName);
        i = read_imagefile(fullImgName, h);
        m(:,:,:,k) = i;    
    end

end