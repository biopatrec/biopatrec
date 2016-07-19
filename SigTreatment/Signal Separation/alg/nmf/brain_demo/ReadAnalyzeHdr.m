function [pre,dim,siz,lim,scale,offset,origin,descr,endian]=ReadAnalyzeHdr(name);
% Reads the header of an analyze file
% 
%  [pre,dim,siz,lim[,scale[,offset[,origin[,descr[,endian]]]]]]=ReadAnalyzeHdr(name)
%  [pre,dim,siz,lim,scale,offset,origin,descr,endian]=ReadAnalyzeHdr(name)
%  [hdr]=ReadAnalyzeHdr(name)
%  
%  pre       - precision for voxels in bit
%                1 - 1 single bit
%                8 - 8 bit voxels (lim is used for deciding if signed or
%                     unsigned char, if min < 0 then signed))
%               16 - 16 bit integer (lim is used for deciding if signed or
%                     unsigned notation should be used, if min < 0 then signed))
%               32 - 32 bit floats
%               32i - 32 bit complex numbers (64 bit pr. voxel)
%               64 - 64 bit floats
%  dim       - x,y,z, no of pixels in each direction
%  siz       - voxel size in mm
%  lim       - max and min limits for pixel values
%  scale     - scaling of pixel values
%  offset    - offset in pixel values
%  origin    - origin for AC-PC plane (SPM notation)
%  descr     - Description from description field
%  endian    - Number format used 'ieee-be' or 'ieee-le' (normally
%               'ieee-be' is always used)
%
%  hdr       - structure with all the fields mentionened above plus
%               path - path of file if included in the call parameter 'name' 
%
%  abs_pix_val = (pix_val - offset) * scale
%
%  name      - name of image file
%
%  Cs, 010294
%
%  Revised
%  CS, 181194  Possibility of offset and scale in header file
%  CS, 130398  Possibility of origin in header file
%  CS, 280100  Reading changed so routines works on both HP and Linux
%              systems
%  CS, 050200  Changed so description field also is returned
%  CS, 060700  Structure output appended as possibility
%  CS, 070801  Changed to be able to handle the iee-le files (non standard
%               analyze files)
%  CS, 210901  Changed including an extra field 'path' in hdr structure 
%
if (nargin ~= 1)
   error('ReadAnalyzeHdr, Incorrect number of input arguments');
end;   
if (nargout ~= 1) & ((nargout < 4) | (nargout > 9))
   error('ReadAnalyzeHdr, Incorrect number of output arguments');
end;
%
pos=findstr(name,'.img');
if (~isempty(pos))
  name=name(1:(pos(1)-1));
end;  
pos=findstr(name,'.hdr');
if (~isempty(pos))
  name=name(1:(pos(1)-1));
end; 
%
FileName=sprintf('%s.hdr',name);
%
pid=fopen(FileName,'r','ieee-be');
%
% Uncertainty if filesize is written as a int16 or int32
%
header_size=fread(pid,2,'int16');
endian='ieee-be';
if (header_size(1) ~= 348) & (header_size(2) ~= 348)
  fclose(pid);
  pid=fopen(FileName,'r','ieee-le');
  header_size=fread(pid,2,'int16');
  endian='ieee-le';
  if (header_size(1) ~= 348) & (header_size(2) ~= 348)
    fclose(pid);
    pid=fopen(FileName,'r','ieee-be');
    header_size=fread(pid,2,'int16');
    endian='ieee-be';
    fprintf('Not able to detect analyze file format, guessing at ieee-be\n');
  end
end  
fread(pid,36,'uchar');           % dummy read header information
dims=fread(pid,1,'ushort');      % dimension (3 or 4)
dim=fread(pid,4,'ushort');       % dimension, number of pixels
if (dims == 3) | (dim(4) == 1) | (dim(4) == 0)
  dim=dim(1:3);
end;  
fread(pid,4,'ushort');          
fread(pid,6,'ushort');          
Datatype=fread(pid,1,'ushort');    % datatype       
BitsPrVoxel=fread(pid,1,'ushort'); %Bits pr. voxel
fread(pid,1,'ushort');
fread(pid,2,'ushort');        
siz=fread(pid,3,'float32');        % size of pixels
fread(pid,4,'float32');
offset=fread(pid,1,'float32');     % offset for pixels (funused8), SPM extension
scale=fread(pid,1,'float32');      % scaling for pixels (funused9), SPM extension

fread(pid,24,'char');

lim=fread(pid,2,'int');            % Limits for number in given analyze format

descr_input=fread(pid,80,'char');  % Description field in header file
descr=char(descr_input)';
descr=deblank(descr);

fread(pid,24,'char');
orient=fread(pid,1,'char');        % Orientation, not used

origin=fread(pid,3,'int16');       % Origin, SPM extension to analyze format

fread(pid,89,'char');              % Not used
fclose(pid);

if (Datatype==1)&(BitsPrVoxel==1)         % single bit
  pre=1;
elseif (Datatype==2)&(BitsPrVoxel==8)     % unsigned char
  pre=8;
elseif (Datatype==4)&(BitsPrVoxel==8)     % signed char
  pre=8;
elseif (Datatype==4)&(BitsPrVoxel==16)    % Needed for compatibility with
                                          % NRU and AIR format
  pre=16;
elseif (Datatype==8)&(BitsPrVoxel==16)    % signed 16 bit int
                                          % based on lim it is decided
					  % whether it is signed/unsigned in
					  % accordance with AIR
  pre=16;
elseif (Datatype==16)&(BitsPrVoxel==32)   % 32 bit float
  pre=32;
elseif (Datatype==32)&(BitsPrVoxel==32)   % Old NRU format (wrong but did
                                          % work because of no complex
					  % files)
  pre=32;
elseif (Datatype==32)&(BitsPrVoxel==64)   % Complex (2xfloats)
  pre=32*sqrt(-1);
elseif (Datatype==64)&(BitsPrVoxel==64)   % 64 bit float
  pre=64;
else
  error(sprintf('Unknown data type, Datatype: %i, Bits pr. voxel %i',Datatype,BitsPrVoxel));
end  

if (pre == 32) | (pre == 64)       % To be sure that img=(imgRead-offset)*scale
   scale=1;
   offset=0;
end   
if (nargout == 1)
  pos=findstr(name,'/');
  if (~isempty(pos))
    hdr.name=name((pos(length(pos))+1):length(name));
    hdr.path=name(1:(pos(length(pos))));
  else
    hdr.name=name;
    hdr.path='';
  end;  
  hdr.pre=pre;
  hdr.dim=dim;
  hdr.siz=siz;
  hdr.lim=lim;
  hdr.scale=scale;
  hdr.offset=offset;
  hdr.origin=origin;
  hdr.descr=descr;
  hdr.endian=endian;
  pre=hdr;
end

% This comment does nothing






