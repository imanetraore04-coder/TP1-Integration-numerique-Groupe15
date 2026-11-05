// 1. Trapezes
function q = trapezes(t, y)
    // Controles de taille (fournis)
    if length(t) <> length(y) then error("t et y doivent avoir la meme longueur."); end
    if length(t) < 2 then error("Il faut au moins deux points."); end
    n = length(t) - 1;
    q = 0;
    for i = 1:n
        h = t(i+1) - t(i);
        if h <= 0 then error("Temps non croissants."); end
        // TODO 1 : aire sur [t(i), t(i+1)]
        aire = h * (y(i) + y(i+1)) / 2;
        // TODO 2 : ajouter aire au total
        q = q + aire;
    end
endfunction

// 2. Simpson (pas egaux, n pair)
function q = simpson(t, y)
    // Controles de taille et de croissance (fournis)
    if length(t) <> length(y) then error("t et y doivent avoir la meme longueur."); end
    if length(t) < 3 then error("Simpson exige au moins deux sous-intervalles."); end
    if or(diff(t) <= 0) then error("Temps non croissants."); end
    n = length(t) - 1;

    // TODO 3 : n est impair
    if modulo(n, 2) == 1 then error("Simpson exige n pair."); end

    h = t(2) - t(1);
    echelle = 1;
    if abs(h) > 1 then echelle = abs(h); end
    tol = 1e-10 * echelle;
    for i = 2:n
        pas = t(i+1) - t(i);
        // TODO 4 : comparer pas et h avec tol
        if abs(pas - h) > tol then error("Simpson exige des pas egaux."); end
    end

    q = y(1) + y(n+1);
    for i = 2:n
        if modulo(i, 2) == 0 then
            // TODO 5 : contribution de poids 4
            q = q + 4 * y(i);
        else
            // TODO 5 : contribution de poids 2
            q = q + 2 * y(i);
        end
    end
    // TODO 5 : appliquer h/3 a la somme ponderee
    q = q * h / 3;
endfunction

// ---------------------------------------------------------------------
// 3. Verification sur un cas connu
// ---------------------------------------------------------------------
tt = [0 1 2 3 4];
PP = [10 13 14 13 10];
T4 = trapezes(tt, PP);
S4 = simpson(tt, PP);
mprintf("\n--- Cas test P(t) = 10 + 4t - t^2 ---\n");
mprintf("Trapezes : %.6f J (attendu 50)\n", T4);
mprintf("Simpson  : %.6f J (attendu %.6f = 152/3)\n", S4, 152/3);
if abs(T4 - 50) > 1e-12 then error("Test trapezes echoue."); end
if abs(S4 - 152/3) > 1e-12 then error("Test Simpson echoue."); end

// Trapezes sur pas inegaux : t = (0, 1, 3), y = (0, 2, 2) -> 1 + 4 = 5
if abs(trapezes([0 1 3], [0 2 2]) - 5) > 1e-12 then error("Trapezes pas inegaux echoue."); end

// Simpson doit refuser pas inegaux et n impair
e1 = execstr("simpson([0 1 3], [0 2 2])", "errcatch");
if e1 == 0 then error("Simpson aurait du refuser les pas inegaux."); end
lasterror();
e2 = execstr("simpson([0 1 2 3], [0 1 4 9])", "errcatch");
if e2 == 0 then error("Simpson aurait du refuser n impair."); end
lasterror();
mprintf("Tests de refus de Simpson : OK\n");

// 4. Energie de la pompe
tmin = [0 10 20 30 40];
Pkw  = [2.0 2.6 3.0 2.5 1.9];
th = zeros(1, length(tmin));
for i = 1:length(tmin)
    // TODO 6 : convertir tmin(i) en heures
    th(i) = tmin(i) / 60;
end
ET = trapezes(th, Pkw);
ES = simpson(th, Pkw);
mprintf("\n--- Pompe ---\n");
mprintf("Trapezes T4 = %.6f kWh\n", ET);
mprintf("Simpson  S4 = %.6f kWh\n", ES);
mprintf("Ecart |T4 - S4| = %.6f kWh\n", abs(ET - ES));

// 5. Conclusion
incert = 0.1 * 40 / 60;
mprintf("Contribution maximale des lectures = %.4f kWh\n", incert);

// TODO 7 : conclusion
// Energie estimee (avec unite) : environ 1,68 kWh (trapezes 1,675 kWh ; Simpson 1,683 kWh).
// Ecart entre les deux methodes : environ 0,008 kWh.
// Comparaison avec l'incertitude des lectures : les lectures (+-0,1 kW) peuvent apporter jusqu'a 0,067 kWh, soit environ 8 fois l'ecart entre methodes ; on ne peut donc pas affirmer que Simpson donne l'energie reelle la plus juste.
// Limite des releves espaces de 10 min : un pic ou un arret bref entre deux releves reste invisible, et Simpson suppose une courbe lisse avec seulement 4 intervalles.
