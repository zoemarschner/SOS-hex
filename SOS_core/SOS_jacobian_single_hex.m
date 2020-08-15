%{
Computes the minimum Jacobian determinant, argmin, and 2nd Eigenvalue for a single hex. There isn't really a case where
you'd want to use this over SOS_jacobian_batch_model, but it's included here since it better shows the core of the algorithm,
and simplify testing this code with a single hex. 
	V			the vertices of the hex
	k			optional, the degree of the SOS relaxation (default 4)
returns:
	J			the minimum Jacobian determinant over the hex
	argmin		the location in parameter space ([0,1]^3) at which J occurs
	second_eig	the second Eigenvalue of the moment matrix, a measure of exact recovery
%}

function [J, argmin, second_eig] = SOS_jacobian_single_hex(V, k)
	if nargin < 2 k = 4; end

	sdpvar u v w bound;

	% set up model
	vars = [u, v, w];
	J = symbolic_jacobian_det(V, vars);

	[s1, s1_c] = polynomial(vars, k);
	[s2, s2_c] = polynomial(vars, k);
	[s3, s3_c] = polynomial(vars, k);
	[s4, s4_c] = polynomial(vars, k);
	[s5, s5_c] = polynomial(vars, k);
	[s6, s6_c] = polynomial(vars, k);

	domain = [u; 1 - u; v; 1 - v; w; 1 - w];

	F_sos = [sos(s1), sos(s2), sos(s3), sos(s4), sos(s5), sos(s6)];
	F_positiv = sos(J - bound - [s1, s2, s3, s4, s5, s6]*domain);

	[F, obj, m] = sosmodel([F_sos, F_positiv], -bound, [], [s1_c; s2_c; s3_c; s4_c; s5_c; s6_c; bound]);
	
	% solve the problem
	optimize(F, obj, []);

	% extract the answers
	J = value(bound);

	moment_mat = dual(F(8));
	moment_mat = moment_mat/moment_mat(1,1);

	eig_vals = eig(moment_mat);
	second_eig = eig_vals(2);

	point = moment_mat(2:4, 1);
	argmin = point(end:-1:1);
end