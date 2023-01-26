function [W] = xdawn_spatial_filters(X,time,stimulus_idx)

nsamples = size(X,1); % 
n=1; %first approach: 2 QR 1 SVD
% create Toeplitz matrix D
D = sparse(nsamples,time); % All zero
D1 = sparse(nsamples, time);
tstart = 1;
	
for i = tstart:time
    D1(stimulus_idx+i-1,i) = 1;
end
D(:,tstart:time) = D1;


if n==1
% A_hat = ((D'*D)^-1) D' X

invDD = inv(D.' * D);
B = invDD * D.';

%The least square estimation
%  P1_hat. 
P1_hat = B(tstart:time,:) * X;

B1 = B(tstart:time,:); 

%  QR decomposition of X
[Qx,Rx] = qr(X,0);

%  QR decomposition of D1
[Qd1,Rd1] = qr(D1,0);

%  SVD of R1* B1* Qx
[phi, lambda, psi] = svd(Rd1 * B1 * Qx, 0);

W = Rx\psi; %inv(Rx)*psi; % 
A1 = inv(Rd1)*phi*lambda;
end

%%%% 2nd approach, QR of D
if n==2
[Qx,Rx] = qr(X,0);
[Qd,Rd] = qr(D,0);
M = Qd'*Qx;
[U,S,V]=svd(M,0);
W = inv(Rx)*V;
%%%%
end

if n==3 % eigenvalue decomposition
A = ((D'*D)\(D'*X));
%eig((A'*D'*D*A),(X'*X));
[U,V]=eig((X'*X)\(A'*D'*D*A));
[d,ind] = sort(-1*diag(V));
W = U(:,ind);

end

enhancedX = X*W;
	
end

