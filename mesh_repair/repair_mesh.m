%{
Calculates a repaired version of the mesh that was passed in
	mesh		a mesh object to repair
	rho			optional, a parameter that essentially determines how much the points are moved
				in each step, leaving it at default is generally fine (default 100)
	verbose		optional, if set to true prints progress messages (default false)
returns:
	new_mesh	the repaired mesh
%}
function new_mesh = repair_mesh(mesh, rho, verbose)
	if nargin < 2 rho = 100; end

	% pre processing
	m = size(mesh.cells, 1);
	n = size(mesh.points, 1);
	org_points = mesh.points;
	cells = mesh.cells;

	new_mesh.cells = mesh.cells;
	cur_points = mesh.points;

	% create models, for projection step + finding min value
	tic
	projection_model = create_projection_model();
	opt_point_model = SOS_jacobian_batch_model();
	t0 = toc;

	disp("Finished creating models in " + t0 + " seconds.")

	% H is matrix expansion of indicies, used in the matrix for the X step
	A = [speye(n); sparse(1:8*m, reshape(cells', 8*m, 1), rho/2)];

	% whether we've found a valid solution!
	done = false;

	% Zs are the projected verticies
	Zs = permute(reshape(cur_points(cells', :)', [3,8,m]), [2,1,3]);

	check_hex_mask = ones(m, 1);

	while(~done) 
		% apply projection (Z step)
		invalid_hex = zeros(m,1);

		for i=1:m
			if check_hex_mask(i) == 1 % only calculate if we need to check this hex
				vertices = cur_points(cells(i, :), :);

				[low_value, min_point] = opt_point_model(vertices);
				cur_vertices = vertices;
				invalid = false;

				while low_value < 0
					invalid = true;
					V = projection_model([cur_vertices; min_point'])
					cur_vertices = V;
	
					[low_value, min_point] = opt_point_model(cur_vertices);
				end

				invalid_hex(i) = invalid;
				Zs(:,:,i) = cur_vertices;
			end
		end

		if nargin >= 3 && verbose
			disp("Finsihed Z step...")
		end

		done = nnz(invalid_hex) == 0;
		if done
			if nargin >= 3 && verbose
				disp("Every hex is valid!")
			end

			break
		else
			if nargin >= 3 && verbose
				disp("There are " + nnz(invalid_hex) + " broken hexes." )
			end
		end

		% X step		
		b = [org_points; rho/2 * reshape(permute(Zs, [1,3,2]), 8*m, 3)];

		prev_points = cur_points;
		cur_points = A\b;

		% don't check hexes that didn't change
		pts_changes = sum(abs(prev_points - cur_points) > 1e-12, 2) >= 1;
		check_hex_mask = (sum(pts_changes(cells), 2) ~= 0) | invalid_hex;

		if nargin >= 3 && verbose
			disp("Completed a cycle.")
		end

		new_mesh.points = cur_points;
	end

	new_mesh.points = cur_points;
end


function model = create_projection_model()
	cur = sdpvar(8, 3);
	sdpvar u v w;

	V = sdpvar(8, 3);
	J = symbolic_jacobian_det(V, [u,v,w]);
	F = [J >= 0]

	Objective = sum((V(:)-cur(:)).^2)
	model = optimizer(F, Objective, [], [cur; u, v, w], V)
end