function [w1, w2, H1, H2, M1, M2] = plot_FIR1_FIRLS(w_p, w_s, Delta_p, Delta_s, Ts)
%PLOT_FIR1_FIRLS Summary of this function goes here
%   Detailed explanation goes here
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_s, Ts);
n = 1500;
[H,w] = freqz(B, A, n);
M_H = M; % ordinul filtrului Butterworth
%Parametrii pentru filtru BTJ:
W = [0 w_p/pi w_s/pi 1]; 
A = [1 1 0 0];
ok1 = 0; ok2 = 0; M1 = 0; M2 = 0; %parametrii while
tol = 0.1*1e-2; %toleranta

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

sprintf('norma (eroarea) relativa a filtrului Fir1 si Butterworth:%0.4f\nnorma (eroarea) relativa a filtrului Firls si Butterworth:%0.4f', norm(abs(H)-abs(H1)), norm(abs(H)-abs(H2)))
end

