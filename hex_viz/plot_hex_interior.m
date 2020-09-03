%{
A plot of a single hex colored based on its jacobian, which shows the interior of the hex, by 
plotting sampled points. For most cases, plot_hex_surface should be used. plot_hex_interior is mainly
intended to plot hexes where its important to be able to see what's going on in the interior, especially 
when making final images of the hex.
 	V			vertices of the hex
 	res			optional, the number of points per axis to use (so total # of points is res^3) (default 30)
	camera		optional, the camera angle (default 3)
	color_map	optional, color map to use (default "parula")
	pt_size		optional, size of points (default 5)
	arg_min		optional, 3x1 vector in reference domain [0,1]^3. if specified that point will be plotted
%}
function plot_hex_interior(V, res, camera, color_map, pt_size, arg_min) 
	if nargin < 5 pt_size = 5; end
	if nargin < 4 color_map = "parula"; end
	if nargin < 3 camera = 3; end
	if nargin < 2 res = 30; end

	% interior points
	[X, Y, Z] = meshgrid(linspace(0, 1, res));
	map = symbolic_trilinear_map(V, [X(:), Y(:), Z(:)]);
	jacobians = symbolic_jacobian_det(V, [X(:), Y(:), Z(:)]);

	figure();
	scatter3(map(:, 1), map(:, 2), map(:, 3), 4, jacobians, 'filled');
	view(camera);
	colormap(color_map)
	axis image vis3d off;
	hold on

	% wireframe
	drawing_i = [1,2,3,4,1,5,8,7,6,5,8,4,3,7,6,2];
	drawing_V = V(drawing_i, :);
	plot3(drawing_V(:, 1), drawing_V(:, 2), drawing_V(:, 3), 'Color', 'black')

	% arg_min if applicable
	if nargin == 6
		[X, Y, Z] = sphere();
		r = 0.03;
		pt = symbolic_trilinear_map(V, arg_min);
		surf(r .* X + pt(1), r .* Y + pt(2), r .* Z + pt(3), 'FaceColor', 'red', 'EdgeColor', 'none')
	end
end