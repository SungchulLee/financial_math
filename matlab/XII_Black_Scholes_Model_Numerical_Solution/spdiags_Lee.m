function A = spdiags_Lee(D,d,n,m)
if n>=m
    D1 = D;
    for j=1:length(d)
        if d(j)>0
            D1(:,j) = 0;
            D1(1+d(j):end,j)= D(1:end-d(j),j);
        end
    end
    A = spdiags(D1,d,n,m);
else
	D1 = D;
    for j=1:length(d)
        if d(j)<0
            D1(:,j) = 0;
            D1(1+abs(d(j)):end,j)= D(1:end-abs(d(j)),j);
        end
    end
    A = spdiags(D1,d,n,m);   
end
end

