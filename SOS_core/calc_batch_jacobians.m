%{
Calculates the jacobians of a tensor of N hexes. (good for computing jacobians of the results of rand_hex(N) or get_hexes) 
If you need to compute the jacobians for an entire mesh, use calc_mesh_jacobians instead 
	Vs			an 8x3xN tensor where each 8x3 matrix is the vertices of one hex.
	verbose		optional, if set to true prints progess (default 0)
	save_file	optional, if specificied jacobians, argmins, and 2nd eigen values will be written to this file
returns:
	Js			a Nx1 vector of the the minimum Jacobian determinants over the hexes
	argmins		a Nx3 vector of the locations in parameter space ([0,1]^3) at which the Js occur
	second_eigs	a Nx1 vector of the second Eigenvalues of the moment matrix (a measure of exact recovery)
%}
function [Js, argmins, second_eigs] = calc_batch_jacobians(Vs, verbose, save_file)
	N = size(Vs, 3);
	model = SOS_jacobian_batch_model;

	Js = zeros(N,1);
	argmins = zeros(N,3);
	second_eigs = zeros(N,1);
	
	for i=1:N
		[J, amin, eig2] = model(Vs(:,:,i));
		Js(i) = J;
		argmins(i, :) = amin;
		second_eigs(i) = eig2;

		if nargin >= 2 && verbose
			disp("finished " + i + " out of " + N)
		end
	end

	if nargin == 3
		writematrix([Js, argmins, second_eigs], save_file)
	end

end