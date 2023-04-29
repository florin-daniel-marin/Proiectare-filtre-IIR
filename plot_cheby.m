function [w1, w2, H1, H2, M1, M2] = plot_cheby(w_p, w_s, Delta_p, Delta_s, Ts)
%PLOT_CHEBY Summary of this function goes here
%   Detailed explanation goes here
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, 2*Delta_p, Ts);
n = 1500;
[H, w] = freqz(B, A, n);
M_H = M; % ordinul filtrului Butterworth
M = 1; ok = 0; tol = 1e-3; %toleranta

while (~ok)
    [B1,A1] = cheby1(M,-db(1-Delta_p),w_p/pi);
    
    [H1, w1] = freqz(B1, A1, n);
    %[H2, w2] = freqz(B2, A2, n);
    
    %calculul valorilor din w_p si w_s pt filtrul eliptic H_ellip 
    sol = abs(w1-w_p)<tol; %sol este pozitia din w a lui W_p aproximativ
    H1_w_p = abs(H1(sol)); %val lui H2 din w_p_aprox
    sol = abs(w1-w_s)<tol; %sol este pozitia din w a lui W_s aproximativ
    H1_w_s = abs(H1(sol));
    
    %compararea specificatilor de proiectare, dc nu coincid, ordinul creste
    if ((H1_w_p <= 1) && (H1_w_p >= (1 - (Delta_p+tol))) && (H1_w_s <= (Delta_s+tol)))
        ok = 1;
        M1 = M;
    end
    M = M + 1;
end

M = 1; ok = 0;

while (~ok)
    [B2, A2] = cheby2(20,-db(Delta_s),w_s/pi);
    [H2, w2] = freqz(B2, A2, n);
    
    %calculul valorilor din w_p si w_s pt filtrul eliptic H_ellip 
    sol = abs(w2-w_p)<tol; %sol este pozitia din w a lui W_p aproximativ
    H2_w_p = abs(H2(sol)); %val lui H2 din w_p_aprox
    sol = abs(w2-w_s)<tol; %sol este pozitia din w a lui W_s aproximativ
    H2_w_s = abs(H2(sol));
    
    %compararea specificatilor de proiectare, dc nu coincid, ordinul creste
    if ((H2_w_p <= 1) && (H2_w_p >= (1 - (Delta_p+tol))) && (H2_w_s <= (Delta_s+tol)))
        ok = 1;
        M2 = M;
    end
    M = M + 1;
end

sprintf('norma (eroarea) relativa a filtrului cheby1 si Butterworth:%0.4f\n', norm(abs(H)-abs(H1)))

end

