function C = ftn_capacity(varargin)
% ftn_capacity  Find the the capacity of an FTN communication system.
%

%% Parse inputs.
validScalar = @(x) isnumeric(x) && isscalar(x) && x > 0;
validString = @(x) ischar(x);
validVector = @(x) ~ischar(x) && (size(x, 1) == 1 || size(x, 2) == 1);
validCsi = @(x) any(validatestring(lower(x), {'csir', 'csit'}));
parser = inputParser;
addParameter(parser, 'snr', 0, validVector);
addParameter(parser, 'nFtnStreams', 1, validScalar);
addParameter(parser, 'packetSize', 1, validScalar);
addParameter(parser, 'pulseShape', 'rect', validString);
addParameter(parser, 'architecture', 'regular', validString);
addParameter(parser, 'csi', 'csir', validCsi);
parse(parser, varargin{:});

%% Assign some arguments to variables to improve readability.
snr = parser.Results.snr;
k = parser.Results.nFtnStreams;
n = parser.Results.packetSize;
architecture = lower(parser.Results.architecture);
csi = lower(parser.Results.csi);

%% Check that we are not using CSIT on a channel model that does not support
%% it.
if strcmp(csi, 'csit') && strcmp(architecture, 'regular')
    error('Cannot use CSIT for regular FTN receiver architecture');
end

%% Calculate channel capacity at each SNR.
C = zeros(1, length(snr));
H = channel_matrix('nFtnStreams', k, ...
                   'packetSize', n, ...
                   'pulseShape', parser.Results.pulseShape, ...
                   'architecture', architecture);
for iSnr = 1:length(snr)
    if strcmp(architecture, 'regular')
        C(iSnr) = sum(log2(eig(eye(k * n) + H * 10 ^ (snr(iSnr) / 10)))) / n;
    elseif strcmp(csi, 'csir')
        noiseVariance = 10 ^ (-snr(iSnr) / 10);
        if strcmp(architecture, 'orthogonalized')
            Qz = noiseVariance * eye(k * n + k - 1);
        elseif strcmp(architecture, 'undersampled')
            Qz = noiseVariance * eye(n + 1);
        else
            error('Invalid architecture selection');
        end
        lambdaHy = eig(H * eye(nt * k * n) * H' + Qz);
        lambdaHyx = eig(Qz);
        C(iSnr) = C(iSnr) + sum(log2(lambdaHy)) - sum(log2(lambdaHyx));
    elseif strcmp(csi, 'csit')
        sigma = svd(H);
        p = water_filling(sigma, snr(iSnr));
        C(iSnr) = C(iSnr) + sum( ...
                  log2(1 + 10 ^ (snr(iSnr) / 10) * p .* sigma .^ 2));
    else
        error('Invalid value for csi or architecture');
    end
end

end
