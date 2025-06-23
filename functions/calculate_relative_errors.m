function result_array = calculate_relative_errors(exp_centrality,c_min,c_05,c_085,c_deg)
    % This function calculates the relative errors between the exponential
    % centrality and the 4 varying Katz centrality vectors provided in each
    % experiment
    
    result_array = zeros([4,1]);
    result_array(1,1) = calc_relative_error(exp_centrality, c_min);
    result_array(2,1) = calc_relative_error(exp_centrality, c_05);
    result_array(3,1) = calc_relative_error(exp_centrality, c_085);
    result_array(4,1) = calc_relative_error(exp_centrality, c_deg);
end

function rel_error = calc_relative_error(exp_centrality, katz_centrality)
    % Calculate the relative error between the exponential centrality and a
    % Katz centrality.

    rel_error = norm(exp_centrality - katz_centrality) / norm(exp_centrality);
end