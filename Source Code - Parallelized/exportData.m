function exportData(tables,names)
% Export Data to spreadsheet
% inputs:
%     data_table

    filter = {'*.xlsx'; '*.xls'; '*.csv'};
            
    % open file explorer for user to choose export location and
    % file name
    [fileName, filePath] = uiputfile(filter);

    % if fileName or filePath type is a double, the user has
    % cancelled the export window
    if class(fileName) == "double" || class(filePath) == "double"
        return;
    elseif size(names) ~= size(tables)
        return;
    else
        fullPath = [filePath, '/', fileName];
        [~,cols] = size(names);
        for i = 1:cols
            t = tables(1,i);
            writecell(t{:}, fullPath, 'Sheet', char(names(1,i)));
        end      
    end
end