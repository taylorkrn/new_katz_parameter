% Generate the info table for the 5 datasets that we were able to import in
% conjuction with the paper:
%
% Mary Aprahamian, Desmond J. Higham, Nicholas J. Higham, Matching 
% exponential-based and resolvent-based centrality measures, Journal 
% of Complex Networks, Volume 4, Issue 2, June 2016, Pages 157–176, 
% https://doi.org/10.1093/comnet/cnv016

infos = generate_infos_table();

infos(1,:) = get_info(A_Karate,"karate",size(A_Karate,1),true,false,true,false);
infos(2,:) = get_info(A_p53,"p53",size(A_p53,1),true,true,false,false);
infos(3,:) = get_info(A_Minnesota,"minnesota",size(A_Minnesota,1),true,false,true,false);
infos(4,:) = get_info(A_CondMat,"condMat",100,false,false,false,true);
infos(5,:) = get_info(A_AstroPh,"astroPh",100,false,false,false,true);

saveTable(infos,"info");

function infos = generate_infos_table()
    % This function generates the empty infos table to be filled with the
    % data
    sz = [5 8];
    varTypes = ["double","double","double","logical","logical","double","double","double"];
    varNames = ["Nodes","Edges","Sparsity","Directed","Weighted","Lambda_1","Lambda_2","K_2"];
    infos = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
end

function return_table = get_info(A,dataset_name,k,show_spy,complex_eigs,sort_naturally,remove_neg)    
    % This function returns the dataset information to be printed in the 
    % respective row of the info table.

    % Find number of nodes
    num_nodes = size(A,1);
    [rows,~,s] = find(A);
    [diag_rows,~,~] = find(diag(A));
    % Check if symmetric
    if issymmetric(A)
        is_directed = false;
    else
        is_directed = true;
    end
    if is_directed
        % Calculate number of edges of a directed graph (this involves
        % simply counting the elements in A.)

        num_edges = size(rows,1);
    else
        % Calculate number of edges of an undirected graph (this involves
        % counting the amount of entries in A / 2 and then adding the
        % diagonal entries / 2 back in.
        num_edges = size(rows,1) / 2;
        num_edges = num_edges + length(diag_rows) / 2;
    end
    % Calculate Sparcity
    sparsity = size(s,1) / num_nodes^2;
    % Check if  weighted
    if any(s(:) ~= 1)
        is_weighted = 1;
    else
        is_weighted = 0;
    end
    % Calculating two largest real values of eigenvalues
    [V,D] = eigs(A,k,'largestabs');
    d = diag(D);
    real_sorted = sort(d,'desc','ComparisonMethod','real');
    lambda_1 = real_sorted(1);
    lambda_2 = real_sorted(2);
    % Calculating the 2 norm conditional number
    cond_2 = cond(V);
    % Organize the array of eigenvalues to match the plot found in the
    % paper linked above.
    if sort_naturally
        d = sort(d);
    end
    if remove_neg
        d = d(d >= 0);
    end
    if show_spy
        f1 = figure;
        spy(A);
        filePath = "plots/" + dataset_name + "_sparsity.png";
        exportgraphics(f1,filePath,'Resolution',300);
    end
    f2 = figure;
    if complex_eigs
        scatter(real(d), imag(d), 'x', LineWidth=2);
    else
        scatter(linspace(1,size(d,1),size(d,1)), d, 'x', LineWidth=2);
    end
    filePath = "plots/" + dataset_name + "_eigenvalues.png";
    exportgraphics(f2,filePath,'Resolution',300);
    return_table = array2table([num_nodes, num_edges, sparsity, is_directed, is_weighted, lambda_1, lambda_2, cond_2]);
end