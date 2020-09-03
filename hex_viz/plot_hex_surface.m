%{
A plot of a single hex with its 6 faces colored based on its jacobians. This will not show the interior of the hex when
it should be visible from outside the hex due to invalidity, but it's still pretty clear to see the shape of the hex 
and it's much faster.
 	V			vertices of the hex
 	res			optional, the number of rectangle per axis to use (so total # of rectangles is 6 * res^2) (default 100)
	camera		optional, the camera angle (default 3)
	color_map	optional, color map to use (default "parula")
	arg_min		optional, 3x1 vector in reference domain [0,1]^3. if specified that point will be plotted
%}
function plot_hex_surface(V, res, camera, color_map, arg_min)
	if nargin < 4 color_map = "parula"; end
	if nargin < 3 camera = 3; end
	if nargin < 2 res = 100; end

	figure()

	% draw wireframe
	drawing_i = [1,2,3,4,1,5,8,7,6,5,8,4,3,7,6,2];
	drawing_V = V(drawing_i, :);
	plot3(drawing_V(:, 1), drawing_V(:, 2), drawing_V(:, 3), 'Color', 'black')
	
	hold on
	view(camera)
	colormap(color_map)
	axis image vis3d off;

	% draw surfaces
	[X,Y] = meshgrid(linspace(0, 1, res));
	v_0 = repelem(0, res^2, 1);
	v_1 = repelem(1, res^2, 1);
	faces = {[v_0, X(:), Y(:)], [X(:), v_0, Y(:)], [X(:), Y(:), v_0], [v_1, X(:), Y(:)], [X(:), v_1, Y(:)], [X(:), Y(:), v_1]};

	for face=faces
		determinants = symbolic_jacobian_det(V, face{1});
		map = symbolic_trilinear_map(V, face{1});
		surf(reshape(map(:, 1), res, res), reshape(map(:, 2), res, res), reshape(map(:, 3), res, res), reshape(determinants, res, res), 'EdgeColor', 'none');
	end

	% arg_min if applicable
	if nargin == 5
		[X, Y, Z] = sphere();
		r = 0.03;
		pt = symbolic_trilinear_map(V, arg_min);
		surf(r .* X + pt(1), r .* Y + pt(2), r .* Z + pt(3), 'FaceColor', 'red', 'EdgeColor', 'none')
	end
end