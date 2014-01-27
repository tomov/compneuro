wD = -0.5 : 0.01 : 0.5;
maxr = zeros(1, length(wD));
maxr_2 = zeros(1, length(wD));

sigmaE = 4; % default
Ncells = 250; % default
i = 1 : Ncells;
u0 = 4 * exp(-(i - Ncells / 2).^2 / (2 * sigmaE^2));

for i = 1 : length(wD)
    [r, u] = single_bump('T', 50, 'wD', wD(i), 'do_plot', 0);
    maxr(i) = max(r);
    [r, u] = single_bump('T', 50, 'wD', wD(i), 'initialU', u0, 'do_plot', 0);
    maxr_2(i) = max(r);
    wD(i)
end

plot(wD, maxr, 'b'); hold on
plot(wD, maxr_2, 'r'); hold off
xlabel('w_D');
ylabel('max_i(r_i(t = 50))');
legend('no bump', 'initial bump');