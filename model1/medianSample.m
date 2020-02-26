function subsignal = medianSample(data, window_size)

subsignal = zeros(ceil(length(data)/window_size),1);

for i = 1:length(subsignal)
    if i == length(subsignal)
        subsignal(i) = median(data((i-1)*window_size+1 : end));
    else
        subsignal(i) = median(data((i-1)*window_size+1 : i*window_size));
    end
end

end