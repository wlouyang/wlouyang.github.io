%===================================================================
% Created: Jan. 2009
%   version 1.0 ?CJan./2009 
% Written by: Wanli Ouyang
% Contact
%      Wanli Ouyang                      <wlouyang@ee.cuhk.edu.hk>
%      Wai-Kuen Cham                      <wkcham@ee.cuhk.edu.hk> 

% Introduction of the code
% This is program shows the fast Walsh Hadamard Transform (WHT) 
% algorithm proposed in [1]. Note that this algorithm is used for WHT on 
% sliding windows rather than block WHT. We used the zero padding method is 
% in [2]. There are two great algorithms for WHT on sliding windows. In 
% this code, the WHT projection values are in dyadic order. The 
% relationship between natural order, sequency order and dyadic order is 
% pointed out in [5]. We use the sequency order in [1], but we use the 
% dyadic order in this code because it is easier to represent the algorithm
% using dyadic order. Sequency order might be more frequently used in 
% practical applications.

% Reference
% [1]	Wanli Ouyang and W. K. Cham, ''Fast Algorithm for Walsh Hadamard 
% Transform on Sliding Windows'', IEEE Trans. Pattern Analysis and Machine 
% Intelligence, under review.
% [2]	Y. Moshe and H. Hel-Or, ''A Fast Block Motion Estimation Algorithm 
% Using Gray Code Kernels'', in Proc. IEEE Symp. Signal Processing and 
% Information Technology, pp.185 - 190, Vancouver, Canada, Aug. 2006.
% [3]	 Y. Hel-Or and H. Hel-Or, ''Real time pattern matching using 
% projection kernels,'' IEEE Trans. Pattern Analysis and Machine 
% Intelligence, vol. 27, no. 9, pp. 1430-1445, Sept. 2005.
% [4]	 G. Ben-Artzi, H. Hel-Or, and Y. Hel-Or, ''The gray-code filter 
% kernels,'' IEEE Trans. Pattern Analysis and Machine Intelligence, vol. 29, 
% no. 3,  pp.382 - 393, Mar. 2007.
% [5]	W.K. Cham and R.J. Clarke, ''Dyadic Symmetry and Walsh Matrices,'' 
% IEE Proceedings, Pt.F., Vol.134, No.2, pp.141-145, Apr. 1987.
%===================================================================

%  ***************************************
%  Conditions of Use and Disclaimer:
%  
%  You are only granted a limited right to use this software for your
%  personal non-commercial use.
%  
%  This software is provided as SHAREWARE for testing and evaluating
%  purposes and cannot be sold or used in any commercial way, or
%  distributed, with or without consideration and whether on its own or
%  bundled with any commercial package, or by accompanying books, magazines
%  or any publication in any media without express written permission from
%  the owner.
%  
%  The owner of this software accepts no responsibility for any damages
%  resulting from any use relating to this software and makes no warranty
%  or representation, either express or implied, including but not limited
%  to, any implied warranty of merchantability or fitness for a particular
%  purpose. This software is provided "AS IS", and you, as a limited right
%  user, assume all risks when using it.
%  
%  Copyright (c) The Chinese University of Hong Kong 2009 
%  
%  This software is intended for personal non-commercial use only. 
%  For any other use, whether commercial or otherwise, please make
%  enquiries by writing to:
%  
%  Technology Licensing Office
%  The Chinese University of Hong Kong
%  Shatin, N.T., Hong Kong
%  
%  Email: tech_license@cuhk.edu.hk
%  ***************************************

clear;

%Get input
img = imread('LENA256.jpg');
img = double(img(:, :, 1));
[imgSizeY imgSizeX] = size(img);

%Obtain the transform size
TransformSize = 16; %Must be power of 2
bits = log2(TransformSize);

H = hadamard(TransformSize); %Obtain the WHT matrix in natural order
H_N_by4 = hadamard(TransformSize/4);%H_N_by4 in natural order is used for t

%Obtain the dyadic order for the above two matrices
H1 = H_N_by4;
bits2 = bits-2;
for i = 0:TransformSize/4-1
    index = 0;
    for j = 1:bits2
        index = bitset(index, bits2-j+1, bitget(i, j));
    end;
    H_N_by4(i+1,:) = H1(index+1,:);
end;
H1 = H;
for i = 0:TransformSize-1
    index = 0;
    for j = 1:bits
        index = bitset(index, bits-j+1, bitget(i, j));
    end;
    H(i+1,:) = H1(index+1,:);
end;

%Prepare constants 
BoundaryX = TransformSize*5/4;
BoundaryY = TransformSize*5/4;
TransformSizeBy4 = TransformSize/4;
BoundedW = BoundaryX+imgSizeX;
BoundedH = BoundaryY+imgSizeY;
BoundedImg = zeros(BoundedH, BoundedW);
BoundedImg(BoundaryY+1:BoundedH, BoundaryX+1:BoundedW) = img;

%Use the zero padding method introduced in [2]
HbMem = zeros(BoundedH-TransformSize, BoundedW-TransformSize, TransformSize, TransformSize);

%Start WHT computation

%Step a: Compute the d_N(j)
BoundedDiffImg = zeros(BoundedH-TransformSize, BoundedW-TransformSize);
BoundedDiffImg = BoundedImg(1:BoundedH, 1:BoundedW-TransformSize) - BoundedImg(1:BoundedH, TransformSize+1:BoundedW);

for jY = 1:TransformSize*5      
    for jX = 1:TransformSize*5  %for each window position (jY, jX)
        
        %Hb1 is used for checking the correctness of the algorithm
        img1 = BoundedImg(jY+1:jY+TransformSize, jX+1+TransformSizeBy4:jX+TransformSize+TransformSizeBy4);% X_N(jY, jX+N/4)
        Hb1 = H*img1*H'; 
        
    %============= Step b  ===============
        
        %Obtain from memory the differene d_N(j)
        img2 = BoundedDiffImg(jY+1:jY+TransformSize, jX+1:jX+TransformSizeBy4);
        %Use d_N(j) to obtain the t. The following code is just a simple 
        %implementation of the WHT. It is advised in [1] that you should 
        %use the GCK algorithm in [4] for the following computation of t if
        %you want better computational efficiency.
        t = H*img2*H_N_by4; 
        
    %============= Step c  ===============
        HbTmp = zeros(TransformSize, TransformSize);
        for iy = 1:TransformSize
            for ix = 1:TransformSizeBy4
                idx = (ix-1)*4+1;
                %For dyadic order WHT, we have the follows.
                HbTmp(iy, idx)   =    HbMem(jY+1, jX+1, iy, idx)   - t(iy, ix);
                HbTmp(iy, idx+1) = - (HbMem(jY+1, jX+1, iy, idx+3) - t(iy, ix));
                HbTmp(iy, idx+2) = - (HbMem(jY+1, jX+1, iy, idx+2) - t(iy, ix));
                HbTmp(iy, idx+3) =    HbMem(jY+1, jX+1, iy, idx+1) - t(iy, ix);
                %The code above could be different for diferent orders.
                %See [1] for sequency order.
            end;
        end;
        HbMem(jY+1, jX+TransformSizeBy4+1, :, :) = HbTmp;
        
    %To Check if the WHT algorithm is correct
        error = abs(Hb1 - HbTmp);
        SAD(jY, jX) = sum(sum(error));
        if (SAD(jY, jX) ~=0)
            fprintf('error in pos /(%d, %d/)\n', jY, jX);
        end;
    end;
end;
% show the result
SAD
SAD_SUM = sum(sum(SAD))
