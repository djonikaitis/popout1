% Synchronize the data with the server
% v1.0 DJ: August 11, 2016. Basic code.
% v2.0 DJ April 2, 2017. Roather quick code, able to work on its own,
% independent of experiment code. Assumption that data is stored as:
% exp_name\data_type\subject_name\session_folder\file_name
% for example: look5\plexon_data\hb\hb_2017_01_01\hb_2017_01_01.pl2
% Data has to be organized... get over it...

clear all;

expsetup.general.directory_baseline_data_server = 'Y:\data\RigE\Experiments_data\';
expsetup.general.directory_baseline_data = 'C:\Users\Rig-E\Desktop\Experiments_data\';
expsetup.general.expname = 'popout1'; % Experiment name
expsetup.general.subject_id = 'hb'; % Subject name

path_append = cell(1);
path_append{1}='data_eyelink_edf';
path_append{2}='data_psychtoolbox';
path_append{3}='figures_online_averages';



% Rename few variables for better code compatibility
path1_data = expsetup.general.directory_baseline_data; % Data path on computer
path1_server = expsetup.general.directory_baseline_data_server; % Data path on the server
expname = expsetup.general.expname;
subject_id = expsetup.general.subject_id;

% Determine how many experiments to run
if strcmp(expname, 'all')
    exp_dir_index = dir(path1_data);
else
    exp_dir_index.name = expname;
end

% For each experiment
for exp_i = 1:length(exp_dir_index)
    if ~strcmp(exp_dir_index(exp_i).name, '.') && ~strcmp(exp_dir_index(exp_i).name, '..')
        
        path1_exp = sprintf('%s%s%s', path1_data, exp_dir_index(exp_i).name, '\');
        
        % For each experiment sub-folder (edf, plexon etc)
        for append_i = 1:numel(path_append)
            
            path1_exp_append = sprintf('%s%s%s', path1_exp, path_append{append_i}, '\');
            
            if isdir(path1_exp_append)
                
                fprintf('\n\nWill synchronise following data sub-folder: \n\n');
                fprintf('%s\n', path1_exp_append )
                
                % Determine which subject to use
                if strcmp(subject_id, 'all')
                    subj_dir_index = dir(path1_exp_append);
                else
                    subj_dir_index.name = subject_id;
                end
                
                %=================
                % Run sync for each subject
                for subj_i = 1:length(subj_dir_index)
                    if ~strcmp(subj_dir_index(subj_i).name, '.') && ~strcmp(subj_dir_index(subj_i).name, '..')
                        
                        path1_subj = sprintf('%s%s%s', path1_exp_append, subj_dir_index(subj_i).name, '\');
                        
                        % Run synch for each session
                        session_dir_index = dir(path1_subj);
                        
                        for session_i=1:length(session_dir_index)
                            if ~strcmp(session_dir_index(session_i).name, '.') && ~strcmp(session_dir_index(session_i).name, '..')
                            
                                fprintf('Will synchronise following session %s \n', session_dir_index(session_i).name);

                                % Select each session folder
                                path1_session = sprintf('%s%s%s', path1_subj, session_dir_index(session_i).name, '\');
                                
                                % Create server folder if it doesn't exist
                                temp1 = path1_session(length(path1_data)+1:end);
                                path1_folder = sprintf('%s%s', path1_server, temp1); % Name of the folder on the server;
                                if ~isdir (path1_folder)
                                    mkdir(path1_folder);
                                end
                                
                                
                                index_file = dir(path1_session);
                                
                                for file_i = 1:length(index_file)
                                    if ~strcmp(index_file(file_i).name, '.') && ~strcmp(index_file(file_i).name, '..');
                                        
                                        % Make such a folder on the server
                                        path1_source = sprintf('%s%s', path1_session, index_file(file_i).name);
                                        temp1 = path1_source(length(path1_data)+1:end);
                                        path1_destination = sprintf('%s%s', path1_server, temp1); % Name of the folder on the server
                                        
                                        if exist(path1_destination) == 2
                                            fprintf('Data file %s exists, no sync \n\n', index_file(file_i).name);
                                        else
                                            fprintf('Will synchronise data file %s \n', index_file(file_i).name);
                                            status = 0;
                                            while status==0
                                                [status, message] = copyfile(path1_source, path1_destination);
                                                fprintf('Success \n\n');
                                                if status == 0
                                                    fprintf('Failed to sync file %s \n\n', index_file(file_i).name);
                                                end
                                            end
                                        end
                                        
                                    end
                                    % End of checking whether file exists (exclude '..')
                                end
                                % End of syncing each file
                                
                                
                            end
                            % End of checking whether session folder exists (exclude '..')
                        end
                        %  End of sync for each session
                    end
                    % End of checking whether subject folder exists (exclude '..')
                end
                % End of sunc for each subject
                %==================
                
            end
            % End of checking whether append folder exists (exclude '..')
        end
        % End of each append folder (plexon, edf)
    end
    % End of checking exp folder exists (exclude '..')
end
% End of sync for each experiment
