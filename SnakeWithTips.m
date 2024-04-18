function [CL] = SnakeWithTips(tip1, tip2, P, I)

%Define parameters
nPoints = 100; % Numbers of points in the contour
gamma =18;    %Iteration time step
ConCrit = 2; %Convergence criteria
kappa = 100;     % Weight of the image force as a whole
sigma = 14;   %Smoothing for the derivative calculations in the image
alpha = 50; % Bending modulus
beta = 20;
nu = 10;  %tip force
mu1 =10; %repel force
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