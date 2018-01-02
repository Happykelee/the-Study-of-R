# the Study of R

**R语言学习笔记**  
自学编程语言的时候，会遇到很多问题和特殊代码语句，记得本子里还不如归类在Github中，所以就开始行动。  
（记录在这里主要是为了自己以后的查阅，更多的是符合自身使用习惯。**重要注意内容在代码段前会重复并加粗。**）

主要学习使用的书籍如下：
* 《R语言实践-机器学习与数据分析》 左飞（著）

## 目录

* [基本操作](#基本操作)
* [数据结构](#数据结构)
  * [模式和类型查看](#模式和类型查看)
  * [向量](#向量)
  * [矩阵](#矩阵)

## [基本操作](#目录)

```R
getwd()
setwd("……")
q()
load()
```

```R
# 函数基本格式
hi.world <- function() {
cat("Hello World!\n")
}
hi.world()

# 函数读入和修改
source()
edit()
```

```R
# 包的使用
install.packages('')
installed.packages()
  colnames(installed.packages()) # 查看已经安装的包名
available.packages()

search()
library()
require()
```

```R
# 帮助
help(exp)
?exp

example(exp)
help.search("poisson")
??"poisson"
```
## [数据结构](#目录)

### [模式和类型查看](#目录)

1. **在R中，向量的下标从1开始计数（向量长度可以为0）**
2. **typeof类型仅在numeric上有区别，默认为双精度，整型数据需要加“L”**
```R
mode() # 模式：numeric/character/logical/complex
typeof() # 类型：double/integer，仅在numeric上有区别，默认为双精度，整型数据需要加“L”
Inf # ∞
-Inf # -∞
NaN # Not a Number
```

### [向量](#目录)

1. **在R中，无法随意添加或删除元素，需要给向量重新赋值，后面的矩阵运算遵循相同规则**
2. **两个向量进行运算时，R会自动循环补齐，后面的矩阵运算遵循相同规则**
3. **索引向量的语法规则为：向量1[向量2]，负数的下标表示要把相应的元素剔除**
```R
seq() # 简单规律
 seq(1, 5, by = 0.5)
 seq(10, 100, length = 10)
 
rep() # 复杂规律
 rep(1:5, 2)
 rep(1:4, each = 2, times = 3)
 rep(1:4, each = 2, len = 4) #因为长度是4，所以仅取前4项
 
c() #没有规则，很常用
```

```R
# 无法随意添加或删除元素，需要给向量重新赋值
z <- c(11, 13, 19, 23)
z <- c(z[1:2],17,z[3:4])

# 两个向量进行运算时，R会自动循环补齐
x <- c(1,2,3)
y <- c(4,6,8,10,12)
x + y
```

```R
# 索引向量的语法规则为：向量1[向量2]
x <- c(0.1,0.2,0.3,0.4,0.5,0.6)
x[c(2,4)]
x[3:5]
# 负数的下标表示要把相应的元素剔除
x[-1]
x[-2:-4]

# 结果返回为TRUE或者FALSE
any()
all()

# 向量中提取元素
a <- c(-1, 1, -2, 4, -5, 9)
b <- a[a<0] # 等同于a<0;a[c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)]
a[a<0] <- 0

subset()
 a[a<0]
 subset(a, a>=0) # 区别体现在处理NA值的方式上
which() # 返回元素的位置
 which(a<0)
```

### [矩阵](#目录)

1. **在R中，矩阵的行列都是从1开始编号，矩阵是按列存储**
2. **元素取值或赋值时，和matlab不同：逗号后不用加冒号,使用方括号而不是圆括号**
```R
matrix()
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 3)
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 4) # 系统会自动循环补齐
 m <- matrix(c(1,2,3,4,5,6),nrow = 2)
 
 m[2,] # 元素取值，和matlab不同：逗号后不用加冒号,使用方括号而不是圆括号
 m[1,1]<-4 # 元素赋值
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, byrow = TRUE) # 设置byrow矩阵元素按行排列
 
 #矩阵的行列取名
record <- matrix(c(98,75,86,92,78,95),nrow = 2)
colnames(record) <- c("Math","Physics","Chemistry")
rownames(record) <- c("John","Mary")
record["John", "Physics"]

m[m[,1]%%2==1 & m[,2]%%2==1 & m[,3]%%2==1,,drop=FALSE] # drop=FALSE防止矩阵筛选后降维
as.matrix() # 将其转换成矩阵
```

```R
rowSums()
colSums()

# 数学意义上的矩阵乘法
%*%

#矩阵行列的修改，不能岁月已增加或删减矩阵行列
rbind()
cbind()

#对行列调用函数
apply(m, dimcode, f, fargs) # dimcode=1，对每行应用函数，dimcode=2，对每列应用函数，fargs表示可选参数集
 apply(m, 2, max)
 
 f <- function(x) {x/sum(x)}
 y <- apply(z,1,f)
 y <- t(apply(z,1,f)) # 转置结果保持与原矩阵结构相同
 
 # 待调用函数需要多个参数
 outlier_value <- function(matrix_row, method_opt){
  if(method_opt==1){return(max(matrix_row))}
  if(method_opt==0){return(min(matrix_row))}
  }
 apply(m,1,outlier_value,1)
 apply(m,1,outlier_value,0)

# 以下类似函数应用不同的数据结构
apply()  # 应用于矩阵
tapply()
lapply() # 应用于列表
sapply() # 应用于向量或者列表
```












































