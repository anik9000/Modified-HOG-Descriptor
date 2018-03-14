clc;                                                                        % this is to clear the command window 
clear all;                                                                  % this is to clear the workspace 
% fid=fopen('featureBengaliCityName80Syn_no grid.dat','w');    
fid=fopen('Your_File.csv','w');                                     % Change the file name

t = cputime;                                                                
totalFeature=60;
for i=1:totalFeature
    fprintf(fid,'att%03d,',i);
end
fprintf(fid,'Class\n');

path1='C:\Users\Ankit\Desktop\Ram Sarkar Sir\HOG Papers\text_test1\';       % This is the path of the folder from where we want to batch read 
imagefiles=dir(strcat(path1,'*.bmp'));                                      % Here we have to provide the extension 
nfiles = length(imagefiles);                                                % This line store the number of image files in that folder  

for im=1:nfiles
    
   currentfilename=imagefiles(im).name;                                     % This line stores the current file name 
    display(strcat(path1,currentfilename));
    I=rgb2gray(imread(strcat(path1,currentfilename)));                      % This line basically read those image files one by one and convert 
                                                                            % them into grayscale 
    a = currentfilename(1, 1);                                              % Stores the first character of each image by which they have been named
                                                                            % one by one
    arr = HOGModified(I);                                                   % Add the function to be called
    fprintf(fid,'%f,',arr);                                                 % Add the contents of arr into the csv file
    b = 'A';
    c = 'B';
    if a == 'n'
        fprintf(fid,'%c\n',b);
    else 
        fprintf(fid,'%c\n',c);
    end
    
    compTime = cputime - t;                                                 % Compute how much time program takes in order to run the code.
end





