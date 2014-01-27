% [r, u] = single_bump()
%
% Runs code for a bump attractor on a linear space, following homework 2 of Neu
% 437, Spring 2011. All parameters for the simulation have built-in default
% values, so the code runs even when called with no arguments, e.g.:
%
%  >> single_bump
%
% PASSING IN OPTIONAL PARAMETERS: You can change parameters from their
% default values either through the graphical user interface (GUI)
% controls provided in the simulation's window, or at the time of calling
% single_bump.m by using a (parameter_name, parameter_value) pair.  For
% example, to specify that Ncells should be 150 and the simulation timestep
% should be 0.05, you pass in two pairs and call:
%
%  >> single_bump('Ncells', 150, 'dt' 0.05)
%
% Parameters not specified in your list of (name, value) pairs will be kept
% at their default values. The order of (parameter_name, parameter_value)
% pairs doesn't matter, you can put them in any order when calling
% single_bump.m
%
% GRAPHICAL MODE VS. NON-GRAPHICAL MODE: If the optional parameter
% 'do_plot' is passed as 0, then no graphics or GUI are generated. In that
% case, the code runs much faster. The return values (see below) will be
% the r vectors u at the end of the simulation.
%
% KEYSTROKES: In graphical mode, click on the main axis and then press
% 'p' to produce a positive input jolt to the network at the mouse's
% location. Press 'd' to produce a negative jolt. (At least on a Mac, you
% can keep the key pressed and move the mouse to produce a rapid sequence
% of jolts.) Press 'q' to end the graphical simulation.
%
% OPTIONAL PARAMETERS:
% --------------------
%
%  'dt'           0.1  by default. The timestep to use in the simulations
%  'T'          10000  by default. The time at which the simulation stops
%  'Ncells'       250  by default. Number of cells in the simulation
%  'wE'           1.4  by default. Scales the strength of excitatory connections
%  'sigmaE'         4  by default. Width of excitatory connections neighborhood
%  'gI'           0.4  by default. Scales the global inhibition: from every cell to every cell
%  'global_drive' 2.1  by default. Magnitude of external constant drive to every cell
%  'sigma_noise'  0.4  by default. Scales magnitude of noise added to each cell
%  'leak_noise'    0   by default. Static randomness, across cells, in their leak membrane conductance
%  'wD'            0   by default. Strength of external gaussian-shaped sensory drive
%  'sigmaD'        4   by default. Width of external gaussian sensory drive
%  'muD'          0.5  by default. This is multiplied by Ncells to obtain
%                                  the midpoint of the initial external drive position.
%  'dV'            0   by default. Drive speed, in neuron positions per unit time.
%  'initialU'    zeros(Ncells,1) by default. A vector that represents initial conditions for u.
%  'do_plot'       1   by default. If this is 0, no figure or plot is generated (code runs much faster).
%
% RETURNS:
% --------
%
%   r      A vector, Ncells long, that represents the firing rate of each
%          neuron at the end of the simulation.
%
%   u      A vector, Ncells long, that represents the membrane potential of
%          each neuron at the end of the simulation.
%

% written by Carlos Brody for Neu 501, Fall 2009. Modified by


function [rr, u] = single_bump(varargin)


t = 0;        % current time


%% Some initial values

% Parameters of the sigmoid activation function of each cell:
cell_thresh = 0.5;  % r = 0.5 + 0.5*tanh((u - cell_thresh)/cell_sigma)
cell_sigma  = 0.3;

pairs = { ...
   'dt'           0.1   ; ...  % timestep size
   'T'          10000   ; ...  % time after which simulation stops
   'Ncells'       250   ; ...  % number of cells in the simulation
   'wE'           1.4   ; ...  % local excitatory weight strength
   'sigmaE'        4    ; ...  % width of excitatory neighborhood
   'gI'           0.4   ; ...  % global inhibition: from every cell to every cell
   'global_drive' 2.1   ; ...  % an external constant drive to every cell
   'sigma_noise'  0.4   ; ...  % magnitude of noise in each cell
   'leak_noise'    0    ; ...  % Static randomness, across cells, in their "leak membrane conductance"
   'wDA'            0.5    ; ...  % Strength of external gaussian drive
   'wDB'            0.5    ; ...  % Strength of external gaussian drive
   'sigmaD'        4    ; ...  % External gaussian drive has same width as default exc conn width
   'muDA'          0.5   ; ...  % Drive starts at midpoint of screen.
   'muDB'          0.5   ; ...  % Drive starts at midpoint of screen.
   'dVA'            0    ; ...  % Drive speed, in neuron positions per unit time.
   'dVB'            0    ; ...  % Drive speed, in neuron positions per unit time.
   'initialU'     []    ; ...  % Optional initial conditions for u
   'do_plot'       1    ; ...  % If this is 0, no figure or plot is generated (runs faster).
   'A'            [] ; ...
   'B'            [] ; ...
}; parseargs(varargin, pairs);

muDA = muDA*Ncells; %#ok<NODEF>
muDB = muDB*Ncells; %#ok<NODEF>

leak = ones(Ncells,1) + leak_noise*randn(Ncells,1); leak(leak<0) = 0;  %#ok<NODEF>

if isempty(A)
    A = 1:Ncells;
end
if isempty(B)
    B = 1:Ncells;
end
invA = 1:Ncells;
invB = 1:Ncells;
for i = 1:Ncells
    invB(B(i)) = i;
    invA(A(i)) = i;
end


if ~isempty(initialU)  %#ok<NODEF>
   if numel(initialU) ~= Ncells,
      error('If you use initialU it must be a vector Ncells long');
   end;
   if size(initialU,1)==1, initialU = initialU'; end;
end;
   


%% Set up the figure
if do_plot,
   figure(1000); clf;
   pos = get(gcf, 'Position');
   % Make sure figure is of enough width, and tell it what fn to call if user
   % presses key:
   set(gcf, 'Units', 'pixels', 'Position', [pos(1) pos(2) 750 600], ...
      'KeyPressFcn', 'bump_keypress_callback');
   % Use the following line instead of prev one if you want two axes stacked
   % on top of each other:
   % set(gcf, 'Units', 'pixels', 'Position', [pos(1) pos(2) 750 600], ...
   %  'KeyPressFcn', 'bump_keypress_callback');
   drawnow;
   pos = get(gcf, 'Position');
   
   %% Set up the GUI controllable elements
   sigma_noise_control = add_control('sigma_noise', sigma_noise, 0.05, 0.05, pos(3)-200, 20); %#ok<NODEF>
   gI_control          = add_control('gI',          gI,          0.05, 0.05, pos(3)-200, 40); %#ok<NODEF>
   wE_control          = add_control('wE',          wE,          0.05, 0.05, pos(3)-200, 60); %#ok<NODEF>
   global_drive_control= add_control('global_drive',global_drive,0.25, 0.25, pos(3)-200, 100); %#ok<NODEF>
   leak_noise_control  = add_control('leak_noise',  leak_noise,  0.05, 0.05, pos(3)-200, 140);
   
   muDA_control         = add_control('drive_A_position', muDA,      0.05, 0.05, pos(3)-200, 180);
   muDB_control         = add_control('drive_B_position', muDB,      0.05, 0.05, pos(3)-200, 180 + 100);
   dVA_control          = add_control('drive_speed',    dVA,       0.05, 0.05, pos(3)-200, 200); %#ok<NODEF>
   dVB_control          = add_control('drive_speed',    dVB,       0.05, 0.05, pos(3)-200, 200 + 100); %#ok<NODEF>
   wDA_control          = add_control('drive_A_strength', wDA,       0.05, 0.05, pos(3)-200, 220); %#ok<NODEF>
   wDB_control          = add_control('drive_B_strength', wDB,       0.05, 0.05, pos(3)-200, 220 + 100); %#ok<NODEF>
end;

%%  Set up cells and connections between them
% u is the "membrane potential"; r is the "firing rate"
if isempty(initialU), u = zeros(Ncells,1); 
else                  u = initialU;
end;
r = zeros(Ncells,1); 
eWeights = zeros(Ncells, Ncells);  % excitatory weights

% Set up weights in the first track:
for i=1:Ncells,
  for j=1:Ncells,
    if i~=j,  % no self-connections
      deltaA = abs(A(i)-A(j));      % MOM
      deltaB = abs(B(i)-B(j));      % MOM
      eWeights(i,j) = eWeights(i,j) + ( exp(-deltaA.^2/(2*sigmaE^2)) + exp(-deltaB.^2/(2*sigmaE^2)) )/sigmaE;
    end;
  end;
end;


%% Now to plotting and looping
% set up plotting axes:
if do_plot,
   external_drive = wDA*exp(-(A'-muDA).^2/(2*sigmaD.^2)) + wDB*exp(-(B'-muDB).^2/(2*sigmaD.^2)); % MOM
   
   ax1dA = axes('Position', [0.1 0.07 0.6 0.05]); set(ax1dA, 'Units', 'pixels');
   external_drive_A = 1:Ncells;
   for i = 1:Ncells
       external_drive_A(A(i)) = external_drive(i); % MOM
   end
   hdA = plot(external_drive_A, 'k.-'); ylim([-0.5 0.5]);
   xlabel('cell #');
   
   ax1A  = axes('Position', [0.1 0.15 0.6 0.15]); set(ax1A, 'Units', 'pixels');
   h1A = plot(r, '.-'); set(h1A, 'Color', [0 0.5 0]); ylim([-0.05 1.15]); t1A = title(sprintf('t=%.2f', t));
   ylabel('activity A');

   
   ax1dB = axes('Position', [0.1 0.4 0.6 0.05]); set(ax1dB, 'Units', 'pixels');
   external_drive_B = 1:Ncells;
   for i = 1:Ncells
       external_drive_B(B(i)) = external_drive(i); % MOM
   end
   hdB = plot(external_drive_B, 'k.-'); ylim([-0.5 0.5]);
   xlabel('cell #');
   
   ax1B  = axes('Position', [0.1 0.5 0.6 0.15]); set(ax1B, 'Units', 'pixels');
   h1B = plot(r, '.-'); set(h1B, 'Color', [0 0.5 0]); ylim([-0.05 1.15]); t1B = title(sprintf('t=%.2f', t));
   ylabel('activity B');
end;

% Loop forever -- or until user presses 'q'
while t<T,
  t = t + dt;
  
  if do_plot,
     % The following line is to deal with reading keypresses-- no need to modify
     c = get(1000, 'UserData'); if isempty(c), c = ''; end; set(1000, 'UserData', '');
     % End reading keypress code
  
     % c will be either empty if no keypress, or will be the character pressed
     switch c,
        % 'p' = Positive Pulse;  'd' = Negative Pulse
        case {'p' 'd'},
           [xvalue0, yvalue] = get_pointer_location(ax1A);  %#ok<NASGU> % this gets the x position of pointer in axes units
           for xvalue = xvalue0-1:xvalue0+1,
              if xvalue >=1 && xvalue <=Ncells, % There are no cells outside the axes
                 switch c,
                    case 'p', u(xvalue)=1;  % user asked for positive jolt
                    case 'd', u(xvalue)=-1; % user asked for negative jolt
                 end;
              end;
           end;
           % 'q' = quit
        case 'q',
           break;  % if q, get out of the WHILE loop
        otherwise,
     end;

     % Get the current GUI values of the following variables
     sigma_noise = get_control(sigma_noise_control);
     gI          = get_control(gI_control);
     wE          = get_control(wE_control);
     wDA          = get_control(wDA_control);
     wDB          = get_control(wDB_control);
     dVA          = get_control(dVA_control);
     dVB          = get_control(dVB_control);
     muDA         = get_control(muDA_control);
     muDB         = get_control(muDB_control);
     global_drive= get_control(global_drive_control);
     
     new_leak_noise = get_control(leak_noise_control);
     if new_leak_noise ~= leak_noise,  % leak_noise doesn't change from timestep to timestep
        leak_noise = new_leak_noise;    % Only if the user changed it do we calculate it anew.
        leak = ones(Ncells,1) + leak_noise*randn(Ncells,1); leak(leak<0) = 0;
     end;
  end;
  
  
  % ---- Dynamics of driving ---
  muDA = muDA + dVA*dt; 
  muDB = muDB + dVB*dt; 
  if muDA > Ncells-2*sigmaE, dVA=-dVA; if do_plot, set_control(dVA_control, dVA); end; end;
  if muDA < 2*sigmaE,        dVA=-dVA; if do_plot, set_control(dVA_control, dVA); end; end;
  if muDB > Ncells-2*sigmaE, dVB=-dVB; if do_plot, set_control(dVB_control, dVB); end; end;
  if muDB < 2*sigmaE,        dVB=-dVB; if do_plot, set_control(dVB_control, dVB); end; end;
  
  if do_plot, set_control(muDA_control, muDA); end;
  if do_plot, set_control(muDB_control, muDB); end;
  external_drive = wDA*exp(-(A'-muDA).^2/(2*sigmaD.^2)) + wDB*exp(-(B'-muDB).^2/(2*sigmaD.^2));  
  % ---- End dynamics of driving ---

  
  % ---- Main dynamical equations ----
  
  dudt = -leak.*u - gI*sum(r) + wE*eWeights*r - sigma_noise*randn(size(u))*sqrt(dt) + ...
global_drive + external_drive;
  u    = u + dt*dudt;
  r    = 0.5+0.5*tanh((u-cell_thresh)/cell_sigma);
  t = t+dt;
  % ---- End main dynamical equations ----
  
  
  % replot
  if do_plot,
     external_drive_A = 1:Ncells;
     r_A = 1:Ncells;
     for i = 1:Ncells
         external_drive_A(A(i)) = external_drive(i); % MOM
         r_A(A(i)) = r(i);
     end
     external_drive_B = 1:Ncells;
     r_B = 1:Ncells;
     for i = 1:Ncells
         external_drive_B(B(i)) = external_drive(i); % MOM
         r_B(B(i)) = r(i);
     end
     
     set(h1A, 'YData', r_A);           set(t1A, 'String', sprintf('t=%.2f', t));
     set(hdA, 'YData', external_drive_A);
     set(h1B, 'YData', r_B);           set(t1B, 'String', sprintf('t=%.2f', t));
     set(hdB, 'YData', external_drive_B);
     drawnow; 
  end;
end;  % and loop

if nargout > 0, rr = r; end;

