# the Study of R

**R语言学习笔记**  
自学编程语言的时候，会遇到很多问题和特殊代码语句，记得本子里还不如归类在Github中，所以就开始行动。  
（记录在这里主要是为了自己以后的查阅，更多的是符合自身使用习惯）

主要学习使用的书籍如下：
* 《R语言实践-机器学习与数据分析》 左飞

## 目录

* [基本操作](#基本操作)

## 基本操作

```
getwd()
setwd("……")
q()
load()
```

```
# 函数基本格式
hi.world <- function() {
cat("Hello World!\n")
}
hi.world()
```

```
# 包的使用
install.packages('')
installed.packages()
  colnames(installed.packages()) #查看已经安装的包名
available.packages()

search()
library()
require()
```

```
# 包的使用
install.packages('')
installed.packages()
  colnames(installed.packages()) #查看已经安装的包名
available.packages()

search()
library()
require()
```
```
# 帮助
help(exp)
?exp

example(exp)
help.search("poisson")
??"poisson"
```
