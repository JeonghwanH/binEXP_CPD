function D = KLDiv(P,Q)
% keyboard
assert(prod(size(P)==size(Q))== 1, 'size of two distributions should be the same');

P = P + 1;
Q = Q + 1;
P = P/sum(P);
Q = Q/sum(Q);

D = sum(P.*(log(P./Q)));
end