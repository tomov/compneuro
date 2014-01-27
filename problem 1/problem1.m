% ?????Creating and viewing memories and initial condition???????
clear all;
% Memory 1: a cross
m1mat = ones(10,10);
m1mat(:, 4) = 0;
m1mat(4, :) = 0;
% Memory 2: a square
m2mat = ones(10,10);
m2mat(5:7, 5:7) = 0;
% Memory 3: a hollow square
m3mat = ones(10,10);
m3mat(:, 1) = 0;
m3mat(:, 10) = 0;
m3mat(1, :) = 0;
m3mat(10, :) = 0;
% Turn matrices into vectors with values from ?1 to 1 instead of 0 to 1
m1 = m1mat(:)*2 - 1;
m2 = m2mat(:)*2 - 1;
m3 = m3mat(:)*2 - 1;
% Plot
subplot(2, 2, 1);
imshow(reshape(m1, 10, 10), [-1 , 1], 'InitialMagnification', 'fit');
title('Memory 1');
subplot(2, 2, 2);
imshow(reshape(m2, 10, 10), [-1 , 1], 'InitialMagnification', 'fit');
title('Memory 2');
subplot(2, 2, 3);
imshow(reshape(m3, 10, 10), [-1 , 1], 'InitialMagnification', 'fit');
title('Memory 3');

% Store memories in W

W = zeros(100, 100);
W = W + fire(m1) * fire(m1');
W = W + fire(m2) * fire(m2');
W = W + fire(m3) * fire(m3');

% Initial condition

f0mat = [m1mat(1:4,:); rand(6,10)];  % default
noise = rand(10, 10) > 0.1;
f0mat = m2mat .* (1 - noise) + rand(10, 10) .* noise; % with random noise

f0 = f0mat(:)*2 - 1;
subplot(2, 2, 4);
imshow(reshape(f0, 10, 10), [-1 , 1], 'InitialMagnification', 'fit');
title('Initial condition'); colorbar;
f0 = 0.9*f0; % do this for computational reasons (atanh(1) = infinity!)
u = unfire(f0)

pause on

% Simulate memory recovery step by step

for step = 1:100
    du = -u + W * fire(u);
    du = du / consts.TAU;
    if sum(abs(fire(u) - fire(u + du * consts.DELTA_T))) < consts.EPS
        break;
    end
    u = u + du * consts.DELTA_T;
    subplot(2, 2, 4);
    imshow(reshape(fire(u), 10, 10), [-1 , 1], 'InitialMagnification', 'fit');
    pause(0.1);
end

pause off