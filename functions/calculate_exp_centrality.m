function [c_exp, time] = calculate_exp_centrality(A)
    % This function runs expmv to calculate the exponential centrality
    % vector of an Adjacency Matrix A.
    % 
    % The function expmv can be found in the expmv file and was precured
    % from https://github.com/higham/expmv
    %
    %   Reference: A. H. Al-Mohy and N. J. Higham, Computing the action of
    %   the matrix exponential, with an application to exponential
    %   integrators. MIMS EPrint 2010.30, The University of Manchester, 2010.
    tic
    [c_exp,~,~,~,~,~] = expmv(1,A,ones([size(A,1),1]));
    time = toc;
end