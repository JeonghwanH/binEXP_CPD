function score = DBindex(data, kmc)
cluster = unique(kmc);
D = zeros(length(cluster));
for i = 1:length(cluster)
    for j = i+1:length(cluster)
        D(i,j) = (mean(data(kmc == cluster(i),:)) + mean(data(kmc == cluster(j),:)))/abs(mean(data(kmc == cluster(i),:)) - mean(data(kmc == cluster(j),:)));
        
    end
end

score = sum(max(D))/length(cluster);
end
