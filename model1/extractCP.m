function CP = extractCP(r)
global setup;

tau = r.tau;
seg = tau(2:end) - tau(1:end-1);
[~,I] = sort(seg, 'descend');
%% mean part
M = zeros(r.K,1);
for i = 1:r.K
    M(i) = mean(setup.data(tau(i):tau(i+1)-1));
end
M_opt = zeros(r.K,1);

for i = 1:r.K
    s = std(setup.data(tau(i):tau(i+1)-1));
    M_opt(i) = sum(seg.*normpdf(M, M(i), s));
%     if r.tau(i) >399
%         keyboard
%     end
end
% keyboard
M_opt(isnan(M_opt)) = 0;
[~, I] = sort(M_opt,'descend');
% disp(I)
s = std(setup.data(tau(I(1)):tau(I(1)+1)-1))*2;

% keyboard
%% length part

CP_bef = (seg > mean(seg(seg>1))).* normpdf(M, M(I(1)), s*1.1);
%%
% keyboard
[~,I] = sort(CP_bef, 'descend');

CP = I(1:min(find(cumsum(sort(CP_bef/sum(CP_bef),'descend')) > 0.99)));
end