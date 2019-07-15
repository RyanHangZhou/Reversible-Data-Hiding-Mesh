function meshPlot(vertex, face)
%Plot mesh

% trimesh(face, vertex(:, 1), vertex(:, 2), vertex(:, 3));
% colormap(gray); axis equal;

plot_mesh(vertex, face);
shading faceted; 
camlight;

end