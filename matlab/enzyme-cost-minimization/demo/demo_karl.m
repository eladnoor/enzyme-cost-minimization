% --------------------------------------------------------
% Demo script for Parameter Balancing and Enzyme Cost Minimization
%
% Prepared model files for E coli central metabolism.are used.
% 
% The MATLAB function 'ecm_simple' is a wrapper function 
% that reads the data, sets some default parameters, and calls 
% dedicated functions for Parameter Balancing or Enzyme Cost Minimization.
%
% The input files (in SBtab format) are given in the subdirectory 'data'
% The results (in SBtab format) are written to the subdirectory 'results'
% --------------------------------------------------------

[path, ~, ~] = fileparts(which(mfilename));
result_path = [path '/results'];
infile_ecm = [path '/data/ecm_karl.csv'];

% --------------------------------------------------------
% Run Enzyme Cost Minimization

options = struct('actions','ecm_standard');
%options = struct('actions','parameter_balancing');

[report, errors] = ecm_simple(infile_ecm, result_path, options);

%% --------------------------------------------------------
% Correlate results with measured proteomics
my_sbtab = sbtab_document_load_from_one(infile_ecm);
model_gene = sbtab_table_get_column(my_sbtab.tables.Reaction,'NameForPlots',0);
model_bnumber = sbtab_table_get_column(my_sbtab.tables.Reaction,'Bnumber',0);
meas_reaction_names = sbtab_table_get_column(my_sbtab.tables.EnzymeConcentration,'Reaction',0);

proteome_bnumber = sbtab_table_get_column(my_sbtab.tables.Proteomics,'Bnumber',0);
proteome_abundance = sbtab_table_get_column(my_sbtab.tables.Proteomics,'Abundance',1);

%%
if false
    %meas_data = sbtab_table_get_column(my_sbtab.tables.EnzymeConcentration,'EnzymeConcentration',1);
else
    meas_data = zeros(size(model_bnumber));
    for i = 1:length(model_bnumber)
        bnumbers = strsplit(model_bnumber{i}, ' + ');
        for j = 1:length(bnumbers)
            idx = find(ismember(proteome_bnumber, bnumbers{j}));
            if ~isempty(idx)
                meas_data(i) = meas_data(i) + proteome_abundance(idx);
            end
        end
    end
    
    % convert copies per fl (of cytoplasm) to mM
    V_cell = 0.66e-3; % [L] for 1L of culture at OD600 = 1
    N_A = 6.022e23;
    meas_data = meas_data * (1e15 / N_A) / V_cell;
end

%%
result_sbtab = sbtab_document_load_from_one([result_path '/ecm_result.csv_Predictions.csv']);
pred_reaction_names = sbtab_table_get_column(result_sbtab.tables.Predictedenzymelevels,'Reaction',0);
pred_headers = result_sbtab.tables.Predictedenzymelevels.uncontrolled.headers;
pred_data = str2double(result_sbtab.tables.Predictedenzymelevels.uncontrolled.data);

% make sure that the order of reactions is identical
assert(all(strcmp(meas_reaction_names, pred_reaction_names)));

%%
%method = 'ecf3s';
method = 'ecf3s';
method_col = find(ismember(pred_headers, method));
correlate_loglog(meas_data, pred_data(:, method_col), model_gene);
xlabel('Meas. abundance (mM)');
ylabel(['Pred. abundance (mM): ' method]);