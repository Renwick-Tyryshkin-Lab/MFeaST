function [I, Inorm1, Inorm2, Inorm3, Inorm4, Inorm5] = mutualInfo(X, Y)

% Mutual Information can trace non-linear dependencies and indirect interactions in data.

%for descrete values

%bin size:
%binsX = ceil(sqrt(length(X)));
%binsY = ceil(sqrt(length(Y)));
binsX = ceil(1.87*((length(X) -1)^0.4));
binsY = ceil(1.87*((length(Y) -1)^0.4));

%make sure X and Y are column vectors
if length(X(1, :)) ~=1
    X = X';
end
if length(Y(1, :)) ~=1
    Y = Y';
end


%compute joint distribution
% [h,x] = hist3([X' Y'], 'Nbins', [binsX binsY]);
[h,x] = hist3([X Y], 'Nbins', [binsX binsY]);

%normalize joint distribution: devide it by length of data_x (or data_y)
fXY=h./length(X);
%integralOverDensityPlot = sum(trapz(fXY)); test that integral is 1

%fXY = [0 0.03 0 0; 0.34 0.3 0.16 0; 0 0 0.03 0.14];

%compute marginal probabilities
fX = sum(fXY, 1);
fY = sum(fXY, 2);

%Compute the mutual information
logXY = fXY; 
logXY(fXY==0) = 1; %will be zero when mult by fXY in MI. need >0 for the log
fX(fX == 0) = 1.000000001; %so that no INF in the results, when xi is 0, 
fY(fY == 0) = 1.000000001; %this will just contribute 0.00000001 to the sum
%for numerical stability use log of probabilities
I = sum(sum(fXY .* (log(logXY) - bsxfun(@plus, log(fX), log(fY)))));

%same but different way to use log:
%I = sum(sum(fXY .* log(logXY ./ bsxfun(@times, fX, fY))));
%I = sum(sum(fXY .* log10(logXY ./ bsxfun(@times, fX, fY))));
%I = sum(sum(fXY .* log2(logXY ./ bsxfun(@times, fX, fY))))

%compute Entropy for the normalization
Hx = -sum(fX .* log(fX));
Hy = -sum(fY .* log(fY));
Hxy = -sum(sum(fXY .* log(logXY)));%H(X,Y) = -SUM(SUM(f(x,y)*log(f(x,y)))

%dual total correlation
%NormI1 = (H(x) + H(Y))/H(X,Y) = MI/H(X,Y) + 1
Inorm1 = (I/Hxy) + 1;

%total correlation
%NormI2 = MI/min(H(X), H(Y))
Inorm2 = I/min(Hx, Hy);

%norm3 = MI/sqrt(HI*HY)
Inorm3 = I/sqrt(Hx*Hy);

%Astola entropy correlation = sqrt(2-(2*H(x,y))/(H(X) + H(Y)) = 
%sqrt(2*(MI/H(x)+H(y)))
Inorm4 = sqrt(2*(I/(Hx+Hy)));

%information correlation coeficient = sqrt(1-e^(-2*MI))
Inorm5 = sqrt(1-exp(-2*I));

