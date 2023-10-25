function dataout = replaceZeros(datain, method)
%replaces zeros in the input data with:
%method: nan - with NaNs
%        lowval - with values that are 10 in the power of the (exponent-1) 
%                   of the lowest value in the datain.
%                    e.g. if the minimum value in the datain is 0.089, 
%                   then the 0s will the replaced with 0.001
%       for any other value in method - no change;
%datain format: rows - features, collumns - samples, datain is double

%check data input

dataout = datain;

%check if there are some values that are below 0
if sum(sum(datain<0))
    %shift all values above 0
    dataout = dataout - min(min(dataout));
end

flag = datain==0;

if sum(sum(flag)) > 0 %if there are any values that are 0
    if strcmpi(method, 'nan')
        dataout(flag) = nan;
    elseif strcmpi(method, 'lowval')
        %add very small value to the counts with 0 relative to other values
        m = min(dataout(~flag));        
        exponent=floor(log10(abs(m)))-1;
        dataout(flag) = 10.^exponent;
    end
end