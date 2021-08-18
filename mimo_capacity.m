function C = mimo_capacity(varargin)
% mimo_capacity  Find the the capacity of a MIMO communication system.
%

%% Parse inputs.
validScalar = @(x) isnumeric(x) && isscalar(x) && x > 0;
validString = @(x) ischar(x);
validVector = @(x) ~ischar(x) && (size(x, 1) == 1 || size(x, 2) == 1);
validCsi = @(x) any(validatestring(lower(x), {'csir', 'csit'}));
parser = inputParser;
addParameter(parser, 'snr', 0, validVector);
addParameter(parser, 'nChannelInstances', 1, validScalar);
addParameter(parser, 'nTransmitAntennas', 1, validScalar);
addParameter(parser, 'nReceiveAntennas', 1, validScalar);
addParameter(parser, 'fadeType', 'zmsw', validString);
addParameter(parser, 'csi', 'csir', validCsi);
parse(parser, varargin{:});

%% Assign some arguments to variables to improve readability.
snr = parser.Results.snr;
nt = parser.Results.nTransmitAntennas;
nr = parser.Results.nReceiveAntennas;
csi = lower(parser.Results.csi);

%% Calculate channel capacity at each SNR.
C = zeros(1, length(snr));
for iChannelInstance = 1:parser.Results.nChannelInstances
    H = channel_matrix('nTransmitAntennas', nt, ...
                       'nReceiveAntennas', nr, ...
                       'fadeType', parser.Results.fadeType);
    for iSnr = 1:length(snr)
        if strcmp(csi, 'csir')
            lambda = eig(eye(nr) + H * H' * 10 ^ (snr(iSnr) / 10) / nt);
            C(iSnr) = C(iSnr) + sum(log2(lambda));
        elseif strcmp(csi, 'csit')
            sigma = svd(H);
            p = water_filling(sigma, snr(iSnr));
            C(iSnr) = C(iSnr) + sum(log2( ...
                      1 + 10 ^ (snr(iSnr) / 10) * p .* sigma .^ 2));
        else
            error('Invalid value for csi, must be "csir" or "csit"');
            return
        end
    end
end
C = C / parser.Results.nChannelInstances;

end
