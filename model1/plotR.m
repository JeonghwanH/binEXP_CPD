function plotR(r, iny)
global setup;

if nargin < 2
    iny = setup.data;
end

plot(1:length(setup.data), iny,'b-')
hold on;
for i = 1:r.K
    m = mean(iny(r.tau(i):r.tau(i+1)-1));
    hold on;
    plot(r.tau(i):r.tau(i+1)-1, repmat(m,size(r.tau(i):r.tau(i+1)-1)),'r.');
end
% keyboard
% stem(r.tau(1:end-1), setup.data(r.tau(1:end-1)), 'BaseValue',5e-4);
% stem(r.tau(1:end-1), ones(size(r.tau(1:end-1)))*14e-4,'BaseValue',5e-4, 'Color', 'k', 'LineWidth', 1,'Marker', 'none');
hold off;
end

