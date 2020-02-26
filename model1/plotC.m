function plotC(r,c,iny)

global setup;

if nargin < 3
    iny = setup.data;
end
colorstring = ['r','b','g'];
plot(1:length(setup.data), iny,'b-')
hold on;
for i = 1:r.K
    m = mean(iny(r.tau(i):r.tau(i+1)-1));
    hold on;
    plot(r.tau(i):r.tau(i+1)-1, iny(r.tau(i):r.tau(i+1)-1), colorstring((1+c(i))));
end
% keyboard
% stem(r.tau(1:end-1), setup.data(r.tau(1:end-1)), 'BaseValue',5e-4);
% stem(r.tau(1:end-1), ones(size(r.tau(1:end-1)))*14e-4,'BaseValue',5e-4, 'Color', 'k', 'LineWidth', 1,'Marker', 'none');
hold off;
end