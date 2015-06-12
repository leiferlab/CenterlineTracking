function [CL] = SnakeWithTips(tip1, tip2, P, I)

%Define parameters
nPoints = 102; % Numbers of points in the contour
gamma = 7;    %Iteration time step
ConCrit = .05; %Convergence criteria
kappa = 720;     % Weight of the image force as a whole
sigma = 6;   %Smoothing for the derivative calculations in the image
alpha = 0; % Bending modulus
beta = 110;
nu = 40;  %tip force
mu1 =50; %repel force
cd = 16; %cutoff distance for repel force



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


end