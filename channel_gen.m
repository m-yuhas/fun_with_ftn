function H = channel_gen(n_t, n_r, k, n, varargin)
% channel_gen  Generate a channel matrix for an FTN-MIMO communication system.
%
%     H = channel_gen(n_t, n_r, k, n, fadetype, pulseshape) generates a
%       channel matrix for an FTN-MIMO system with n_t transmitting antennas,
%       n_r receiving antennas, k FTN streams, and a packet size of n symbols
%       per FTN stream.
fadetype = '';
pulseshape = '';
if size(varargin, 2) == 2
    fadetype = varargin{1};
    pulseshape = varargin{2};
elseif size(varargin, 2) ~= 0
    size(varargin)
    error('Incorrect usage, see help channel_gen for correct args');
end
H = kron(h_mimo(n_t, n_r, fadetype), h_ftn(k, n, pulseshape));
end

function H_FTN = h_ftn(k, n, pulseshape)
% h_ftn  Generate an FTN channel matrix.
%
%     H_FTN = h_ftn(k, n, pulseshape) generates a k * n x k * n FTN channel
%         matrix for k FTN streams, n symbols per FTN stream, and pulse shape
%         'pulseshape'
%
% Supported values for the pulseshape parameter are 'rect'.
row = zeros(1, k * n);
if strcmp(pulseshape, 'rect')
    row(1:k) = (k:-1:1) / k;
else
H_FTN = toeplitz(row);
end
end


function H_MIMO = h_mimo(n_t, n_r, fadetype)
% h_mimo  Generate a MIMO channel matrix.
%
%     H_MIMO = h_mimo(n_t, n_r, fadetype) generates an n_r x n_t MIMO channel
%         matrix for a MIMO system with n_r receiving antennas, n_t
%         transmitting antennas, and a 'fadetype' fading model for multipath
%         channel gains.
%
% Supported values for the fadetype parameter are 'ray'.
if strcmp(fadetype, 'ray')
    H_MIMO = raylrnd(1 / sqrt(pi / 2), n_r, n_t);
else
    H_MIMO = ones(n_r, n_t);
end
end
