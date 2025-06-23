% Generate and save random time-dependent data.

[T_1, T_2, T_3, T_4, T_5] = generate_5_random_day_data(150,0.01);

save('data/T_1.mat','T_1');
save('data/T_2.mat','T_2');
save('data/T_3.mat','T_3');
save('data/T_4.mat','T_4');
save('data/T_5.mat','T_5');

function [T_1, T_2, T_3, T_4, T_5] = generate_5_random_day_data(num_nodes, density)
    % Generate random 'email' data for a standard work week. The element
    % (T_ij) will then represent whether person i emailed person j on that
    % particular day (or at any point during the week).

    T_1 = sprand(num_nodes,num_nodes,density);
    T_1 = adjust_adjacency_matrix(T_1, num_nodes);
    T_2 = sprand(num_nodes,num_nodes,density);
    T_2 = adjust_adjacency_matrix(T_2, num_nodes);
    T_3 = sprand(num_nodes,num_nodes,density);
    T_3 = adjust_adjacency_matrix(T_3, num_nodes);
    T_4 = sprand(num_nodes,num_nodes,density);
    T_4 = adjust_adjacency_matrix(T_4, num_nodes);
    T_5 = sprand(num_nodes,num_nodes,density);
    T_5 = adjust_adjacency_matrix(T_5, num_nodes);
end

function T = adjust_adjacency_matrix(T, num_nodes)
    % Convert random matrix to an unweighted adjancency matrix so that
    % there are no self-loops.

    for i=1:num_nodes
        % Remove diagonal elements
        T(i,i) = 0;
    end
    % Change to unweighted
    T = sparse(double(T & T));
end