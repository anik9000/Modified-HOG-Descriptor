 function mI=minimalBoundaryReturnGrayImage(bI,gI)
 w=size(bI,2);
 h=size(bI,1);
% figure;imshow(dI);
sr=1; er=h; sc=1; ec=w;
for i=1:h
    for j=1:w
        if(bI(i,j)==1)
            er=i;
        end
    end
end

%finding Starting Row
for i=h:-1:1
    for j=1:w
        if(bI(i,j)==1)
            sr=i;
        end
    end
end

%finding Ending Column
for i=1:w
    for j=1:h
        if(bI(j,i)==1)
            ec=i;
        end
    end
end
%finding Starting Column
for i=w:-1:1
    for j=1:h
        if(bI(j,i)==1)
            sc=i;
        end
    end
end

if(sum(sum(bI))==0)
    sr=1;er=h;sc=1;ec=w;
end

mI=zeros(er-sr+1, ec-sc+1);
mI=uint8(mI);
for i=sr:er
    for j=sc:ec
     mI(i-sr+1,j-sc+1)=gI(i,j);   
    end
end
end
