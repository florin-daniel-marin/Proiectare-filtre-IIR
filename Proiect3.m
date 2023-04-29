close all; clc; clear;
%% Faza 1 Filtru Butterworth - a. 
[w_p, w_s, Delta_p, Ts] = PS_PRJ_3_Faza_1a(1,15);

[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, Delta_p, Ts);
titlu = 'Filtru Butterworth'; 
legenda = {'Filtru Butterworth', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere', 'maxim:0(dB)', '1+Delta_p', '1-Delta_p', 'Delta_s'};
figure
subplot(2,1,1)
hold on
plot_spectru(w_p, w_s, Delta_p, Delta_p, Ts, titlu, legenda);
text (0.2, 0.2, sprintf('delta_p:%0.4f\ndelta_s:%0.4f:', Delta_p, Delta_p), 'fontsize' , 6.5, 'color', 'b')
hold off
    
subplot(2,1,2)
hold on
plot_faza(w_p, w_s, Delta_p, Delta_p, Ts);
hold off

%% Faza 1 punctul - b
close all;
[B_pseudo,A_pseudo,w_c_pseudo,M_pseudo] = But_FTI_FAZA1B(w_p, w_s, Delta_p, Delta_p, Ts);
digital_freq_display_2(B, B_pseudo, A, A_pseudo, w_p, w_s, w_c, w_c_pseudo, Delta_p, Delta_p, Ts, M, M_pseudo, 'Filtru Butterworth', 'filtru Butterworth cu transf. pseudo-Biliniara');
%graficile sunt identice pentru functia de
%transfer digitala a Butterworth, obtinuta prin ambele metode: Biliniara
%(2/Ts) si pseudo-biliniara (1/Ts)

%% Faza 1 punctul - c
close all;
Ts_info = ["Ts" "0.1*Ts" "Ts/4" "Ts/2" "3*Ts/4" "5*Ts/4" "7*Ts/4" "9*Ts/4" "3*Ts"];
Tsc = ones(1,9);
Tsc(1) = 0.1*Ts;
Tsc(2) = Ts/4; 
Tsc(3) = Ts/2; 
Tsc(4) = 3*Ts/4;
Tsc(5) = 5*Ts/4; 
Tsc(6) = 7*Ts/4;
Tsc(7) = 9*Ts/4;
Tsc(8) = 3*Ts;
Tsc(9) = Ts;

% Display toate cele 8 grafice cu timpul de esantionare diferite:
figure
hold on
for i = 1 : 9 
    subplot(2,1,1)
    hold on
    plot_spectru(w_p, w_s, Delta_p, Delta_p, Tsc(i), 'filtre Butterworth cu perioade de esantionare diferite, care nu afecteaza FT discret', legenda);
    hold off
    
    subplot(2,1,2)
    hold on
    plot_faza(w_p, w_s, Delta_p, Delta_p, Tsc(i));
    hold off
end
legend (Ts_info, 'location', 'southwest')
hold off
% Functia de transfer a filtrului discret nu depinde de perioada de
% esantionare Ts, dupa cum am vazut mai sus. Matematic, la punctul b am
% aratat ca 1/Ts si 2/Ts au dat acelasi grafic. Schimbarea este echivalenta
% cu Ts_pseudo-Tustin = 2*Ts.

%% Faza 1 punctul - d
close all;
delta_info = ["Delta_p/2" "Delta_p" "3*Delta_p/2" "2*Delta_p" "Delta_s/2" "Delta_s" "3*Delta_s/2" "2*Delta_s"];
delta_p(1) = Delta_p/2;
delta_p(2) = Delta_p;
delta_p(3) = 3*Delta_p/2;
delta_p(4) = 2*Delta_p;

delta_s(1) = Delta_p/2;
delta_s(2) = Delta_p;
delta_s(3) = 3*Delta_p/2;
delta_s(4) = 2*Delta_p;
k = 1; l = 1;

%Figura 1: 16 plot-uri, pentru delta_p < delta_p initial

figure('name', 'Proiectarea filtrelor Butterworth prin variatia tolerantelor 1');
for i = 1 : 2
    for j = 1 : 4
        subplot(4,4,k)
        hold on
        plot_spectru(w_p, w_s, delta_p(i), delta_s(j), Ts, int2str(l), 'functia');
        hold off

        subplot(4,4,k+1)
        hold on
        plot_faza(w_p, w_s, delta_p(i), delta_s(j), Ts);
        text (0.5, -10, [delta_info(i), delta_info(4+j)])
        hold off
        
        l = l + 1;
        k = k + 2;
    end
end

subplot(4,4,1)
hold on
legend(legenda)
hold off

%Figura 2: 16 plot-uri, pentru delta_p > delta_p initial
k = 1; 
l = 1;

figure('name', 'Proiectarea filtrelor Butterworth prin variatia tolerantelor 2');

for i = 3 : 4
    for j = 1 : 4
        subplot(4,4,k)
        hold on
        plot_spectru(w_p, w_s, delta_p(i), delta_s(j), Ts, int2str(l), 'functia');
        hold off

        subplot(4,4,k+1)
        hold on
        plot_faza(w_p, w_s, delta_p(i), delta_s(j), Ts);
        text (0.5, -10, [delta_info(i), delta_info(4+j)])
        hold off
        
        l = l + 1;
        k = k + 2;
    end
end

subplot(4,4,1)
hold on
legend(legenda)
hold off
%Ordinul filtrului este invers proportional cu delta_p si delta_s, astfel,
%observam in figura 1, pe poz stanga-sus se afla filtrul cu ordinul cel mai
%mare, iar pe poz dreapta-jos din figura 2, filtrul cu ordinul cel mai mic.

%Filtrul cu ordinul cel mai mare are delta_p si delta_s cele mai mici, iar
%filtrul cu ordinul cel mai mic, invers.

%Filtrul cel mai bun, are caracteristica foarte aproape de cea ideala, iar
%ordinul minim, conditii ce in practica se contrazic. 

%Deci filtrul cel mai bun se afla la mijloc, cu valori ale ordinului intre:
%20 si 30 din simularile efectuate, adica delta_p si delta_s cele mai bune
%sunt intre (0.04 si 0.09)

%% Faza 1 punctul - e
close all; clc; clear;
[w_p, w_s, Delta_p, Ts] = PS_PRJ_3_Faza_1a(1,15);
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, 2*Delta_p, Ts);

%Filtrul Butterworth ca la punctul A, pentru comparatie cu celelalte 2 filtre:
titlu = 'Proiectarea filtrelor prin 3 metode; compararea filtrelor dupa ordinul minim';
legenda = {'metoda ferestrei FIR1', 'metoda c.m.m patrate FIRLS', 'Metoda pct.A Filtru Butterworth', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere', 'maxim:1(0dB)', '1+Delta_p', 'Mp(1-Delta_p)', 'Delta_s'};


[w1, w2, H1, H2, M1, M2] = plot_FIR1_FIRLS(w_p, w_s, Delta_p, Delta_p, Ts);

figure
subplot (2,1,1)
hold on
plot(w1, abs(H1));
plot(w2, abs(H2));
plot_spectru(w_p, w_s, Delta_p, Delta_p, Ts, titlu, legenda);
text (0.2, 0.4, sprintf('ordin M-FIR-Butterworth:%d\nordin M1-FIR1:%d\nordin M2-FIRLS:%d\ndelta_p:%0.4f\ndelta_s:%0.4f', M, M1, M2 , Delta_p, Delta_p), 'fontsize' , 10, 'color', 'b')
hold off

subplot (2,1,2)
hold on
plot(w1, unwrap(angle(H1)));
plot(w2, unwrap(angle(H2))); %faza
plot_faza(w_p, w_s, Delta_p, Delta_p, Ts);
hold off

%Comentariu: Filtrul Butterworth implementat la punctul A este ideal,
%deoarece ordinul este mic, iar caracteristica este suficient de apropiata
%de filtrul trece jos ideal. 

%In comparatie cu celelalte metode: Butterworth are ordinul intre 10-60
%Metoda c.m.m.p. intre 30-90, iar metoda ferestrei 90-300.

%Comp cu filtrul ideal: metoda ferestrei - cel mai aproape de filtru IDEAL
%metoda cmmp, chiar daca are ord mai mare decat BW, BW este mai apropiat de
%filtru IDEAL, chiar cu ordinul filtrului de 2, 3 ori mai mic decat metoda
%cmmp.

%Pe locul 2 este filtru prin metoda CMMP, are ordin relativ mic si
%caracteristica apropiata de filtru Butterworth (se vede din norma)

%% Faza 2 - a PPTFI cu filtre Cauer si Cebisev
close all; clc; clear;
[w_p, w_s, Delta_p, Ts] = PS_PRJ_3_Faza_1a(1,15);
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, 2*Delta_p, Ts);

%Filtrul Butterworth ca la punctul A, pentru comparatie cu filtrul eliptic:
titlu = 'Filtrul trece jos Cauer(eliptic) de ordin minim care indeplineste urm. spec. de proiectare, comparat cu filtrul Butterworth:';
legenda = {'Filtrul eliptic', 'Metoda pct.A Filtru Butterworth', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere','maxim:0(dB)', '1+Delta_p', '1-Delta_p', 'Delta_s', 'location', 'best'};

[w_ellip, H_ellip, M_ellip] = plot_Eliptic(w_p, w_s, Delta_p, 2*Delta_p, Ts);

figure
subplot (2,1,1)
hold on
plot(w_ellip, abs(H_ellip));
plot_spectru(w_p, w_s, Delta_p, 2*Delta_p, Ts, titlu, legenda);
text (0.2, 0.4, sprintf('ordin M-FIR-Butterworth:%d\nordin M_eliptic-Filtru Cauer(Eliptic):%d\ndelta_p:%0.4f\ndelta_s:%0.4f', M, M_ellip, Delta_p, 2*Delta_p), 'fontsize' , 10, 'color', 'b');
hold off

subplot (2,1,2)
hold on
plot(w_ellip, unwrap(angle(H_ellip)));
plot_faza(w_p, w_s, Delta_p, 2*Delta_p, Ts);
hold off

%Filtrul eliptic are ondulatii, de aceea norma erorii este mai mare, dar
%are ordinul de 4-5 ori mai mic decat Butterworth => filtru bun dc nu tinem
%cont de ondulatii
%% Faza 2 - b
close all; clc; clear;
[w_p, w_s, Delta_p, Ts] = PS_PRJ_3_Faza_1a(1,15);
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, 2*Delta_p, Ts);


%Filtrul Butterworth ca la punctul A, pentru comparatie cu filtrul eliptic:
titlu = 'Filtru Butterworth, Filtru FIR1, Filtru FIRLS, Filtru Eliptic (Cauer)';
legenda = {'metoda ferestrei FIR1', 'metoda c.m.m patrate FIRLS', 'filtru eliptic (Cauer)', 'Metoda pct.A Filtru Butterworth', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere', 'maxim:1(0dB)', '1+Delta_p', '1-Delta_p', 'Delta_s', 'location', 'best'}

figure
hold on
[w1, w2, H1, H2, M1, M2] = plot_FIR1_FIRLS (w_p, w_s, Delta_p, 2*Delta_p, Ts);
[w_ellip, H_ellip, M_ellip] = plot_Eliptic (w_p, w_s, Delta_p, 2*Delta_p, Ts);

subplot (2,1,1)
hold on
plot(w1, abs(H1));
plot(w2, abs(H2));
plot(w_ellip, abs(H_ellip));
plot_spectru(w_p, w_s, Delta_p, 2*Delta_p, Ts, titlu, legenda);
text (0.2, 0.4, sprintf('ordin M-FIR-Butterworth:%d\nordin M1-FIR1:%d\nordin M2-FIRLS:%d\nordin M_eliptic-Filtru Cauer(Eliptic):%d\ndelta_p:%0.4f\ndelta_s:%0.4f', M, M1, M2, M_ellip, Delta_p, 2*Delta_p), 'fontsize' , 10, 'color', 'b')
hold off

subplot (2,1,2)
hold on
plot(w1, unwrap(angle(H1)));
plot(w2, unwrap(angle(H2))); %faza
plot(w_ellip, unwrap(angle(H_ellip)));
plot_faza(w_p, w_s, Delta_p, 2*Delta_p, Ts);

hold off
%Dintre cele 4 filtre trece jos, in continuare as alege filtrul
%Butterworth, deoarece acesta nu are ondulatii in partea de trecere sau de
%stopare. Daca insa acceptam ondulatile, ordinul foarte mic si asemanarea
%cu filtrul ideal => best filter: ELIPTIC (CAUER)

%% Faza 2 - C
close all; clc; clear;
[w_p, w_s, Delta_p, Ts] = PS_PRJ_3_Faza_1a(1,15);
[B,A,w_c,M] = But_FTI_FAZA1A(w_p, w_s, Delta_p, 2*Delta_p, Ts);

titlu = 'Filtru Butterworth, Filtru FIR1, Filtru FIRLS, Filtru Eliptic (Cauer)';
legenda = {'metoda ferestrei FIR1', 'metoda c.m.m patrate FIRLS', 'filtru eliptic (Cauer)', 'filtru cheby1', 'filtru cheby2', 'Metoda pct.A Filtru Butterworth', 'pulsatia de trecere', 'pulsatia de stopare', 'pulsatia de taiere', 'maxim:1(0dB)', '1+Delta_p', '1-Delta_p', 'Delta_s', 'location', 'best'}


[w1, w2, H1, H2, M1, M2] = plot_FIR1_FIRLS (w_p, w_s, Delta_p, 2*Delta_p, Ts);
[w_ellip, H_ellip, M_ellip] = plot_Eliptic (w_p, w_s, Delta_p, 2*Delta_p, Ts);
[wc1, wc2, Hc1, Hc2, Mc1, Mc2] = plot_cheby (w_p, w_s, Delta_p, 2*Delta_p, Ts);

figure
subplot (2,1,1)
hold on
plot(w1, abs(H1));
plot(w2, abs(H2));
plot(w_ellip, abs(H_ellip));
plot(wc1, abs(Hc1));
plot(wc2, abs(Hc2));
plot_spectru(w_p, w_s, Delta_p, 2*Delta_p, Ts, titlu, legenda);
text (0.2, 0.4, sprintf('ordin M-FIR-Butterworth:%d\nordin M1-FIR1:%d\nordin M2-FIRLS:%d\nordin M_eliptic-Filtru Cauer(Eliptic):%d\nOrdin Mc1 Cheby1:%d\nOrdin Mc2 Cheby2:%d\ndelta_p:%0.4f\ndelta_s:%0.4f', M, M1, M2, M_ellip, Mc1, Mc2, Delta_p, 2*Delta_p), 'fontsize' , 10, 'color', 'b')
hold off

subplot (2,1,2)
hold on
plot(w1, unwrap(angle(H1)));
plot(w2, unwrap(angle(H2))); %faza
plot(w_ellip, unwrap(angle(H_ellip)));
plot(wc1, unwrap(angle(Hc1)));
plot(wc2, unwrap(angle(Hc2)));
plot_faza(w_p, w_s, Delta_p, 2*Delta_p, Ts);

hold off

%% Faza 3

