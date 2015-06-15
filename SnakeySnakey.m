function CL = SnakeySnakey(tip1, tip2, P, I)

disp('Calculating snakes...');
%Define parameters
nPoints = 102; % Numbers of points in the contour
gamma = 7;    %Iteration time step
ConCrit = .08; %Convergence criteria
kappa = 800;     % Weight of the image force as a whole
sigma = 10;   %Smoothing for the derivative calculations in the image
alpha = 0; % Bending modulus
beta = 400;
nu = 40;  %tip force
mu1 =300; %repel force
cd = 10; %cutoff distance for repel force



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Forces

%External energy from the image
Fline = external_energy(I, sigma);


%%Internal Energy
B = internal_energy(alpha, beta, gamma, nPoints);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pold = P;

K = relax2tip_gui(Pold, tip1, tip2, kappa, Fline, gamma, B, nPoints, ConCrit, cd, mu1,I);

P = K;
 CL = P;
 disp('OK!');

