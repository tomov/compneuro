Ncells = 200; % default

A = 1:Ncells;
B = randperm(Ncells);


sigmaE = 4; % default
mu0A = 0.6;
mu0B = 0.3;
u0 = 3 * exp(-(A - mu0A * Ncells).^2 / (2 * sigmaE^2)) + 3 * exp(-(B - mu0B * Ncells).^2 / (2 * sigmaE^2));

for sim = 1:50
    [r, u] = single_bump('T', 30, 'A', A, 'B', B, 'muDA', mu0A, 'muDB', mu0B, 'Ncells', Ncells, 'initialU', u0, 'wDA', 0, 'wDB', 0, 'do_plot', 0);
    betaA(sim) = magical(A, r);
    betaB(sim) = magical(B, r);
    fprintf('%.2f    %.2f\n', betaA(sim), betaB(sim));
end

figure;
scatter(betaA, betaB)
%%ma

for i = 1:length(betaA)
    if betaA(i) < 10 Aa(j) = betaA(i); Ab(j) = betaB(i); j = j+1; end;
end;

for i = 1:length(betaA)
    if betaA(i) >= 10 Ba(j) = betaA(i); Bb(j) = betaB(i); j = j+1; end;
end;