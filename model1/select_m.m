function [B, L, m] = select_m(t, data, max_m)
% t = t-mean(t);
% data = (data - mean(data))/std(data);
if length(t) == 1
    B = data;
    L = -100000;
    m = 1;
else
    X = ones(size(t));
    for i = 1:max_m
        X = [X; t.^i];
    end
    residue = zeros(max_m+1,1);
    BIC = zeros(max_m+1,1);
    for i = 1:max_m+1
%         keyboard
        B = (X(1:i,:)*X(1:i,:)')\X(1:i,:)*data;
        residue(i) = (data - X(1:i,:)'*B(1:i,1))'*(data - X(1:i,:)'*B(1:i,1));
        BIC(i) = log(residue(i)/length(data))*length(data) + i*log(length(data));
    end
    % figure(); plot(1:max_m+1,residue/length(data));
    % figure(); plot(1:max_m+1,BIC);

    [L,m] = min(BIC);
    B = (X(1:m,:)*X(1:m,:)')\X(1:m,:)*data;
end
% B = (X(1:m+1,:)*X(1:m+1,:)')\X(1:m+1,:)*data;
% figure();
% plot(t,(X(1:m+1,:)'*B)','r-')
% hold on;
% plot(t,data);
% keyboard
end