## new_katz_parameter

The first and main task of this Repo is to attempt to reproduce the results presented in the paper:

Mary Aprahamian, Desmond J. Higham, Nicholas J. Higham, Matching exponential-based and resolvent-based centrality measures, Journal of Complex Networks, Volume 4, Issue 2, June 2016, Pages 157–176, https://doi.org/10.1093/comnet/cnv016

Currently the correlation values $\tau, \rho, r$ are not able to be replicated.

The second goal is to try out the use of Katz centrality on time-dependent data and dynamic walks.

## Workflow

# Replication of Data
    1. import_data - Load data 
    2. get_data_info_and_plots - Get information table and plot datasets. Produces an info table (saved in the tables folder) and plots (saved in the plots folder)
    3. calculate_centralities_and_correlations - Calculate different exponential and Katz centralities on all datasets. Produces result tables that are saved in the tables folder
    4. get_average_times - Calculates the average time each centrality approach takes (average of 10 runs). Results saved in tables/times.mat

# Time-Dependent Centrality
    1. generate_time_dependent_data - Generates random Adjacency matrices (this step can be ignored as examples are already saved in the data folder)
    2. load_and_plot_time_dependent_data - Loads the Adjacency matrices saved in the data folder. Produces a time_dependency_matrices.png plot saved in the plot folder
    3. calculate_week_and_time_dependent_centralities - Computes weekly and daily, dynamic walk katz centrality. Plots the weekly katz centrality and dynamic katz centrality correlations against the weekly exponential centrality to observe that much more information is contained in the dynamic centrality vectors.


## TODO
Fix the correlations bug!

Please feel free to contribute - I would be very interested to know what is going wrong.
