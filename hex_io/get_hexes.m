%{
This function is used to extract a subset of the hexes in a mesh
	mesh	A mesh object from which the hexes should be extracted
	hexes	A Nx1 vector of integers representing the position in the mesh 
			of the hexes to be returned 
returns:
	V		A 8x3xN tensor with the vertices of the specified hexes
%}
function V = get_hexes(mesh, hexes)
	N = length(hexes);
	C = mesh.cells(hexes, :);
	V = permute(reshape(mesh.points(C', :)', [3,8,N]), [2,1,3]);
end