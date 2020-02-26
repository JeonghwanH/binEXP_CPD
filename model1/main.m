clear;  clc;
clear global; clear; close all; clc
global setup;
doSetup();
%%
[r4MAP, rs, target_ps, is_accepted] = doMCMC();

K = (min(target_ps));
p = (target_ps - (K));
p = p/sum(p);
r_mean = zeros(size(r4MAP.value));
for j = 1:length(target_ps)
    r_mean = r_mean + rs(j).value * p(j);
end
r_hard = round(r_mean*4,0);
r_hard(r_hard~=0) = 1;
r_hard = make_r(r_hard(2:end));
r_man = MNECP(r_hard);

%% key exponent

k = 4;
B = zeros(r_man.K,k);
for acb = 1:r_man.K
%     keyboard
%     
    t = r_man.tau(acb):r_man.tau(acb+1)-1;
    n = (r_man.tau(acb+1)-r_man.tau(acb));
%     t = r_man.tau(i)+floor(n/4):r_man.tau(i+1)-floor(n/4);
    m(acb) = mean(setup.data(t));
    B(acb,:) = polyfit((t-mean(t))/std(t),setup.data(t)',k-1)';
    
end

c = [1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0, 1, 0, 2, 0, 1, 0]';
%%
n_segs = 60;
F_hist = hist_feature(r_man, n_segs, 0);
F_dist = hist_feature(r_man, n_segs, 1);
%%
idx = c<4;

num_exp = 100;
dic = [1,2,3;1,3,2;2,1,3;2,3,1;3,1,2;3,2,1];

for j = 1:num_exp
    kmc_hist = KMC((F_hist(idx,:)+1)./sum(F_hist(idx,:)+1,2), 3,1000,1);
%     kmc = acc_hist_res{3,i}(44*(j-1)+1:44*(j));
    acc = [];
    for jc = 1:6
        C = confusionmat(c(idx)+1,dic(jc,kmc_hist));
        acc(jc) = sum(diag(C))/sum(sum(C));
    end
%     D = dic(m_c,:);
%     C = confusionmat(c(idx)+1,D(kmc));
    acc_hist(j) = max(acc);
    DB_hist(j) = DBindex(F_hist(idx,:), kmc_hist);
    
    kmc_B = KMC(B(idx,:),3,1000);
%     kmc = acc_B_res{3,i}(44*(j-1)+1:44*(j));
    acc = [];
    for jc = 1:6
        C = confusionmat(c(idx)+1,dic(jc,kmc_B));
        acc(jc) = sum(diag(C))/sum(sum(C));
%         keyboard
    end
    
%     C = confusionmat(c(idx),kmc);
    acc_B(j) = max(acc);
    DB_B(j) = DBindex(B(idx,:), kmc_B);
end

figure();plot(acc_hist,'o'); hold on; plot(DB_hist*max(acc_hist)/max(DB_hist)); legend('accuracy', 'DB index')
figure();plot(acc_B,'o'); hold on; plot(DB_B*max(acc_B)/max(DB_B)); legend('accuracy', 'DB index')



%%
A = tsne(F_hist(idx,:));
figure()
gscatter(A(:,1), A(:,2), kmc_hist, 'rbgk','o*+d')
legend('Location','northeastoutside')
figure()
gscatter(A(:,1), A(:,2), kmc_B, 'rbgk','o*+d')
legend('Location','northeastoutside')
figure()
gscatter(A(:,1), A(:,2), c, 'rbgk','o*+d')
legend(["I","S","M"],'Location','northeastoutside')


%%
figure('Position', [1050 200 550 300])
plot(medianSample(abs(setup.data_wo_noise + setup.noise_add*std(setup.data_wo_noise)*2),1000))
xlabel('t')
% ylabel('magnitude')
xlim([0 length(setup.data)])

figure('Position', [500 500 550 300])
plot(setup.data_wo_noise)
xlabel('t')
% ylabel('magnitude')
xlim([0 length(setup.data_wo_noise)])

figure('Position', [500 200 550 300])
plot(medianSample(abs(setup.data_wo_noise),1000))
xlabel('t')
% ylabel('magnitude')
xlim([0 length(setup.data)])

figure('Position', [1050 500 550 300])
plot(setup.data_wo_noise + setup.noise_add*std(setup.data_wo_noise)*2)
xlabel('t')
% ylabel('magnitude')
xlim([0 length(setup.data_wo_noise)])

%%
figure('Position', [1050 500 550 300])
plot(r_mean)
xlabel('t')
ylabel('p(r_t)')
xlim([0 length(r_mean)])

%%
figure('Position', [1050 500 550 300])
plotR(r_man)
xlabel('t')
% ylabel('power')
xlim([0 length(r_mean)])
%%
figure('Position', [1050 500 550 300])
plotC(r_man,c)
xlim([0 length(r_mean)])
xlabel('t')

