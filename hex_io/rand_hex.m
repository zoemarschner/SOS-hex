%{
Generates N random hexes for testing by perturbing each vertex randomly using a gaussian 
distribution with standard deviation sigma
	N		number of hexes to generate, optional, default=1
	simga	standard deviation, optional, default=0.3
returns:
	V		vertices, 8x3xN (where each 8x3 matrix is a hex)
%}
function V = rand_hex(N, sigma)
	if nargin < 2 sigma = 0.3; end
	if nargin < 1 N = 1; end
	
	base = repmat([0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1], [1,1, N]);
	V = normrnd(0, sigma, [8, 3, N]) + base;
end