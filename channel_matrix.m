function H = channel_matrix(varargin)
% channel_gen  Generate a channel matrix for an FTN-MIMO communication system.
%
%     H = channel_gen(n_t, n_r, k, n, fadetype, pulseshape) generates a
%       channel matrix for an FTN-MIMO system with n_t transmitting antennas,
%       n_r receiving antennas, k FTN streams, and a packet size of n symbols
%       per FTN stream.

%% Declare all variables.
H = 1;
validScalar = @(x) isnumeric(x) && isscalar(x) && x >= 0;
validFadeType = @(x) any(validatestring(lower(x), {'rayleigh', 'zmsw'}));
validPulseShape = @(x) any(validatestring(lower(x), {'rect'}));
validArchitecture = @(x) any(validatestring(lower(x), ...
                             {'regular', 'orthogonalized', 'undersampled'}));
parser = inputParser;

%% Parse input.
addParameter(parser, 'nTransmitAntennas', 0, validScalar);
addParameter(parser, 'nReceiveAntennas', 0, validScalar);
addParameter(parser, 'nFtnStreams', 0, validScalar);
addParameter(parser, 'packetSize', 0, validScalar);
addParameter(parser, 'fadeType', 'zmsw', validFadeType);
addParameter(parser, 'pulseShape', 'rect', validPulseShape);
addParameter(parser, 'architecture', 'regular', validArchitecture);
parse(parser, varargin{:});

%% Construct channel matrix as the Kronecker product of the MIMO and FTN
%% channel matrices.  Note: in the case of MIMO-only or FTN-only, this returns
%% the MIMO channel matrix and FTN channel matrix respectively.
H = kron(h_mimo(parser.Results.nTransmitAntennas, ...
                parser.Results.nReceiveAntennas, ...
                parser.Results.fadeType), ...
         h_ftn(parser.Results.nFtnStreams, ...
               parser.Results.packetSize, ...
               parser.Results.pulseShape, ...
               parser.Results.architecture));

end


function H_FTN = h_ftn(k, n, pulseShape, architecture)
% h_ftn  Generate an FTN channel matrix.
%
%     H_FTN = h_ftn(k, n, pulseshape) generates a k * n x k * n FTN channel
%         matrix for k FTN streams, n symbols per FTN stream, and pulse shape
%         'pulseshape'
%
% Supported values for the pulseshape parameter are 'rect'.
H_FTN = 1;
if ~strcmp(lower(pulseShape), 'rect')
    error('Currently only rectangle pulses are supported');
elseif k <= 0 || n <= 0
    return
elseif strcmp(lower(architecture), 'regular')
    row = zeros(1, k * n);
    row(1:k) = (k:-1:1) / k;
    H_FTN = toeplitz(row);
elseif strcmp(lower(architecture), 'orthogonalized')
    H_FTN = zeros(k * n, k * n + k - 1);
    row = [(1 / k) * ones(1, k), zeros(1, k * n - 1)];
    for iRow = 1:k * n
        H_FTN(iRow, :) = row;
        row = circshift(row, 1, 2);
    end
    H_FTN = H_FTN';
elseif strcmp(lower(architecture), 'undersampled')
    Right = zeros(k * n, n + 1);
    Left = zeros(k * n, n + 1);
    rightColumn = zeros(k * n, 1);
    rightColumn(1:k) = (k:-1:1) / k;
    leftColumn = zeros(k * n, 1);
    leftColumn(end - k + 2:end) = (1:k - 1) / k;
    for iColumn = 1:n
        Right(:, iColumn) = rightColumn;
        rightColumn = circshift(rightColumn, k, 1);
        Left(:, end - iColumn + 1) = leftColumn;
        leftColumn = circshift(leftColumn, -k, 1);
    end
    H_FTN = Right + Left;
    H_FTN = H_FTN';
else
    error('Invalid FTN receiver architecture selection');
end
H_FTN = H_FTN / max(1, k);

end


function H_MIMO = h_mimo(nTransmitters, nReceivers, fadeType)
% h_mimo  Generate a MIMO channel matrix.
%
%     H_MIMO = h_mimo(n_t, n_r, fadetype) generates an n_r x n_t MIMO channel
%         matrix for a MIMO system with n_r receiving antennas, n_t
%         transmitting antennas, and a 'fadetype' fading model for multipath
%         channel gains.
%
% Supported values for the fadetype parameter are 'ray'.
H_MIMO = 1;
if nTransmitters <= 0 || nReceivers <= 0
    return
elseif strcmp(lower(fadeType), 'rayleigh')
    H_MIMO = raylrnd(1 / sqrt(pi / 2), nReceivers, nTransmitters);
elseif strcmp(lower(fadeType), 'zmsw')
    H_MIMO = randn(nReceivers, nTransmitters);
else
    error('Invalid fading model provided');
end

end
