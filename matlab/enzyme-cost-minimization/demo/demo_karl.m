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


% --------------------------------------------------------
% Set file names

result_DIR = 'results';
infile_ecm = 'data/ecm_karl.csv';
%infile_ecm = 'data/ecm_ecoli_aerobic.csv';

% --------------------------------------------------------
% Run Enzyme Cost Minimization

options = struct('actions','ecm_standard');
%options = struct('actions','parameter_balancing');

[report, errors] = ecm_simple(infile_ecm, result_DIR, options);

%% --------------------------------------------------------
% Correlate results with measured proteomics
my_sbtab = sbtab_document_load_from_one(infile_ecm);
genes = sbtab_table_get_column(my_sbtab.tables.Reaction,'Gene',0);
meas_reaction_names = sbtab_table_get_column(my_sbtab.tables.EnzymeConcentration,'Reaction',0);
meas_data = sbtab_table_get_column(my_sbtab.tables.EnzymeConcentration,'EnzymeConcentration',1);

result_sbtab = sbtab_document_load_from_one([result_DIR '/ecm_result.csv_Predictions.csv']);
pred_reaction_names = sbtab_table_get_column(result_sbtab.tables.Predictedenzymelevels,'Reaction',0);
pred_headers = result_sbtab.tables.Predictedenzymelevels.uncontrolled.headers;
pred_data = str2double(result_sbtab.tables.Predictedenzymelevels.uncontrolled.data);

% make sure that the order of reactions is identical
assert(all(strcmp(meas_reaction_names, pred_reaction_names)));

%%
method = 'ecf3s';
%method = 'ecf4cmr';
method_col = find(ismember(pred_headers, method));
correlate_loglog(meas_data1, pred_data(:, method_col), genes, method);
