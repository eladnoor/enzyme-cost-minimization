function [my_c, my_u, my_up, my_u_cost, my_A_forward, my_x, my_grad, my_lambda] = ecm_one_run(ecm_score,pp,x_min,x_max,x_init,ecm_options,opt)

%% optimize log concentration profile

[my_x, my_fval,my_exitflag,my_output,my_lambda,my_grad] = fmincon(@(xx) ecm_get_score(ecm_score,xx,pp) + ecm_regularisation(xx,x_min,x_max,ecm_options.lambda_regularisation), x_init,[],[],[],[],x_min,x_max,@(xx) ecm_inequalities(xx,pp.N_forward,pp.log_Keq_forward),opt);

my_c         = exp(my_x);
my_A_forward = RT * [pp.log_Keq_forward - pp.N_forward' * log(my_c)]; my_A_forward(pp.ind_not_scored) = nan;

%% compute resulting enzyme profile

[my_u_cost, my_u]        = ecm_get_score(ecm_score,my_x,pp);
my_up                    = my_u; 
my_up(pp.ind_not_scored) = nan;
