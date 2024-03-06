################################################################################


# 大家好，我是古德漠鹰
# 今天和大家一起学习：如何快速进行表格的长<->宽转换



################################################################################


# 设置工作目录
setwd("D:/sharing/T001_PMLDSR/PMLDSR_0005_W2L_L2W")

# 首先移除加载的对象
rm(list = ls())
ls()


# 加载所需的R包
library(data.table)

# 构建示例表格
dt <- data.table(name = c("小李", "小李", "小李", "小王", "小王", "小王"), 
                 year = c(2020L, 2021L, 2022L, 2020L, 2021L, 2022L),
                 salary = c(5500.50, 6000.50, 6200.50, 7000.50, 7500.50, 7700.50))
# 查看该表格
dt

# 转换该表格的'宽'的样式
# 以'year'内容为新的列标题，'salary'为对应的值
data.table::dcast(dt, name ~ year, value.var = "salary")

# 把'宽'表赋值给新对象, dt_W
dt_W <- data.table::dcast(dt, name ~ year, value.var = "salary")
dt_W

# 如何把'宽'表变回'长'表
data.table::melt(dt_W, id.vars = "name", measure.vars = colnames(dt_W)[-1])

# 赋值对象, dt_L
dt_L <-data.table::melt(dt_W, id.vars = "name", measure.vars = colnames(dt_W)[-1])
dt_L

# 与原表进行比较，注意到有些不同
dt

# 列名不同，所以先更改列名
setnames(dt_L, new = c("name", "year", "salary"))
dt_L

# 列类型不同，再使用两步过程更改列类型
# 可以思考为什么不一步变成整型
dt_L[, year := as.character(year)]
# 字符型
dt_L
dt_L[, year := as.integer(year)]
# 整型
dt_L


# 一些列的顺序不同，要重新排序
# 先按照'name'排，再用'year'
dt_L <- dt_L[order(name, year)]
dt_L

# 再次与原表比较
dt

# 一致！本次任务完成。注意，以上操作可以非常有效地操作很大的表格

# 额外思考data.table::dcast函数功能
data.table::dcast(dt, name ~ ., value.var = "salary", fun.aggregate = mean)

# 比较
dt[, mean(salary), by = name]

# 给出相同结果
##################################################
##################################################
##################################################

# 谢谢大家，今天就讲到这里，我们下期再见！

# Happy to share PMLDSR and Good Luck!



##################################################
##################################################
##################################################