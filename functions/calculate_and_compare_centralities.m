function calculate_and_compare_centralities(A, cut_amount, dataset_name)
    % This function calculates the 5 different centralities of the
    % Adjacency matrix A

    [katz_alphas, ~, katz_conds, c_min, c_05, c_085, c_deg] = calculate_katz_centralities(A);
    [exp_centrality, ~] = calculate_exp_centrality(A);
    rel_errors = calculate_relative_errors(exp_centrality, c_min, c_05, c_085, c_deg);
    ranking_types = ["no_ranking", "indeces", "indeces_normed_n", "indeces_normed_1", "rank", "rank_repeat", "rank_repeat_skip"];
    for i=1:length(ranking_types)
        result_table = generate_correlation_table(katz_alphas, katz_conds, rel_errors);
        rank_type = ranking_types(i);
        [tau_top, tau_1, rho_top, rho_1, r_top, r_1] = calculate_correlations(exp_centrality, c_min, c_05, c_085, c_deg, cut_amount, rank_type);
        result_table.("tau_top") = tau_top;
        result_table.("tau_1") = tau_1;
        result_table.("rho_top") = rho_top;
        result_table.("rho_1") = rho_1;
        result_table.("r_top") = r_top;
        result_table.("r_1") = r_1;
        table_name = dataset_name + "_" + rank_type;
        saveTable(result_table, table_name)
    end
end

function correlations_table = generate_correlation_table(alphas, conds, rel_errors)
    % This function generates a table that matches the format seen in the
    % paper:
    %
    % Mary Aprahamian, Desmond J. Higham, Nicholas J. Higham, Matching 
    % exponential-based and resolvent-based centrality measures, Journal 
    % of Complex Networks, Volume 4, Issue 2, June 2016, Pages 157–176, 
    % https://doi.org/10.1093/comnet/cnv016

    sz = [4 10];
    varTypes = ["string","double","double","double","double","double","double","double","double","double"];
    varNames = ["Name","alpha","tau_top","tau_1","rho_top","rho_1","r_top","r_1","err_rel","cond_1"];
    correlations_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

    correlations_table.("Name") = ["katz_min", "katz_05", "katz_085", "katz_deg"]';
    correlations_table.("alpha") = alphas;
    correlations_table.("cond_1") = conds;
    correlations_table.("err_rel") = rel_errors;
end