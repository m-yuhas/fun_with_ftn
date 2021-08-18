function C = ftnmimo_capacity(varargin)
%% Parse inputs.
validScalar = @(x) isnumeric(x) && isscalar(x) && x > 0;
validString = @(x) ischar(x);
validVector = @(x) ~ischar(x) && (size(x, 1) == 1 || size(x, 2) == 1);
validCsi = @(x) any(validatestring(lower(x), {'csir', 'csit'}));
parser = inputParser;
addParameter(parser, 'snr', 0, validVector);
addParameter(parser, 'nTransmitAntennas', 1, validScalar);
addParameter(parser, 'nReceiveAntennas', 1, validScalar);
addParameter(parser, 'nFtnStreams', 1, validScalar);
addParameter(parser, 'nChannelInstances', 1, validScalar);
addParameter(parser, 'packetSize', 1, validScalar);
addParameter(parser, 'fadeType', 1, validString);
addParameter(parser, 'pulseShape', 'rect', validString);
addParameter(parser, 'architecture', 'regular', validString);
addParameter(parser, 'csi', 'csir', validCsi);
parse(parser, varargin{:});

%% Assign some arguments to variables to improve readability.
snr = parser.Results.snr;
nt = parser.Results.nTransmitAntennas;
nr = parser.Results.nReceiveAntennas;
k = parser.Results.nFtnStreams;
n = parser.Results.packetSize;
architecture = lower(parser.Results.architecture);
csi = lower(parser.Results.csi);

%% Check that we are not using CSIT on a channel model that does not support
%% it.
if strcmp(csi, 'csit') && strcmp(architecture, 'regular')
    error('Cannot use CSIT for regular FTN-MIMO receiver architecture');
end

% Calculate channel capacity at each snr.
C = zeros(1, length(snr));
for iter = 1:parser.Results.nChannelInstances
    H  = channel_matrix('nTransmitAntennas', nt, ...
                        'nReceiveAntennas', nr, ...
                        'nFtnStreams', k, ...
                        'packetSize', n, ...
                        'fadeType', parser.Results.fadeType, ...
                        'pulseShape', parser.Results.pulseShape, ...
                        'architecture', parser.Results.architecture);
    for iSnr = 1:length(snr)
        noiseVariance = 10 ^ (-snr(iSnr) / 10);
        if strcmp(csi, 'csir')
            if strcmp(architecture, 'regular')
                Hftn = channel_matrix('nFtnStreams', k, ...
                                      'packetSize', n, ...
                                      'fadeType', parser.Results.fadeType);
                Qz = noiseVariance * kron(eye(nr), Hftn) * sqrt(k) / sqrt(nt);
            elseif strcmp(architecture, 'orthogonalized')
                Qz = noiseVariance * eye(k * n + k - 1);
            elseif strcmp(architecture, 'undersampled')
                Qz = noiseVariance * eye(n + 1);
            else
                error('Invalid architecture selection');
            end
            lambdaHy = svd(H * eye(nt * k * n) * H' * sqrt(k) / sqrt(nt) + Qz);
            lambdaHyx = svd(Qz);
            C(iSnr) = C(iSnr) + sum(log2(lambdaHy) - log2(lambdaHyx)) / n;
        elseif strcmp(lower(csi), 'csit')
            sigma = svd(H);
            p = water_filling(sigma, snr(iSnr));
            C(iSnr) = C(iSnr) + sum(log2(1 + p .* sigma .^ 2 / noiseVariance));
        else
            error('Invalid value for csi, must be "csir" or "csit"');
        end
    end
end
C = C / parser.Results.nChannelInstances;

end
