function simulate_capacity(varargin)
% blah blah blah do this later
snrs = 20:-5:5
cm_instances = 1000
nts = 1:1:10
nrs = 1:1:10
ns = 100:1:100
ks = 1:1:10

capacties = zeros(size(snrs, 2), size(nts, 2), size(nrs, 2), size(ns, 2), size(ks, 2));
for snr_idx = 1:size(snrs, 2)
    for inst = 1:cm_instances
        H = channel_gen(n_t, n_r, k, n, 'ray', 'rect');
        for nt_idx = 1:size(nts, 2)
	    for n:

sigsq = 10 ^ (-snr / 10);
capacities = inv(n + (k - 1) / k) * sum(log2(abs(eig(eye(n_t * k * n, n_r * k * n) + H / sigsq))));

save('capacities.mat')
end
