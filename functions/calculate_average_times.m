function times_array = calculate_average_times(A, num_loops)
    % This function calculates the 5 different centrality vectors of A
    % multiple times (defined by num_loops). The average time required to
    % compute each centrality vector is the returned in the times_array
    % object.

    times = zeros([5,1]);
    for i=1:num_loops
        [~, katz_times, ~, ~, ~, ~, ~] = calculate_katz_centralities(A);
        [~, exp_time] = calculate_exp_centrality(A);
        times(1) = times(1) + exp_time;
        for j=1:4
            times(j+1) = times(j+1) + katz_times(j);
        end
    end
    times_array = times ./ num_loops; 
end