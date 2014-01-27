Ncells = 100; % default
A = 1:Ncells;
B = randperm(Ncells);


single_bump('Ncells', Ncells, 'dVA', -1, 'dVB', 1, 'do_plot', 1, 'A', A, 'B', B, 'wE', 0.8, 'gI', 0.3, 'wDA', 0.3, 'wDB', 0.3);