function [] = plot_faza(w_p, w_s, Delta_p, Delta_s, Ts)
%PLOT_DISPLAY Summary of this function goes here
%   Detailed explanation goes here
n = 1500;
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_s, Ts);
[G,w] = freqz(B,A,n);

plot(w, unwrap(angle(G))) %faza
ylabel('Faza(rad)');
xlabel('Pulsatia-w(Hz)');
title (sprintf('Perioada de esantionare: %0.3f\n Ordinul filtrului:%d', Ts, M), 'fontsize', 7) %legenda
grid
end
