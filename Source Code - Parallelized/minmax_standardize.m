function norm_data = minmax_standardize( data, dim )
%minmax_normalize applies min-max standartization to the data
%   the output data is between 0 and 1
%INPUT: 
%   data - numeric matrix or vector
%   dim - dimention along which to standartize the data
%OUTPUT:
%   norm_data - standardized input data matrix along dimention dim
% EXAMPLE
% stand_data = minmax_standardize(mydata, 2);
%
% AUTHOR: Kathrin Tyryshkin
% Revision Date:  May 9th, 2018

%initialize
norm_data = zeros(size(data));
m = size(data);

if ~exist('dim', 'var')
    dim = 1;
end

%flip the dimentions for uniform computing
if dim == 2
    data = data'; 
    norm_data = norm_data';
end

if min(m) == 1 % if it is a vector, set dim to 1
    dmaxdmin =  nanmax(data) - nanmin(data);
    %standardize
    norm_data = (data - nanmin(data))./dmaxdmin;
else %data is a matrix
    disp('data is a matrix');
    for i=1:size(data, 1)
        dmin = nanmin(data(i, :));
        dmaxdmin =  nanmax(data(i, :)) - dmin;
        norm_data(i,:) = (data(i,:) - dmin)./dmaxdmin;
    end
end


%flip back the dimentions
if dim == 2
    norm_data = norm_data';
end

 
end %function