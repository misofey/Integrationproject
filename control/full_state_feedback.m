load("../models/connected.mat");

A = connected.A;
B = connected.B;

p = [-10.1, -9.9, -1.05, -0.95];
p = exp(p*0.01);

K = place(A,B, p)