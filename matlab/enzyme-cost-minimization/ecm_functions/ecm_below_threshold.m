function [ineq_constraints, eq_constraints] = ecm_below_threshold(ecm_score,xx,pp,u_threshold,x_min,x_max,ecm_options)

% function needed for enzyme cost minimization

a1 = ecm_get_score(ecm_score,xx,pp) + ecm_regularisation(xx,x_min,x_max,ecm_options.lambda_regularisation) - u_threshold;
 
a2 = ecm_inequalities(xx,pp.N_forward,pp.log_Keq_forward);

ineq_constraints = [a1; a2];
eq_constraints   = [];