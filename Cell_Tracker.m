% Check if the cell culture log file exists
if exist('cell_culture_log.csv', 'file')
    % Read the existing log file
    log = readtable('cell_culture_log.csv');
else
    % Initialize the log table
    log = table('Size',[0 6], 'VariableTypes',{'string','string','string','double','string','datetime'}, ...
                'VariableNames',{'cell_sample','experiment_id','action','passage_number','media','DateTime'});
end

% Get user inputs
cell_sample = input('Enter the cell sample: ', 's');
experiment_id = input('Enter the experiment ID: ', 's');
action = input('Enter the action (split or media change): ', 's');
media = input('Enter the cell media: ', 's');

% Check if the cell sample and experiment ID already exist in the log
last_row_idx = find(strcmp(log.cell_sample, cell_sample) & strcmp(log.experiment_id, experiment_id), 1, 'last');

% If the cell sample and experiment ID already exist, update the log
if ~isempty(last_row_idx)
    % Get the last passage number for the cell sample and experiment ID
    last_passage_number = log.passage_number(last_row_idx);

    % Update the passage number for a split action
    if strcmp(action, 'split')
        new_passage_number = last_passage_number + 1;
    else
        new_passage_number = last_passage_number;
    end
    
    % Add a new row to the log
    new_row = {cell_sample, experiment_id, action, new_passage_number, media, datetime('now')};
    log = [log; new_row];

% If the cell sample and experiment ID do not exist, add a new row to the log with a passage number of 2 or media change action
else
    if strcmp(action, 'split')
        new_passage_number = 2;
    else
        new_passage_number = 1;
    end
    
    % Add a new row to the log
    new_row = {cell_sample, experiment_id, action, new_passage_number, media, datetime('now')};
    log = [log; new_row];
end

% Write the updated log to a CSV file
writetable(log, 'cell_culture_log.csv');
disp('Log updated successfully');
