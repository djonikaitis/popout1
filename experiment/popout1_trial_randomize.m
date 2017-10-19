% Randomized all parameters for the trial


%% Initialize NaN fields of all settings

% New trial initialized
if tid == 1
    % Do nothing
else
    f1 = fieldnames(expsetup.stim);
    ind = strncmp(f1,'esetup', 6) |...
        strncmp(f1,'edata', 5);
    for i=1:numel(ind)
        if ind(i)==1
            if ~iscell(expsetup.stim.(f1{i}))
                [m,n,o]=size(expsetup.stim.(f1{i}));
                expsetup.stim.(f1{i})(tid,1:n,1:o) = NaN;
            elseif iscell(expsetup.stim.(f1{i}))
                [m,n,o]=size(expsetup.stim.(f1{i}));
                expsetup.stim.(f1{i}){tid,1:n,1:o} = NaN;
            end
        end
    end
end

var_copy = struct; % This structure exists for training purposes only


%% Which exp version is running?

expsetup.stim.esetup_exp_version{tid,1} = expsetup.stim.exp_version_temp;


%% Main condition & block number

if tid==1
    a = expsetup.stim.number_of_blocks/numel(expsetup.stim.main_cond);
    a = floor(a);
    if size(expsetup.stim.main_cond, 1)< size(expsetup.stim.main_cond,2)
        expsetup.stim.main_cond = expsetup.stim.main_cond';
    end
    expsetup.stim.main_cond_reps = repmat(expsetup.stim.main_cond, a, 1);
end

if tid==1
    % Shuffle conditons or just do them in a sequence?
    if stim.main_cond_shuffle==1
        temp1=Shuffle(expsetup.stim.main_cond_reps);
    else
        temp1=expsetup.stim.main_cond_reps;
    end
    expsetup.stim.main_cond_reps = temp1;
    expsetup.stim.esetup_block_cond{tid} = temp1{1};
    expsetup.stim.esetup_block_no(tid) = 1;
elseif tid>1 
    if expsetup.stim.trial_error_repeat == 1
        ind = strcmp(expsetup.stim.edata_error_code, 'correct') & expsetup.stim.esetup_block_no == expsetup.stim.esetup_block_no(tid-1);
    else
        ind = expsetup.stim.esetup_block_no == expsetup.stim.esetup_block_no(tid-1);
    end
    if sum(ind) < expsetup.stim.number_of_trials_per_block % Same block
        expsetup.stim.esetup_block_cond{tid} = expsetup.stim.esetup_block_cond{tid-1};
        expsetup.stim.esetup_block_no(tid) = expsetup.stim.esetup_block_no(tid-1);
    elseif sum(ind) >= expsetup.stim.number_of_trials_per_block % New block
        expsetup.stim.esetup_block_no(tid) = expsetup.stim.esetup_block_no(tid-1)+1;
        i1 = expsetup.stim.esetup_block_no(tid);
        expsetup.stim.esetup_block_cond{tid} = expsetup.stim.main_cond_reps{i1};
    end
end


%%  Background color

expsetup.stim.esetup_background_color(tid,1:3) = expsetup.stim.background_color;


%%  Fix

% Fixation position, color
expsetup.stim.esetup_fixation_coord(tid,1:2) = expsetup.stim.fixation_coord;
expsetup.stim.esetup_fixation_color(tid,1:3) = expsetup.stim.fixation_color;
expsetup.stim.esetup_fixation_shape{tid} = expsetup.stim.fixation_shape;
expsetup.stim.esetup_fixation_size(tid,1:4) = expsetup.stim.fixation_size;

% Fixation size drift
temp1=Shuffle(expsetup.stim.fixation_size_drift);
expsetup.stim.esetup_fixation_size_drift(tid,1:4) = [0, 0, temp1(1), temp1(1)];

% Fixation size eyetrack
temp1=Shuffle(expsetup.stim.fixation_size_eyetrack);
expsetup.stim.esetup_fixation_size_eyetrack(tid,1:4) = [0, 0, temp1(1), temp1(1)];

% Fixation acquire duration
temp1=Shuffle(expsetup.stim.fixation_acquire_duration);
expsetup.stim.esetup_fixation_acquire_duration(tid,1) = temp1(1);
 
% Fixation maintain duration varies as a stage of training
temp1=Shuffle(expsetup.stim.fixation_maintain_duration);
expsetup.stim.esetup_fixation_maintain_duration(tid,1) = temp1(1);

% Do drift correction or not?
expsetup.stim.esetup_fixation_drift_correction_on(tid) = expsetup.stim.fixation_drift_correction_on;

% What is starting drift error? 0 by default
expsetup.stim.esetup_fixation_drift_offset (tid,1:2) = 0;

%% fixation - target overlap

% is there overlap?
%=========
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'fixation - target overlap probability');
ind2 = find(ind0==1);

a=[];
if ind1>ind2
    t1 = expsetup.stim.fixation_overlap_probability;
    if t1>0
        a(1:t1) = 1;
        if t1<=100
            a(t1+1:100) = 0;
        end
    else
        a(1)=0;
    end
    temp1 = Shuffle(a);
elseif ind1==ind2
    t1 = tv1(1).temp_var_current;
    if t1>0
        a(1:t1) = 1;
        if t1<=100
            a(t1+1:100) = 0;
        end
    else
        a(1)=0;
    end
    temp1 = Shuffle(a);
    var_copy.esetup_fixation_overlap_on = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    t1 = expsetup.stim.fixation_overlap_probability_ini;
    if t1>0
        a(1:t1) = 1;
        if t1<=100
            a(t1+1:100) = 0;
        end
    else
        a(1)=0;
    end
    temp1 = Shuffle(a);
end
%===========
expsetup.stim.esetup_fixation_overlap_on(tid)=temp1(1);



% what is overlap duration?
%=========
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'fixation - target overlap increase');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.fixation_overlap_duration);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_fixation_overlap_duration = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.fixation_overlap_duration_ini);
end
%===========

if expsetup.stim.esetup_fixation_overlap_on(tid)==1
    expsetup.stim.esetup_fixation_overlap_duration(tid) = temp1(1);
else
    expsetup.stim.esetup_fixation_overlap_duration(tid) = 0;
end

%% hold eye position on saccade target

%=========
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'saccade target hold increase');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.saccade_target_hold_duration);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_saccade_target_hold_duration = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.saccade_target_hold_duration_ini);
end
%===========
expsetup.stim.esetup_saccade_target_hold_duration(tid)=temp1(1);



%% Target and/or distractor on?

a = [];
% Determine if it's single target trial or multiple targets
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'visually guided saccade');
ind2 = find(ind0==1);
if ind1<=ind2 % Single target only
    t1 = expsetup.stim.st1_only_probability_ini; 
    a(1:t1) = 1;
    temp1 = Shuffle(a);
else
    ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
    ind1 = find(ind0==1);
    ind0 = strcmp(expsetup.stim.training_stage_matrix, 'target & distractor all combinations');
    ind2 = find(ind0==1);
    if ind1>=ind2 % Single and double target
        t1 = expsetup.stim.st1_only_probability;
        if t1>0
            a(1:t1) = 1;
        end
        t1 = expsetup.stim.st2_only_probability;
        if t1>0
            if numel(a)>0
                a(end+1:end+t1) = 2;
            else
                a(1:t1) = 2;
            end
        end
        t1 = expsetup.stim.st1_st2_probability;
        if t1>0
            if numel(a)>0
                a(end+1:end+t1) = 3;
            else
                a(1:t1) = 3;
            end
        end
        temp1 = Shuffle(a);
    elseif ind1<ind2 % st1 & st2 always appear together
        t1 = expsetup.stim.st1_st2_probability_ini;
        a(1:t1) = 3;
        temp1 = Shuffle(a);
    end    
end

if temp1(1)==1
    expsetup.stim.esetup_target_number{tid} = 'st1';
elseif temp1(1)==2
    expsetup.stim.esetup_target_number{tid} = 'st2';
elseif temp1(1)==3
    expsetup.stim.esetup_target_number{tid} = 'st1 & st2';
end



%% Popout on/off?

%=========
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'popout');
ind2 = find(ind0==1);
a = [];
if ind1>=ind2
    t1 = expsetup.stim.popout_probability;
    if t1>0
        a(1:t1) = 1;
        if t1<=100
            a(t1+1:100) = 0;
        end
    else
        a(1)=0;
    end
    temp1 = Shuffle(a); % Select 1 or 2 targets
elseif ind1<ind2
    t1 = expsetup.stim.popout_probability_ini;
    if t1>0
        a(1:t1) = 1;
        if t1<=100
            a(t1+1:100) = 0;
        end
    else
        a(1)=0;
    end
    temp1 = Shuffle(a); % Select 1 or 2 targets
end
%===========
expsetup.stim.esetup_popout_on(tid) = temp1(1);


%% Target soa

%=========
if strcmp(expsetup.stim.esetup_exp_version{tid}, 'target soa decrease')
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_target_soa = temp1(1); % Copy variable for error trials
else
    temp1 = Shuffle(expsetup.stim.target_soa);
end
%===========

expsetup.stim.esetup_target_soa(tid) = temp1(1);


%% Stimuli positions

expsetup.stim.esetup_memory_coord(tid,1:2) = expsetup.stim.memory_coord_ini;

% Saccade/distractor positions
a = Shuffle(1:size(expsetup.stim.target_coord,1));
temp1 = expsetup.stim.target_coord(a,:);
st1 = temp1(1,1:2); % Target
st2 = temp1(2,1:2); % Distractor

expsetup.stim.esetup_st1_coord(tid,1:2) = st1;
expsetup.stim.esetup_st2_coord(tid,1:2) = st2;
    
    
%%  Initialize different colors and shapes

%=========
% Modified part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'all target shapes');
ind2 = find(ind0==1);
if ind1>=ind2
    a = 1:size(expsetup.stim.st1_color,1);
    temp1 = Shuffle(a);
    st1_color = expsetup.stim.st1_color;
    st1_shape = expsetup.stim.st1_shape;
    st1_angle = expsetup.stim.st1_angle;
    st2_color = expsetup.stim.st2_color;
    st2_shape = expsetup.stim.st2_shape;
    st2_angle = expsetup.stim.st2_angle;
    popout_color = expsetup.stim.popout_color;
    popout_shape = expsetup.stim.popout_shape;
    popout_angle = expsetup.stim.popout_angle;
elseif ind1<ind2
    a = 1:size(expsetup.stim.st1_color_ini,1);
    temp1 = Shuffle(a);
    st1_color = expsetup.stim.st1_color_ini;
    st1_shape = expsetup.stim.st1_shape_ini;
    st1_angle = expsetup.stim.st1_angle_ini;
    st2_color = expsetup.stim.st2_color_ini;
    st2_shape = expsetup.stim.st2_shape_ini;
    st2_angle = expsetup.stim.st2_angle_ini;
    popout_color = expsetup.stim.popout_color_ini;
    popout_shape = expsetup.stim.popout_shape_ini;
    popout_angle = expsetup.stim.popout_angle_ini;
end
%===========

% ST 1
expsetup.stim.esetup_st1_color(tid,1:3) = st1_color(temp1(1),1:3);
expsetup.stim.esetup_st1_shape{tid} = st1_shape{temp1(1)};
expsetup.stim.esetup_st1_angle(tid,1) = st1_angle(temp1(1),1);
if strcmp(expsetup.stim.esetup_st1_shape{tid}, 'rectangle')
    expsetup.stim.esetup_st1_size(tid,1:4) = expsetup.stim.st1_size;
    expsetup.stim.esetup_st1_size(tid,3) = expsetup.stim.esetup_st1_size(tid,3)/expsetup.stim.rectangle_size_ratio;
else
    expsetup.stim.esetup_st1_size(tid,1:4) = expsetup.stim.st1_size;
end

% ST 2
expsetup.stim.esetup_st2_color(tid,1:3) = st2_color(temp1(1),1:3);
expsetup.stim.esetup_st2_shape{tid} = st2_shape{temp1(1)};
expsetup.stim.esetup_st2_angle(tid,1) = st2_angle(temp1(1),1);
if strcmp(expsetup.stim.esetup_st2_shape{tid}, 'rectangle')
    expsetup.stim.esetup_st2_size(tid,1:4) = expsetup.stim.st2_size;
    expsetup.stim.esetup_st2_size(tid,3) = expsetup.stim.esetup_st2_size(tid,3)/expsetup.stim.rectangle_size_ratio;
else
    expsetup.stim.esetup_st2_size(tid,1:4) = expsetup.stim.st2_size;
end

% Popout
expsetup.stim.esetup_popout_color(tid,1:3) = popout_color(temp1(1),1:3);
expsetup.stim.esetup_popout_shape{tid} = popout_shape{temp1(1)};
expsetup.stim.esetup_popout_angle(tid,1) = popout_angle(temp1(1),1);
if strcmp(expsetup.stim.esetup_popout_shape{tid}, 'rectangle')
    expsetup.stim.esetup_popout_size(tid,1:4) = expsetup.stim.popout_size;
    expsetup.stim.esetup_popout_size(tid,3) = expsetup.stim.esetup_popout_size(tid,3)/expsetup.stim.rectangle_size_ratio;
else
    expsetup.stim.esetup_popout_size(tid,1:4) = expsetup.stim.popout_size;
end

% Memory 
expsetup.stim.esetup_memory_color(tid,1:3) = expsetup.stim.esetup_st1_color(tid,1:3);
expsetup.stim.esetup_memory_shape{tid} = expsetup.stim.esetup_st1_shape{tid};
expsetup.stim.esetup_memory_angle(tid,1) = expsetup.stim.esetup_st1_angle(tid,1);
expsetup.stim.esetup_memory_size(tid,1:4) = expsetup.stim.esetup_st1_size(tid,1:4);

% Pen width for drawing
expsetup.stim.esetup_target_pen_width(tid,1) = expsetup.stim.target_pen_width;
expsetup.stim.esetup_memory_pen_width(tid,1) = expsetup.stim.memory_pen_width;


%%  Memory target duration and memory delay
   
% Memory delay, varies as a stage of training
%=========
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'memory delay increase');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.memory_delay);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_memory_delay = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.memory_delay_ini);
end
%===========
expsetup.stim.esetup_memory_delay(tid) = temp1(1);

% Memory target duration
temp1 = Shuffle(expsetup.stim.memory_duration);
expsetup.stim.esetup_memory_duration(tid) = temp1(1);


%% Saccade accuracy

temp1=Shuffle(expsetup.stim.response_saccade_accuracy);
expsetup.stim.esetup_target_size_eyetrack(tid,1:4) = [0, 0, temp1(1), temp1(1)];


%% Total fixation duration

% If memory probe is shown, add it to the fixation maintenance duration
expsetup.stim.esetup_total_fixation_duration(tid) = ...
    expsetup.stim.esetup_fixation_maintain_duration(tid) + ...
    expsetup.stim.esetup_memory_duration(tid) + ...
    expsetup.stim.esetup_memory_delay(tid) + ...
    expsetup.stim.esetup_fixation_overlap_duration(tid);

expsetup.stim.esetup_total_time_to_st_onset(tid) = ...
    expsetup.stim.esetup_fixation_maintain_duration(tid) + ...
    expsetup.stim.esetup_memory_duration(tid) + ...
    expsetup.stim.esetup_memory_delay(tid);


%% Texture
% 
% % Is texture on
% temp1 = Shuffle(expsetup.stim.background_texture_on);
% expsetup.stim.esetup_background_texture_on(tid) = temp1(1);
% 
% % Angle of the texture
% temp1 = Shuffle(expsetup.stim.background_texture_line_angle);
% expsetup.stim.esetup_background_texture_line_angle(tid) = temp1(1);
% 
% % Number of lines
% temp1 = Shuffle(expsetup.stim.background_texture_line_number);
% expsetup.stim.esetup_background_texture_line_number(tid) = temp1(1);
% 
% % Line length
% temp1 = Shuffle(expsetup.stim.background_texture_line_length);
% expsetup.stim.esetup_background_texture_line_length(tid) = temp1(1);


%% 

%     % ST2 color level changes
%     if strcmp(expsetup.stim.esetup_exp_version{tid}, 'task switch luminance change') ||...
%             strcmp(expsetup.stim.esetup_exp_version{tid}, 'look luminance change') ||...
%             strcmp(expsetup.stim.esetup_exp_version{tid}, 'avoid luminance change')
%         % Calculate ST2 level
%         c1 = expsetup.stim.response_t2_color_task1;
%         d1 = expsetup.stim.esetup_background_color(tid,1:3) - c1;
%         a1 = c1 + d1 * expsetup.stim.esetup_st2_color_level(tid);
%         expsetup.stim.esetup_st2_color(tid,1:3) = a1;
%         var_copy.esetup_st2_color = expsetup.stim.esetup_st2_color(tid,1:3); % Copy variable for error trials
%     else
%         c1 = expsetup.stim.response_t2_color_task1;
%         expsetup.stim.esetup_st2_color(tid,1:3) = c1;
%     end
% 
% elseif expsetup.stim.esetup_block_cond(tid,1) == 2 && expsetup.stim.esetup_target_number(tid,1) == 2
%     
%     expsetup.stim.esetup_st1_coord(tid,1:2) = st_nonmem;
%     expsetup.stim.esetup_st2_coord(tid,1:2) = st_mem;
%     expsetup.stim.esetup_st1_color(tid,1:3) = expsetup.stim.response_t2_color_task2;
%     expsetup.stim.esetup_target_shape{tid} = expsetup.stim.response_shape_task2;
%     
%     % ST2 color level changes
%     if strcmp(expsetup.stim.esetup_exp_version{tid}, 'task switch luminance change') ||...
%             strcmp(expsetup.stim.esetup_exp_version{tid}, 'look luminance change') ||...
%             strcmp(expsetup.stim.esetup_exp_version{tid}, 'avoid luminance change')
%         % Calculate ST2 level
%         c1 = expsetup.stim.response_t1_color_task2;
%         d1 = expsetup.stim.esetup_background_color(tid,1:3) - c1;
%         a1 = c1 + d1 * expsetup.stim.esetup_st2_color_level(tid);
%         expsetup.stim.esetup_st2_color(tid,1:3) = a1;
%         var_copy.esetup_st2_color = expsetup.stim.esetup_st2_color(tid,1:3); % Copy variable for error trials
%     else
%         c1 = expsetup.stim.response_t1_color_task1;
%         expsetup.stim.esetup_st2_color(tid,1:3) = c1;
%     end
%     


% % ST2 color, varies as a stage of training. For look/avoid task ST2 color
% % level and step is the same.
% %=========
% if strcmp(expsetup.stim.esetup_exp_version{tid}, 'task switch luminance change') ||...
%         strcmp(expsetup.stim.esetup_exp_version{tid}, 'look luminance change') ||...
%         strcmp(expsetup.stim.esetup_exp_version{tid}, 'avoid luminance change')
%     temp1 = Shuffle(tv1(1).temp_var_current);
%     var_copy.esetup_st2_color_level = temp1(1); % Copy variable for error trials
% else
%     temp1 = Shuffle(expsetup.stim.st2_color_level);
% end
% 
% % End of fixed part
% %===========
% expsetup.stim.esetup_st2_color_level(tid) = temp1(1);

%% If previous trial was an error, then copy settings of the previous trial

if tid>1
    if expsetup.stim.trial_error_repeat == 1 % Repeat error trial immediately
        if  ~strcmp(expsetup.stim.edata_error_code{tid-1}, 'correct')
            f1 = fieldnames(expsetup.stim);
            ind = strncmp(f1,'esetup', 6);
            for i=1:numel(ind)
                if ind(i)==1
                    if ~iscell(expsetup.stim.(f1{i}))
                        [m,n,o]=size(expsetup.stim.(f1{i}));
                        expsetup.stim.(f1{i})(tid,1:n,1:o) = expsetup.stim.(f1{i})(tid-1,1:n,1:o);
                    elseif iscell(expsetup.stim.(f1{i}))
                        expsetup.stim.(f1{i}){tid} = expsetup.stim.(f1{i}){tid-1};
                    end
                end
            end
        end
    end
end

%% Training protocol update
% If previous trial was an error, some stimulus properties are not copied
% (very important, else task will not get easier)

if tid>1
    if expsetup.stim.trial_error_repeat == 1 % Repeat error trial immediately
        if  ~strcmp(expsetup.stim.edata_error_code{tid-1}, 'correct')
            if ~isempty(fieldnames(var_copy))
                f1 = fieldnames(var_copy);
                for i=1:numel(f1)
                    if ~iscell(expsetup.stim.(f1{i}))
                        [m,n,o]=size(var_copy.(f1{i}));
                        expsetup.stim.(f1{i})(tid,1:n,1:o) = var_copy.(f1{i})(1:m,1:n,1:o);
                    elseif iscell(expsetup.stim.(f1{i}))
                        expsetup.stim.(f1{i}){tid} = var_copy.(f1{i});
                    end
                end
            end
        end
    end
end

