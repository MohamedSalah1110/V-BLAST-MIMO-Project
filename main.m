%% V-BLAST MIMO Project 
addpath('src');

clc; clear; close all;

Nt = 3;
total_bits = 6e5;

detectors = {'ZF','ZF-SIC','ML','MMSE','MMSE-SIC'};
colors = {'r','g','b','m','k'};

%% -------- Part 1: BER vs Nr --------
SNR_fixed = 10;
Nr_range = 3:6;
BER_vs_Nr = zeros(length(detectors), length(Nr_range));

for i = 1:length(Nr_range)
    Nr = Nr_range(i);
    fprintf('Simulating Nr = %d\n', Nr);
    BER_vs_Nr(:,i) = run_mimo_sim(Nt, Nr, SNR_fixed, total_bits);
end

%% -------- Part 2: BER vs SNR --------
Nr_fixed = 3;
SNR_range = 0:2:20;
BER_vs_SNR = zeros(length(detectors), length(SNR_range));

for i = 1:length(SNR_range)
    snr = SNR_range(i);
    fprintf('Simulating SNR = %d dB\n', snr);
    BER_vs_SNR(:,i) = run_mimo_sim(Nt, Nr_fixed, snr, total_bits);
end

%% -------- Plot Results --------
figure;
for d = 1:length(detectors)
    semilogy(Nr_range, BER_vs_Nr(d,:), [colors{d} 'o-'],'LineWidth',2);
    hold on;
end
grid on;
xlabel('Number of Receive Antennas');
ylabel('BER');
title('BER vs Nr (SNR = 10 dB)');
legend(detectors);
