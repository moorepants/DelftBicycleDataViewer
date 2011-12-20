% File: fixdatfiles.m
% Date: November 24, 2008
% Author: Jason Moore
% Description: Reformats the MXXX.dat files recorded on October 27, 2008
% for the first treadmill tests so they are compatible with data_viewer.m.
% The MXXX.dat files must be in the same directory as this file.
clear all
% initialiaze filename variable
filename = [];
% enter in the first and last files to be reformatted. the missing
% intermediate files will be skipped
startFile = 1;
endFile = 165;
% for each file do this:
for i = startFile:endFile
    % choose the correct filename format with the proper amount of leading
    % zeros
    if i < 10
        filename = ['M00' num2str(i) '.dat'];
    elseif i > 99
        filename = ['M'   num2str(i) '.dat'];
    else
        filename = ['M0'  num2str(i) '.dat'];
    end
    % open the file
    fid=fopen(filename);
    if fid == -1 % then do nothing, because this file doesn't exist
    else
        % skip the first two characters in the file
        fseek(fid,2,'bof');
        % get the first 11 strings separated by '|'
        runinfo = textscan(fid,'%s',14,'delimiter',',');
        % skip four spaces
        fseek(fid,4,'cof');
        % store the header strings
        headers = textscan(fid,'%s',17);
        % store the data delimited by tabs
        data = textscan(fid,'%n','delimiter','\t');
        % close the file
        fclose(fid);
        % make the run info string in the new format
        RunInfoStr = ['%' runinfo{1,1}{1,1} ' ' runinfo{1,1}{2,1} ', ' ...
            runinfo{1,1}{3,1} ', ' runinfo{1,1}{4,1} '|' runinfo{1,1}{5,1}...
            '|' runinfo{1,1}{6,1} '|' runinfo{1,1}{7,1} '|' runinfo{1,1}{8,1}...
            '|' runinfo{1,1}{9,1} '|' runinfo{1,1}{10,1} '|' runinfo{1,1}{11,1}...
            '|' runinfo{1,1}{12,1} '|' runinfo{1,1}{13,1} '|' runinfo{1,1}{14,1}];

        % make the header string in the new format
        HeaderStr = sprintf('%%%s\t%s %s\t%s %s\t%s %s\t%s %s\t%s %s %s\t%s %s %s\t%s\t%s'...
            ,headers{1,1}{1,1},headers{1,1}{2,1},headers{1,1}{3,1}...
            ,headers{1,1}{4,1},headers{1,1}{5,1},headers{1,1}{6,1}...
            ,headers{1,1}{7,1},headers{1,1}{8,1},headers{1,1}{9,1}...
            ,headers{1,1}{10,1},headers{1,1}{11,1},headers{1,1}{12,1}...
            ,headers{1,1}{13,1},headers{1,1}{14,1},headers{1,1}{15,1}...
            ,headers{1,1}{16,1},headers{1,1}{17,1});
        % turn the data vector into a data matrix with 9 columns
        dataMat = zeros(length(data{1,1})/9,9);
        for j = 1:((length(dataMat)))
            dataMat(j,1:9) = data{1,1}(j*9-8:j*9,1)';
        end
        % make a new file name for the reformated data files
        NewFileName = ['N' filename];
        % create and open the new file for writing
        fid = fopen(NewFileName,'wt');
        % rewind to the first space in the file
        frewind(fid);
        % write the run info and header line to the file
        fprintf(fid,'%s\n%s\n',RunInfoStr,HeaderStr);
        % close the file
        fclose(fid);
        % append the data to the file
        dlmwrite(NewFileName,dataMat,'precision', '%.6f','delimiter',...
            '\t','newline', 'pc','-append');
    end
end