function ber_results = run_mimo_sim(Nt, Nr, SNR_dB, total_bits)

snr_lin = 10^(SNR_dB/10);
noise_var = 1/snr_lin;
sigma = sqrt(noise_var/2);

num_sym = ceil(total_bits/Nt);
errs = zeros(5,1);
time_det = zeros(5,1);

% ===== ML CODEBOOK =====
ml_bits = (dec2bin(0:2^Nt-1)-'0')';
ml_syms = (2*ml_bits-1)/sqrt(Nt);

for k = 1:num_sym

    bits = randi([0 1],Nt,1);
    x = (2*bits-1)/sqrt(Nt);

    H = (randn(Nr,Nt)+1j*randn(Nr,Nt))/sqrt(2);
    n = sigma*(randn(Nr,1)+1j*randn(Nr,1));
    y = H*x + n;

    % ================= ZF =================
    tic;
    x_zf = real(pinv(H)*y) > 0;
    time_det(1) = time_det(1) + toc;
    errs(1) = errs(1) + sum(bits ~= x_zf);

    % ================= ZF-SIC =================
    tic;
    x_sic_zf = sic_detect(y,H,Nt,noise_var,'ZF');
    time_det(2) = time_det(2) + toc;
    errs(2) = errs(2) + sum(bits ~= x_sic_zf);

    % ================= ML =================
    tic;
    dist = sum(abs(y - H*ml_syms).^2,1);
    [~,idx] = min(dist);
    time_det(3) = time_det(3) + toc;
    errs(3) = errs(3) + sum(bits ~= ml_bits(:,idx));

    % ================= MMSE =================
    tic;
    Wmmse = (H'*H + noise_var*eye(Nt))\H';
    x_mmse = real(Wmmse*y) > 0;
    time_det(4) = time_det(4) + toc;
    errs(4) = errs(4) + sum(bits ~= x_mmse);

    % ================= MMSE-SIC =================
    tic;
    x_sic_mmse = sic_detect(y,H,Nt,noise_var,'MMSE');
    time_det(5) = time_det(5) + toc;
    errs(5) = errs(5) + sum(bits ~= x_sic_mmse);

end

ber_results = errs/(num_sym*Nt);

assignin('base','Detector_Timing',time_det/num_sym);
end
