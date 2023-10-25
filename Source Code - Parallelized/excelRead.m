function excelData = excelRead(pathName, fileName)
% Import data from excel spreadsheet
% inputs:
%     pathName: string, directory path
%     fileName: string, filename to read
% output:
%   excelData: cellarray of the input file

%check input
arguments
    pathName string
    fileName string
end

fullpath = pathName + fileName;
excelData = readcell(fullpath,'TextType','char','DatetimeType','text');
excelData = cellfun(@rmmissing, excelData, 'UniformOutput', false);
excelData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),excelData)) = {''};
excelData(cellfun(@isempty, excelData)) = {''};

% remove double quotes from first column
if any(cellfun(@isstring,excelData(:,1)))
    strrep(excelData(:,1),'"','');
end

end