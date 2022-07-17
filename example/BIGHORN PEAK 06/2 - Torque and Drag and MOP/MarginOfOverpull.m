function [MOOP,Strength]=MarginOfOverpull(ri,ro,A,E,Ys,p_in,p_out,F_hoisting,T_const,DLS)
kappa=DLS; %(kappa= rad/in) and (DLS=rad/in)
sigma_b=E*ro*kappa;           %rd(in); E(psi);
sigma_a=F_hoisting/A;
sigma_an=(ri^2*p_in-ro^2*p_out)/(ro^2-ri^2);
f_td=0.5*(2*ro/(ro-ri))^2/(2*ro/(ro-ri)-1);
sigma_vm=(((ri/ro)^2*sqrt(3)/2*(p_in-p_out)*f_td).^2+(sigma_a-sigma_an+sigma_b).^2+3*(T_const).^2).^0.5;
MOOP=(Ys-sigma_vm)*A;
Strength=Ys*A;
end