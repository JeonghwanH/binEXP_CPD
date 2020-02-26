function r = make_r(value)
global setup;
assert(length(value)==length(setup.data)-1, 'value should be size(data)-1')

r.value = sparse([1; value]);
r.tau = [find(r.value); length(setup.data)+1];
r.K = sum(r.value);
S = 0;
% r.mu_post = zeros(r.K,length(setup.mu_c));
for i = 1:r.K
    m = mean(setup.data(r.tau(i):r.tau(i+1)-1));
%     s = std(setup.data(r.tau(i):r.tau(i+1)-1));
%     sigma_post = sqrt(1/(1/setup.V_c + 1/s^2));
%     for j = 1:length(setup.mu_c)
% %         keyboard
%         r.mu_post(i,j) = (setup.mu_c(j)/setup.V_c + m/s^2)/(1/setup.V_c + 1/s^2);
%         S = S + log(setup.cluster_p(j)) + sum(log(normpdf(setup.data(r.tau(i):r.tau(i+1)-1),r.mu_post(j),sigma_post)));
%     end
    S = S + (setup.data(r.tau(i):r.tau(i+1)-1) - m)'*(setup.data(r.tau(i):r.tau(i+1)-1) - m);
%     disp(sigma_post)
%     disp(mu_post)
    %     keyboard
end

r.S = S; % log version
% r.lambda = (r.K-1)/(length(setup.data)-1);
% r.lambda = 48/(length(setup.data)-1);
% r.sigma = sqrt(r.S/(length(setup.data)-r.K));

% r.V = (var(setup.data)*length(setup.data)-r.S)/r.K - r.sigma^2;
% r.sigma = setup.sigma;
% r.V = setup.sigma^2;
% r.V = r.sigma^2;

r.lambda = setup.lambda;
r.sigma = setup.sigma;
r.V = setup.V;
end