function [tau_top, tau_1, rho_top, rho_1, r_top, r_1] = calculate_correlations(exp_centrality, c_min, c_05, c_085, c_deg, cut_amount, rank_type)
    % This function calculates the Kendall, Spearman and Pearson
    % correlations of the required input centrality vectors
    %
    % exp_centrality is compared to c_min, c_05, c_085 and c_deg, with the 
    % results being saved in _1 vectors. With cut_amount defining the 
    % number of nodes that are chosen to represent the 'most significant 
    % nodes', which are then compared and saved in _top vectors.
    % 
    % rank_type defines whether any pre-ranking or pre-ordering is applied
    % before the correlation calculations are undertaken. If no
    % pre-ordering should take place, rank_type should be 'no_ranking'.


    [exp_sorted, exp_sorted_small] = calc_ranking(exp_centrality, cut_amount, rank_type);
    [a_min_sorted, a_min_sorted_small] = calc_ranking(c_min, cut_amount, rank_type);
    [a_05_sorted, a_05_sorted_small] = calc_ranking(c_05, cut_amount, rank_type);
    [a_085_sorted, a_085_sorted_small] = calc_ranking(c_085, cut_amount, rank_type);
    [a_deg_sorted, a_deg_sorted_small] = calc_ranking(c_deg, cut_amount, rank_type);

    % Calculate tau_top
    tau_top = zeros([4,1]);
    tau_top(1,1) = corr(exp_sorted_small, a_min_sorted_small,'Type','Kendall',Rows="complete");
    tau_top(2,1) = corr(exp_sorted_small, a_05_sorted_small,'Type','Kendall',Rows="complete");
    tau_top(3,1) = corr(exp_sorted_small, a_085_sorted_small,'Type','Kendall',Rows="complete");
    tau_top(4,1) = corr(exp_sorted_small, a_deg_sorted_small,'Type','Kendall',Rows="complete");

    % Calculate tau_1
    tau_1 = zeros([4,1]);
    tau_1(1,1) = corr(exp_sorted, a_min_sorted,'Type','Kendall');
    tau_1(2,1) = corr(exp_sorted, a_05_sorted,'Type','Kendall');
    tau_1(3,1) = corr(exp_sorted, a_085_sorted,'Type','Kendall');
    tau_1(4,1) = corr(exp_sorted, a_deg_sorted,'Type','Kendall');


    % Calculate Rho_top
    rho_top = zeros([4,1]);
    rho_top(1,1) = corr(exp_sorted_small, a_min_sorted_small,'Type','Spearman',Rows="complete");
    rho_top(2,1) = corr(exp_sorted_small, a_05_sorted_small,'Type','Spearman',Rows="complete");
    rho_top(3,1) = corr(exp_sorted_small, a_085_sorted_small,'Type','Spearman',Rows="complete");
    rho_top(4,1) = corr(exp_sorted_small, a_deg_sorted_small,'Type','Spearman',Rows="complete");

    % Calculate Rho_1
    rho_1 = zeros([4,1]);
    rho_1(1,1) = corr(exp_sorted, a_min_sorted,'Type','Spearman');
    rho_1(2,1) = corr(exp_sorted, a_05_sorted,'Type','Spearman');
    rho_1(3,1) = corr(exp_sorted, a_085_sorted,'Type','Spearman');
    rho_1(4,1) = corr(exp_sorted, a_deg_sorted,'Type','Spearman');


    % Calculate r_top
    r_top = zeros([4,1]);
    r_top(1,1) = corr(exp_sorted_small, a_min_sorted_small,'Type','Pearson',Rows="complete");
    r_top(2,1) = corr(exp_sorted_small, a_05_sorted_small,'Type','Pearson',Rows="complete");
    r_top(3,1) = corr(exp_sorted_small, a_085_sorted_small,'Type','Pearson',Rows="complete");
    r_top(4,1) = corr(exp_sorted_small, a_deg_sorted_small,'Type','Pearson',Rows="complete");

    % Calculate r_1
    r_1 = zeros([4,1]);
    r_1(1,1) = corr(exp_sorted, a_min_sorted,'Type','Pearson');
    r_1(2,1) = corr(exp_sorted, a_05_sorted,'Type','Pearson');
    r_1(3,1) = corr(exp_sorted, a_085_sorted,'Type','Pearson');
    r_1(4,1) = corr(exp_sorted, a_deg_sorted,'Type','Pearson'); 
end

function [sorted_index, sorted_index_small] = calc_ranking(centrality_result, cut_amount, rank_type)
    % This function re-orders or ranks the nodes of a centrality result.
    % A sorted vector, along with a small sorted vector, which is either
    % the size of cut_amount or is filled with NaN if the node isn't one 
    % of the most significant nodes.

    if strcmp(rank_type, "no_ranking")
        sorted_index = centrality_result;
        sorted_index_small = centrality_result;
        [sorted_array,~] = sort(centrality_result,'descend');
        sorted_index_small(sorted_index_small > sorted_array(cut_amount)) = NaN;
    elseif strcmp(rank_type, "indeces")
        [~,sorted_index] = sort(centrality_result,'descend');
        sorted_index_small = sorted_index(1:cut_amount);
    elseif strcmp(rank_type, "indeces_normed_n")
        [~,sorted_index] = sort(centrality_result,'descend');
        sorted_index_small = sorted_index(1:cut_amount);
        sorted_index = sorted_index ./ (sum(sorted_index) / length(sorted_index));
        sorted_index_small = sorted_index_small ./ (sum(sorted_index_small) / length(sorted_index_small));
    elseif strcmp(rank_type, "indeces_normed_1")
        [~,sorted_index] = sort(centrality_result,'descend');
        sorted_index_small = sorted_index(1:cut_amount);
        sorted_index = sorted_index ./ sum(sorted_index);
        sorted_index_small = sorted_index_small ./ sum(sorted_index_small);
    elseif strcmp(rank_type, "rank")
        [~,reverse_rank] = sort(centrality_result,'descend');
        sorted_index = 1:length(centrality_result);
        sorted_index(reverse_rank) = sorted_index;
        sorted_index = sorted_index';
        sorted_index_small = sorted_index;
        sorted_index_small(sorted_index_small > cut_amount) = NaN;
    elseif strcmp(rank_type, "rank_repeat")
        [~,~,sorted_index] = unique(-centrality_result);
        sorted_index_small = sorted_index;
        sorted_index_small(sorted_index_small > cut_amount) = NaN;
    elseif strcmp(rank_type, "rank_repeat_skip")
        centrality_sorted = sort(-centrality_result);
        [~,sorted_index] = ismember(-centrality_result,centrality_sorted);
        sorted_index_small = sorted_index;
        sorted_index_small(sorted_index_small > cut_amount) = NaN;
    else
        sorted_index = [];
        sorted_index_small = [];
    end
end