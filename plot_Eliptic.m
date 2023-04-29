function [w_ellip, H_ellip, M] = plot_Eliptic(w_p, w_s, Delta_p, Delta_s, Ts)
%PLOT_ELIPTIC Summary of this function goes here
%   Detailed explanation goes here
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_s, Ts);
n = 1500;
[H, w] = freqz(B, A, n);
M_H = M; % ordinul filtrului Butterworth
M = 1; ok = 0; tol = 1e-3; %toleranta

while (~ok)
    close all;
    
    [B,A] = ellip(M, -db(1-Delta_p), -db(Delta_s), w_p/pi);
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

sprintf('norma (eroarea) relativa a filtrului Eliptic si Butterworth:%0.4f\n', norm(abs(H)-abs(H_ellip)))

end

