clear;
%%read
path = 'D:\code\data\bone\';
name = 'USImage';
endd=1;
fmt = 'bmp';
img1 = imread([path, name, int2str(endd)], fmt);
[wid, len] = size(img1);
img1 = zeros(wid, len, endd);
for nums=1:endd
    img1(:,:,nums) = imread([path, name, int2str(nums)], fmt);
    img1(1:110,:,nums)=0;
end

for nums=1:endd
    temp = imbinarize(img1(:,:,nums),0.1);
    for i=1:10
        temp=imfill(temp,'holes'); 
    end
    D=[1 1 1;1 1 1;1 1 1];
    for i=1:5
        temp=imdilate(temp, D);
    end
    for i=1:5
        temp=imerode(temp, D);
    end
    temp=1-temp;

    %%求最大连通域
    imBw = temp; 
    imLabel = bwlabel(imBw); 
    stats = regionprops(imLabel,'Area'); 
    area = cat(1,stats.Area);
    index = find(area == max(area)); 
    temp = ismember(imLabel,index); 

    for i=1:10
    temp=imdilate(temp, D);
    end
    temp=double(temp);

    img1(:,:,nums)=img1(:,:,nums).*temp;
end

%%write
newname=['new',name];
img1(1:110,:,:)=0;
for nums=1:endd
    imwrite(img1(:,:,nums), [path, newname, int2str(nums), '.bmp']);
end