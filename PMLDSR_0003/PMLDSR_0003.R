######################################################################
# PMLDSR_0003: Efficiently perform kNN related operation in R
######################################################################

# Set working directory
# Note: either "/" or "\\" as the proper symbol (NOT "\")
setwd("D:/sharing/T001_PMLDSR/PMLDSR_0003")

rm(list = ls())
ls()

# I like to use this package for data processing/analysis
# Fast, convenient and powerful
library(data.table)


######################################################################
# Prepare data for better underatanding the kNN related operation
set.seed(1234567)
cls_1_c1 <- rnorm(3, mean = 1, sd = 0.2)
cls_1_c2 <- rnorm(3, mean = 2, sd = 0.8)

cls_2_c1 <- rnorm(3, mean = 4, sd = 0.2)
cls_2_c2 <- rnorm(3, mean = 6, sd = 0.8)

cls_3_c1 <- rnorm(3, mean = 7, sd = 0.2)
cls_3_c2 <- rnorm(3, mean = 8, sd = 0.8)

dat <- cbind(c(cls_1_c1, cls_2_c1, cls_3_c1), c(cls_1_c2, cls_2_c2, cls_3_c2))

colnames(dat) <- c("c1", "c2")
dat <- as.data.frame(dat)
dat$name <- paste0("p", 1:9)

plot(x = dat$c1, y = dat$c2, xlab = "x", ylab = "y")
text(dat$c1, dat$c2, dat$name)

# Save figure to file
# pdf(file = "scatter.pdf")
# plot(x = dat$c1, y = dat$c2, xlab = "x", ylab = "y")
# text(dat$c1, dat$c2, dat$name)
# dev.off()


# png(file = "scatter.png", width = 10, height = 10, units = "cm", res = 300, pointsize = 7)
# par(mar = c(4, 4, 0.5, 0.5))
# plot(x = dat$c1, y = dat$c2, xlab = "x", ylab = "y")
# text(dat$c1, dat$c2, dat$name)
# dev.off()


# Look at the figure, we can directly see the nearest neighbors
# E.g., if we want to find 3 nearest neighbors for each point, then
# for p1 (i.e., point 1), its 3 nearest neighbors should be p2, p3 and p4.
# For p5, its 3 nearest neighbors should be p6, p4 and p8.
# Let us check it.

# Convert to numerical matrix before performing kNN
dat_mat <- as.matrix(dat[, c("c1", "c2")])

# Method 01
# pak::pkg_install("RcppHNSW")
library(RcppHNSW)
res_hnsw <- hnsw_knn(dat_mat, k = 4)
print(res_hnsw$idx)
nbor_hnsw <- res_hnsw$idx


# Method 02
library(FNN)
# Note that here k set to 3 if one want to find 3 nearest neighbors for each
# point (1 to 9)
res_fnn <- FNN::knn.index(dat_mat, k = 3)
print(res_fnn)
# For comparison later
nbor_fnn <- cbind(1:nrow(res_fnn), res_fnn)


# Method 03
# pak::pkg_install("rnndescent")
library(rnndescent)
res_rnndesc <- brute_force_knn(dat_mat, k = 4, metric = "euclidean")
print(res_rnndesc$idx)
nbor_rnndesc <- res_rnndesc$idx


# Method 04
# pak::pkg_install("Rnanoflann")
library(Rnanoflann)
res_rnanof <- Rnanoflann::nn(data = dat_mat, points = dat_mat, k = 4)
print(res_rnanof$indices)
nbor_rnanof <- res_rnanof$indices


# Method 05
# pak::pkg_install("RANN")
library(RANN)
res_rann <- RANN::nn2(data = dat_mat, query = dat_mat, k = 4)
print(res_rann$nn.idx)
nbor_rann <- res_rann$nn.idx


# Method 06
# Fast K Nearest Neighbour Library for Low Dimensions
# pak::pkg_install("nabor")
library(nabor)
res_nabor <- nabor::knn(data = dat_mat, query = dat_mat, k = 4)
print(res_nabor$nn.idx)
nbor_nabor <- res_nabor$nn.idx


# Method 07
# More complicated operation for getting same result with others
# pak::pkg_install("N2R")
library(N2R)
res_n2r <- N2R::Knn(m = dat_mat, k = 4, indexType = "L2")
# Need additional operation
res_n2r_i <- matrix(res_n2r@i + 1, ncol = 4, byrow = TRUE)
res_n2r_x <- matrix(res_n2r@x, ncol = 4, byrow = TRUE)
idx_order <- order(row(res_n2r_x), res_n2r_x)
res_n2r <- matrix(res_n2r_i[idx_order], byrow = TRUE, ncol = ncol(res_n2r_x))
print(res_n2r)
nbor_n2r <- res_n2r


# Compare 2 objects
# all.equal(nbor_nabor, nbor_rann)

# Compare > 2 objects
objs <- mget(c("nbor_hnsw", "nbor_fnn", "nbor_rnndesc", "nbor_rnanof", "nbor_rann", "nbor_nabor", "nbor_n2r"))
outer(objs, objs, Vectorize(all.equal))


##################################################
# 以上函数都是非常高效的kNN相关操作，我这里只是
# 抛砖引玉
# 感兴趣的朋友可以自行实验其他功能
# 比如：测试不同的距离metrics
# • "l2" Squared L2, i.e. squared Euclidean.
# • "euclidean" Euclidean
# • "cosine"
# • "dice"
# • "euclidean"
# • "hamming"
# • "hellinger"
# • "jaccard"

# 比如：测试两个数据集最近邻相关操作
# 提示： RANN::nn2(data = dat_mat_1, query = dat_mat_2, k）

# 各位朋友，可以发挥你的想象力，来好好使用以上kNN相关的高效函数

##################################################
##################################################
##################################################



# Happy to share PMLDSR and Good Luck!



##################################################
##################################################
##################################################