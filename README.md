# the Study of R

**R语言学习笔记**  
自学编程语言的时候，会遇到很多问题和特殊代码语句，记得本子里还不如归类在Github中，所以就开始行动。  
（记录在这里主要是为了自己以后的查阅，更多的是符合自身使用习惯。**重要注意内容在代码段前会重复并加粗。**）

主要学习使用的书籍如下：
* 《R语言实践-机器学习与数据分析》 左飞（著）

## 目录

* [基本操作](#基本操作)
* [数据结构](#数据结构)
  * [模式和类型查看等](#模式和类型查看等)
  * [向量](#向量)
  * [矩阵](#矩阵)
  * [列表](#列表)
  * [数据框](#数据框)

## [基本操作](#目录)

```R
getwd()
setwd("……")
q()
load()

rm()
 rm(A)
 rm(list = ls()) # 清理全部数据

A <- 2
(A <- 2) #赋值语句外加上括号会打印出赋值后变量的值
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

### [模式和类型查看等](#目录)

1. **在R中，向量的下标从1开始计数（向量长度可以为0）；**
2. **typeof类型仅在numeric上有区别，默认为双精度，整型数据需要加“L”。**
```R
mode() # 模式：numeric/character/logical/complex/list/expression……
class() # 类：numeric/character/logical/complex/list/data.frame
typeof() # 类型：double/integer，仅在numeric上有区别，默认为双精度，整型数据需要加“L”
Inf # ∞
-Inf # -∞
NaN # Not a Number
```

```R
apply()  # 应用于矩阵或数据框（数据框和矩阵相似）
 apply(m, dimcode, f, fargs) # 详见#矩阵-对行列调用函数
tapply()
lapply() # 应用于列表或数据框（数据框为列表的特例），返回列表
sapply() # 应用于列表或数据框，可以返回列表、向量或矩阵
 lapply(m,f) # 详见列表-列表调用函数
```

### [向量](#目录)

1. **在R中，无法随意添加或删除元素，需要给向量重新赋值，后面的矩阵运算遵循相同规则；**
2. **两个向量进行运算时，R会自动循环补齐，后面的矩阵运算遵循相同规则；**
3. **索引向量的语法规则为：向量1[向量2]，负数的下标表示要把相应的元素剔除。**
```R
seq() # 简单规律
 seq(1, 5, by = 0.5)
 seq(10, 100, length = 10)
 
rep() # 复杂规律
 rep(1:5, 2)
 rep(1:4, each = 2, times = 3)
 rep(1:4, each = 2, len = 4) #因为长度是4，所以仅取前4项
 
c() #没有规则，很常用

# 向量元素的命名
names()
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
 subset(a, a>=0) # 区别体现subset()排除掉NA值
which() # 返回元素的位置
 which(a<0)
```

### [矩阵](#目录)

1. **在R中，矩阵的行列都是从1开始编号，矩阵是按列存储；**
2. **元素取值或赋值时，和matlab不同：逗号后不用加冒号，使用方括号而不是圆括号；**
3. **drop=FALSE防止矩阵筛选后降维，数据框同样适用。**
```R
matrix()
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 3)
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 4) # 系统会自动循环补齐
 m <- matrix(c(1,2,3,4,5,6),nrow = 2)
 
 m[2,] # 元素取值，和matlab不同：逗号后不用加冒号,使用方括号而不是圆括号
 m[1,1]<-4 # 元素赋值
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, byrow = TRUE) # 设置byrow矩阵元素按行排列
 
# 矩阵的行列取名
record <- matrix(c(98,75,86,92,78,95),nrow = 2)
colnames(record) <- c("Math","Physics","Chemistry")
rownames(record) <- c("John","Mary")
record["John", "Physics"]

# drop=FALSE防止矩阵筛选后降维
m[m[,1]%%2==1 & m[,2]%%2==1 & m[,3]%%2==1,drop=FALSE]
as.matrix() # 将其转换成矩阵
```

```R
rowSums()
colSums()

# 数学意义上的矩阵乘法
%*%

#矩阵行列的修改，不能随意增加或删减矩阵行列
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
```

### [列表](#目录)

列表是R的结构型数据中最为复杂的一种，是向量的泛化，也就是对一些对象的有序集合。
1. **列表元素访问时，双方括号返回对应元素的取值，单方括号返回原列表的字列表；**
2. **列表为“递归型”向量，即列表的元素可以再分，而向量是“原子型”向量。**

```R
list()
 goods <- list(name="Cookie", price=4.00, outdate=FALSE)
 goods <- list("Cookie", 4.00, FALSE) #采用数值为默认的标签名

# 使用vector()创建
temp <- vector(mode="list")
temp[["name"]] <- "Cookie"

# 列表递归
a1 <- list(name="Cookie", price=4.0, outdate=FALSE)
a2 <- list(name="Milk", price=2.0, outdate=TRUE)
warehouse <- list(a1, a2)
```
```R
# 访问元素：双方括号返回对应元素的取值，单方括号返回原列表的字列表
goods$name
goods[["name"]]
goods[[1]]

goods["name"]
goods[1]

goods[1:2]
goods[[1:2]] # 错误使用

# 增删元素
goods$producer <- "A Company" #添加标签并初始化
goods[["material"]] <- "flour"
goods[[6]] <- 1
goods$material <- NULL

# 拼接列表
c()
 c(list(A=1,c="C"),list(new="NEW"))

# 列表转化为向量
unlist()
 ngoods <- unlist(goods)
c(……, recursive=T)
 c(goods,recursive=T)
#去除元素的名称
names(ngoods) <- NULL # 等同于unname(ngoods)

# 列表调用函数
lapply()
 temp <- list(1:10,-2:-9)
 lapply(temp, mean) # 返回列表
sapply()
 sapply(temp,mean) # 返回向量
 sapply(temp,mean,simplify=FALSE,USE.NAMES=FALSE) # 等同于lapply(temp, mean)
```

### [数据框](#目录)

数据框（和矩阵相似）有行列两个维度，“列”表示变量，“行”表示变量的观察记录。  
数据框的每列可以是不同的模式(mode)，更像是列表的扩展。每列相当于一个向量（列表），向量长度一致，如果不一致会按“循环补齐”原则补充完整。
1. **在数据框进行行列添加时，rbind()和cbind()会返回一个新的数据框，并不会对原数据框做任何更改，frame$newcolumm会对原数据直接进行修改。**
```R
data.frame()
 male <- c(124,88,200)
 female <- c(108,56,221)
 degree <- c("low","middle","high")
 myopia <- data.frame(degree,male,female)
 myopia <- data.frame(c("low","middle","high"),c(124,88,200),c(108,56,221))

str() # 查看数据库内部结构
 str(……, stringAsFactors = T) # 默认情况下会将向量转化为因子
 
as.data.frame() # 将其转换成数据框
```
```R
# 列表形式访问元素
 # 输出向量
 myopia$degree
 myopia[["degree"]]
 myopia[[1]]
 # 输出子数据框
 myopia["degree"]
 myopia[1]

# 矩阵形式访问元素
myopia[1,]
myopia[,2]
myopia[3,2]

# 提取子数据框
sub <- myopia[2,1:2] # 单取一行，返回类型仍为数据框
sub <- myopia[2:3,2] # 单取一列，返回类型为向量
 sub <- myopia[2:3,2,drop=F] # 设置drop=F时,返回类型为数据框
 sub <- myopia[2]; sub <- sub[2:3,1] # 效果同上
 
myopia[c("male", "female")]
myopia[male>100,]

# 数据框添加
names <- c("Jack", "Steven")
ages <- c(15, 16)
students <- data.frame(names, ages, stringsAsFactors=F) # 防止字符串转化为因子，避免添加数据时和因子的水平冲突

rbind(students, list("Sariah",15))
cbind(students, gender=c("M","M")) # rbind()和cbind()会返回一个新的数据框
students$gender <- c("M","M") # 对原数据框做更改
students$gender <- NULL # 同上

# 数据框合并
merge()
 merge(students,students2) # 输出共同列名的行，不共享列名的行被排除
 merge(students,students3,by.x="names",by.y="na") # 将students数据框中的names列和students2数据框中的na列合并
 merge(students,students3,by.y="na",by.x="names",all.x=T) # 默认情况下all.x、all.y和all为FALSE，如果设置为TRUE，则会包含所有元素，缺失值取为NA
 merge(students,students3,by.y="na",by.x="names",all.y=T)
 merge(students,students3,by.y="na",by.x="names",all=T)
 
# 数据框调用函数
apply(tt[,2:3,drop=F],2,mean)
lapply(students,sort)
sapply(students,sort)
```








































