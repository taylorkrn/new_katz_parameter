% This script calculates the centrality vectors and runs the correlation
% tests for the 5 datasets found in the data folder.

calculate_and_compare_centralities(A_Karate, 7,"Karate");
calculate_and_compare_centralities(A_p53, 14,"p53");
calculate_and_compare_centralities(A_Minnesota, 26,"Minnesota");
calculate_and_compare_centralities(A_CondMat, 113,"CondMat");
calculate_and_compare_centralities(A_AstroPh, 161, "AstroPh");