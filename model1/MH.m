function [is_accepted, alpha, res] = MH(r, r_star, option)
global setup;
% 
% [p_star,lp_star] = posterior(r_star);
% [p,lp] = posterior(r);
% [q,lq] = proposal(r,option);
% [q_star,lq_star] = proposal(r_star,option);

switch option
    case 0
%         lalpha = -setup.phi*(r_star.S - r.S)...
%             - (r_star.K - r.K)*log((setup.sigma^2+setup.V)/setup.sigma^2)/2;
        lalpha = -(r.V/(2*r.sigma^2*(r.sigma^2+r.V)))*(r_star.S - r.S)...
            - (r_star.K - r.K)*log((r.sigma^2+r.V)/r.sigma^2)/2;
%         lalpha = (lp_star - lp) - (lq_star - lq);

    case 1
%         lalpha = -setup.phi*(r_star.S - r.S) -setup.gamma*(r_star.K - r.K);
        lalpha = -(r.V/(2*r.sigma^2*(r.sigma^2+r.V)))*(r_star.S - r.S) ...
            - (log(r.sigma^2 + r.V)/2 - log(r.sigma^2)/2 - log(r.lambda/(1-r.lambda)))*(r_star.K - r.K);
%         lalpha = (lp_star - lp) - (lq_star - lq);
        
    case 2
%         lalpha = -setup.phi*(r_star.S - r.S);
        lalpha = -(r.V/(2*r.sigma^2*(r.sigma^2+r.V)))*(r_star.S - r.S);
%         lalpha = (lp_star - lp) - (lq_star - lq);
end
% lalpha = (lp_star-lp) + (lq - lq_star);
alpha = min(exp(lalpha), 1);
% keyboard
u = rand;
if alpha > u
    res = r_star;
    is_accepted = 1;
else
    res = r;
    is_accepted = 0;
end

end