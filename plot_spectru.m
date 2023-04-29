function [] = plot_spectru(w_p, w_s, Delta_p, Delta_s, Ts, titlu, legenda)
%PLOT_DISPLAY Summary of this function goes here
%   Detailed explanation goes here
n = 1500;
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_s, Ts);
[G,w] = freqz(B,A,n);

plot(w, abs(G)) %spectrul in db

xline(w_p,'-g');
xline(w_s,'-r');
xline(w_c,'-b');
yline(1,'--');
yline(1+Delta_p,'--b');
yline(1-Delta_p,'--g');
yline(Delta_s,'--r');

title (titlu);
legend (legenda);
text (0.2, -300, sprintf('delta_p:%0.4f\ndelta_s:%0.4f:', Delta_p, Delta_s), 'fontsize' , 6.5, 'color', 'b')
legend('boxoff')
ylabel('Amplitudinea');
xlabel('Pulsatia-w(Hz)');
grid
end
