function [p,lp] = posterior(r)
global setup;

assert(length(r.value)==length(setup.data), 'r should be the same as data in size');
assert(min(r.value)==0 & max(r.value)==1 & sum(r.value==logical(r.value)) == length(r.value), 'r \in {0, 1}');

phi = r.V/(2*r.sigma^2*(r.sigma^2+r.V));
% % phi = 1000;
gamma = log(r.sigma^2 + r.V)/2 - log(r.sigma^2)/2 - log(r.lambda/(1-r.lambda));
% phi = 0.5/r.sigma^2;
% gamma = log(r.lambda/(1-r.lambda));

lp = -phi*r.S - gamma*r.K;
% keyboard
p = exp(lp);

% keyboard

% lp = r.S + r.K*log(setup.lambda/(1-setup.lambda)) + log(1-setup.lambda)*length(setup.data);
% p = exp(lp);
% keyboard
end