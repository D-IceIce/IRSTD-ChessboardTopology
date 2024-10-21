function re = admdfunc(img,scale)
img = double(img);
out = [];
for ii = 1:length(scale)
    out = cat(3, out, subfubc(img, scale(ii)));
end
re = max(out, [], 3);
end

function out3 = subfubc(img, len)
op35 = ones(len)/(len*len);

m35 = imfilter(double(img), op35, 'symmetric');
lx = floor(len/2);
ly = floor(len/2);
op = zeros(len * 3);

op(ly+1, lx+1) = 1;
op(ly+1, len + lx + 1) = 1;
op(ly+1, len*2 + lx + 1) = 1;
op(len + ly+1, lx+1) = 1;
op(len + ly+1, len + lx + 1) = 0;
op(len + ly+1, len*2 + lx + 1) = 1;
op(len*2 + ly+1, lx+1) = 1;
op(len*2 + ly+1, len + lx + 1) = 1;
op(len*2 + ly+1, len*2 + lx + 1) = 1;

m3b = imdilate(m35, op);
out3 = (m35 - m3b).^2.*(m35 - m3b>0);
end