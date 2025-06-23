function saveTable(result_table, dataset_name)
    % This function saves a table in the tables using the dataset_name
    % provided

    file_name = 'tables/' + dataset_name;
    save(file_name, "result_table")
end