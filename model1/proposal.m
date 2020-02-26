function [q, lq, r_star] = proposal(r, option)
% len = length(r.value);
global setup;

switch option

    case 0
%         keyboard
        pd = makedist('Binomial', 1, r.lambda);
        value = pd.random(size(setup.data));
        
%         value = zeros(size(r.value));
%         value(u) = 1;

        q = 1;
        lq = 0;
        
%         init_r = make_r(value(2:end));
        
    case 1
        u = randperm(length(r.value),1);
        value = r.value;
        value(u) = 1 - r.value(u);
%         r_star = make_r(value(2:end));
        q = 1/length(r.value);
        lq = log(q);
        
        % value = randperm(length(r.value),6);
        
    case 2
        
        cand_one = find(r.value == 1);
        cand_zero = find(r.value == 0);
        u1 = randi(length(cand_one),1);
        u0 = randi(length(cand_zero),1);
        value = r.value;
        value(cand_one(u1)) = 0;
        value(cand_zero(u0)) = 1;
        q = 1;
        lq = 0;
end

r_star = make_r(value(2:end));

end