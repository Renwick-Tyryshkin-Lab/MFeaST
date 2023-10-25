function pathExportedTo = exportDataTo(tables,names,path)
% Export Data to spreadsheet, given a default path, return the final path
% inputs:
%     data_table

    pathExportedTo = path;
            
    % open file explorer for user to choose export location and
    % file name with a default path
    [fileName, filePath] = uiputfile([path '*.xlsx'],'Export Results');

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
        pathExportedTo = filePath;
    end
end