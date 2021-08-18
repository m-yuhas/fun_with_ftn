function p = water_filling(sigma, snr)
% water_filling  Find an optimal power allocation vector 'p' for parallel
%                Gaussian channels with channel gains 'sigma', a vector of
%                singular values of the channel matrix.
%
%     p = water_filling(sigma, snr) returns a power allocation vector 'p' for
%         parallel Gaussian channels with channel gains 'sigma', a vector of
%         singular values of the the channel matrix.  The value at an index of
%         'p' refers to the optimal power allocation for the singular value
%         with the corresponding index in 'sigma'.

noiseVariance = 10 ^ (-snr / 10);
p = zeros(length(sigma), 1);
for iSigma = length(sigma):-1:1
    waterLevel = (1 + noiseVariance * sum(1 / sigma(1:iSigma) .^ 2)) / iSigma;
    if waterLevel - noiseVariance / sigma(iSigma) .^ 2 > 0
        p(1:iSigma) = waterLevel - noiseVariance / sigma(1:iSigma) .^ 2;
        return
    end
end

end
