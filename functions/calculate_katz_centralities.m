function [alphas, times, conds, c_min, c_05, c_085, c_deg] = calculate_katz_centralities(A)
    % This function calculates 4 different Katz centrality vectors based on
    % an Adjacency matrix A. The 4 different values of alpha are c_min,
    % which is described in the paper: 
    %
    % Mary Aprahamian, Desmond J. Higham, Nicholas J. Higham, Matching 
    % exponential-based and resolvent-based centrality measures, Journal 
    % of Complex Networks, Volume 4, Issue 2, June 2016, Pages 157–176, 
    % https://doi.org/10.1093/comnet/cnv016
    %
    % Along with c_05 = 0.5 * 1/lambda, c_085 = 0.85 * 1/lambda, and 
    % c_deg = 1 / ||A|| + 1
    %
    % The alpha values, time required to calculate the centrality vectors, 
    % conditional numbers and centrality vectors are returned. 

    % Set up results
    mat_size = size(A,1);
    alphas = zeros([4,1]);
    times = zeros([4,1]);
    conds = zeros([4,1]);

    % Compute Eigenvalues
    tic
    eigenvalues = eigs(A);
    lambda = eigenvalues(1);
    eig_time = toc;

    [alphas(1,1), c_min, times(1,1), conds(1,1)] = calculate_min(A, mat_size, lambda, eig_time);
    [alphas(2,1), c_05, times(2,1), conds(2,1)] = calculate_05(A, mat_size, lambda, eig_time);
    [alphas(3,1), c_085, times(3,1), conds(3,1)] = calculate_085(A, mat_size, lambda, eig_time);
    [alphas(4,1), c_deg, times(4,1), conds(4,1)] = calculate_deg(A, mat_size);
end

function [alpha, centrality, time, cond] = calculate_min(A, mat_size, lambda, eig_time)
    % Calculate c_min
    tic
    alpha = (1 - exp(-lambda)) / lambda;
    A_min = (speye(mat_size) - (alpha .* A));
    centrality = full(A_min \ sparse(ones([mat_size,1])));
    % centrality = A_min \ ones([mat_size,1]);
    end_time = toc;
    time = end_time + eig_time;
    cond = condest(A_min,1);    
end

function [alpha, centrality, time, cond] = calculate_05(A, mat_size, lambda, eig_time)
    % Calculate c_05
    tic
    alpha = 0.5 / lambda;
    A_05 = (speye(mat_size) - (alpha .* A));
    centrality = full(A_05 \ sparse(ones([mat_size,1])));
    % centrality = A_05 \ ones([mat_size,1]);
    end_time = toc;
    time = end_time + eig_time;
    cond = condest(A_05,1);    
end

function [alpha, centrality, time, cond] = calculate_085(A, mat_size, lambda, eig_time)
    % Calculate c_085
    tic
    alpha = 0.85 / lambda;
    A_085 = (speye(mat_size) - (alpha .* A));
    centrality = full(A_085 \ sparse(ones([mat_size,1])));
    % centrality = A_085 \ ones([mat_size,1]);
    end_time = toc;
    time = end_time + eig_time;
    cond = condest(A_085,1);    
end


function [alpha, centrality, time, cond] = calculate_deg(A, mat_size)
    % Calculate c_deg
    tic
    alpha = 1 / (norm(A,Inf) + 1);
    A_deg = (speye(mat_size) - (alpha .* A));
    centrality = full(A_deg \ sparse(ones([mat_size,1])));
    % centrality = A_deg \ ones([mat_size,1]);
    time = toc;
    cond = condest(A_deg,1);    
end