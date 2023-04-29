function [] = digital_freq_display_2(B, B2, A, A2, w_p, w_s, w_c, w_c2, Delta_p, Delta_s, Ts, M, M2, tip_filtru1, tip_filtru2)
%PLOT_DISPLAY Summary of this function goes here
%   Detailed explanation goes here
n = 1000;
[G,w] = freqz(B,A,n);
[G2] = freqz(B2,A2,n);


subplot(2,1,1)
hold on
plot(w, db(abs(G))) %spectrul in db
plot(w, db(abs(G2)))

xline(w_p,'-g', 'pulsatia de trecere');
xline(w_s,'-r', 'pulsatia de stopare');
xline(w_c,'-b', 'pulsatia de taiere');

y1 = yline(db(1),'--b');
y2 = yline(db(1-Delta_p),'--g');
y3 = yline(db(Delta_s),'--r');

title (sprintf('%s si\n%s', tip_filtru1, tip_filtru2));
legend ([y1 y2 y3], {'maxim:0(dB)', 'Mp(1-Delta_p)', 'Delta_s'})
legend('boxoff')
ylabel('Amplitudinea(db)');
xlabel('Pulsatia-w(Hz)');

hold off
grid

subplot(2,1,2) 
hold on
plot(w, unwrap(angle(G)))
plot(w, unwrap(angle(G2))) %faza

ylabel('Faza(rad)');
xlabel('Pulsatia-w(Hz)');
title (sprintf('Perioada de esantionare: %0.3f\n Ordinul filtrelor:%d, %d', Ts, M, M2)) %legenda
hold off
grid
end
