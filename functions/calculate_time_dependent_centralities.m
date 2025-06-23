function [alphas, time_min, time_05, time_085] = calculate_time_dependent_centralities(A_1,A_2,A_3,A_4,A_5)
    % Calculate the katz time dependent centralities which are based on the
    % max eigenvalue of the matrices. Alpha_deg is not used in these
    % experiments.
    
    max_eig = calculate_max_eig(A_1,A_2,A_3,A_4,A_5);
    alpha_min = (1 - exp(-max_eig)) / max_eig;
    time_min = calculate_katz(A_1, A_2, A_3, A_4, A_5, alpha_min);
    alpha_05 = 0.5 / max_eig;
    time_05 = calculate_katz(A_1, A_2, A_3, A_4, A_5, alpha_05);
    alpha_085 = 0.85 / max_eig;
    time_085 = calculate_katz(A_1, A_2, A_3, A_4, A_5, alpha_085);
    alphas = [alpha_min; alpha_05; alpha_085];
end

function max_eig = calculate_max_eig(A_1,A_2,A_3,A_4,A_5)
    % Calculate the maximum eigenvalue of all the 5 time-dependent arrays
    eigs_matrix = zeros([6,5]);
    eigs_matrix(:,1) = eigs(A_1);
    eigs_matrix(:,2) = eigs(A_2);
    eigs_matrix(:,3) = eigs(A_3);
    eigs_matrix(:,4) = eigs(A_4);
    eigs_matrix(:,5) = eigs(A_5);
    max_eig = max(eigs_matrix, [], "all");
end

function centrality = calculate_katz(A_1, A_2, A_3, A_4, A_5, alpha)
    % Calculate the Time-Dependent Centrality through repetitive use of the
    % backslash operation.
    mat_size = size(A_1,1);
    A = (speye(mat_size) - (alpha .* A_5));
    centrality = full(A \ sparse(ones([size(A,1),1])));
    A = (speye(mat_size) - (alpha .* A_4));
    centrality = full(A \ centrality);
    A = (speye(mat_size) - (alpha .* A_3));
    centrality = full(A \ centrality);
    A = (speye(mat_size) - (alpha .* A_2));
    centrality = full(A \ centrality);
    A = (speye(mat_size) - (alpha .* A_1));
    centrality = full(A \ centrality);
end