% This script reproduces plots from the thesis:
% Capacity Analysis of Faster-Than-Nyquist MIMO Systems
% McGill University (Canada), 2017
% 
% Only the figures generated in MATLAB are reproduced here, for information on
% any hand-drawn figures, please contact the author.  Any novel contributions
% appearing in the thesis can be verified with this script.

% Use the same SNR for  all capacity plots.
snr = -5:5:20;

% Use the same number of channel instances to estimate ergodic capacity for all
% plots.
nChannelInstances = 1e3;

% Use the same packet size for all FTN capacity plots.
packetSize = 1e2;

%% Figure 3. Example of transmitted pulses in Nyquist rate and time-domain
%% systems
disp('Generating figure 3...');
t = -5:1e-3:5;
figure(3);
subplot(2,1,1);
hold on;
for tau = -3:1:3
    plot(t, sinc(t + tau), 'b-');
end
line([0, 0], [-0.4, 1], 'Color', 'k', 'LineStyle', '--');
line([1, 1], [-0.4, 1], 'Color', 'k', 'LineStyle', '--');
title('Orthogonal Transmission Using Sinc Pulses');
xlabel('t (samples)');
ylabel('sinc(t)');
subplot(2,1,2);
hold on;
for tau = -3:1:3
    plot(t, sinc(t + 0.75 * tau), 'b-');
end
line([0, 0], [-0.4, 1], 'Color', 'k', 'LineStyle', '--');
line([0.75, 0.75], [-0.4, 1], 'Color', 'k', 'LineStyle', '--');
title('Non-Orthogonal Transmission Using Faster-Than-Nyquist Signaling');
xlabel('t (samples)');
ylabel('sinc(t)');
hold off;

%% Figure 6. Capacity comparison of MIMO systems with n_t=n_r=1...10
disp('Generating figure 6...');
nAntennas = 1:10;
Cfig6 = zeros(length(nAntennas), length(snr));
for iAnt = 1:length(nAntennas)
    Cfig6(iAnt, :) = mimo_capacity('snr', snr, ...
                                   'nChannelInstances', nChannelInstances, ...
                                   'nTransmitAntennas', nAntennas(iAnt), ...
                                   'nReceiveAntennas', nAntennas(iAnt), ...
                                   'fadeType', 'zmsw', ...
                                   'csi', 'csir');
end
figure(6);
hold on;
plot(snr, Cfig6(1, :), 'r-+');
plot(snr, Cfig6(2, :), 'g-o');
plot(snr, Cfig6(3, :), 'b-*');
plot(snr, Cfig6(4, :), 'c-x');
plot(snr, Cfig6(5, :), 'm-s');
plot(snr, Cfig6(6, :), 'y-+');
plot(snr, Cfig6(7, :), 'c-o');
plot(snr, Cfig6(8, :), 'r-*');
plot(snr, Cfig6(9, :), 'g-x');
plot(snr, Cfig6(10, :), 'b-s');
xlabel('Capacity (Bits / Sec / Hz)');
ylabel('SNR (dB)');
legend('SISO', ...
       '2x2 MIMO', ...
       '4x4 MIMO', ...
       '5x5 MIMO', ...
       '6x6 MIMO', ...
       '7x7 MIMO', ...
       '8x8 MIMO', ...
       '9x9 MIMO', ...
       '10x10 MIMO', ...
       'Location', 'northwest');
hold off;

%% Figure 7. Capacity comparison of MISO systems for n_t=1...10
disp('Generating figure 7...');
nTx = 1:10;
Cfig7 = zeros(length(nTx), length(snr));
for iTx = 1:length(nTx)
    Cfig7(iTx, :) = mimo_capacity('snr', snr, ...
                                  'nChannelInstances', nChannelInstances, ...
                                  'nTransmitAntennas', nTx(iTx), ...
                                  'nReceiveAntennas', 1, ...
                                  'fadeType', 'zmsw', ...
                                  'csi', 'csir');
end
figure(7);
hold on;
plot(snr, Cfig7(1, :), 'r-+');
plot(snr, Cfig7(2, :), 'g-o');
plot(snr, Cfig7(3, :), 'b-*');
plot(snr, Cfig7(4, :), 'c-x');
plot(snr, Cfig7(5, :), 'm-s');
plot(snr, Cfig7(6, :), 'y-+');
plot(snr, Cfig7(7, :), 'c-o');
plot(snr, Cfig7(8, :), 'r-*');
plot(snr, Cfig7(9, :), 'g-x');
plot(snr, Cfig7(10, :), 'b-s');
xlabel('Capacity (Bits / Sec / Hz)');
ylabel('SNR (dB)');
legend('SISO', ...
       '2x1 MIMO', ...
       '3x1 MIMO', ...
       '4x1 MIMO', ...
       '5x1 MIMO', ...
       '6x1 MIMO', ...
       '7x1 MIMO', ...
       '8x1 MIMO', ...
       '9x1 MIMO', ...
       '10x1 MIMO', ...
       'Location', 'northwest');
hold off;

%% Figure 8. Capacity comparison of SIMO systems for n_r=1...10
disp('Generating figure 8...');
nRx = 1:10;
Cfig8 = zeros(length(nRx), length(snr));
for iRx = 1:length(nRx)
    Cfig8(iRx, :) = mimo_capacity('snr', snr, ...
                                  'nChannelInstances', nChannelInstances, ...
                                  'nReceiveAntennas', nRx(iRx), ...
                                  'fadeType', 'zmsw', ...
                                  'csi', 'csir');
end
figure(8);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig8(2, :), 'g-o');
plot(snr, Cfig8(3, :), 'b-*');
plot(snr, Cfig8(4, :), 'c-x');
plot(snr, Cfig8(5, :), 'm-s');
plot(snr, Cfig8(6, :), 'y-+');
plot(snr, Cfig8(7, :), 'c-o');
plot(snr, Cfig8(8, :), 'r-*');
plot(snr, Cfig8(9, :), 'g-x');
plot(snr, Cfig8(10, :), 'b-s');
xlabel('Capacity (Bits / Sec / Hz)');
ylabel('SNR (dB)');
legend('SISO', ...
       '1x2 MIMO', ...
       '1x3 MIMO', ...
       '1x4 MIMO', ...
       '1x5 MIMO', ...
       '1x6 MIMO', ...
       '1x7 MIMO', ...
       '1x8 MIMO', ...
       '1x9 MIMO', ...
       '1x10 MIMO', ...
       'Location', 'northwest');
hold off;

%% Figure 9. Capacity comparison of a SISO system, 1x2 SIMO, 2x1 MISO, and a
%% 2x2 MIMO system
disp('Generating figure 9...');
figure(9);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig8(2, :), 'g-o');
plot(snr, Cfig7(2, :), 'b-*');
plot(snr, Cfig6(2, :), 'c-x');
xlabel('Capacity (Bits / Sec / Hz)');
ylabel('SNR (dB)');
legend('SISO', ...
       '1x2 MIMO', ...
       '2x1 MIMO', ...
       '2x2 MIMO', ...
       'Location', 'northwest');
hold off;

%% Figure 10. Graphical representation of the water filling algorithm: the
%% height of each parallel Gaussian channel corresponds to the inverse of its
%% SNR and the water level corresponds to the power allocated to each channel
% 
%% Note:
%% The y-axis label in the thesis is misleading.  What is plotted is not 1/SNR,
%% but the inverse of the singular values of the channel matrix.  Regardless,
%% the graph still illustrates that more power should be allocated to the
%% parallel Gaussian channel with the highest SNR.  You can find the SNR for an
%% individual parallel Gaussian channel given its singular value using the
%% formula: SNR = 10*log10(sig_i/sig^2), where sig_i is the singular value and
%% sig^2 is the noise variance.
disp('Generating figure 10...');
H = channel_matrix('nTransmitAntennas', 10, ...
                   'nReceiveAntennas', 10, ...
                   'fadeType', 'zmsw');
parallelGaussianChannels = 1 ./ svd(H);
figure(10);
hold on;
bar(parallelGaussianChannels, 'b');
line([0, 10.5], ...
     [parallelGaussianChannels(8), parallelGaussianChannels(8)], ...
     'LineStyle', '-', ...
     'Color', 'r');
text(0.1, parallelGaussianChannels(8) + 0.1, 'Water level');
xlabel('Parallel Gaussian Channels');
ylabel('1/SNR');
axis([0, 10.5, 0, 6]);
hold off;

%% Figure 11. Comparison of MIMO systems with the same number of transmitters
%% and receivers for CSIR and CSIT
disp('Generating figure 11...');
nAnt = 2:2:8;
Cfig11 = zeros(length(nAnt), length(snr));
for iAnt = 1:length(nAnt)
    Cfig11(iAnt, :) = mimo_capacity('snr', snr, ...
                                    'nChannelInstances', nChannelInstances, ...
                                    'nTransmitAntennas', nAnt(iAnt), ...
                                    'nReceiveAntennas', nAnt(iAnt), ...
                                    'fadeType', 'zmsw', ...
                                    'csi', 'csit');
end
figure(11);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig6(2, :), 'b-*');
plot(snr, Cfig11(1, :), 'b--*');
plot(snr, Cfig6(4, :), 'c-x');
plot(snr, Cfig11(2, :), 'c--x');
plot(snr, Cfig6(6, :), 'm-+');
plot(snr, Cfig11(3, :), 'm--+');
plot(snr, Cfig6(8, :), 'g-x');
plot(snr, Cfig11(4, :), 'g--x');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('SISO', ...
       '2x2 MIMO CSIR',
       '2x2 MIMO CSIT',
       '4x4 MIMO CSIR',
       '4x4 MIMO CSIT',
       '6x6 MIMO CSIR',
       '6x6 MIMO CSIT',
       '8x8 MIMO CSIR',
       '8x8 MIMO CSIT',
       'Location', 'northwest');
hold off;

%% Figure 12. Comparison of MIMO systems with the more transmitting antennas
%% than receiving antennas for CSIR and CSIT
disp('Generating figure 12...');
nTx = 2:2:8;
Cfig12 = zeros(length(nTx), length(snr));
for iTx = 1:length(nTx)
    Cfig12(iTx, :) = mimo_capacity('snr', snr, ...
                                   'nChannelInstances', nChannelInstances, ...
                                   'nTransmitAntennas', nTx(iTx), ...
                                   'nReceiveAntennas', 1, ...
                                   'fadeType', 'zmsw', ...
                                   'csi', 'csit');
end
figure(12);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig7(2, :), 'g-o');
plot(snr, Cfig12(1, :), 'g--o');
plot(snr, Cfig7(4, :), 'c-x');
plot(snr, Cfig12(2, :), 'c--x');
plot(snr, Cfig7(6, :), 'y-+');
plot(snr, Cfig12(3, :), 'y--+');
plot(snr, Cfig7(8, :), 'r-*');
plot(snr, Cfig12(4, :), 'r--*');
xlabel('SNR (dB)')
ylabel('Capacity (Bits / Sec / Hz');
legend('SISO', ...
       '2x1 MIMO CSIR', ...
       '2x1 MIMO CSIT', ...
       '4x1 MIMO CSIR', ...
       '4x1 MIMO CSIT', ...
       '6x1 MIMO CSIR', ...
       '6x1 MIMO CSIT', ...
       '8x1 MIMO CSIR', ...
       '8x1 MIMO CSIT', ...
       'Location', 'northwest');
hold off;

%% Figure 13. Comparison of MIMO Systems with more receiving antennas than
%% transmitting antennas for CSIR and CSIT
%%
%% Errata: In the thesis the label '1x9 MIMO CSIT' is incorrect, this should be
%% '1x8 MIMO CSIT'.
disp('Generating figure 13...');
nRx = 2:2:8;
Cfig13 = zeros(length(nRx), length(snr));
for iRx = 1:length(nRx)
    Cfig13(iRx, :) = mimo_capacity('snr', snr, ...
                                   'nChannelInstances', nChannelInstances, ...
                                   'nTransmitAntennas', 1, ...
                                   'nReceiveAntennas', nRx(iRx), ...
                                   'fadeType', 'zmsw', ...
                                   'csi', 'csit');
end
figure(13);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig8(2, :), 'g-o');
plot(snr, Cfig13(1, :), 'g--o');
plot(snr, Cfig8(4, :), 'c-x');
plot(snr, Cfig13(2, :), 'c--x');
plot(snr, Cfig8(6, :), 'y-+');
plot(snr, Cfig13(3, :), 'y--+');
plot(snr, Cfig8(8, :), 'r-*');
plot(snr, Cfig13(4, :), 'r--*');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('SISO', ...
       '1x2 MIMO CSIR', ...
       '1x2 MIMO CSIT', ...
       '1x4 MIMO CSIR', ...
       '1x4 MIMO CSIT', ...
       '1x6 MIMO CSIR', ...
       '1x6 MIMO CSIT', ...
       '1x8 MIMO CSIR', ...
       '1x8 MIMO CSIT', ...
       'Location', 'northwest');
hold off;

%% Figure 14. Comparison of a SISO system, 1x2 MIMO with CSIR, 2x1 MIMO with
%% CSIR, 2x2 MIMO with CSIR, 1x2 MIMO with CSIT, 2x1 MIMO with CSIT, and 2x2
%% MIMO with CSIT
%%
%% Errata: In the thesis the trace labels are incorrect.  Please refer to the
%% labels and corresponding traces generated by this script.
disp('Generating figure 14...');
figure(14);
hold on;
plot(snr, Cfig8(1, :), 'r-+');
plot(snr, Cfig8(2, :), 'g-o');
plot(snr, Cfig7(2, :), 'b-*');
plot(snr, Cfig6(2, :), 'c-x');
plot(snr, Cfig13(1, :), 'g--o');
plot(snr, Cfig12(1, :), 'b--*');
plot(snr, Cfig11(1, :), 'c--x');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('SISO', ...
       '1x2 MIMO CSIR', ...
       '2x1 MIMO CSIR', ...
       '2x2 MIMO CSIR', ...
       '1x2 MIMO CSIT', ...
       '2x1 MIMO CSIT', ...
       '2x2 MIMO CSIT', ...
       'Location', 'northwest');
hold off;

%% Figure 18. Capacities of FTN systems from k=1...10
disp('Generating figure 18...');
nFtn = 1:10;
C = zeros(length(nFtn), length(snr));
for iFtn = 1:length(nFtn)
    Cfig18(iFtn, :) = ftn_capacity('snr', snr,
                                   'nFtnStreams', nFtn(iFtn), ...
                                   'packetSize', packetSize, ...
                                   'pulseShape', 'rect', ...
                                   'architecture', 'regular', ...
                                   'csi', 'csir');
end
figure(18);
hold on;
plot(snr, Cfig18(1, :), 'r-+');
plot(snr, Cfig18(2, :), 'g-o');
plot(snr, Cfig18(3, :), 'b-*');
plot(snr, Cfig18(4, :), 'c-x');
plot(snr, Cfig18(5, :), 'm-s');
plot(snr, Cfig18(6, :), 'y-+');
plot(snr, Cfig18(7, :), 'c-o');
plot(snr, Cfig18(8, :), 'r-*');
plot(snr, Cfig18(9, :), 'g-x');
plot(snr, Cfig18(10, :), 'b-s');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('Nyquist Rate', ...
       '2xFTN', ...
       '3xFTN', ...
       '4xFTN', ...
       '5xFTN', ...
       '6xFTN', ...
       '7xFTN', ...
       '8xFTN', ...
       '9xFTN', ...
       '10xFTN', ...
       'Location', 'northwest');
hold off;

%% Figure 20. Capacity of a 2x2 MIMO System with FTN rates k=1...5
disp('Generating figure 20...');
nFtn = 2:5;
C = zeros(length(nFtn), length(snr));
for iFtn = 1:length(nFtn)
    Cfig20(iFtn, :) = ftnmimo_capacity('snr', snr, ...
                                       'nChannelInstances', nChannelInstances, ...
                                       'nTransmitAntennas', 2, ...
                                       'nReceiveAntennas', 2, ...
                                       'nFtnStreams', nFtn(iFtn), ...
                                       'packetSize', packetSize, ...
                                       'fadeType', 'zmsw', ...
                                       'pulseShape', 'rect', ...
                                       'architecture', 'regular');
end
figure(20);
hold on;
plot(snr, Cfig6(2, :), 'r-+');
plot(snr, Cfig20(1, :), 'g-o');
plot(snr, Cfig20(2, :), 'b-*');
plot(snr, Cfig20(3, :), 'c-x');
plot(snr, Cfig20(4, :), 'm-s');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('Nyquist Transmission', ...
       '2xFTN', ...
       '3xFTN', ...
       '4xFTN', ...
       '5xFTN', ...
       'Location', 'northwest');
hold off;

%% Figure 21. Capacities of a 2xFTN system for various MIMO configurations
disp('Generating figure 21...');
nAnt = 2:5;
C = zeros(length(nAnt), length(snr));
for iAnt = 1:length(nAnt)
    Cfig21(iAnt, :) = ftnmimo_capacity('snr', snr, ...
                                      'nChannelInstances', nChannelInstances, ...
                                      'nTransmitAntennas', iAnt, ...
                                      'nReceiveAntennas', iAnt, ...
                                      'nFtnStreams', 2, ...
                                      'packetSize', packetSize, ...
                                      'fadeType', 'zmsw', ...
                                      'pulseShape', 'rect', ...
                                      'architecture', 'regular');
end
figure(21);
hold on;
plot(snr, Cfig18(2, :), 'r-+');
plot(snr, Cfig21(1, :), 'g-o');
plot(snr, Cfig21(2, :), 'b-*');
plot(snr, Cfig21(3, :), 'c-x');
plot(snr, Cfig21(4, :), 'm-s');
xlabel('SNR (dB)');
ylabel('Capacity (Bits / Sec / Hz');
legend('SISO', ...
       '2x2 MIMO', ...
       '3x3 MIMO', ...
       '4x4 MIMO', ...
       '5x5 MIMO', ...
       'Location', 'northwest');
hold off;





pause;
