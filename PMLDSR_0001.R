######################################################################
# PMLDSR_0001: Efficiently read CSV file using R
######################################################################

# Set working directory
# Note: either "/" or "\\" as the proper symbol (NOT "\")
setwd("D:/sharing/T001_PMLDSR/PMLDSR_001")


# Load packages
library(data.table)
library(readr)
library(vroom)
library(sqldf)
library(ff)
library(iotools)
library(arrow)
library(microbenchmark)
library(ggplot2)


# Check CSV file names
list.files(pattern = "*.csv")




# Check CSV file size
print(fs::file_size("./fdt_1.csv"))
# 3.47M

print(fs::file_size("./fdt_2.csv"))
# 34.6M

print(fs::file_size("./fdt_3.csv"))
# 346M

print(fs::file_size("./fdt_4.csv"))
# 3.38G

print(fs::file_size("./fdt_5.csv"))
# 33.8G





##############################################
# Method 01
dat_3M_urc <- utils::read.csv("fdt_1.csv")
dim(dat_3M_urc)
dat_3M_urc[1:3, 1:5]

# Method 02
dat_3M_dt <- data.table::fread("fdt_1.csv")
dim(dat_3M_dt)
dat_3M_dt[1:3, 1:5]
# dplyr::glimpse(dat_3M_arca)

# Method 03
dat_3M_rrc <- readr::read_csv("fdt_1.csv", show_col_types = FALSE)
dim(dat_3M_rrc)
dat_3M_rrc[1:3, 1:5]

# Method 04
# Note: altrep = FALSE, but slow speed
dat_3M_vv <- vroom::vroom("fdt_1.csv", show_col_types = FALSE, altrep = FALSE)
dim(dat_3M_vv)
dat_3M_vv[1:3, 1:5]

# Method 05
dat_3M_srcs <- sqldf::read.csv.sql("fdt_1.csv", sql = "select * from file")
dim(dat_3M_srcs)
dat_3M_srcs[1:3, 1:5]

# Method 06
dat_3M_frcf <- ff::read.csv.ffdf(file = "fdt_1.csv")
dim(dat_3M_frcf)
dat_3M_frcf[1:3, 1:5]

# Method 07
dat_3M_ircr <- iotools::read.csv.raw("fdt_1.csv")
dim(dat_3M_frcf)
dat_3M_frcf[1:3, 1:5]

# Method 08
dat_3M_arca <- arrow::read_csv_arrow("fdt_1.csv")
dim(dat_3M_arca)
dat_3M_arca[1:3, 1:5]



# Write a simple function to reduce the duplicated work
read_csv_func <- function(input_csv = "fdt_1.csv", plot_benchmark = FALSE, bc_times = 5) {
  # If plot benchmark result from reading speed of different methods
  if (plot_benchmark) {
    time_benchmark <- microbenchmark::microbenchmark(
      utils_read_csv = utils::read.csv(input_csv),
      data_table_fread = data.table::fread(input_csv),
      readr_read_csv = readr::read_csv(input_csv, show_col_types = FALSE),
      vroom_vroom = vroom::vroom(input_csv, show_col_types = FALSE, altrep = FALSE),
      sqldf_read_csv_sql = sqldf::read.csv.sql(input_csv, sql = "select * from file"),
      ff_read_csv_ffdf = ff::read.csv.ffdf(file = input_csv),
      iotools_read_csv = iotools::read.csv.raw(input_csv),
      arrow_read_csv = arrow::read_csv_arrow(input_csv),
      times = bc_times
    )
    print(time_benchmark, order = "mean")
    x11()
    print(ggplot2::autoplot(time_benchmark))
  } else {
    print("Method 01: utils::read.csv...")
    dat_urc <- utils::read.csv(input_csv)
    print(dim(dat_urc))
    print(dat_urc[1:3, 1:5])
    print("=======")
    
    print("Method 02: data.table::fread...")
    dat_dtf <- data.table::fread(input_csv)
    print(dim(dat_dtf))
    print(dat_dtf[1:3, 1:5])
    print("=======")
    
    print("Method 03: readr::read_csv...")
    dat_rrc <- readr::read_csv(input_csv, show_col_types = FALSE)
    print(dim(dat_rrc))
    print(dat_rrc[1:3, 1:5])
    print("=======")
    
    print("Method 04: vroom::vroom...")
    dat_vv <- vroom::vroom(input_csv, show_col_types = FALSE, altrep = FALSE)
    print(dim(dat_vv))
    print(dat_vv[1:3, 1:5])
    print("=======")
    
    print("Method 05: sqldf::read.csv.sql...")
    dat_srcs <- sqldf::read.csv.sql(input_csv, sql = "select * from file")
    print(dim(dat_srcs))
    print(dat_srcs[1:3, 1:5])
    print("=======")
    
    print("Method 06: ff::read.csv.ffdf...")
    dat_frcf <- ff::read.csv.ffdf(file = input_csv)
    print(dim(dat_frcf))
    print(dat_frcf[1:3, 1:5])
    print("=======")
    
    print("Method 07: iotools::read.csv.raw")
    dat_ircr <- iotools::read.csv.raw(input_csv)
    print(dim(dat_frcf))
    print(dat_frcf[1:3, 1:5])
    print("=======")
    
    print("Method 08: arrow::read_csv_arrow")
    dat_arca <- arrow::read_csv_arrow(input_csv)
    print(dim(dat_arca))
    print(dat_arca[1:3, 1:5])
  }
  return(invisible(NULL))
}

# ~3.5 MB
st <- Sys.time()
read_csv_func("fdt_1.csv", plot_benchmark = TRUE, bc_times = 5)
et <- Sys.time()
print(tc <- et - st)
# Time difference of 7.230562 secs

# Without time benchmark
read_csv_func("fdt_1.csv", plot_benchmark = FALSE, bc_times = 5)

# 35 MB
st <- Sys.time()
read_csv_func("fdt_2.csv", plot_benchmark = TRUE, bc_times = 5)  
et <- Sys.time()
print(tc <- et - st)
# Time difference of 22.62124 secs


# Sure that you will find other ways (e.g., sparklyr::spark_read_csv()), 
# but the above mentioned methods are relatively common.


##################################################
# Personal choice: data.table::fread()
##################################################
## data.table::fread()
# Check file size
print(fs::file_size("./fdt_4.csv"))
# 3.38G

st <- Sys.time()
dat_3GB <- data.table::fread("./fdt_4.csv")
et <- Sys.time()
print(tc <- et - st)
# Time difference of 1.094166 secs
##################################################




# Happy to share PMLDSR and Good Luck!



##################################################
##################################################
##################################################



# Simulate data
# Number of rows
nr <- 1000
# Number of cols
nc <- 200
# Fake data
set.seed(1234567)
fdata <- rnorm(nr * nc) 
# Fake matrix
fmat <- base::matrix(fdata, nrow = nr, ncol = nc)
fdt <- data.table::as.data.table(fmat)
# Object size
# base::format(utils::object.size(fdt), units = "Mb")
# base::print(utils::object.size(fdt), units = "Mb")
print(pryr::object_size(fdt))
# 1.62 MB
# Starting time
st <- Sys.time()
data.table::fwrite(x = fdt, file = "./fdt_1.csv", sep = ",")
# Ending time
et <- Sys.time()
# Time cost
print(tc <- et - st)
# Time difference of 0.01077199 secs
# Check file size
print(fs::file_size("./fdt_1.csv"))
# 3.47M


# Simulate data
# Number of rows
nr <- 10000
# Number of cols
nc <- 200
# Fake data
set.seed(1234567)
fdata <- rnorm(nr * nc) 
# Fake matrix
fmat <- base::matrix(fdata, nrow = nr, ncol = nc)
fdt <- data.table::as.data.table(fmat)
# Object size
# base::format(utils::object.size(fdt), units = "Mb")
# base::print(utils::object.size(fdt), units = "Mb")
print(pryr::object_size(fdt))
# 16.02 MB
# Starting time
st <- Sys.time()
data.table::fwrite(x = fdt, file = "./fdt_2.csv", sep = ",")
# Ending time
et <- Sys.time()
# Time cost
print(tc <- et - st)
# Time difference of 0.02221894 secs
# Check file size
print(fs::file_size("./fdt_2.csv"))
# 34.6M



# Simulate data
# Number of rows
nr <- 100000
# Number of cols
nc <- 200
# Fake data
set.seed(1234567)
fdata <- rnorm(nr * nc) 
# Fake matrix
fmat <- base::matrix(fdata, nrow = nr, ncol = nc)
fdt <- data.table::as.data.table(fmat)
# Object size
print(pryr::object_size(fdt))
# 160.02 MB
# Starting time
st <- Sys.time()
data.table::fwrite(x = fdt, file = "./fdt_3.csv", sep = ",")
# Ending time
et <- Sys.time()
# Time cost
print(tc <- et - st)
# Time difference of 0.122654 secs
# Check file size
print(fs::file_size("./fdt_3.csv"))
# 346M



# Simulate data
# Take some time
# Number of rows
nr <- 1000000
# Number of cols
nc <- 200
# Fake data
set.seed(1234567)
fdata <- rnorm(nr * nc) 
# Fake matrix
fmat <- base::matrix(fdata, nrow = nr, ncol = nc)
fdt <- data.table::as.data.table(fmat)
# Object size
print(pryr::object_size(fdt))
# 1.60 GB
# Starting time
st <- Sys.time()
data.table::fwrite(x = fdt, file = "./fdt_4.csv", sep = ",")
# Ending time
et <- Sys.time()
# Time cost
print(tc <- et - st)
# Time difference of 1.198414 secs
# Check file size
print(fs::file_size("./fdt_4.csv"))
# 3.38G



# Simulate data
# Take some time
# Number of rows
nr <- 10000000
# Number of cols
nc <- 200
# Fake data
set.seed(1234567)
# This step takes some time
fdata <- rnorm(nr * nc)
# Object size
pryr::object_size(fdt)
# Fake matrix
fmat <- base::matrix(fdata, nrow = nr, ncol = nc)
fdt <- data.table::as.data.table(fmat)
# Object size
print(pryr::object_size(fdt))
# 16.00 GB
# Starting time
st <- Sys.time()
data.table::fwrite(x = fdt, file = "./fdt_5.csv", sep = ",")
# Ending time
et <- Sys.time()
# Time cost
print(tc <- et - st)
# Time difference of 35.00926 secs
# Check file size
print(fs::file_size("./fdt_5.csv"))
# 33.8G

