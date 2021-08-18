function simulate_capacity(varargin)
% blah blah blah do this later
snrs = 20:-5:5
cm_instances = 1000
nts = 1:1:10
nrs = 1:1:10
ns = 100:1:100
ks = 1:1:10

capacties = zeros(size(snrs, 2), ...
    size(nts, 2), ...
    size(nrs, 2), ...
    size(ns, 2), ...
    size(ks, 2));
params = vector_perms(nts, nrs, ns, ks)
for p = 1:size(params, 1)
    nt = params(p:1);
    nr = params(p:2);
    n = params(p:3);
    k = params(p:4);
    for inst = 1:cm_instances
        H = channel_gen(nt, nr, k, n, 'ray', 'rect');
        for snr = 1:size(snrs, 2)
            svals = svd(eye(n_t * k * n, n_r * k * n) + 10 ^ (snr / 10) * H);
	    sum_log_eigen = sum(log2(svals .^2))
            capacities(snr, nt, nr, n, k) = inv(nt + (k - 1) / k) * sum_log_eigen;
        end
    end
end
capacities = capacities / cm_instances;

end
