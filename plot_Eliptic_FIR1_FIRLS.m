function [] = plot_Eliptic_FIR1_FIRLS(w_p, w_s, Delta_p, Delta_s, Ts)
%PLOT_ELIPTIC_FIR1_FIRLS Summary of this function goes here
%   Detailed explanation goes here
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_s, Ts);

n = 1500;
[H,w] = freqz(B, A, n);
M_H = M; % ordinul filtrului Butterworth

%Parametrii pentru filtru BTJ:
W = [0 w_p/pi w_s/pi 1]; 
A = [1 1 0 0];
ok1 = 0; ok2 = 0; M1 = 0; M2 = 0; %parametrii while
ok = 0; tol = 1e-3; %toleranta

while ((~ok1) || (~ok2))
    close all;
    if ~ok1
        h1 = fir1(M-1, w_c/pi); %secventa pondere a filtrului Metoda Fereastra
        [H1,w1] = freqz(h1,1,n); %rasp in frecventa
    end
    if ~ok2
        h2 = firls(M-1, W, A); %secventa pondere a filtrului Met celor mai mici patrate
        [H2,w2] = freqz(h2,1,n); %rasp in frecventa
    end
    
    %calculul valorilor din w_p si w_s pt filtrele H1 si H2
    %pozitia din w a lui W_p aproximativ
    H1_w_p = abs(H1(abs(w1-w_p)<tol)); %val lui H1 din w_p_aprox
    %pozitia din w a lui W_s aproximativ
    H1_w_s = abs(H1(abs(w1-w_s)<tol)); %val lui H1 din w_s_aprox
    
    %pozitia din w a lui W_p aproximativ
    H2_w_p = abs(H2(abs(w2-w_p)<tol)); %val lui H2 din w_p_aprox
    %pozitia din w a lui W_s aproximativ
    H2_w_s = abs(H2(abs(w2-w_s)<tol)); %val lui H2 din w_s_aprox
    
    %compararea specificatilor de proiectare, dc nu coincid, ordinul creste
    if ((H1_w_p <= 1) && (H1_w_p >= (1 - (Delta_p+tol))) && (H1_w_s <= (Delta_s+tol))&& (~ok1))
        ok1 = 1;
        M1 = M;
    end
    
    if ((H2_w_p <= 1) && (H2_w_p >= (1 - (Delta_p+tol))) && (H2_w_s <= (Delta_s+tol)) && (~ok2))
        ok2 = 1;
        M2 = M;
    end
    
    M = M + 1;
end

%eliptic:
M = 1;
while (~ok)
    close all;
    
    [B,A] = ellip(M, -db(1-Delta_p), -db(2*Delta_p), w_p/pi);
    [H_ellip, w_ellip] = freqz(B, A, n);
    
    %calculul valorilor din w_p si w_s pt filtrul eliptic H_ellip 
    sol = abs(w_ellip-w_p)<tol; %sol este pozitia din w a lui W_p aproximativ
    H_ellip_w_p = abs(H_ellip(sol)); %val lui H2 din w_p_aprox
    sol = abs(w_ellip-w_s)<tol; %sol este pozitia din w a lui W_s aproximativ
    H_ellip_w_s = abs(H_ellip(sol)); %val lui H2 din w_s_aprox
    
    %compararea specificatilor de proiectare, dc nu coincid, ordinul creste
    if ((H_ellip_w_p <= 1) && (H_ellip_w_p >= (1 - (Delta_p+tol))) && (H_ellip_w_s <= (Delta_s+tol)))
        ok = 1;
    end
    M = M + 1;
end

subplot(2,1,1)
hold on
plot(w, abs(H));
plot(w1, abs(H1));
plot(w2, abs(H2));
plot(w_ellip, abs(H_ellip));
    xline(w_p,'.g');
    xline(w_s,'.r');
    xline(w_c,'.b');
    yline(1,'--');
    yline(1+Delta_p,'--b');
    yline(1-Delta_p,'--g');
    yline(Delta_s,'--r');
    grid on 
title (sprintf('%s', 'Filtru Butterworth, Filtru FIR1, Filtru FIRLS, Filtru Eliptic (Cauer)'));
text (0.2, 0.4, sprintf('ordin M-FIR-Butterworth:%d\nordin M1-FIR1:%d\nordin M2-FIRLS:%d\nordin M_eliptic-Filtru Cauer(Eliptic):%d\ndelta_p:%0.4f\ndelta_s:%0.4f', M_H, M1, M2, M, Delta_p, 2*Delta_p), 'fontsize' , 10, 'color', 'b')
legend ('Metoda pct.A Filtru Butterworth','metoda ferestrei FIR1', 'metoda c.m.m patrate FIRLS', 'filtru eliptic (Cauer)', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere','maxim:1(0dB)', '1+Delta_p', '1-Delta_p', 'Delta_s', 'fontsize' , 8, 'location', 'best', 'LineWidth', 2);
legend('boxoff')
ylabel('Amplitudinea');
xlabel('Pulsatia-w(Hz)');
hold off

subplot(2,1,2)
hold on
plot(w, unwrap(angle(H)));
plot(w, unwrap(angle(H_ellip)));
plot(w, unwrap(angle(H1)));
plot(w, unwrap(angle(H2)));
ylabel('Faza(rad)');
xlabel('Pulsatia-w(Hz)');
grid on
hold off

sprintf('norma (eroarea) relativa a filtrului FIR1 si Butterworth:%0.4f\nnorma (eroarea) relativa a filtrului FIRLS si Butterworth:%0.4f\nnorma (eroarea) relativa a filtrului Eliptic si Butterworth:%0.4f\n', norm(abs(H)-abs(H1)), norm(abs(H)-abs(H2)), norm(abs(H)-abs(H_ellip)))

end

