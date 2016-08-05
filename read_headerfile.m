% Primarily a C code made by (see website below or check the ANALYZE75.pdf file
% in this same directory)
%   ANALYZE(TM) Header File format
% 	(c) Copyright, 1986-1995 
% 	Biomedical Imaging Resource
% 	Mayo Foundation
%   WEBSITE: http://www.mayo.edu/bir/PDF/ANALYZE75.pdf
% The code below for matlab was made by Roman and has been customised
% as per the needs of the Neuroscience Dept-NYSPI.
% Date: 09/12/2002
% ===============================================================================
% This routine reads binary data from a header file i.e with extension '.hdr'
% and outputs its various fieldnames with their corresponding values to the structure
% array 'hdr'
function hdr=read_headerfile(filename)

% Ensuring that the hdr-FILE is 348 bytes long
fproperties=dir(filename);
rbytes=348;
if fproperties.bytes ~= rbytes
    error('BRAINFIT:insufficientData',...
          [filename,' has ',num2str(fproperties.bytes),' but should have ',num2str(rbytes),' bytes']) 
end

% fid=fopen(filename,'r'); % opens file for reading in the binary data
% % Matlab		C		    Bytes
% % 'int16'		short int	2
% % 'int32'		int		    4
% % 'char'		char		1
try
    fid=fopen(filename,'r','b'); % opens file for reading in the binary data
    % struct header_key:						/* header key   */
    %					                        % Element #	                  	/* off + size      */
    hdr.sizeof_hdr = fread(fid,1,'int32');	    % 1		int sizeof_hdr			/* 0 + 4           */
    if hdr.sizeof_hdr==348
    else
        error('BRAINFIT:insufficientData',['Error: ' num2str(hdr.sizeof_hdr)]);
    end
    hdr.machineformat='b';%IEEE floating point with little-endian byte ordering
catch
    fid=fopen(filename,'r','l'); % opens file for reading in the binary data
    hdr.sizeof_hdr = fread(fid,1,'int32');	    % 1		int sizeof_hdr			/* 0 + 4           */    
    hdr.machineformat='l';%IEEE floating point with big-endian byte ordering
end

% struct header_key:						/* header key   */
%					                        % Element #	                  	/* off + size      */
% hdr.sizeof_hdr = fread(fid,1,'int32');	    % 1		int sizeof_hdr			/* 0 + 4           */
hdr.data_type = fgets(fid,10);			    % 2		char data_type[10];		/* 4 + 10          */
hdr.db_name = fgets(fid,18);			    % 12	char db_name[18];		/* 14 + 18         */
hdr.extents = fread(fid,1,'int32');		    % 30	int extents;			/* 32 + 4          */
hdr.session_error = fread(fid,1,'int16');   % 31	short int session_error;/* 36 + 2          */
hdr.regular = fgets(fid,1);			        % 32	char regular;			/* 38 + 1          */
hdr.hkey_un0 = fgets(fid,1);			    % 33	char hkey_un0;			/* 39 + 1          */
%									                                        /* total=40 bytes  */
% struct image_dimension:
hdr.dim = fread(fid,8,'int16');			    % 34    short int dim[8];		/* 0 + 16          */
%								                    short int unused8;		/* 16 + 2          */
%								                    short int unused9;		/* 18 + 2          */
%								                    short int unused10;	    /* 20 + 2          */
%								                    short int unused11;	    /* 22 + 2          */
%								                    short int unused12;	    /* 24 + 2          */
%								                    short int unused13;	    /* 26 + 2          */
%								                    short int unused14;	    /* 28 + 2          */
hdr.vox_units = fgets(fid,4);			    % 42
hdr.cal_units = fgets(fid,8);			    % 46
hdr.unused1 = fread(fid,1,'int16');		    % 54
hdr.datatype = fread(fid,1,'int16');		% 55	short int datatype;		/* 30 + 2          */
hdr.bitpix = fread(fid,1,'int16');		    % 56	short int bitpix;		/* 32 + 2          */
hdr.dim_un0 = fread(fid,1,'int16');		    % 57	short int dim_un0;		/* 34 + 2          */
hdr.pixdim = fread(fid,8,'float32');		% 58	float pixdim[8];		/* 36 + 32         */
%                                                   there are 8 elements
hdr.vox_offset = fread(fid,1,'float32');	% 66	float vox_offset;		/* 68 + 4          */
hdr.funused1 = fread(fid,1,'float32');		% 67	float funused1;			/* 72 + 4          */
hdr.funused2 = fread(fid,1,'float32');		% 68	float funused2;			/* 76 + 4          */
hdr.funused3 = fread(fid,1,'float32');		% 69	float funused3;			/* 80 + 4          */
hdr.cal_max = fread(fid,1,'float32');		% 70	float cal_max;			/* 84 + 4          */
hdr.cal_min = fread(fid,1,'float32');		% 71	float cal_min;			/* 88 + 4          */
hdr.compressed = fread(fid,1,'int32');		% 72	float compressed;		/* 92 + 4          */
hdr.verified = fread(fid,1,'int32');		% 73	float verified;			/* 96 + 4          */
hdr.glmax = fread(fid,1,'int32');		    % 74	int glmax,glmin;		/* 100 + 8         */
hdr.glmin = fread(fid,1,'int32');		    % 75
%												                            /* total=108 bytes */
% struct data_history:      
hdr.descrip = fgets(fid,80);			    % 76	char descrip[80];		/* 0 + 80          */
hdr.aux_file = fgets(fid,24);			    %156	char aux_file[24];		/* 80 + 24         */
hdr.orient = fgets(fid,1);			        %180	char orient;			/* 104 + 1         */
hdr.originator = fgets(fid,10);			    %181	char originator[10];	/* 105 + 10        */
hdr.generated = fgets(fid,10);			    %191	char generated[10];		/* 115 + 10        */
hdr.scannum = fgets(fid,10);			    %201	char scannum[10];		/* 125 + 10        */
hdr.patient_id = fgets(fid,10);			    %211	char patient_id[10];	/* 135 + 10        */
hdr.exp_date = fgets(fid,10);			    %221	char exp_date[10];		/* 145 + 10        */
hdr.exp_time = fgets(fid,10);			    %231	char exp_time[10];		/* 155 + 10        */
hdr.hist_un0 = fgets(fid,3);			    %241	char hist_un0[3];		/* 165 + 3         */
hdr.views = fread(fid,1,'int32');		    %244	int views			    /* 168 + 4         */
hdr.vols_added = fread(fid,1,'int32');		%245	int vols_added;			/* 172 + 4         */
hdr.start_field = fread(fid,1,'int32');		%246	int start_field;		/* 176 + 4         */
hdr.field_skip = fread(fid,1,'int32');		%247	int field_skip;			/* 180 + 4         */
hdr.omax = fread(fid,1,'int32');		    %248	int omax, omin;			/* 184 + 8         */
hdr.omin = fread(fid,1,'int32');		    %249		
hdr.smax = fread(fid,1,'int32');		    %250	int smax, smin;			/* 192 + 8         */
hdr.smin = fread(fid,1,'int32');		    %251
%												                            /* total=200 bytes */
%struct dsr
%{
%   struct header_key hk;                                                   /* 0 + 40          */
%   struct image_dimension dime;                                            /* 40 + 108        */
%   struct data_history hist;                                               /* 148 + 200       */
%                                                                           /* total= 348 bytes*/
%}
hdr.scale_factor = hdr.funused1;
fclose(fid); % closes file incl. messages