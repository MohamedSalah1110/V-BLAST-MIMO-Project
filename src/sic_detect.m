function d_bits = sic_detect(y, H, Nt, n_var, mode)

r = y;
k_act = 1:Nt;
d_bits = zeros(Nt,1);
H_rem = H;

for i = 1:Nt
    H_curr = H_rem(:,k_act);

    if strcmp(mode,'ZF')
        G = pinv(H_curr);
    else
        G = (H_curr'*H_curr + n_var*eye(length(k_act)))\H_curr';
    end

    [~,row_idx] = min(sum(abs(G).^2,2));
    best_k = k_act(row_idx);

    soft_sym = G(row_idx,:) * r;
    bit = real(soft_sym) > 0;
    d_bits(best_k) = bit;

    sym_rec = (2*bit-1)/sqrt(Nt);
    r = r - H(:,best_k)*sym_rec;

    k_act(row_idx) = [];
end
end
