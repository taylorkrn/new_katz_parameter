% We load the 5 time-dependent datasets and then generate the overall
% connection Adjacency matrix for the week. The Adjacency matrices are then
% plotted
A_1 = load_matrix('T_1');
A_2 = load_matrix('T_2');
A_3 = load_matrix('T_3');
A_4 = load_matrix('T_4');
A_5 = load_matrix('T_5');

A_week = double(((((A_1 | A_2) | A_3) | A_4) | A_5));

f = figure;
tiledlayout(2,3)

% Plot A_1
nexttile
spy(A_1)
title('A_1')

% Plot A_2
nexttile
spy(A_2)
title('A_2')

% Plot A_3
nexttile
spy(A_3)
title('A_3')

% Plot A_4
nexttile
spy(A_4)
title('A_4')

% Plot A_5
nexttile
spy(A_5)
title('A_5')

% Plot A_week
nexttile
spy(A_week)
title('A_{week}')

filePath = "plots/time_dependency_matrices.png";
exportgraphics(f,filePath,'Resolution',300);

function A = load_matrix(matrix_name)
    dataname_string = sprintf('data/%s.mat',matrix_name);
    A = load(dataname_string);
    A = A.(matrix_name);
end



