%------------------------------------------------
%
% DEMO NOTES: SHOW WITH 1, 0.5, 100, AND 0.001 !!!!!
%
% also call sound() in command line so you can interrupt it... 
%
%------------------------------------------------

w_1 = 1000;
w_2 = w_1 + 100;

t = [0:1/8192:100];
y1 = sin(2*pi*w_1*t);
y2 = sin(2*pi*w_2*t);

%sound(y1)
%sound(y2)
%sound((y2 + y1)/2)