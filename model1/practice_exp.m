%%
K = (min(target_ps));
p = (target_ps - (K));
p = p/sum(p);
r_mean = zeros(size(r4MAP.value));
for i = 1:length(target_ps)
    r_mean = r_mean + rs(i).value * p(i);
end
% r_mean = r_mean/sum(target_ps);
r_hard = round(r_mean*3,0);
% r_hard = round(r_mean,0);
r_hard(r_hard~=0) = 1;
r_hard = make_r(r_hard(2:end));

% figure(); plotR(r_hard,setup.data)
r_d_hard = decode_r(r_hard);
r_man = MNECP(r_hard);
% r_man_est =MNECP(r_hard_est);
%%
k = 4;
B = zeros(r_man.K,k);
for i = 1:r_man.K
%     keyboard
%     
    t = r_man.tau(i):r_man.tau(i+1)-1;
    n = (r_man.tau(i+1)-r_man.tau(i));
%     t = r_man.tau(i)+floor(n/4):r_man.tau(i+1)-floor(n/4);
    m(i) = mean(setup.data(t));
    B(i,:) = polyfit((t-mean(t))/std(t),setup.data(t)',k-1)';
    
end

%%
c = zeros(r_man.K,1);
for i = 1:r_man.K
    if m(i) >  0.67e-03
        c(i) = 2;
    elseif m(i) > 0.5e-03
        c(i) = 1;
    end
end
c(21) = 3;

%%
n_segs = 60;
F_hist = hist_feature(r_man, n_segs, 0);
F_dist = hist_feature(r_man, n_segs, 1);
%%
idx = c<3;

num_exp = 100;
dic = [1,2,3;1,3,2;2,1,3;2,3,1;3,1,2;3,2,1];

for i = 1:num_exp
    kmc = KMC((F_hist(idx,:)+1)./sum(F_hist(idx,:)+1,2), 3,1000,1);
    for j = 1:6
        C = confusionmat(c(idx)+1,dic(j,kmc));
        acc(j) = sum(diag(C))/sum(sum(C));
    end
%     D = dic(m_c,:);
%     C = confusionmat(c(idx)+1,D(kmc));
    acc_hist(i) = max(acc);
    DB_hist(i) = DBindex(F_hist(idx,:), kmc);
    kmc = KMC(B(idx,:),3,1000);
    for j = 1:6
        C = confusionmat(c(idx)+1,dic(j,kmc));
        acc(j) = sum(diag(C))/sum(sum(C));
%         keyboard
    end
    
%     C = confusionmat(c(idx),kmc);
    acc_B(i) = max(acc);
    DB_B(i) = DBindex(B(idx,:), kmc);
end

figure();plot(acc_hist); hold on; plot(DB_hist*max(acc_hist)/max(DB_hist))
figure();plot(acc_B); hold on; plot(DB_B*max(acc_B)/max(DB_B))
%%
dtw_feature = cell(r_man.K,1);
for i = 1:r_man.K
    
    dtw_feature{i} = setup.data(r_man.tau(i):r_man.tau(i+1)-1);
end
kmc = KMC(dtw_feature,3,1000,2);


%%
kmc = KMC(B(idx,:),3,1000);
A = tsne(B(idx,:));
figure()
gscatter(A(:,1), A(:,2), kmc, 'rbgk','o*+d')
legend('Location','northeastoutside')
%%
figure()
kmc = KMC((F_hist(idx,:)+1)./sum(F_hist(idx,:)+1,2), 3,1000,1);
gscatter(A(:,1), A(:,2), kmc,[],'o*+d')
legend('Location','northeastoutside')
% 
% figure()
% gscatter(A(:,1), A(:,2), c(c>0), 'rbgk','o*+d' )
% legend('Location','northeastoutside')
% 
%% making figures

figure; plot(1:length(setup.data),r_man.value); ylim([0 1.2]); 
xlabel('t')
ylabel('p(r_t)')


figure; plot(r_mean)
xlabel('t')
ylabel('p(r_t)')
ylim([1 1900]);
ylim([0 1.1]);
% 
% hold on;
% plot(find(logical(r_man.value)),r_mean(logical(r_man.value)),'o');
% % xlabel('t')
% % ylabel('p(r_t)')


figure; plotR(r_man)

figure();
k=5
plot(setup.data(r_man.tau(k):r_man.tau(k+1)))

%%
num_exp = 100;
figure();
for i = 1:num_exp
    kmc = KMC((F_hist(idx,:)+1)./sum(F_hist(idx,:)+1,2), 2,1000,1);
    C = confusionmat(c(idx),kmc);
    acc_hist(i) = max(C(1,1)+C(2,2),C(1,2)+C(2,1))/sum(sum(C));
    DB_hist(i) = DBindex(F_hist(idx,:), kmc);
    kmc = KMC(B,3,1000);
    C = confusionmat(c(idx),kmc);
    acc_B(i) = max(C(1,1)+C(2,2),C(1,2)+C(2,1))/sum(sum(C));
    DB_B(i) = DBindex(B(idx,:), kmc);
end

tau = r_man.tau;
for i = 1:r_man.K
    for j = 1:r_man.K
        D(i,j) = dtw(setup.data(tau(i):tau(i+1)-1),setup.data(tau(j):tau(j+1)-1));
    end
end

%%

k = 4;
% B = zeros(r_man.K,k);
figure('Position', [1050 500 550 300])
for i = 1:r_man.K
%     keyboard
%     
    t = r_man.tau(i):r_man.tau(i+1)-1;
    time = (t-mean(t))/std(t);
    n = (r_man.tau(i+1)-r_man.tau(i));
%     t = r_man.tau(i)+floor(n/4):r_man.tau(i+1)-floor(n/4);
%     m(i) = mean(setup.data(t));
%     B(i,:) = polyfit(t-mean(t),setup.data(t)',k-1)';
    plot(t, B(i,:)*[time.^3; time.^2; time; ones(size(time))], 'b-')
    hold on
%     plot(t,setup.data(t),'b-')
end
xlim([0 length(r_mean)])
ylim([0 1.45e-3])
figure('Position', [1050 500 550 300])
for i = 1:r_man.K
%     keyboard
%     
    t = r_man.tau(i):r_man.tau(i+1)-1;
    time = t-mean(t);
    n = (r_man.tau(i+1)-r_man.tau(i));
%     t = r_man.tau(i)+floor(n/4):r_man.tau(i+1)-floor(n/4);
%     m(i) = mean(setup.data(t));
%     B(i,:) = polyfit(t-mean(t),setup.data(t)',k-1)';
%     plot(t, B(i,:)*[time.^3; time.^2; time; ones(size(time))], 'r-')
    hold on
    plot(t,setup.data(t),'b-')
end
xlim([0 length(r_mean)])
ylim([0 1.45e-3])