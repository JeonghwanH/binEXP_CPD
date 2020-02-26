function doSetup()
global setup;
rng(4);

%% data and noise
data = csvread('../data/O_16_500_1.txt',3,0); %3
setup.data_wo_noise = data(638600:2296000); %3

%%
setup.noise_insert = randn(floor([0.1, 1].* size(setup.data_wo_noise)));
setup.noise_add = randn(size(setup.data_wo_noise));
setup.noise_sigma = 1*std(setup.data_wo_noise);
% setup.noise_insert_sigma = 2*std(setup.data_wo_noise);
% setup.or = [[setup.data_wo_noise(1:757300)+setup.noise_sigma*setup.noise_add(1:757300)]; ...
%     setup.noise_insert_sigma*setup.noise_insert; ...
%     [setup.data_wo_noise(757301:end)+ setup.noise_sigma*setup.noise_add(757301:end)]];
setup.data = medianSample(abs(setup.data_wo_noise + setup.noise_add*setup.noise_sigma), 1000);
% setup.data = medianSample(abs(setup.or), 1000);


%% parameters
setup.lambda = 48/(length(setup.data)-1);
setup.sigma = 9.643770988886488e-05;
setup.V = 7.376956456892337e-07;

%% MCMC
setup.nRuns       = 100000;     % Number of samples (iterations)
setup.nBurnins  = 10000;      % Number of runs until the chain approaches stationarity
setup.lag     = 1;        % Thinning or lag period: storing only every lag-th point
setup.acc = 0;
end
