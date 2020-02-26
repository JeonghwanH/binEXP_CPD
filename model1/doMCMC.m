function [r4MAP, rs, target_ps, is_accepted] = doMCMC(init_r)
global setup;

if nargin < 1
    pd = makedist('Binomial', 1, 64/length(setup.data));
    value = pd.random(size(setup.data));
    init_r = make_r(value(2:end));
end

for i = 1:setup.nBurnins
    
    if i == 1
        r = init_r;
        [~, ~, r_star] = proposal(r,mod(i,3));
        [~, ~, res] = MH(r, r_star, mod(i,3));
        r = res;
    else
        [~, ~, r_star] = proposal(r,mod(i,3));
        [~, ~, res] = MH(r, r_star, mod(i,3));
        r = res;
    end
    
end

for i = 1:setup.nRuns
%     if i > 60
%         keyboard
%     end
%     [~, ~, r_star] = proposal(r,mod(i,3));
    [~, ~, r_star] = proposal(r,mod(i,2)+1);
%     [~,target_ps_star(i)] = posterior(r_star);
%     [~,target_ps_compare(i)] = posterior(r);
%     [is_accepted(i), ~, rs(i)] = MH(r,r_star,mod(i,3));
    [is_accepted(i), ~, rs(i)] = MH(r,r_star,mod(i,2)+1);
    [~,target_ps(i)] = posterior(rs(i));
    
    if mod(i,600)==10000
        figure(1);
        plot(target_ps);
        figure(2)
        plotR(r_star, setup.data)
        figure(3);
        plot(is_accepted,'o');
%         figure(4);
%         plot(1:i,target_ps);
%         figure(4);
%         hold on;
%         plot(i,rs(i).tau);
        drawnow
        fprintf("%d th sample drawn \n",i);
%         disp(r.mu_post)
%         disp(r.S)
    end
    r = rs(i);
end
[~, I] = max(target_ps);
r4MAP = rs(I);
end