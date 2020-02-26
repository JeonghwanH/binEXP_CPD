function nr = decode_r(r)

CP = extractCP(r);

value = zeros(size(r.value));
value(r.tau(CP)) = 1;
% keyboard
value(r.tau(CP+1)) = 1;
nr = make_r(value(2:length(r.value)));
figure()
plotR(nr)

end