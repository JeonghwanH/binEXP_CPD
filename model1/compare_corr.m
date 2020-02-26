W = 100;
asdf = xcorr(setup.data(1:end)-mean(setup.data(1:end)),setup.data(1:W)-mean(setup.data(1:W)));
% asdf = xcorr(setup.data(1:end),setup.data(1:W));
asdf = asdf(length(setup.data):2*length(setup.data)-1);
% plot((asdf-min(asdf))/(max(asdf)-min(asdf)));

figure();
plot((setup.data-min(setup.data))/(max(setup.data)-min(setup.data)))

right_ans = r_man_res_4{16}.tau;

figure('Position', [500 500 550 300])
[~,peaks] = findpeaks(asdf,'MinPeakDistance',20,'MinPeakHeight',0);
findpeaks(asdf,'MinPeakDistance',20,'MinPeakHeight',0);
xlim([0, length(setup.data)])
title('Peaks on cross-covariance')
xlabel('t')

figure('Position', [500 500 550 300])
plot(setup.data,'b')
hold on;
stem(right_ans,max(setup.data)*ones(size(right_ans)),'r','BaseValue',min(setup.data),'Marker','none')
xlim([0, length(setup.data)])
ylim([min(setup.data), max(setup.data)])
xlabel('t')

figure('Position', [500 500 550 300])
plot(setup.data,'b')
hold on;
stem(peaks,max(setup.data)*ones(size(peaks)),'r','BaseValue',min(setup.data),'Marker','none')
xlim([0, length(setup.data)])
ylim([min(setup.data), max(setup.data)])
xlabel('t')

figure('Position', [500 500 550 300])
plot(asdf)
% hold on;
% stem(peaks,max(asdf)*ones(size(peaks)),'BaseValue',min(asdf),'Marker','none')
xlim([0, length(setup.data)])
ylim([min(asdf), max(asdf)])
title('Cross-covariance')
xlabel('t')
%%
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  saveas(FigHandle, string(iFig),'epsc');    %<---- 'Brackets'
end

%%
boundary = [right_ans-3;right_ans-2;right_ans-1;right_ans; right_ans+1;right_ans+2;right_ans+3];
minpeakdistance = 0:20;
precision = zeros(size(minpeakdistance));
sensitivity = zeros(size(minpeakdistance));
for d = 0:20
    [~,peaksy] = findpeaks(asdf,'MinPeakDistance',d,'MinPeakHeight',0);
    precision(d+1) = sum(ismember(peaksy,boundary))/length(peaksy);
    sensitivity(d+1) = sum(ismember(peaksy,boundary))/length(right_ans);
end
    

