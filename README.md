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
  * [因子](#因子)
  * [列表](#列表)
  * [矩阵/数组](#矩阵数组)
  * [数据框](#数据框)
  * [表](#表)
* [数据输入/输出](#数据输入输出)
  * [数据输入](#数据输入)
  * [数据输出](#数据输出)
  * [缺失值处理](#缺失值处理)
* [统计图形绘制](#统计图形绘制)
  * [绘图基础](#绘图基础)
  * [图像读取及处理](#图像读取及处理)
  * [饼状图](#饼状图) 
  * [直方图](#直方图)
  * [核密图](#核密图)
  * [箱线图](#箱线图)
  * [条形图](#条形图)
  * [qq图](#qq图)

## [基本操作](#目录)

```R
system()
system.time() # 计算系统运算时间

getwd()
setwd("……")
q()
load()

head()
tail()

rm()
 rm(A)
 rm(list = ls()) # 清理全部数据

A <- 2
(A <- 2) #赋值语句外加上括号会打印出赋值后变量的值

# 路径名称使用'/'或'\\', 而不是'\'
 odbcConnectExcel('E:/b.xls') # 正确
 odbcConnectExcel('E:\\b.xls') # 正确
 odbcConnectExcel('E:\b.xls') # 错误
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
 # dependencies=TRUE (安装依赖包)
installed.packages()
 rownames(installed.packages()) # 查看已经安装的包名
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

R是一种基于对象的语言。R的对象分为单纯对象和复合对象两种：**单纯对象**的所有元素都是同一数据类型（数值、字符串），元素不再是对象；**复合对象**的元素可是是不同的类型，每个元素是一个对象。

在统计学中，变量分为**名义变量(nominal variable)或分类变量(categorical variable)**，和**数值变量(numerical variable)**。  
在R中，变量类型可以归类为三种类型：名义型、有序型和连续型。**名义型**表示分类，并且类型之间没有顺序之分，如性别（男性和女性）；**有序型**也表示分类，不过类型之间存在顺序关系，而非数量关系，如近视程度（不近视、轻微近视、严重近视）；**连续型**呈现某个范围内的取值，同时存在顺序和数量上的区别，如年龄。  
**其中，名义型变量和有序型变量在R中被称为[因子](#因子)。**

* **R语言中S3,S4,RC结构详见：**  
  * https://www.zhihu.com/question/31486406
  * http://www.cnblogs.com/HeYanjie/p/6292536.html
  * https://uploads.cosx.org/2012/11/ChinaR2012_SH_Nov04_07_WYC.pdf
 
* **其他参考资料：**
  * R语言学习笔记(2)-数据类型和数据结构: http://developer.51cto.com/art/201305/393125.htm
  * R语言进阶之4-数据整形(reshape)： http://developer.51cto.com/art/201305/396615.htm
  * R语言中的vector(向量),array(数组)总结： http://blog.csdn.net/yezonggang/article/details/51103460


### [模式和类型查看等](#目录)

1. **在R中，向量的下标从1开始计数（向量长度可以为0）；**
2. **typeof类型仅在numeric上有区别，默认为双精度，整型数据需要加“L”；**
3. **class()和attr()可以对数据类型进行操作，而且对原数据直接进行修改，而不是返回新的数据。**
```R
class() # 类：numeric/character/logical/complex/list/data.frame
mode() # 模式属性：numeric/character/logical/complex/list/expression……
typeof() # 类型属性：double/integer/character/logical/complex/list/expression……，仅在numeric上有区别，默认为双精度，整型数据需要加“L”
length() # 长度属性
unclass() # 拆分数据

 # class()还可以更改对象的类，直接对数据进行修改
 x <- 1:6
 class(x) <- "logical"
 class(x) = "matrix" # 错误
 # 通过函数attributes()和attr()进行操作
 attr(x,"dim") = c(2,3)
 
str() # 查看数据的内部结构

Inf # ∞
-Inf # -∞
NA # 缺失
NaN # Not a Number（数据不确定）
```

```R
apply()  # 应用于矩阵、数据框或表（数据框和矩阵相似）
 apply(m, dimcode, f, fargs) # 详见#矩阵-对行列调用函数
tapply() # 应用于原子型对象（向量）和因子
 tapply(X, INDEX, F) # 详见#因子-因子调用函数
lapply() # 应用于列表或数据框（数据框为列表的特例），返回列表
sapply() # 应用于列表或数据框，可以返回列表、向量或矩阵
 lapply(m,f) # 详见列表-列表调用函数
```

```R
# 类型转换函数(is./as.)
 # is. 判断数据类型，返回TRUE或FALSE
 is.na() # 是否缺失
 is.nan() # 是否不确定
 is.finite() # 是否有限
 is.infinite() # 是否无限
 is.numeric() # 是否数值型数据
 is.character() # 是否字符型数据
 is.logical() # 是否逻辑型数据
 is.vector() # 是否向量数据
 is.list() # 是否列表向量
 is.factor() # 是否因子数据
 is.matrix() # 是否矩阵数据
 is.array() # 是否数组数据
 is.data.frame() # 是否数据框数据
 
 # as. 转换数据类型
 as.numeric()
 as.character()
 as.logical()
 as.vector()
 as.list()
 as.factor()
 as.matrix()
 as.data.frame()
```

```R
names() # 向量元素的命名/数据集的列标签
dimnames()
 dimnames(US_data)[[2]] # 输出列标签 相当于names()
 dimnames(US_data)[[1]] # 输出行标签
```

```R
#数据整形
reshape()/stack()/unstack() # 数据框/列表的长、宽格式之间转换

 reshape() # R base/stats的函数，参数较多且复杂
 reshape(data, varying = NULL, v.names = NULL, timevar = "time",
    idvar = "id", ids = 1:NROW(data),
    times = seq_along(varying[[1]]),
    drop = NULL, direction, new.row.names = NULL,
    sep = ".",
    split = if (sep == "") {
        list(regexp = "[A-Za-z][0-9]", include = TRUE)}
        else {
        list(regexp = sep, include = FALSE, fixed = TRUE)}
    )
    
 x <- data.frame(CK=c(1.1, 1.2, 1.1, 1.5), T1=c(2.1, 2.2, 2.3, 2.1), T2=c(2.5, 2.2, 2.3, 2.1)) 
 xx <- stack(x)
 unstack(xx)
 
 reshape/reshape2程序包
 melt() # “溶解”数据，会根据数据类型）选择melt.data.frame, melt.array 或 melt.list函数进行实际操作
  # 数组类型
  datax <- array(1:8, dim=c(2,2,2))
  melt(datax)
  melt(datax, varnames=LETTERS[24:26],value.name="Val") # 修改列名
  
  # 列表类型（元素值排列在前，名称在后，越是顶级的列表元素名称越靠后）
  datax <- list(agi="AT1G10000", GO=c("GO:1010","GO:2020"), KEGG=c("0100", "0200", "0300")) 
  melt(datax)
  melt(list(at_0100=datax))
  
  # 数据框类型（相对复杂）
  melt(data, id.vars, measure.vars, variable.name = "variable", ..., na.rm = FALSE, value.name = "value")
  # id.vars是被当做维度的列变量；每个变量在结果中占一列；measure.vars是被当成观测值的列变量，它们的列变量名称和值分别组成variable 和 value两列，列变量名称用variable.name 和 value.name来指定。
  aq <- melt(airquality, var.ids=c("Ozone", "Month", "Day"), measure.vars=c(2:4), variable.name="V.type", value.name="value") 
  
  # var.ids可以写成id，measure.vars可以写成measure。id和即measure.vars这两个参数可以只指定其中一个，剩余的列被当成另外一个参数的值；如果两个都省略，数值型的列被看成观测值，其他的被当成id。
  # 如果想省略参数或者去掉部分数据，参数名最好用id/measure，否则得到的结果很可能不是你要的结果
  melt(airquality, var.ids=1) # 返回非理想结果
  melt(airquality, id=1)
  
 cast() # 还原数据及汇总
 cast(aq, Ozone+Month+Day~V.type)
 cast(aq, Month~V.type, fun.aggregate=mean, na.rm=TRUE) 
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
 
c() # 没有规则，很常用

assign() # 赋值函数
assign（"a",c(1,2,3,4,5,6,7,8,9))
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
which()/which.min()/which.max() # 返回元素的位置
 which(a<0)
```

### [因子](#目录)

在R中，因子可以看成一个包含了更多信息的向量，是将一个向量的重新“编码”；不同值的分类被称为“水平”。
1. **将向量转化成因子，默认转化为名义型变量，如果要有目的地转化为有序型变量，需要设置参数order和levels.**

```R
factor()
 ssample <- c("BJ","SH","CQ","SH") # 字符型向量 默认转化成名义型变量
 sf <- factor(ssample)
 nsample <- c(2,3,3,5) # 数值型变量 转化后因子水平按数值大小创建
 nf <- factor(nsample)
 assessment <- c("weak","good","limited","fair")
 assessment1 <- factor(assessment, order=TRUE, levels=c("good","fair","limited","weak")) # 有序型变量 参数order = T, 并设置参数levels

# 因子插入
 # 创建时可插入任一水平
 sample <- c(12,15,7,10)
 fsample <- factor(sample,levels=c(7,10,12,15,100))
 # 插入数据
 fsample[5]<-100 # 只能添加水平中含有的值
 fsample[6]<-99 # 非法操作
 
length(fsample) # 返回数据的长度，而非因子的长度

# 因子调用函数
tapply(X, INDEX, F) # X为原子型对象，INDEX为因子或因子列表（如果不是用as.factor强制转换，长度与X等长，F为应用函数

# INDEX为因子
 wt <- c(46,39,35,42,43,43) 
 group <- c("A","B","C","A","B","C")
 tapply(wt,as.factor(group),mean)
 
 # INDEX为因子列表
 wt <- c(46,39,35,42,43,43,42,44,36,40,39,38)
 diet <- c("A","B","C","A","B","C","A","B","C","A","B","C")
 gender <- c("M","M","M","M","M","M","F","F","F","F","F","F")
 tapply(wt,list(as.factor(diet),as.factor(gender)),mean) # 输出二维矩阵
 
by(X, INDEX, F) # tapply()函数的变种，X可以是数据框和矩阵
 by(myopia,myopia$degree,function(frame) frame[,2]+frame[,3])
  
split(X, f) # 形成分组 X为待处理数据，f为因子或因子列表
 split(wt,list(diet,gender))
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

### [矩阵/数组](#目录)

矩阵是一个二维数组，只是每个元素都拥有相同的模式（数值型、字符型或逻辑型），**矩阵可通过函数matrix创建矩阵**；数组与矩阵类似，但是维度可以大于2，**数组可通过array函数创建**。

1. **在R中，矩阵的行列都是从1开始编号，矩阵是按列存储；**
2. **元素取值或赋值时，和matlab不同：逗号后不用加冒号，使用方括号而不是圆括号；**
3. **drop=FALSE防止矩阵筛选后降维，数据框同样适用。**
```R
matrix()
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 3)
 m <- matrix(c(1,2,3,4,5,6),nrow = 2, ncol = 4) # 系统会自动循环补齐
 m <- matrix(c(1,2,3,4,5,6),nrow = 2)

array()
 array(1:24, c(2,3,4))
 array(1:24, dim = c(2,3,4))
 
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
```

```R
rowSums()
colSums()

dim()
nrow()
ncol()

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

### [数据框](#目录)

数据框（和矩阵相似）有行列两个维度，“列”表示变量，“行”表示变量的观察记录。  
数据框的每列可以是不同的模式(mode)，更像是列表的扩展。每列相当于一个向量（列表），向量长度一致，如果不一致会按“循环补齐”原则补充完整。
1. **在数据框进行行列添加时，rbind(),cbind(),transform()和within()会返回一个新的数据框，并不会对原数据框做任何更改，frame$newcolumm会对原数据直接进行修改。**
```R
data.frame(……, stringAsFactors = T) # 默认情况下会将向量转化为因子
 male <- c(124,88,200)
 female <- c(108,56,221)
 degree <- c("low","middle","high")
 myopia <- data.frame(degree,male,female)
 myopia <- data.frame(c("low","middle","high"),c(124,88,200),c(108,56,221))
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

# 数据框添加/删除
names <- c("Jack", "Steven")
ages <- c(15, 16)
students <- data.frame(names, ages, stringsAsFactors=F) # 防止字符串转化为因子，避免添加数据时和因子的水平冲突

rbind(students, list("Sariah",15))
cbind(students, gender=c("M","M")) # rbind()和cbind()会返回一个新的数据框

students$gender <- c("M","M") # 对原数据框做更改
students$gender <- NULL # 同上

transform()
 aq <- transform(airquality, log.ozone=log(Ozone), Ozone=NULL, Wind=Wind^2) # 增加/删除/修改
 
within()
 aq <- within(airquality, { 
    log.ozone <- log(Ozone) 
    squared.wind <- Wind^2 
    rm(Ozone, Wind) 
 } ) 

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

### [表](#目录)

表和矩阵或数据框十分相似，对表进行过复杂的操作都可以类比矩阵或数据框。
1. **table()的原理是使用交叉分类因子创建列联表，记录每一个因子水平组合的频数；**
2. **使用apply()和addmargins()计算表中变量的边际值，需要注意表的维度。**
```R
table()
# 使用交叉分类因子创建列联表，记录每一个因子水平组合的频数
 table(list(diet,gender))
 # 多维表的创建
 table(artery$Diabetes)
 table(list(artery$Diabetes,artery$Hypertension))
 table(D=artery$Diabetes,H=artery$Hypertension,S=artery$Ever_smoked)
 
# 表中变量的边际值，同时注意高维表的边际值计算
dh_tab <- table(list(D=artery$Diabetes,H=artery$Hypertension))
 # 使用apply()函数
 apply(dh_tab,1,sum)
 apply(dh_tab,2,sum)
 # 使用addmargins()函数
 addmargins(dhs_tab)
```

## [数据输入/输出](#目录)

### [数据输入](#目录)

1. **读取Excel数据的方法：** http://blog.csdn.net/cl1143015961/article/details/50035529
2. * **加载RODBC安装包如下如下问题：**  
[RODBC] ERROR: state IM002, code 0, message [Microsoft][ODBC 驱动程序管理器]
   * **加载rJava安装包如下如下问题：**  
loadNamespace()里算'rJava'时.onLoad失败了，详细内容：  
调用: fun(libname, pkgname)  
错误: JAVA_HOME cannot be determined from the Registry  
   * **解决方法：使用R 32-bit系统**


```R
attach() # 用于直接读取列表的变量
detach() # 解除

readline()
 website.address <- readline("Please input the website address:\n")
```

#### 读取表格
```R
# 读取表格
read.table()/read.csv()/read.delim()
 -header # default = F(table), T(csv,delim)
 -sep # default = " "(table), ","(csv), "\t"(delim)
 -as.is # default = F, 默认情况下将字符型转化成因子，=T保持原数据类型
 -check.names # default = T, 默认情况下会对标题进行检查，将列名中含有的特殊符号（如%)转化为., =F保持原来列名
 -row.names
 -col.names
 -na.string # default = NA, 赋给缺失数据的值
 
 read.delim("clipboard") # 读取剪贴板数据
 
read.fwf # 逐行读入数据
 -widths # 设置变量的宽度
```

#### 读取网页
```R
# 读取网页
readHTMLTable() #XML安装包
```

#### 读取数据库和其他软件格式数据
```R
# RODBC安装包，ODBC为微软公司提供的多类数据库的接口（Access, SQL Sever, Excel等）
 odbcConnectExcel() # Excel
 odbcConnectExcel2007()
 ……

# 读取Excel数据
 # RODBC安装包
 odbcConnectExcel() # .xls
 odbcConnectExcel2007() # .xlsx
  -sqlTables() # 给出ODBC连接对应的数据库中的数据表
  -sqlFetch()  # 读取ODBC连接中的一个表到R的数据框中
  -sqlQuery()  # 在ODBC连接上执行查询语句并返回结果
  -sqlCopy()   #
  -sqlDrop()   #
  -sqlClear()  #
  ……
  
 channel = odbcConnectExcel2007("c:/car.xlsx")
 sqlTables(channel)
 sqlFetch(channel, "Sheet1")
 data_excel2 = sqlQuery(channel, "select * from[Sheet1$]")
 close(channel) # 等同于odbcClose(channel)
 
 # xlsx安装包（需要依赖于rJava包）
 read.xlsx()
 read.xlsx2()
  -sheetIndex # sheet索引号
  ……
  
 table_test <- read.xlsx("D:/R/xlsx.xlsx",1)
 
 # openxlsx安装包（不能读取.xls文件）
 read.xlsx()
 write.xlsx()
  -sheetIndex # sheet索引号
  ……
  
 table_test <- read.xlsx("D:/R/xlsx.xlsx",1)
 
 # gdata包（电脑需要安装Perl）
 read.xls()
 
 # readxl包
 read_excel()
 
# 处理数据库数据
略
```

### [数据输出](#目录)

```R
cat()
 car = file("d:/car.txt")
 cat("Make lp100km mass.kg List.price", "\"Alpha Romeo\" 9.5 1242 38500", "\"Audi A3\" 8.8 1160 38700", file = car, sep = "\n")
 close(car)
 
write.table()/write.csv()
```
### [缺失值处理](#目录)

```R
# 判断数据是否缺失
 is.na()
  air_data = airquality[1:7,1:4]
  is.na(air_data)
  sum(is.na(air_data))
  
 complete.cases() # 取值与is.na()相反
  complete.cases(air_data) # 判定的是矩阵每一行是否完整
  complete.cases(air_data$Ozone) # 判定的是单独某列是否完整
  
 aggr() #缺失数据可视化（VIM程序包）
  library(VIM)
  air_data = airquality[1:31,1:4]
  aggr(air_data, las = 1, numbers = TRUE)
  
# 缺失样本删除
 air_data[complete.cases(air_data),]
 air_data[(!is.na(air_data$Ozone))&(!is.na(air_data$Solar.R)),]
 no.omit()
  na.omit(air_data)
  
# 缺失值替换
 air_data2 = air_data
 air_data2$Ozone[is.na(air_data2$Ozone)] = median(air_data$Ozone[!is.na(air_data$Ozone)])
 air_data2$Solar.R[is.na(air_data2$Solar.R)] = round(mean(air_data$Solar.R[!is.na(air_data$Solar.R)]))
```

## [统计图形绘制](#目录)

### [绘图基础](#目录)

**参考资料：**
* R绘图基础（一）：http://bbs.pinggu.org/thread-3162571-1-1.html
* 第八讲R语言-图形函数： https://wenku.baidu.com/view/6236eb0e7cd184254b353524.html
* R语言绘图渐进：http://blog.sina.com.cn/s/blog_5de124240101q5vw.html

#### 绘制设备(Device)

R语言中的绘图设备有多种，但可以分为两类，一类是绘图文件，另一类是绘图窗口。另外，R绘图的工作方式与变量、数据和函数等对象的处理形式大为不同，绘图结果不能复制给一个对象，而是直接输出到绘图设备中。


```R
windows()/dev.new(…)/win.graph()/X11() # 打开一个新的图形设备
png()/jpeg()/pdf()/bmp()/tiff()/postscript() # 打开一种绘图文件类型
dev.list() # 显示当前打开的所有图形设备编号 
dev.cur() # 显示当前活动的图形设备 
dev.set(…) # 切换活动图形设备号
dev.off() # 关闭指定设备号
graphics.off() # 关闭所有绘图窗口和图形设备 
```

#### 布局

R绘图所占的区域，被分成两大部分，一是外围边距，一是绘图区域。

```R
par() # 图形参数永久设置，par()（括号中不写任何参数）返回当前的图形参数设置(list)

# 外围边距及布局  ！仅par()设置
 -oma # 外围边距，oma(out margin area)，行高(line)为单位
 -mfrow # mfrow = c(nr,nc), nr*nc矩阵布局，按行次使用窗口
 -mcol # mcol = c(nr,nc), nr*nc矩阵布局，按列次使用窗口
 
split.screen() # 图形分割（可不规则划分），mfrow,mfcol可进行矩阵布局
close.screen(all = TRUE) # 退出
erase.screen() # 
screen() # 预备输出

layout()
 -widths 
 -heights
 ……
 layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE)) # 布局第一排有一个图，第二排有两个图
 layout(matrix(c(1,2,3,3), 2, 2, byrow = TRUE)) # 布局第一排有二个图，第二排有一个图
layout.show() # 显示具体的布局

```
```R
 # 绘制参数之绘图区域（绘图边距）！仅par()设置
 -mar # 图形边空的四个向量 c(bottom, left, top, right)，default: par(mar=c(5, 4, 4, 2) + 0.1)，行高(line)为单位
 -mai # 同上，inch为单位
```

```R
# 可视化显示设置内容（R中运行如下脚本）
SOUTH<-1; WEST<-2; NORTH<-3; EAST<-4;

GenericFigure <- function(ID, size1, size2)
{
  plot(0:10, 0:10, type="n", xlab="X", ylab="Y")
  text(5,5, ID, col="red", cex=size1)
  box("plot", col="red")
  mtext(paste("cex",size2,sep=""), SOUTH, line=3, adj=1.0, cex=size2, col="blue")
  title(paste("title",ID,sep=""))
}

MultipleFigures <- function()
{
  GenericFigure("1", 3, 0.5)
  box("figure", lty="dotted", col="blue")

  GenericFigure("2", 3, 1)
  box("figure", lty="dotted", col="blue")

  GenericFigure("3", 3, 1.5)
  box("figure", lty="dotted", col="blue")

  GenericFigure("4", 3, 2)
  box("figure", lty="dotted", col="blue")
}

par(mfrow=c(2,2),mar=c(6,4,2,1),oma=c(4,3,2,1))

MultipleFigures()

box("inner", lty="dotted", col="green")
box("outer", lty="solid", col="green")

mtext("Outer Margin Area (oma) of South", SOUTH, line=1, cex=1, outer=TRUE)

plotline<-function(n,direc){
  for(i in 0:n){
    mtext(paste("line",i,sep=""), direc, line=i, cex=1, col="black", adj=1, outer=TRUE)
  }
}
plotline(4,SOUTH)
```

```R
 # 绘制参数之绘图区域（主绘图）
 -fig # 任意未知作图（左下角(0,0),右上角(1,1)）
 -new # 是否在原画布基础上作图
 
 -bg # 背景色
 -bty # 图形边框形状, 'n'(不绘制表框)
 -pty # 's'正方形，'m'最大利用 ！par()设置
 
 -adj # 字符位置：0(left), 0.5(center,default), 1(right)
 -tck # 轴上刻度长度值（百分比），tck=1,绘制grid  ！仅暂时性设置
 -tcl # 轴上刻度长度值（行高），tcl=0.5(default)
 -cex # 缺省状态下符号和文字大小的值
 -col # 符号颜色（边框）
 -font # 文字字体，1(normal), 2(italic), 3(bold), 4(italic&bord)
  -cex.axis/col.axis/font.axis # 坐标轴刻度数字大小/颜色/字体
  -*.lab  # 坐标轴标签文字大小/颜色/字体
  -*.main # 坐标轴标题文字大小/颜色/字体
  -*.sub  # 坐标轴副标题文字大小/颜色/字体
 -ps # 控制整体文字的大小  ！par()设置
 -las # 坐标轴刻度数字标记方向的整数， 0(平行于轴), 1(横排), 2(垂直于轴), 3(竖排)
 
 -type # 'p'(绘制单独点default),'l'(线),'b'(both),’c'(点线图去掉点),'o'(点绘在线上),'h'(从点到零轴的垂线(high-density)),'s'/'S'(阶梯式图),'n'(不绘制,坐标轴是绘出)
 -lty # 线型 (0=blank, 1=solid (default), 2=dashed, 3=dotted, 4=dotdash, 5=longdash, 6=twodash)
 -pch # points符号类型，1-25,21-25可以加颜色，或者使用字符
 -lwd # 宽度
 
 -log # 坐标对数化
 -axes = FALSE # 无坐标轴
 -xaxt = "n" # 抑制X轴原标记及文字表达，与axis(side=1, ……)联用
 -yaxt = "n" # 抑制Y轴原标记及文字表达，与axis(side=2, ……)联用
 ……

colors() # 显示657种所有颜色名称
 
lines() # 在现有的图形上叠加一条密度曲线
plot()  # 创建一幅新的图形
 -asp #y/x 坐标轴比例

polygon() # 曲线内填充颜色函数
 -border # 边界颜色 F/NA为省略边界色，T/NULL为前景色
curve(expr, from =, to =, …… ) # 绘制函数对应的曲线
image() # Display a Color Image

axis() # 坐标表达设置
title() # 标题
legend() # 图例
box() # 为图形增加一个框

rug() # 轴须图
```

### [图像读取及处理](#目录)

**参考资料：**
* R语言图像处理： http://blog.csdn.net/pyramidnail/article/details/8627880

```R
library(jpeg)
library(ggplot2)
library(reshape)

# 读取
readImage<-readJPEG('test.jpg') # 读取图片，readJPEG为jpeg程序包下的函数
longImage<-melt(readImage) # melt为reshape程序包下的函数
rgbImage<-reshape(longImage, timevar='X3', idvar=c('X1','X2'), direction='wide')
colorColumns<- rgbImage[, substr(colnames(rgbImage), 1, 5)== "value"] # 提取像素RGB值，substr(x, start, stop):Extract or replace substrings in a character vector.
rgbImage$X1<- -rgbImage$X1
with(rgbImage,plot(X2, X1, col = rgb(colorColumns), asp = 1, pch =".",axes=F,xlab='',ylab=''))
# 上述三条语句可简化为：
plot(rgbImage$X2, -rgbImage$X1, col = rgb(rgbImage[3:5]), asp = 1, pch =".",axes=F,xlab='',ylab='')

# 图像模糊处理
rgbAlter<- rgbImage 
rgbAlter$X2<- jitter(rgbAlter$X2)
rgbAlter$X1<- jitter(rgbAlter$X1)
rgbAlter$Size<- runif(1:nrow(rgbAlter), 0, 2) # and random point sizes
with(rgbAlter,plot(X2, X1, col = rgb(colorColumns), asp = 1, cex = Size, axes=F,xlab='',ylab=''))

# 去除绿色
rgbAlter<- rgbImage
rgbAlter[,4] <- 0 
with(rgbAlter,plot(X2, X1, col = rgb(rgbAlter[, 3:5]), asp = 1, pch = ".",axes=F,xlab='',ylab=''))

# 曝光处理
rgbAlter<- rgbImage
rgbAlter[,c(3:5)] <- round(rgbAlter[, c(3:5)] * 2) / 2
with(rgbAlter,plot(X2, X1, col = rgb(rgbAlter[, 3:5]), asp = 1, pch =".",axes=F,xlab='',ylab=''))

```

### [饼状图](#目录)

```R
# 二维饼状图
pie()
 -main # 标题
 -labels
 -clockwise # T为顺时针，F为逆时针
 -col # 颜色
 -border # 边界颜色 F/NA为省略边界色，T/NULL为前景色 ###
 
 countries <- c("Brazil","Russia","India","China","South Africa")
 GDP <- c(23920, 20790, 18618, 94906, 3660)
 percentage <- round(GDP/sum(GDP)*100, 2)
 index <- paste(countries, " ", percentage, "%", sep="")
 pie(GDP, labels = index, clockwise = T, col = rainbow(length(index)), main= "Pie Chart with Percentages")
 
# 三维饼状图
pie3D() # plotreix程序包
 - explode # 扇片间距
 
 pie3D(GDP, labels = countries, explode = 0.1, main = "3D Pie Chart")
 
# 扇形图
fan.plot()
 fan.plot(GDP, labels = countries, main = "Fan Plot")
```
### [直方图](#目录)

直方图是一种对数据分布情况进行展示的二维统计图形，横轴将值域划分划分一定数量的组别，纵轴上则显示相应值出现的频数，**与条形图不同**。

```R
hist()
 -breaks # 划分档次，控制分组数量（调用pretty函数进行分组划分）
 -xlab/ylab
 -xlim/ylim
 -freq # 设置为F，根据概率密度而不是频数绘制图形，实现直方图归一化
 ……
 
 hist(mpg, breaks = 12, xlim = c(10, 35), xlab = "Miles/Gallon", main = "Histogram Example")
 hist(mpg, breaks = c(2*5:9, 5*4:7), col = "blue1", ylim = c(0, 0.12), xlab = "Miles/Gallon", main = "Example with Non-equidistant Breaks") # 不等距划分，且直方图归一化
 hist(mpg, breaks = 12, col = "blue1", ylim = c(0, 0.12), xlim = c(10, 35), freq = FALSE, xlab = "Miles/Gallon", main = "Histogram Example of Density ")
  
 h <- hist(mpg, breaks = 12, col = "blue", xlim = c(10, 35), xlab = "Miles/Gallon", main = "Histogram Example with Normal Curve")
 xfit <- seq(min(mpg), max(mpg), length = length(mpg)) # 曲线是根据原始数据的均值和标准差估算出来的正态分布曲线所画
 yfit <- dnorm(xfit, mean=mean(mpg), sd=sd(mpg))
 yfit <- yfit*diff(h$mids[1:2])*length(mpg) # diff(h$mids[1:2])求间隙大小，diff求相邻两项的差
 lines(xfit, yfit, col = "red", lwd = 2)
```
### [核密图](#目录)

```R
density();plot()
 
 d <- density(mpg)
 plot(d, main = "Density of Miles/Gallon")
 polygon(d, col = "wheat", border = "blue") ###
 rug(jitter(mpg, amount = 0.01), col = "brown") # jitter()添加小的随机数
 
# 组间差异
plot(density(mtcars[mtcars$cyl==4, ]$mpg), col = "red", lty = 1, xlim = c(5, 40), ylim = c(0, 0.25), xlab = "", main = "")
par(new = TRUE) ###
plot(density(mtcars[mtcars$cyl==6, ]$mpg), col = "blue", lty = 2, xlim = c(5, 40), ylim = c(0, 0.25), xlab = "", main = "")
par(new = TRUE)
plot(density(mtcars[mtcars$cyl==8, ]$mpg), col = "green", lty = 3, xlim = c(5, 40), ylim = c(0, 0.25), xlab = "Miles/Gallon", main = "MPG Distribution by Cylinders")
text.legend = c("cyl=4", "cyl=6", "cyl=8")
legend("topright", legend = text.legend, lty=c(1, 2, 3), col = c("red", "blue", "green"))

# 组间差异（满足某种分布）
curve(dnorm(x,mean(mtcars[mtcars$cyl==4, ]$mpg), sd(mtcars[mtcars$cyl==4, ]$mpg)), from = 5, to = 40, ylim=c(0,0.28),col = "red", lty = 1, xlab = "", ylab="",main="")
par(new=TRUE)
curve(dnorm(x,mean(mtcars[mtcars$cyl==6, ]$mpg), sd(mtcars[mtcars$cyl==6, ]$mpg)), from = 5, to = 40, ylim=c(0,0.28),col = "blue", lty = 2, xlab = "", ylab="",main="")
par(new=TRUE)
curve(dnorm(x,mean(mtcars[mtcars$cyl==8, ]$mpg), sd(mtcars[mtcars$cyl==8, ]$mpg)), from = 5, to = 40, ylim=c(0,0.28),col = "green", lty = 3, xlab = "Miles/Gallon", ylab = "Density", main="MPG Distribution by Cylinders")
text.legend = c("cyl=4","cyl=6", "cyl=8")
legend("topright", legend = text.legend, lty=c(1,2,3), col = c("red", "blue", "green"))
```
### [箱线图](#目录)

箱线图通过绘制一组数据的“**最大值、最小值、中位数、下四分位数及上四分位数**”这五个指标来显示该组数据的分散情况。

```R
boxplot()
 boxplot(mpg, main="Box plot", ylab="Miles per Gallon")
 
boxplot.stats(x, coef = 1.5, do.conf = TRUE, do.out = TRUE) # 仅输出统计结果，不画图
 -coef # default = 1.5 "须"长度的极限值，1.5倍四分位距；设置为0，上升至数据集的极限（最大值最小值）
 # 输出结果参数
 - stats # 盒须最小值 盒最小值 中位数 盒最大值 盒须最大值
 - n # 非缺失值的个数
 -conf # 中位数95%的置信区间
 -out # 异常值
 
# 返回五个指标的函数
fivenum<-function(x){
 x<-sort(x)
 n <- length(x)
 n4 <- floor((n + 3)/2)/2
 d <- c(1, n4, (n + 1)/2, n + 1 - n4, n)
 return(0.5 * (x[floor(d)] + x[ceiling(d)]))
}
summary()
quantile()


# 并列箱线图
boxplot(mpg ~ cyl, data = mtcars, main = " ", xlab = " ", ylab = " ")

# 凹槽箱线图
boxplot(mpg ~ cyl, data = mtcars, notch = TRUE, main = " ", ylab = " ", xaxt = "n") # xaxt = "n" 抑制X轴原表达
axis(side = 1, at = c(1, 2, 3), labels = c("4 cylinders", "6 cylinders", "8 cylinders"))

# 多个分组因子箱线图
cyl.f <- factor (cyl, levels = c(4, 6, 8), labels = c("4 cyls", "6 cyls", "8 cyls"))
am.f <- factor(am, levels = c(0, 1), labels = c("auto","std"))
boxplot(mpg ~ am.f*cyl.f, data = mtcars, varwidth = TRUE, col = c("wheat", "orange"), xlab = " ", main = " ")
```
### [条形图](#目录)

```R
barplot()
 # Vertical
 my.data <- c(5.87, 7.94, 3.77, 7.41, 5.37)
 names(my.data) <-c("US", "Japan", "China", "Brazil", "India") # 可用barplot()
 函数中names.arg参数替换 
 barplot(my.data, ylim = c(0,round(max(my.data))), main = "Barplot Example (Vertical)", xlab = "Countries", ylab = "GDP per Energy")
 
 # Horizontal(,horiz = TRUE)
 barplot(my.data, xlim = c(0,round(max(my.data))),horiz = TRUE, main = "Barplot Example (Horizontal)", xlab = "GDP per Energy", ylab = "Countries")
 
 # 堆砌
 my.data <- matrix(c(38.1, 1.7, 27.8, 28.7, 34.1, 69.6), nrow = 2)
 rownames(my.data) <- c("China", "Germany")
 colnames(my.data) <- c("primary","secondary","tertiary")
 barplot(my.data, main = "Grouped Barplot", col = c("wheat", "orange"), legend = rownames(my.data), args.legend = list(x = "top"))
 
 # 并列(beside = TRUE)
 barplot(my.data, main = "Grouped Barplot", col = c("wheat", "orange"), beside = TRUE, legend = rownames(my.data), args.legend = list(x = "top"))
 
 # 棘状图
 library(vcd)
 spine(my.data, main="Employment in Three Industries")
```
### [qq图](#目录)

分位数函数就是相应累积分布函数的反函数。

```R

```




































