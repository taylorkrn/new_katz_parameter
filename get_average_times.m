% This script calculates the average time that it takes to calculate the 
% centrality vectors for each of the 5 datasets found in the data folder.
% The results are then saved in the table named 'times' in the tables
% folder.

times = generate_time_table();

Karate_times = calculate_average_times(A_Karate,10);
times.("Karate") = Karate_times;
p53_times = calculate_average_times(A_p53,10);
times.("p53") = p53_times;
Minnesota_times = calculate_average_times(A_Minnesota,10);
times.("Minnesota") = Minnesota_times;
CondMat_times = calculate_average_times(A_CondMat,10);
times.("CondMat") = CondMat_times;
AstroPh_times = calculate_average_times(A_AstroPh,10);
times.("AstroPh") = AstroPh_times;
saveTable(times,"times");

function time_table = generate_time_table()
    sz = [5 6];
    varTypes = ["string","double","double","double","double","double"];
    varNames = ["Name","Karate","p53","Minnesota","CondMat","AstroPh"];
    time_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

    time_table.("Name") = ["exp", "katz_min", "katz_05", "katz_085", "katz_deg"]';
end