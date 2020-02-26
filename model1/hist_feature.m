function F = hist_feature(r, n_segs, option)
global setup;

if nargin <3
    option = 0;
end

edges = linspace(min(setup.data),max(setup.data),n_segs+1);
F = zeros(r.K, n_segs);

for i = 1:r.K
    try
        F(i,:) = histcounts(setup.data(r.tau(i):r.tau(i+1)-1), edges);
    catch
        keyboard
    end
end

if option ~= 0
    F = F./sum(F,2);
end
end