function arr = HOGModified(inputImage)                                      % Takes grayscale image as input
arr1=zeros(1,12);                                                           %Generated features values are stored into these five arrays.
arr2=zeros(1,12);
arr3=zeros(1,12);
arr4=zeros(1,12);
arr5=zeros(1,12);

jj=1;
th= graythresh(inputImage);
bw=im2bw(inputImage,th);
binaryImage=imcomplement(bw);
% Noise Removal
MN=[3,2];
structureElement=strel('rectangle',MN);
dialateImage=imclose(binaryImage,structureElement);
%Removal of extra white space sorrounding the textual content (Word Image)
workingImage=minimalBoundaryReturnGrayImage(dialateImage,inputImage); 
filter=fspecial('gaussian',[3,3],0.5);
simage1=imfilter(workingImage,filter,'replicate');
simage=double(simage1);
[r,c]=size(simage);
max=size(simage);

%**********************Case 1: Tranpose ([1 0 -1])*************************
% Gradient Calculation in xy direction
% xgrad= zeros(max);
% for i=2:r-1
%     for j=1:c-1
%         xgrad(i,j)=simage(i-1,j)- simage(i+1,j);
%     end
% end
% % Gradient Calculation in Y direction
% ygrad=zeros(max);
% for j=2:c-1
%     for i=1:r-1
%         ygrad(i,j)=simage(i,j-1)-simage(i,j+1);
%     end
% end
% magnitude=zeros(max);
%  for k=1:r
%      for l=1:c
%          magnitude(k,l)= sqrt((xgrad(k,l)*xgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
%      end
%  end
% %Case 2: Robert Cross Tranpose ({-1 0,0 1})
% xgrad= zeros(max);
% for i=1:r
%     for j=1:c-1
%         xgrad(i,j)=simage(i,j+1)- simage(i,j);
%     end
% end
% ygrad=zeros(max);
% for j=1:c
%     for i=1:r-1
%         ygrad(i,j)=simage(i+1,j)-simage(i,j);
%     end
% end
% %Magnitude matrix generation
% magnitude=zeros(max);
%  for k=1:r
%      for l=1:c
%          magnitude(k,l)= sqrt((xgrad(k,l)*xgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
%      end
%  end

% Case 3: For 2 pixel consideration ***** [-1 0 1] and Tranpose([-1 0 1])
% xgrad= zeros(max);
% for i=1:r
%     for j=1:c-2
%         xgrad(i,j)=simage(i,j+2)- simage(i,j);
%     end
% end
% ygrad=zeros(max);
% for j=1:c
%     for i=1:r-2
%         ygrad(i,j)=simage(i+2,j)-simage(i,j);
%     end
% end
% magnitude=zeros(max);
%  for k=1:r
%      for l=1:c
%          magnitude(k,l)= sqrt((xgrad(k,l)*xgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
%      end
%  end

% Case 4: For 2 pixel consideration ***** [-1 1/2 1/2] and Transpose([-1 1/2 1/2])


% Gradient Calculation in x direction
xgrad= zeros(max);
for i = 1:(r - 1) 
    for j = 1:(c - 1)
        xgrad(i, j) = simage(i, j + 1) - simage(i, j);
    end
end


% Gradient Calculation in Y direction
ygrad=zeros(max);
for j=1:(c - 1) 
    for i=1:(r - 1)
        ygrad(i, j) = simage(i + 1, j) - simage(i, j);
    end
end




% Gradient Calculation diagonally
zgrad = zeros(max);
for i = 1:(r - 1)
    for j = 1:(c - 1)
        zgrad(i, j) = simage(i,j) - simage(i+1, j+1);
    end
end

% Gradient Calculation in reverse diagonal
zrevgrad = zeros(max);
for k = 1:(r - 1)
    for l = 1:(c - 1)
        zrevgrad(k,l) = simage(k, l + 1) - simage(k + 1, l);
    end
end

% Calculation of magnitude
magnitude1=zeros(max);
 for k=1:r
     for l=1:c
         magnitude1(k,l)= sqrt((xgrad(k,l)*xgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
     end
 end
 
 magnitude2=zeros(max);
 for k=1:r
     for l=1:c
         magnitude2(k,l)= sqrt((zgrad(k,l)*zgrad(k,l))+(xgrad(k,l)*xgrad(k,l)));
     end
 end
 
 magnitude3=zeros(max);
 for k=1:r
     for l=1:c
         magnitude3(k,l)= sqrt((zgrad(k,l)*zgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
     end
 end
 
 magnitude4=zeros(max);
 for k=1:r
     for l=1:c
         magnitude4(k,l)= sqrt((zrevgrad(k,l)*zrevgrad(k,l))+(xgrad(k,l)*xgrad(k,l)));
     end
 end
 

  magnitude5=zeros(max);
 for k=1:r
     for l=1:c
         magnitude5(k,l)= sqrt((zrevgrad(k,l)*zrevgrad(k,l))+(ygrad(k,l)*ygrad(k,l)));
     end
 end
 

 
%12-directional Histogram generation
 direction1=zeros(max);
  for k=1:r
     for l=1:c
          if(xgrad(k,l)~=0)
      
            if(xgrad(k,l)>0 && ygrad(k,l)>=0)
             direction1(k,l)= atand(ygrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)<0 && ygrad(k,l)>=0)
             direction1(k,l)= 180+atand(ygrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)>0 && ygrad(k,l)<0)
             direction1(k,l)= 360+atand(ygrad(k,l)/xgrad(k,l));
            else
             direction1(k,l)= 180+atand(ygrad(k,l)/xgrad(k,l));
            end 
          else
            if(ygrad(k,l)>0)
             direction1(k,l)= 90;  
            elseif(ygrad(k,l)==0)
                direction1(k,l)= 0;
            else
             direction1(k,l)= 270;   
            end  
         end
              
     end
  end
  local1=zeros(12);
  counter1=zeros(12);
     for j=1:r
         for k=1:c
                if(direction1(j,k)~=0)
                    local1(ceil((direction1(j,k)/30)))=local1(ceil((direction1(j,k)/30)))+magnitude1(j,k);
                    counter1(ceil((direction1(j,k)/30)))=counter1(ceil((direction1(j,k)/30)))+1;
                else
                    local1(1)=local1(1)+magnitude1(j,k);
                    counter1(1)=counter1(1)+1;
                end
         end
     end
     
      direction2=zeros(max);
  for k=1:r
     for l=1:c
          if(xgrad(k,l)~=0)
      
            if(xgrad(k,l)>0 && zgrad(k,l)>=0)
             direction2(k,l)= atand(zgrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)<0 && zgrad(k,l)>=0)
             direction2(k,l)= 180+atand(zgrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)>0 && zgrad(k,l)<0)
             direction2(k,l)= 360+atand(zgrad(k,l)/xgrad(k,l));
            else
             direction2(k,l)= 180+atand(zgrad(k,l)/xgrad(k,l));
            end 
          else
            if(zgrad(k,l)>0)
             direction2(k,l)= 90;  
            elseif(zgrad(k,l)==0)
                direction2(k,l)= 0;
            else
             direction2(k,l)= 270;   
            end  
         end
              
     end
  end
  local2=zeros(12);
  counter2=zeros(12);
     for j=1:r
         for k=1:c
                if(direction2(j,k)~=0)
                    local2(ceil((direction2(j,k)/30)))=local2(ceil((direction2(j,k)/30)))+magnitude2(j,k);
                    counter2(ceil((direction2(j,k)/30)))=counter2(ceil((direction2(j,k)/30)))+1;
                else
                    local2(1)=local2(1)+magnitude2(j,k);
                    counter2(1)=counter2(1)+1;
                end
         end
     end
     
      direction3=zeros(max);
  for k=1:r
     for l=1:c
          if(ygrad(k,l)~=0)
      
            if(ygrad(k,l)>0 && zgrad(k,l)>=0)
             direction3(k,l)= atand(zgrad(k,l)/ygrad(k,l));
            elseif(ygrad(k,l)<0 && zgrad(k,l)>=0)
             direction3(k,l)= 180+atand(zgrad(k,l)/ygrad(k,l));
            elseif(xgrad(k,l)>0 && zgrad(k,l)<0)
             direction3(k,l)= 360+atand(zgrad(k,l)/ygrad(k,l));
            else
             direction3(k,l)= 180+atand(zgrad(k,l)/ygrad(k,l));
            end 
          else
            if(zgrad(k,l)>0)
             direction3(k,l)= 90;  
            elseif(zgrad(k,l)==0)
                direction3(k,l)= 0;
            else
             direction3(k,l)= 270;   
            end  
         end
              
     end
  end
  local3=zeros(12);
  counter3=zeros(12);
     for j=1:r
         for k=1:c
                if(direction3(j,k)~=0)
                    local3(ceil((direction3(j,k)/30)))=local3(ceil((direction3(j,k)/30)))+magnitude3(j,k);
                    counter3(ceil((direction3(j,k)/30)))=counter3(ceil((direction3(j,k)/30)))+1;
                else
                    local3(1)=local3(1)+magnitude3(j,k);
                    counter3(1)=counter3(1)+1;
                end
         end
     end
     
      direction4=zeros(max);
  for k=1:r
     for l=1:c
          if(xgrad(k,l)~=0)
      
            if(xgrad(k,l)>0 && zrevgrad(k,l)>=0)
             direction4(k,l)= atand(zrevgrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)<0 && zrevgrad(k,l)>=0)
             direction4(k,l)= 180+atand(zrevgrad(k,l)/xgrad(k,l));
            elseif(xgrad(k,l)>0 && zrevgrad(k,l)<0)
             direction4(k,l)= 360+atand(zrevgrad(k,l)/xgrad(k,l));
            else
             direction4(k,l)= 180+atand(zrevgrad(k,l)/xgrad(k,l));
            end 
          else
            if(zrevgrad(k,l)>0)
             direction4(k,l)= 90;  
            elseif(zrevgrad(k,l)==0)
                direction4(k,l)= 0;
            else
             direction4(k,l)= 270;   
            end  
         end
              
     end
  end
  local4=zeros(12);
  counter4=zeros(12);
     for j=1:r
         for k=1:c
                if(direction4(j,k)~=0)
                    local4(ceil((direction4(j,k)/30)))=local4(ceil((direction4(j,k)/30)))+magnitude4(j,k);
                    counter4(ceil((direction4(j,k)/30)))=counter4(ceil((direction4(j,k)/30)))+1;
                else
                    local4(1)=local4(1)+magnitude4(j,k);
                    counter4(1)=counter4(1)+1;
                end
         end
     end
     
      
     

direction5=zeros(max);
  for k=1:r
     for l=1:c
          if(ygrad(k,l)~=0)
      
            if(ygrad(k,l)>0 && zrevgrad(k,l)>=0)
             direction5(k,l)= atand(zrevgrad(k,l)/xgrad(k,l));
            elseif(ygrad(k,l)<0 && zrevgrad(k,l)>=0)
             direction5(k,l)= 180+atand(zrevgrad(k,l)/ygrad(k,l));
            elseif(ygrad(k,l)>0 && zrevgrad(k,l)<0)
             direction5(k,l)= 360+atand(zrevgrad(k,l)/ygrad(k,l));
            else
             direction5(k,l)= 180+atand(zrevgrad(k,l)/ygrad(k,l));
            end 
          else
            if(zrevgrad(k,l)>0)
             direction5(k,l)= 90;  
            elseif(zrevgrad(k,l)==0)
                direction5(k,l)= 0;
            else
             direction5(k,l)= 270;   
            end  
         end
              
     end
  end
  local5=zeros(12);
  counter5=zeros(12);
     for j=1:r
         for k=1:c
                if(direction5(j,k)~=0)
                    local5(ceil((direction5(j,k)/30)))=local5(ceil((direction5(j,k)/30)))+magnitude5(j,k);
                    counter5(ceil((direction5(j,k)/30)))=counter5(ceil((direction5(j,k)/30)))+1;
                else
                    local5(1)=local5(1)+magnitude5(j,k);
                    counter5(1)=counter5(1)+1;
                end
         end
     end

 
 
%Storing of feature values for returning
 for count=1:12
         arr1(jj)=local1(count);
         jj=jj+1;
 end
arr1 = arr1'; 
 
 jj = 1;
for count=1:12
         arr2(jj)=local2(count);
         jj=jj+1;
end  
arr2 = arr2';
     
jj = 1;
for count=1:12
         arr3(jj)=local3(count);
         jj=jj+1;
end  
arr3 = arr3';
     
jj = 1;
for count=1:12
         arr4(jj)=local4(count);
         jj=jj+1;
end  
arr4 = arr4';
     

jj =1;
for count=1:12
         arr5(jj)=local5(count);
         jj=jj+1;
end
arr5 = arr5';

arr = [arr1; arr2; arr3; arr4; arr5];
arr = arr';


     
end

