% Test the correlation to exponential weekly centrality of katz daily and
% weekly centralities
% The aim is to show that there is a significant difference.
% Further research into how the centrality changes needs to be carried out

calculate_time_dependency_table_and_plot(A_1, A_2, A_3, A_4, A_5, A_week)

function calculate_time_dependency_table_and_plot(A_1, A_2, A_3, A_4, A_5, A_week)
    % This function calculates the centralities and the correlations,
    % saving the results in a table and plotting them.
    % TODO: Right now we use a c_deg_placeholder because the relative
    % errors and correlation calculations require a c_deg input. This needs
    % to be modified
    [alphas_day, c_min_day, c_05_day, c_085_day] = calculate_time_dependent_centralities(A_1, A_2, A_3, A_4, A_5);
    [c_exp_week,~] = calculate_exp_centrality(A_week);
    [alphas_week,~,~,c_min_week, c_05_week, c_085_week, ~] = calculate_katz_centralities(A_week);
    
    c_deg_placeholder = ones([150,1]);
    
    rel_errors_day = calculate_relative_errors(c_exp_week, c_min_day, c_05_day, c_085_day, c_deg_placeholder);
    rel_errors_day(end) = [];
    rel_errors_week = calculate_relative_errors(c_exp_week, c_min_week, c_05_week, c_085_week, c_deg_placeholder);
    rel_errors_week(end) = [];
    
    alphas_week(end) = [];
    
    time_dependent_table = create_time_dependent_table([alphas_day; alphas_week], [rel_errors_day; rel_errors_week]);
    
    [tau_top_day, tau_1_day, rho_top_day, rho_1_day, r_top_day, r_1_day] = calculate_correlations(c_exp_week, c_min_day, c_05_day, c_085_day, c_deg_placeholder, 15, 'no_ranking');
    [tau_top_week, tau_1_week, rho_top_week, rho_1_week, r_top_week, r_1_week] = calculate_correlations(c_exp_week, c_min_week, c_05_week, c_085_week, c_deg_placeholder, 15, 'no_ranking');
    
    tau_top_day(end) = [];
    tau_1_day(end) = [];
    rho_top_day(end) = [];
    rho_1_day(end) = [];
    r_top_day(end) = [];
    r_1_day(end) = [];
    
    tau_top_week(end) = [];
    tau_1_week(end) = [];
    rho_top_week(end) = [];
    rho_1_week(end) = [];
    r_top_week(end) = [];
    r_1_week(end) = [];
    
    time_dependent_table.("tau_top") = [tau_top_day; tau_top_week];
    time_dependent_table.("tau_1") = [tau_1_day; tau_1_week];
    time_dependent_table.("rho_top") = [rho_top_day; rho_top_week];
    time_dependent_table.("rho_1") = [rho_1_day; rho_1_week];
    time_dependent_table.("r_top") = [r_top_day; r_top_week];
    time_dependent_table.("r_1") = [r_1_day; r_1_week];
    
    saveTable(time_dependent_table, "time_dependence")

    f = figure;
    plot(time_dependent_table{1,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]}, 'DisplayName','c_{min}(day)')
    hold on
    plot(time_dependent_table{2,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]},'DisplayName','c_{05}(day)')
    plot(time_dependent_table{3,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]},'DisplayName','c_{085}(day)')
    plot(time_dependent_table{4,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]},'DisplayName','c_{min}(week)')
    plot(time_dependent_table{5,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]},'DisplayName','c_{05}(week)')
    plot(time_dependent_table{6,["tau_top","tau_1","rho_top","rho_1","r_top","r_1"]},'DisplayName','c_{085}(week)')
    hold off
    ylim([0,1.5])
    xticks([1 2 3 4 5 6])
    xticklabels({'\tau_{top}','\tau_1','\rho_{top}','\rho_1','r_{top}','r_1'})
    legend()

    filePath = "plots/time_dependency.png";
    exportgraphics(f,filePath,'Resolution',300);
    
    f2 = figure;
    plot(c_min_day, 'DisplayName','c_{min}(day)')
    hold on
    plot(c_min_week, 'DisplayName','c_{min}(week)')
    hold off
    legend()

    filePath = "plots/time_dependency_centralities.png";
    exportgraphics(f2,filePath,'Resolution',300);
end

function time_dependent_table = create_time_dependent_table(alphas, rel_errors)
    % This function generates the empty time_dependency table to be filled
    % with the data

    sz = [6 9];
    varTypes = ["string","double","double","double","double","double","double","double","double"];
    varNames = ["Name","alpha","tau_top","tau_1","rho_top","rho_1","r_top","r_1","err_rel"];
    time_dependent_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

    time_dependent_table.("Name") = ["min_daily", "05_daily", "085_daily", "min_weekly", "05_weekly", "085_weekly"]';
    time_dependent_table.('alpha') = alphas;
    time_dependent_table.('err_rel') = rel_errors;
    
end
