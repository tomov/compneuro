Ncells = 200; % default
A = 1:Ncells;
B = randperm(Ncells);


sigmaE = 4; % default
sigma_noise = 0.4;

A = 1:Ncells;
B = randperm(Ncells);


i = 1 : Ncells;
mu0s = 1 : 1 : Ncells;

for idx = 1 : length(mu0s)
    mu0 = mu0s(idx);
    u0 = 4 * exp(-(A - mu0).^2 / (2 * sigmaE^2));
    [r, u] = single_bump('T', 20, 'Ncells', Ncells, 'sigma_noise', 0, 'initialU', u0, 'do_plot', 0, 'A', A, 'B', B);
    center(idx) = sum(r .* A') / sum(r);
%    [r, u] = single_bump('T', 20, 'Ncells', Ncells, 'sigma_noise', sigma_noise, 'initialU', u0, 'do_plot', 0);
%    center_2(idx) = sum(r .* i') / sum(r);
    mu0
end

figure;
plot(mu0s, center - mu0s);
xlabel('mu_0');
ylabel('\mu_C - \mu_0');

