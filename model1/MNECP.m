function r_suc = MNECP(r)
global setup;
tau = r.tau;
seg = tau(2:end)-tau(1:end-1);
chunk = seg>mean(seg(seg>1));
for i = 1:length(seg)
    m(i) = mean(setup.data(tau(i):tau(i+1)-1));
end
% keyboard
merged = find((abs(m(1:end-1)-m(2:end))<1.8e-05)'&chunk(1:end-1).*chunk(2:end))+1;
tau = setdiff(tau,tau(merged));
seg = tau(2:end)-tau(1:end-1);
chunk = seg>mean(seg(seg>1));
m = 0;
% chunk = seg > mean(seg(seg>2));
for i = 1:length(seg)
    m(i) = mean(setup.data(tau(i):tau(i+1)-1));
end
%%
chunk = seg>mean(seg(seg>1));
[~,I] = sort(m,'descend');
seg_chunk = seg;
seg_chunk(~chunk) = 0;
asdf = seg_chunk(I);

% figure(); plot(cumsum(asdf))
[~,start] = max([1:length(asdf)]'.*(max(cumsum(asdf))-cumsum(asdf)));
im_chunk = zeros(size(chunk));
im_chunk(I(start:end)) = 1;
im_chunk(seg_chunk == 0 ) = 0;
% figure(); plotR(r_hard); hold on; stem([tau(logical(im_chunk));tau(find(logical(im_chunk))+1)], ...
%     max(setup.data)*ones(size([tau(logical(im_chunk));tau(find(logical(im_chunk))+1)])))
% keyboard
value = zeros(size(r.value));
n_tau = sort([tau(logical(im_chunk));tau(find(logical(im_chunk))+1)],'ascend');
value(n_tau) = 1;
for i = 1:length(n_tau)
    if i == length(n_tau)
        if length(setup.data)+1 - n_tau(i) < mean(seg(seg>1))
            value(n_tau(i)) = 0;
%     disp(i)
        end
    else
        if n_tau(i+1) - n_tau(i) < mean(seg(seg>1))
            value(n_tau(i)) = 0;
    %     disp(i)
        end
    end
end
% keyboard
% value = value.*im_chunk;
r_suc = make_r(value(2:length(setup.data)));
figure(); plotR(r_suc)

end