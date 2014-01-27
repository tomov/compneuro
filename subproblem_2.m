wD = -0.5 : 0.01 : 0.5;
maxr = zeros(1, length(wD));
maxr_2 = zeros(1, length(wD));

sigmaE = 4; % default
sigma_noise = 0.4;
Ncells = 50; % default

i = 1 : Ncells;
mu0s = Ncells / 2 - 3 : 0.01 : Ncells / 2 + 3;

for idx = 1 : length(mu0s)
    mu0 = mu0s(idx);
    u0 = 4 * exp(-(i - mu0).^2 / (2 * sigmaE^2));
    [r, u] = single_bump('T', 50, 'Ncells', Ncells, 'sigma_noise', 0, 'initialU', u0, 'do_plot', 0);
    center(idx) = sum(r .* i') / sum(r);
    [r, u] = single_bump('T', 50, 'Ncells', Ncells, 'sigma_noise', sigma_noise, 'initialU', u0, 'do_plot', 0);
    center_2(idx) = sum(r .* i') / sum(r);
    mu0
end

plot(mu0s, center_2 - mu0s);
xlabel('mu_0');
ylabel('\mu_C - \mu_0');

