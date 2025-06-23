% This script imports the 5 datasets found in the data folder. The files
% are loaded and the Adjacency matrices are generated.
%
% Be aware that the Minessota dataset is imported as an unweighted
% adjacency matrix, but the weighted edges calculated be the shortest
% distances between the points is also generated.

A_Karate = import_karate();
A_p53 = import_p53();
[A_Minnesota, A_Minnesota_Weighted] = import_minnesota();
A_AstroPh = import_ca("data/CA-AstroPh.txt");
A_CondMat = import_ca("data/CA-CondMat.txt");


function A_Karate = import_karate()
    % Importing Zachary Karate Club
    Zachary_Edge_Matrix = readmatrix("data/karate_club.txt");
    G_Zachary = graph(Zachary_Edge_Matrix(:,1),Zachary_Edge_Matrix(:,2));
    zero_nodes_Zachary = find(degree(G_Zachary) == 0);
    G_Zachary = rmnode(G_Zachary, zero_nodes_Zachary);
    A_Karate = adjacency(G_Zachary);
end


function A_p53 = import_p53()
    % Importing oncogene p53
    p53_Structure = load("data/p53.mat");
    A_p53 = p53_Structure.A;
end


function [A_Minnesota, A_Minnesota_Weighted] = import_minnesota()
    % Importing Minnesota
    % The unweighted Adjacency matrix is used in the resulting experiments,
    % however a weighted Adjacency matrix (created through calculating the
    % distance between the latitude/longitude points) is also generated.
    
    Minnesota_Structure = load("data/minnesota.mat");
    A_Minnesota = Minnesota_Structure.Problem.A;
    Minnesota_coords = Minnesota_Structure.Problem.aux.coord;
    num_nodes = size(Minnesota_coords,1);
    [rows,columns,~] = find(A_Minnesota);
    A_Minnesota_Weighted = zeros(num_nodes, num_nodes);
    for i=1:size(rows,1)
        if A_Minnesota_Weighted(rows(i),columns(i)) == 0
            distance = norm(Minnesota_coords(rows(i),:) - Minnesota_coords(columns(i),:));
            A_Minnesota_Weighted(rows(i),columns(i)) = distance;
            A_Minnesota_Weighted(columns(i),rows(i)) = distance;
        end
    end
    A_Minnesota_Weighted = sparse(A_Minnesota_Weighted);
end


function A_CA = import_ca(file_path)
    % Importing CA-AstroPh and CA-CondMat
    Edge_Matrix = readmatrix(file_path);
    Graph = graph(Edge_Matrix(:,1),Edge_Matrix(:,2));
    
    % Remove nodes that have no edges
    zero_nodes = find(degree(Graph) == 0);
    Graph = rmnode(Graph, zero_nodes);
    
    A_CA = adjacency(Graph);
end