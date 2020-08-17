%{
Plots a mesh object, coloring each hex by jacobian if they're specified
	mesh		a mesh object to repair
	cam			optional, the initial camera position (default 3)
	light_vec	optional, the position of the light (default [1,1,1])
	color_map 	optional, color map to use (default "parula")
	z_up		optional, if set to 1 the y and z coordiantes will be switched (default false)
%}
function plot_mesh(mesh, cam, light_vec, color_map, z_up)
	points = mesh.points;
	if nargin == 5 && z_up points = [points(:,1), points(:,3), points(:,2)]; end
	if nargin < 4 color_map = "parula"; end
	if nargin < 3 light_vec = [1,1,1]; end
	if nargin < 2 cam = 3; end


	N = size(mesh.cells, 1);
	mask = [ 1 2 3 4; 6 7 3 2; 7 8 4 3; 8 5 1 4; 5 6 2 1; 6 5 8 7];

	rep_cells = repelem(mesh.cells, 6, 1)';
	rep_mask = (repmat(mask, N, 1) + 8.*repmat(0:6*N-1, 4, 1)')';
	rep_cells(rep_mask(:));
	faces = reshape(rep_cells(rep_mask(:)), 4, 6*N)';

	figure()

	if isfield(mesh,'jacobians')
		rep_jacobians = repelem(mesh.jacobians(:, 1)', 6)'; 
		patch(gca, "Faces", faces, "Vertices", points, "CData", rep_jacobians, 'FaceAlpha', 1, 'FaceColor', 'flat', 'LineWidth', 0.25);
	else
		patch(gca, "Faces", faces, "Vertices", points, 'FaceAlpha', 0, 'FaceColor', 'flat', 'LineWidth', 0.25);

	end

	hold on 
	view(cam)
	axis image vis3d off;
	colormap(color_map);

	light('Position', light_vec, 'Style','local');
	lighting gouraud
	material([0.4, 1, 0.001, 10])
end
	