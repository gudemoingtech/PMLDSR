######################################################################
# PMLDSR_0003: Efficiently perform kNN related operation in R
######################################################################

# Set working directory
# Note: either "/" or "\\" as the proper symbol (NOT "\")
setwd("D:/sharing/T001_PMLDSR/PMLDSR_0004")

rm(list = ls())
ls()



# pak::pkg_install("pmsampsize")
library(pmsampsize)


# 举例：二分类逻辑回归模型（binary logistic regression model）


# 假如我们看到一篇关于临床预测模型的论文或者相关研究
# 使用方法：二分类逻辑回归
# 总患者数：5000
# 患有A疾病的患者数：150
# 回归使用的参数个数：20
# 模型的AUC：0.8

# 01：根据以上信息，我们可以验证以上方法是否满足最低样本数 （Riley's rule）

# Here, we call this as base model
pmsampsize(type = "b",
           # Similar to AUC in binary LR model
           cstatistic = 0.8, 
           parameters = 20,
           # 发生率
           prevalence = 150 / 5000)


# The obtained largest sample size is chosen
# 结果表明以上研究，基于Riley等人提出的标准，是满足要求的，说明模型是具有
# 鲁棒性的（robust）


# 02：如果我们想建立一个全新的模型，但只能测量得到10个参数，
# 其他指标与以上模型保持一致，那么
# 我们最少需要多少个样本呢？

pmsampsize(type = "b",
           cstatistic = 0.8, 
           parameters = 10,
           prevalence = 150 / 5000)


# 03：与02相同，但这次我们可以测量30个参数作为自变量，那么我们最少需要多少个样本？

pmsampsize(type = "b",
           cstatistic = 0.8, 
           parameters = 30,
           prevalence = 150 / 5000)



################################################################################
# This time, let us see the sample size changes with different AUC values
# (i.e., cstatistic here)

# Base model: AUC = 0.8
pmsampsize(type = "b",
           # Similar to AUC in binary LR model
           cstatistic = 0.8, 
           parameters = 20,
           # 发生率
           prevalence = 150 / 5000)


# AUC decreased to 0.7
pmsampsize(type = "b",
           cstatistic = 0.7, 
           parameters = 20,
           prevalence = 150 / 5000)


# AUC increased to 0.9
pmsampsize(type = "b",
           cstatistic = 0.9, 
           parameters = 20,
           prevalence = 150 / 5000)


# This output gives similar results (Table 4) with this 
# paper "https://pubmed.ncbi.nlm.nih.gov/35641659/", where they 
# used "Nagelkerke R-square"


# 问题：为什么降低AUC值，反而会需要更多的样本呢？同理，为什么增大AUC值，会极大
# 地减少样本量？


# Note based on the paper "https://pubmed.ncbi.nlm.nih.gov/35641659/":
#===========
# sample size can be reduced by lowering the number of parameter predictors
#===========
# The most feasible option to decrease the required sample size is to 
# reduce the number of predictor variables included in the model as 
# the number of predictors and the sample size have a directly 
# proportional relationship in the range of 5 to 30 predictor variables.
# 为了降低使用的样本量，我们可以减少所需评估参数(beta)的数量


# 临床预测模型中，最小样本量评估是一个很流行的话题，设计很多理论知识，感兴趣
# 的朋友，请自行查找相关文献。

# 如果你只是关注“样本量评估”，而不是局限于临床预测模型，不是局限于逻辑回归，
# 那你会发现有太多工具可供选择。



# 注意今天介绍的方法适用于以下描述：
# A new method to calculate the sample size for
# ‘parametric predictive models’ was proposed based on
# different factors, such as disease ‘prevalence’ in the
# population, the ‘number of predictor variables’, the
# number of participants, and the ‘expected fit’ of the 
# regression model.





##############################################################################
# 一些相关的论文
##############################################################################

# Paper:
# "Sample size and predictive performance of machine
# learning methods with survival data: A simulation study"
#====================================================
# ML techniques are able to learn complexities from data at the cost of
# hyper-parameter tuning and interpretability. One aspect of special interest is
#====================================================
# While there is sample size guidance when using traditional statistical models, 
# the same does not apply when using ML techniques.
#====================================================
# While ML models require larger sample sizes, it is sufficient
# doubling or tripling the minimum sample size required by traditional
# regression models to obtain similar performances
# and not to increase by one or more order of magnitude.
#====================================================


# Paper:
# "A practical solution to estimate the sample
# size required for clinical prediction models
# generated from observational research on
# data"
#=======================================================
# The most feasible option to decrease the required sample size is to reduce 
# the number of predictor variables included in the model as the number of 
# predictors and the sample size have a directly proportional relationship 
# in the range of 5 to 30 predictor variables.
#=======================================================


# Paper:
# "Sample size requirements are not being 
# considered in studies developing prediction 
# models for binary outcomes: a systematic 
# review"
#======================================================
# Ask researchers to report the sample size calculation!
#======================================================


##################################################
##################################################
##################################################



# Happy to share PMLDSR and Good Luck!



##################################################
##################################################
##################################################