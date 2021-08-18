% This script reproduces plots from the paper:
% On the Capacity of Faster-than-Nyquist MIMO Transmission with CSI at the
% Receiver
% IEEE Globecom, 2015
% 
% Only the figures generated in MATLAB are reproduced here, for information on
% any hand-drawn figures, please contact the author.

% Use the same SNR for  all capacity plots.
snr = -5:5:20;

% Use the same number of channel instances to estimate ergodic capacity for all
% plots.
nChannelInstances = 1e3;

% Use the same packet size for all FTN capacity plots.
packetSize = 1e2;

%% Fig. 5. The channel capacity improvement of a 2x2 MIMO system with increasing
%% FTN signaling rate k=2,3,4,5 compared to a Nyquist rate (k=1) 2x2 MIMO system
%% over SNR = -5 to 20 dB with a packet length 100.
disp('Generating figure 5...');
nFtn = 1:5;
Cfig5 = zeros(length(nFtn), length(snr));
for iFtn = 1:length(nFtn)
    Cfig5(iFtn, :) = ftnmimo_capacity('snr', snr, ...
                                       'nChannelInstances', nChannelInstances, ...
                                       'nTransmitAntennas', 2, ...
                                       'nReceiveAntennas', 2, ...
                                       'nFtnStreams', nFtn(iFtn), ...
                                       'packetSize', packetSize, ...
                                       'fadeType', 'zmsw', ...
                                       'pulseShape', 'rect', ...
                                       'architecture', 'regular');
end
figure(5);
hold on;
plot(snr, Cfig5(1, :), 'r-+');
plot(snr, Cfig5(2, :), 'g-o');
plot(snr, Cfig5(3, :), 'b-*');
plot(snr, Cfig5(4, :), 'c-x');
plot(snr, Cfig5(5, :), 'm-s');
xlabel('SNR (dB)');
ylabel('Bits Per Channel Use');
legend('Nyquist Transmission', ...
       '2xFTN', ...
       '3xFTN', ...
       '4xFTN', ...
       '5xFTN', ...
       'Location', 'northwest');
hold off;

%% Fig. 6. The channel capacity improvement of a Nyquist rate, 2xFTN system
%% (k=2), and 3xFTN system (k=3) with increasing MIMO size (2x2, 3x3, 4x4, and
%% 5x5) at SNR = 5 dB with a packet length 100.
disp('Generating figure 6...');
nFtn = 1:3;
nMimo = 1:5
Cfig6 = zeros(length(nFtn), length(nMimo));
for iFtn = 1:length(nFtn)
  for iMimo = 1:length(nMimo)
    Cfig6(iFtn, iMimo) = ftnmimo_capacity('snr', 5, ...
                                          'nChannelInstances', nChannelInstances, ...
                                          'nTransmitAntennas', nMimo(iMimo), ...
                                          'nReceiveAntennas', nMimo(iMimo), ...
                                          'nFtnStreams', nFtn(iFtn), ...
                                          'packetSize', packetSize, ...
                                          'fadeType', 'zmsw', ...
                                          'pulseShape', 'rect', ...
                                          'architecture', 'regular');
  end
end
figure(6);
hold on;
plot(nMimo, Cfig6(1, :), 'r-+');
plot(nMimo, Cfig6(2, :), 'g-o');
plot(nMimo, Cfig6(3, :), 'b-*');
xlabel('NxN MIMO');
ylabel('Bits Per Channel Use');
legend('Nyquist Rate', ...
       '2xFTN', ...
       '3xFTN', ...
       'Location', 'northwest');
hold off;

