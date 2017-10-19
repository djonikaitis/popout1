% Create a structure TV which will be used to update stimulus values

%============

tv1 = struct; % Temporary Variable (TV)
tv1(1).update = 'none';

% Select variables to be modified
if strcmp(expsetup.stim.exp_version_temp, 'saccade target hold increase')
    tv1(1).temp_var_final = nanmean(expsetup.stim.saccade_target_hold_duration);
    tv1(1).temp_var_ini = expsetup.stim.saccade_target_hold_duration_ini;
    tv1(1).temp_var_ini_step = expsetup.stim.saccade_target_hold_duration_ini_step;
    tv1(1).name = 'esetup_saccade_target_hold_duration';
    tv1(1).temp_var_current = NaN; % This value will be filed up
    tv1(1).update = 'gradual';
end

% Select variables to be modified
if strcmp(expsetup.stim.exp_version_temp, 'fixation - target overlap increase')
    tv1(1).temp_var_final = nanmean(expsetup.stim.fixation_overlap_duration);
    tv1(1).temp_var_ini = expsetup.stim.fixation_overlap_duration_ini;
    tv1(1).temp_var_ini_step = expsetup.stim.fixation_overlap_duration_ini_step;
    tv1(1).name = 'esetup_fixation_overlap_duration';
    tv1(1).temp_var_current = NaN; % This value will be filed up
    tv1(1).update = 'gradual';
end


% Select variables to be modified
if strcmp(expsetup.stim.exp_version_temp, 'target soa decrease')
    tv1(1).temp_var_final = nanmean(expsetup.stim.target_soa);
    tv1(1).temp_var_ini = expsetup.stim.target_soa_ini;
    tv1(1).temp_var_ini_step = expsetup.stim.target_soa_ini_step;
    tv1(1).name = 'esetup_target_soa';
    tv1(1).temp_var_current = NaN; % This value will be filed up
    tv1(1).update = 'gradual';
end

% Select variables to be modified
if strcmp(expsetup.stim.exp_version_temp, 'memory delay increase')
    tv1(1).temp_var_final = nanmean(expsetup.stim.memory_delay);
    tv1(1).temp_var_ini = expsetup.stim.memory_delay_ini;
    tv1(1).temp_var_ini_step = expsetup.stim.memory_delay_ini_step;
    tv1(1).name = 'esetup_memory_delay';
    tv1(1).temp_var_current = NaN; % This value will be filed up
    tv1(1).update = 'gradual';
end




