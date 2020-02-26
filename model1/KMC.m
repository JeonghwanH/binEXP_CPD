function cluster = KMC(data, numComp, maxIter, option)
[n,d] = size(data);

% data = (data - mean(data))./std(data);
mu = zeros(numComp,d);
distance = zeros(n,numComp);
cluster = zeros(size(n,1));
if nargin < 4
    option = 0;
end

switch option
    case 1
        while(length(unique(cluster))~=numComp)
            for i = 1:n
                cluster(i,1) = randi([1,numComp]);
            end

            for iter = 1:maxIter
                for i = 1:numComp
                    mu(i,:) = mean(data(cluster==i,:));
                    for j = 1:n
                        distance(j,i) = KLDiv(mu(i,:),data(j,:)) + KLDiv(data(j,:),mu(i,:));
                    end
                end
                [~,cluster] = min(distance,[],2);
            end
        end
        
    case 0

%         for i = 1:n
%             cluster(i,1) = randi([1,numComp]);
%         end
%         
%         for iter = 1:maxIter
%             for i = 1:numComp
%                 mu(i,:) = mean(data(cluster==i,:));
%                 distance(:,i) = sqrt(sum((data - mu(i,:)).^2,2));
%             end
%             [~,cluster] = min(distance,[],2);
%         end
%         keyboard
        while(length(unique(cluster))~=numComp)
            for i = 1:n
                cluster(i,1) = randi([1,numComp]);
            end

            for iter = 1:maxIter
                for i = 1:numComp
                    mu(i,:) = mean(data(cluster==i,:));
                    distance(:,i) = sqrt(sum((data - mu(i,:)).^2,2));
                end
                [~,cluster] = min(distance,[],2);
            end
        end
        
    case 2
        while(length(unique(cluster))~=numComp)
            for i = 1:n
                cluster(i,1) = randi([1,numComp]);
            end

            for iter = 1:maxIter
                for i = 1:numComp
                    mu(i,:) = mean(data{cluster==i});
                    for j = 1:n
%                         distance(j,i) = KLDiv(mu(i,:),data(j,:)) + KLDiv(data(j,:),mu(i,:));
                        distance(j,i) = dtw(mu(i,:),data{j});
                    end
                end
                [~,cluster] = min(distance,[],2);
            end
        end
        
end
end
