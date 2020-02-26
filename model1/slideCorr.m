function mu4Corr = slideCorr(sigma, yy)
global setup;
mu4Corr = [];
rng(1);
switch nargin
    case 0
        yy = setup.data;
    case 1
        yy = setup.data;
        yy = yy + randn(size(yy))*sigma;
    case 2
        yy = yy + randn(size(yy))*sigma;
end
    

disp(std(yy))
% figure(4)
% plot(yy)

len = length(yy);

for win_size=10:5:floor(len/23)
%     keyboard
    sC = xcorr(yy-mean(yy),yy(1:win_size)-mean(yy(1:win_size)));
    sC = sC(len:2*len-win_size,1);
%     figure(1)
%     plot(sC)
    title(string(win_size))
%     figure(2);
%     [pks,locs] = findpeaks(sC,'MinPeakDistance',win_size);
%     [pks,locs] = sort(sC,'descend');
    mu4cor = zeros(44,1);
    [~,I] = sort(sC, 'descend');
    candidate = 1:size(sC,1);
    k = 1;
%     keyboard
    for m = 1:size(mu4cor,1)
        
        while ~ismember(I(k), candidate)
            k = k + 1;
        end
        mu4cor(m) = I(k);
%         keyboard
        candidate = setdiff(candidate,max(1,I(k)-win_size):min(I(k)+win_size,size(sC,1)));
    end
%     keyboard
%     n_ans = size(locs,1) -4;
%     for i = 1:n_ans
%         subplot(n_ans,1,i)
%         plotMU(locs(i:i+4)', 'mean')
%     end
%     figure(3);
%     for i = 1:n_ans
%         subplot(n_ans,1,i)
%         plotMU(locs(i:i+4)')
%     end
%     plotMU(locs(2:end)')
    mu4cor = sort(mu4cor);
    value = zeros(size(yy));
    value(mu4cor) = 1;
%     keyboard
    figure()
    plotR(make_r(value(2:end)))
    
% %     keyboard
%     if ismember(1,mu4cor)
%         figure(2)
%         plotMU(mu4cor(2:end,1)','mean',yy);
%         title("noised mean")
%         figure(3)
%         plotMU(mu4cor(2:end,1)',"original",yy);
%         title("noised original")
%         figure(4)
%         plotMU(mu4cor(2:end,1)','mean', setup.data_wo_noise);
%         title("pure mean")
%         figure(5)
%         plotMU(mu4cor(2:end,1)',"original",setup.data_wo_noise);
%         title("pure original")
%     else
%         n_ans = size(mu4cor,1) -4;
%         figure(2)
%         for i = 1:n_ans
%             subplot(n_ans,1,i)
%             plotMU(mu4cor(i:i+4)', 'mean',yy)
%         end
%         figure(3);
%         for i = 1:n_ans
%             subplot(n_ans,1,i)
%             plotMU(mu4cor(i:i+4)',"original",yy)
%         end
%     end
    
%     pause
%     clf;
    size(mu4cor)
    mu4Corr = [mu4Corr; mu4cor(2:end,:)'];
end

end

