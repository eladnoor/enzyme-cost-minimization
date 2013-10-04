% --------------------------------------------------
% Model building based on Flux-Specific Enzyme Costs 
% --------------------------------------------------
% 
% There are two ways to run a FSC optimisation: 
% 
% 1. Create model and options within MATLAB and run 'flux_specific_enzyme_cost'
% 
% 2. Prepare the model (SBtab format) and options (text files) 
%    in a model directory and run the three matlab commands 
%    'fsc_prepare_model', 'fsc_prepare_data', and 'fsc_model'.
%    All necessary information will be read from the input files.
% 
% 
% Here the second option is described in more detail: 
% 
%   o Create a directory for your model ("model directory")
%   
%   o Put SBtab files describing your model into the model directory
%   
%   o Put options file 'fsc_options.txt' into the model directory
%   
%   o Put options file 'fsc_options_data_<DATASET>.txt' into the model directory
%   
%   o Put options file 'fsc_options_run_<FSC_RUN>.txt' into the directory
%   
%   o Run 'fsc_prepare_model(<MODEL_DIRECTORY>)'
%   
%   o Run 'fsc_prepare_data(<MODEL_DIRECTORY>, <DATASET>)';
%   
%   o Run 'fsc_model(<MODEL_DIRECTORY>, <FSC_RUN>)';
% 
% 
% All output files will be written to the model directory
%    (note that files in this directory may be overwritten)
% 
% 
% --------------------------------------------------------------------
% --------------------------------------------------------------------
% 
% Format of the file "fsc_options.txt"
% 
% Using the file fsc_options.txt, you can define a number of matlab variables
% that control which models will be built and how. Here is an example:
% 
% --------------------------------------------------------------------
% 
% fsc_options.model_name = 'ecoli_glycolysis';
% fsc_options.sbml_file  = 'ecoli_glycolysis_network.xml';
% fsc_options.methods    = {'mtdf','mtdfw','mpsc2sub','psc1','psc2sub','psc2','psc3','psc4cmr'};
% 
% --------------------------------------------------------------------
% 
% Running the calculations:
% 
% [c, u, u_tot, up, A_forward] = fsc_model('~/projekte/pathway_specific_cost/psc/models/ecoli_glycolysis')