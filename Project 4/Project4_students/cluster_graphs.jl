# Cluster 2D real-world graphs with spectral clustering and compare with k-means 
# USI, ICS, Lugano
# Numerical Computing

using SparseArrays, LinearAlgebra, Arpack
using Clustering
using MAT

include("Tools/add_paths.jl");

# Number of clusters
K = 4;

W, pts = read_mat_graph("./Datasets/Meshes/airfoil1.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/barth4.mat");
# W, pts = read_mat_graph("./Datasets/Meshes/3elt.mat");

draw_graph(W, pts)

# Dummy variable
dummy_map = rand(1:K, size(pts, 1));

# 2a) Create the Laplacian matrix and plot the graph

#  we can use the file createlaplacian to create the Laplacian matrix.
L, D = createlaplacian(W); # L is the Laplacian matrix, D is the diagonal matrix


#   Eigen-decomposition
#     use eigsvals() and eigvecs())

# use eigsvals() and eigvecs() to get the eigenvalues and eigenvectors
eigenvalues, eigenvectors = eigs(L, nev = K, which = :SR);
eigenvalues1, eigenvalues2 = sort(eigenvalues);
# we do not sort the eigenvectors
eigenvectors = eigenvectors[:, eigenvalues2];


#   Plot and compare
# draw_graph(W, pts)
#   TODO: Plot using eigenvector coordinates
draw_graph(W, eigenvectors[:, 2:3])




# 2b) Cluster each graph in K = 4 clusters with spectral and 
# k-means method, compare your results visually for each case.

spectral1, spectral2 = kmeans(eigenvectors[:, 1], K), kmeans(eigenvectors[:, 2], K);

kmeans1, kmeans2 = kmeans(pts[:, 1], K), kmeans(pts[:, 2], K);


#   Plot and compare
#   TODO: Plot the spectral clusters
# draw_graph(W, pts, dummy_map)
draw_graph(W, pts, spectral2)
#   TODO: Plot the spectral clusters
# draw_graph(W, pts, dummy_map)
draw_graph(W, pts, kmeans2)

# 2c) Calculate the number of nodes per clustering
# histogram(dummy_map, title = "Dummy histogram", legend = false)
# histogram(dummy_map, title = "Dummy histogram", legend = false)
histogram(spectral2, title = "Spectral histogram", legend = false)
histogram(kmeans2, title = "K-means histogram", legend = false)


