%{
Saves a mesh object to a .vtk file, and optionally also saves the jacobians as a .csv.
	mesh			the mesh object to save
	file_name		the file to write to
	save_jacobians	optional, a boolean flag that determines whether the jacobians should be saved (default false)
	jacobian_file	optional, specifies the file to save the jacobians to (default <file_name>_jacobians.csv)
					it's not recommended to set this, as it'll make loading the csvs slightly more difficult
%}
function save_vtk(mesh, file_name, save_jacobians, jacobian_file)
	if nargin < 4
		[file_path, name, ext] = fileparts(file_name);
		jacobian_file = fullfile(file_path, name + "_jacobians.csv");

		if nargin < 3 save_jacobians = false; end
	end

	file = fopen(file_name, 'wt');

	fprintf(file, '# vtk DataFile Version 3.0\n%s\nASCII\nDATASET UNSTRUCTURED_GRID\n', file_name);

	fprintf(file, 'POINTS %d double\n', size(mesh.points, 1));
	fprintf(file, '%.15f %.15f %.15f\n', mesh.points');

	fprintf(file, 'CELLS %d %d\n', size(mesh.cells, 1), 9*size(mesh.cells, 1));
	fprintf(file, '8 %d %d %d %d %d %d %d %d\n', mesh.cells' - 1);

	fprintf(file, 'CELL_TYPES %d\n', size(mesh.cells, 1));
	fprintf(file, '%d \n', ones(size(mesh.cells, 1),1).*12);

	fclose(file);

	if save_jacobians
		writematrix(mesh.jacobians, jacobian_file)
	end
end