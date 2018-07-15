# 概率与统计

[>>返回R学习笔记主页!](https://github.com/Happykelee/the-Study-of-R)


## 目录

* [基础](#基础)
  * [概率分布模型](#概率分布模型)
* [统计推断](#统计推断)
  * [参数估计](#参数估计)
  * [参数假设检验](#参数假设检验)
  * [非参数假设检验](#非参数假设检验)
* [方差分析方法](#方差分析方法)
  * [基本概念](#基本概念)
  * [单因素方差分析](#单因素方差分析)
  * [双因素方差分析](#双因素方差分析)
  * [多重比较](#多重比较)
  * 方差齐性的检验方法

## [基础](#目录)

1. **随机变量X** - **累积分布函数(CDF)** - **概率质量函数(PMF)/概率密度函数(PDF)**

2. **期望(一阶矩)$E(X)/\mu$** - **k阶矩** - **方差(二阶中心距)D(X)/Var(X)** - **标准差$\sqrt{D(X)}/\sigma(X)$**

3. **大数定理：** 样本数量越多，则其平均就越趋近期望值。*(简)*

4. **中央极限定理：** 大量相互独立的随机变量之和的分布以正态分布为极限。*(简)*

5. **总体(总体容器/有限总体/无限总体)** - **个体** - **抽样(sample())**
   **样本(样本容量)** - **样本值(观察值)** - **分布函数F**
   **样本均值$\bar{X}$** - **样本方差(无偏估计/有偏估计)$S^2$** - **来自正态分布$N(\mu,\sigma^2)$的一个样本，样本均值和样本方差分别是$\bar{X}$和$S^2$，则有$\frac{\bar{X}-\mu}{S/\sqrt{n}}$ ~ $t(n-1)$**

### [概率分布模型](#目录)

```R
# 离散概率分布
  # 伯努利分布/二项分布:binom
  # 负二项分布:nbinom
  # 几何分布:geom
  # 泊松分布:pois
# 连续概率分布
  # 均值分布:unif
  # 指数分布:exp
  # 正态分布:norm
# ......

# e.g.
curve(dbinom(x, p = 0.5, size = 10), from = 0, to = 10, type = 's', main = 'Binomial')

dfunc(x, ... ,) # 密度函数
pfunc(x, ... ,) # 分布函数
qfunc(x, ... ,) # 分位数函数
rfunc(x, ... ,) # 随机数函数
```

## [统计推断](#目录)


|Tables             |genres                       |
|:-----------------:|:---------------------------:|
|[参数估计](#参数估计)|点估计：矩方法/极大似然估计    |
|                   |区间估计                      |
|假设检验            |[参数假设检验](#参数假设检验)|
|                   |[非参数假设检验](#非参数假设检验)|

### [参数估计](#目录)

参数估计是用样本统计量估计总体参数值，$\bar{\theta}$称为估计量。
* **点估计(矩估计法)**
* **区间估计：** 置信区间、置信水平、显著水平

**1. 极大似然估计**

总体含有待估参数$\theta$，可以取很多值，要在$\theta$的一切可能取值中选出一个是样本观测值出现的概率最大的$\theta$值，记为$\hat{\theta}$，并称$\hat{\theta}$为$\theta$的极大似然估计。

**似然函数：** $L(\theta) = \prod_{i=1}^{n}p(x_i;\theta)$  
**对数似然函数：** $l(\theta) = lnL(\theta)$, 通过$l(\theta)$对$\theta$的每一个分量求偏导并令其为0求解。  
**对于不同的分布形式而言，其似然函数的形式也是各式各样的。**

```R
# 单参数情况，使用optimize()/maxLik()函数求解
# e.g.(optimize()) 指数分布求解参数lamda
 f <- function(lamda){
   logL = n*log(lamda) - lamda*sum(x) # 对数似然函数
   return(logL)
 }

 x = c(518,612,713,388,434)
 n = length(x)
 duration <- optimize(f, c(0,1), maximum = TRUE)
 1/duration$maximum # 指数分布的期望为lamda的倒数

# e.g.(maxLik())
 library(MASS)
 attach(geyser)

 hist(waiting, freq = F, col = 'wheat')
 lines(density(waiting), col = 'red', lwd = 2, lty = 1)
 # 由结果推断为两个正态分布相叠加

 LL <- function(params, data){
   t1 <- suppressWarnings(dnorm(data, params[2], params[3]))
   t2 <- suppressWarnings(dnorm(data, params[4], params[5]))
   ll <- sum(log(params[1]*t1+(1-params[1])*t2))
   # 两个叠加的正态分布的对数似然函数
   return <- ll
 }

 library('maxLik')
 # 参数method可以选择不同的数值求解方法：NR/BHHH/BFGS/NM/SANN
 mle <- maxLik(logLik = LL, start = c(0.5,50,10,80,10), data = waiting)

 a <- mle$estimate[1]
 mu1 <- mle$estimate[2]; s1 <- mle$estimate[3]
 mu2 <- mle$estimate[4]; s2 <- mle$estimate[5]

 X <- seq(40,120,length = 100)
 f <- a*dnorm(X,mu1,s1) + (1-a)*dnorm(X,mu2,s2)

 lines(X, f, col ='blue', lwd = 2, lty = 2)
 legend('topright', legend = c('Density Line', 'Max Likelihood'), lwd = c(2,2), lty = c(1,2), col = c('red', 'blue'))
```

**2. 单总体参数区间估计**

```R
# 总体比例的区间估计
 # Wald方法：正态分布对二项分布进行估计
 # Clopper-Person方法：基于二项分布估计
   binom.test()

# 总体均值的区间估计
 # 情况一：总体正态分布且方差已知/
 # 总体非正态分布但为大样本(>=30)，样本均值的抽样分布均为正态分布
 conf.int <- function(x,n,sigma,alpha){
   options(digits = 5) # 五位有效数字
   mean <- mean(x)
   low <- mean - sigma*qnorm(1-alpha/2,mean=0,sd=1,lower.tail=T)/sqrt(n)
   up <- mean + sigma*qnorm(1-alpha/2,mean=0,sd=1,lower.tail=T)/sqrt(n)
   return(c(low,up))
 }

 # 情况二：总体正态分布但方差未知/
 # 总体非正态分布，大样本情况下用样本方差代替总体方差

 # 情况三：总体正态分布，但方差未知且小样本，样本方差代替总体方差，
 # 样本均值服从(n-1)自由度的t分布。
 pH <- c(......)
 n <- length(pH)
 mean <- mean(pH)
 sd <- sd(pH)
 results <- mean + qt(c(0.025,0.975),n-1) * sd /sqrt(n)

 t.test(pH, mu=7)

# 总体方差的区间估计
 # 样本方差服从自由度为n-1的卡方分布
 chisq.var.test <- function(x, alpha){
   options(digits = 4)
   result<-list( )
   n<-length(x)
   v<-var(x)
   result$conf.int.var <- c(
     (n-1)*v/qchisq(alpha/2, df=n-1, lower.tail=F),
     (n-1)*v/qchisq(alpha/2, df=n-1, lower.tail=T))
   result$conf.int.se <- sqrt(result$conf.int.var)
   result
 }
```

**3. 双总体均值差的估计**

**独立样本**

**总体方差相同（总体方差由样本方差代替）：**
$t=\frac{\bar{x_1}-\bar{x_2}-(\mu_1-\mu_2)}{s'/\sqrt{1/n_1+1/n_2}}$ ~ $t(n_1+n_2-2)$, $s'=\sqrt\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{n_1+n_2-2}$

**总体方差不相同（总体方差由样本方差代替）：**
$t=\frac{\bar{x_1}-\bar{x_2}-(\mu_1-\mu_2)}{\sqrt{s_1^2/n_1+s_2^2/n_2}}$ ~ $t(v)$, $v=(\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2})^2/[\frac{(\sigma_1^2)^2}{n_1^2(n_1-1)}+\frac{(\sigma_2^2)^2}{n_2^2(n_2-2)}]$, $\hat{v}=(\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2})^2/[\frac{(s_1^2)^2}{n_1^2(n_1-1)}+\frac{(s_2^2)^2}{n_2^2(n_2-2)}]$
```R
t.test()
# 情况一：两总体方差已知
# 情况二：两总体方差未知但相同，用两个样本方差代替
 chicks <- data.frame(feed = rep(c(1,2), times=c(3,6)), weight_gain = c(42, 68, 85, 42, 97, 81, 95, 61, 103))
 n1 <- sum(chicks$feed == 1)
 n2 <- sum(chicks$feed == 2)
 n <- n1+n2
 mean <- tapply(chicks$weight_gain, chicks$feed, mean)
 sd <- tapply(chicks$weight_gain, chicks$feed, sd)
 sd2 <- sqrt(((n1-1)*sd[1]^2+(n2-1)*sd[2]^2)/(n-2))
 alpha <- 0.05
 diff = mean[1]-mean[2]
 results_diff = diff+qt(c(alpha/2,1-alpha/2),n-2)*sd2*sqrt(1/n1+1/n2)

t.test(weight_gain ~ feed, data = chicks, var.equal = TRUE)

# 情况三：两总体方差未知但不相同，用两个样本方差代替
 v <- (sd[1]^2/n1+sd[2]^2/n2)^2/(sd[1]^4/n1^2/(n1-1)+sd[2]^4/n2^2/(n2-1))
 results_diff = diff+qt(c(alpha/2,1-alpha/2),v)*sqrt(sd[1]^2/n1+sd[2]^2/n2)

 t.test(weight_gain ~ feed, data = chicks, var.equal = FALSE)
```

**配对样本**

```R
# 情况一：大样本
# 情况二：小样本
Feed.1 <- c(44, 55, 68, 85, 90, 97)
Feed.2 <- c(42, 61, 81, 95, 97, 103)
n = length(Feed.1)
alpha = 0.05
diff = Feed.1-Feed.2
mean = mean(diff)
sd = sd(diff)
(results_diff = mean+qt(c(alpha/2,1-alpha/2),n-1)*sd/sqrt(n))

t.test(Feed.1, Feed.2, paired = T)

t.test(diff)
```

**4. 双总体比例差的估计**

```R
prop.test()
 prop.test(x=c(225,128),n=c(500,400), correct=F)
 prop.test(x=c(225,128),n=c(500,400)) # 使用连续性修正
```

### [参数假设检验](#目录)

假设检验的基本思想为小概率反证法思想。
* **原假设($H_0$):** 那些单纯由随机因素导致的采样观察结果；
* **备择假设($H_1$):** 指受某些非随机因素影响而得到的采样观察结果。
* **单侧问题** / **双侧问题**

**1. 均值检验**

* 大样本下的统计量都被看成是正态分布，需要使用z统计量，计算公式为$z=\frac{\bar{X}-\mu}{\sigma/\sqrt{n}}$，通常用样本标准差s代替$\sigma$。
* 小样本情况下，样本统计量服从t分布，使用t统计量，计算公式为$t=\frac{\bar{X}-\mu}{S/\sqrt{n}}$，t的自由度为n-1。

```R
# 小样本情况
pH <- c(......)
n <- length(pH)
mean <- mean(pH)
sd <- sd(pH)
alpha <- 0.05
t.value <- (mean-7) * sd /sqrt(n)

# 双尾检验
2*pt(t.value, n-1, lower.tail = T)
qt(alpha/2,n-1);qt(1-alpha/2,n-1)
t.test(pH, mu=7)

# 单尾检验（左端）
pt(t.value, n-1)
t.test(pH, mu=7, alternative = 'less')
```

```R
# 双总体均值差的假设检验(独立样本，总体方差相同)
chicks <- data.frame(feed = rep(c(1,2), times=c(3,6)), weight_gain = c(42, 68, 85, 42, 97, 81, 95, 61, 103))
n1 <- sum(chicks$feed == 1)
n2 <- sum(chicks$feed == 2)
n <- n1+n2
mean <- tapply(chicks$weight_gain, chicks$feed, mean)
sd <- tapply(chicks$weight_gain, chicks$feed, sd)
sd2 <- sqrt(((n1-1)*sd[1]^2+(n2-1)*sd[2]^2)/(n-2))
t.value <- (mean[1]-mean[2])/sd2/sqrt(1/n1+1/n2)
alpha <- 0.05

# 双尾检验
qt(alpha/2,n-2);qt(1-alpha/2,n-2)
2*pt(t.value, n-2, lower.tail = T)

t.test(weight_gain ~ feed, data = chicks, var.equal = TRUE)
```

```R
# 双总体均值差的假设检验(独立样本，总体方差不同)
chicks <- data.frame(feed = rep(c(1,2), times=c(3,6)), weight_gain = c(42, 68, 85, 42, 97, 81, 95, 61, 103))
n1 <- sum(chicks$feed == 1)
n2 <- sum(chicks$feed == 2)
v <- (sd[1]^2/n1+sd[2]^2/n2)^2/(sd[1]^4/n1^2/(n1-1)+sd[2]^4/n2^2/(n2-1))
mean <- tapply(chicks$weight_gain, chicks$feed, mean)
sd <- tapply(chicks$weight_gain, chicks$feed, sd)
t.value <- (mean[1]-mean[2])/sqrt(sd[1]^2/n1+sd[2]^2/n2)
alpha <- 0.05

# 双尾检验
qt(alpha/2,v);qt(1-alpha/2,v)
2*pt(t.value, v, lower.tail = T)

t.test(weight_gain ~ feed, data = chicks, var.equal = FALSE)
```

```R
# 双总体均值差的假设检验(配对样本)
Feed.1 <- c(44, 55, 68, 85, 90, 97)
Feed.2 <- c(42, 61, 81, 95, 97, 103)
n = length(Feed.1)
mean <- mean()
alpha = 0.05
diff = Feed.1-Feed.2
mean = mean(diff)
sd = sd(diff)
t.value = mean/sd*sqrt(n)

# 双尾检验
qt(alpha/2,n-1);qt(1-alpha/2,n-1)
2*pt(t.value, n-1, lower.tail = T)

t.test(Feed.2, Feed.1, paired = T)

t.test(diff)
```

### [非参数假设检验](#目录)

总体分布服从正态分布或总体分布已知条件下进行的统计检验称为**参数检验**；总体分布不要求服从正态分布或总体分布情况不明时，用来检验**数据资源是否来自同一个总体的统计检验方法**就是**非参数检验方法**。

**1. 列联分析**

列联分析是研究两个分类变量之间关系的统计方法，**统计数据** 有类别型数据和数值型数据之分，**列联表** 是由两个以上的变量进行交叉分类的频数分布表。

* **皮尔逊卡方检验**
  * **卡方统计值：**$\chi^2 = \sum\frac{(f_o-f_e)^2}{f_e}$, $f_o$表示观察值频数，$f_e$表示期望值频数
  * **期望：** 行和与列和之积再除以表中数据总和，$E_r,c = n_r*n_c/n$
  * **自由度：** $df = (r-1) * (c-1)$
  * **应用条件：** 隐含条件为正态分布近似二项分布，故每个单元格数据是确切的频数/类别不可相互交织/期望频数均不小于1/至少80%的期望频数不小于5
* **费希尔确切检验**
2*2的列联表检验的方法，为超几何分布。

    |    |  X1 |  X2 |  X  |
    |:--:|:---:|:---:|:---:|
    | Y1 |  a  |  b  | a+b |
    | Y2 |  c  |  d  | c+d |
    |  Y | a+c | b+d |  N  |

    $P(X=a) = \frac{C_{a+b}^aC_{c+d}^c}{C_{a+c}^N}$


```R
# 骰子是否有偏
 chisq.test(c(25, 18, 28, 20, 16, 13))

# 已知卡方统计值和自由度
 pchisq(42.252,6,lower.tail=F)

# 原始数据输入
 alcohol.by.nicotine <- matrix(c(105, 7, 11, 58, 5, 13, 84, 37, 42, 57, 16, 17), nrow = 4, byrow = TRUE)
 chisq.test(alcohol.by.nicotine)

# 不满足条件的情况
 aluminium.by.alzheimers <- matrix(c(112, 3, 5, 8, 114, 9, 3, 2), nrow=2, byrow = TRUE)
 chisq.test(aluminium.by.alzheimers, simulate.p.value = TRUE)
 # 蒙特卡洛模拟法计算P值
```
```R
# 左利手与性别是否有关
handedness <- matrix(c(1, 30, 4, 12), nrow = 2, byrow = TRUE)
fisher.test(handedness)
```

**2. 符号检验**

符号检验是一种使用正负号来检验不同假设的非参数检验方法。

* **检验的假设：** 涉及单一总体中位数的假设和配对数据的假设；
* **核心思想：** 分析数据中正负号出现的频率，并确定它们是否有显著差异；
* **检测方法：** 判断观察值与原假设中心位置的大小，$S_+$为正符号的数目，$S_-$为负符号的数目，**$S_*$为两者中较小者作为统计量**。以**二项分布为基础，概率为0.5**的一种假设检验；当n大于25时，近似认为结果分布服从正态N(0,1)分布。
* **统计量修正：** 由于正态分布是连续分布，所以需要进行连续修正，计算公式为：$z=\frac{(x+0.5)-0.5n}{0.5\sqrt{n}}$，x表示频率较小的符号出现的次数，*证明略*。

```R
z = -2.23 # 已知统计量并已经对其进行修正
pnorm(z) # 正态分布近似

x <- c(......)
binom.test(sum(x>99), length(x), alternative = 'less') # 二项分布
pbinom(sum(x>99), length(x), prob=0.5, lower.tail = T) * 2 # 双尾
```

**3. 威尔科克森符号秩检验**

利用观察值和原假设中心位置的差的正负，以及差值的大小的信息。

* **检验的假设：** 一个样本是否来自一个具有指定中位数的总体；
* **核心思想：** 差值按照绝对值的大小编秩并给秩次加上原来差值符号，所形成的的正秩和与负秩和在理论上是相等的（满足原假设）。
* **检测方法：** $T_+$为正号的秩和，$T_-$为负号的秩和，$T$为两者中较小者。**当T不大于30时，T为统计量；当T小于30时，$z=\frac{T-n(n+1)/4}{\sqrt{n(n+1)(2n+1)/24}}$，*证明略***。

```R
# 原假设中位数为8
x=c(4.12,5.81,7.63,9.74,10.39,11.92,12.32,12.89,13.54,14.45)
wilcox.test(x-8, alternative = "greater")

# 配对数据
x <- c(1.83, 0.50, 1.62, 2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
y <- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)
wilcox.test(y - x, alternative = "less")

wilcox.test(x, y, paired = TRUE, alternative = "greater")

# 数据较多，计算近似P值
wilcox.test(y - x, alternative = "less",exact = FALSE, correct = FALSE)
 # exact = F, correct表示是否进行连续型修正
```

**4. 威尔科克森的秩和检验**

两个样本所代表的总体是否有相同的分布或是否来自同一个分布。

* **核心思想：** 如果两个样本来自同一个总体，这些值都在数值的一个合并集中进行排序，那么高和低的秩应该平均地落在两个样本中；如果一个样本中发现低秩特别显著，而在另一个总体中发现高秩特别显著，有理由怀疑这两个样本来自不同的总体。
* **方法优势：** 总体正态分布要求不成立的情况下，可以用秩和检验法；另外，秩和检验法简单方便且高效。
* **检验方法：** 样本1的容量为n1，样本2的容量为n2，总体1观察值的秩和为T,合并两个样本后秩集的均值为$\frac{(n_1+n_2)(n_1+n_2+1)}{2(n_1+n_2)} = (n_1+n_2+1)/2$；原假设前提，T的期望$\mu_T = \frac{n_1(n_1+n_2+1)}{2}$，T的方差$\sigma{_T}{^2} = \frac{n_1n_2}{12}(n_1+n_2+1)$。$T_L$表示左边界临界值，$T_L$表示右边界临界值。
**当两个样本数均不大于10时，T为统计量，比较T和临界表中的数值；当两个样本数大于10时，$z = \frac{T-\mu_T}{\sigma{_T}}$，调整T的方差：$\sigma{_T}{^2} = \frac{n_1n_2}{12}[(n_1+n_2+1)-\frac{\sum_{j=1}^{k}t_j(t^2_j-1)}{(n_1+n_2)(n_1+n_2-1)}]$**

```R
# 小样本
placebo <- c(0.90, 0.37, 1.63, 0.83, 0.95, 0.78, 0.86, 0.61, 0.38, 1.97)
alcohol <- c(1.46, 1.45, 1.76, 1.44, 1.11, 3.07, 0.98, 1.27, 2.56, 1.32)
wilcox.test(placebo, alcohol, alternative = "less", exact = TRUE)

# 大样本
pnorm(3.817159, lower.tail = FALSE)

before <- c(11.0, 11.2, 11.2, 11.2, 11.4, 11.5, 11.6, 11.7, 11.8, 11.9, 11.9, 12.1)
after <- c(10.2, 10.3, 10.4, 10.6, 10.6, 10.7, 10.8, 10.8, 10.9, 11.1, 11.1, 11.3)
wilcox.test(before, after, alternative = "greater", exact = FALSE, correct = FALSE)
```

**5. 克鲁斯卡尔-沃里斯检验**

来自3个或更多独立总体的样本数据是否具有相同的分布，无总体分布要求。
* **应用要求：** 每个样本中至少有5个观察值，统计量H的分布才用$\chi^2$分布来近似。
* **统计量：** $H = \frac{12}{n_T(n_T+1)}(\sum_{i}\frac{T_{i}^{2}}{n_i})-3(n_T+1)$, 其中$n_i$是样本i的观察值数量，k是样本的个数，$n_T$是混合后的总样本容量，$T_i$是样本i在总的样本观察值中的秩和。  
**等价于：** $H = \frac{12}{n_T(n_T+1)}(\sum{n_i}(\bar{T_{i}}-\widehat{T_{i}})^2,  \bar{T_{i}} = \frac{T_i}{n_i},  \widehat{T_{i}} = \frac{T_i}{\sum{n_i}}$
对给定的显著水平$\alpha$，如果统计量H超过自由度为k-1的$\chi^2$的临界值，则拒绝原假设。
**当样本观察值的秩有大量存在时，** $H' = H / (1-\sum_{j}\frac{t_{i}^{3}-t_j}{n_{T}^{3}-n_T})$，其中$t_j$是第j个相等秩组中的观察值数量。

```R
# e.g.
x <-c(4.2, 3.3, 3.7, 4.3, 4.1, 3.3)
y <-c(4.5, 4.4, 3.5, 4.2, 4.6, 4.2)
z <-c(5.6, 3.6, 4.5, 5.1, 4.9, 4.7)
kruskal.test(list(x, y, z))
```

## [方差分析方法](#目录)

### [基本概念](#目录)

**方差分析** 是通过检验各总体均值是否相等来判断分类型变量对数值型变量是否有显著影响的统计检验方法，由费希尔提出，故又称为**F检验**。  
方差分析中，将要检验的对象称为**因素**或**因子**，因素的不同表现称为**水平**或**处理**，每个水平下得到的样本数据称为**观察值**。  
只有一个因素的方差分析称为**单因素方差分析**。在单因素分析中，涉及两个变量：一个是分类型变量（自变量），一个是数值型变量（因变量）。

方差分析是通过对数据误差的考察来判断不同总体的均值是否相等，进而分析自变量对因变量是否有显著影响。
* **总变异：** 反应全体数据误差大小的平方和，用总离均差平方和$SS_T$表示：$SS_T = \sum_{i=1}^{g}\sum_{j=1}^{n_i}(X_{ij}-\bar{X})^2$
* **组间变异：** 反映处理因素的作用以及随机误差作用，用组间离均差平方和$SS_A$：$SS_A = \sum_{i=1}^{g}\sum_{j=1}^{n_i}(\bar{X_i}-\bar{X})^2$
* **组内变异：** 主要反映随机误差作用，用组内离均差平方和$SS_A$：$SS_E = \sum_{i=1}^{g}\sum_{j=1}^{n_i}(X_{ij}-\bar{X_i})^2$
* **关系：** $SS_T = SS_A + SS_E$，$df_T = df_A + df_E$，$df_T=N-1,df_A=g-1,df_E=N-g$
* **均方差：** $MS_A = \frac{SS_A}{df_A}, MS_E = \frac{SS_E}{df_E}$
* **统计量：** $F = \frac{MS_A}{MS_E}$，如果自变量对因变量没有影响，那么组间误差将值包含随机误差，F值接近于1；否则，F值会大于1。
* **判断系数：** $R^2 = \frac{SS_A}{SS_T}$，用于测量自变量与因变量之间的关系强度。
* **基本假定：** 每个总体都服从正态分布/各观测值互相独立/各组观察数据都是从相同方差的正态总体中抽取的(方差齐性)。

### [单因素方差分析](#目录)

$\frac{SS_E}{\sigma^2}$ ~ $\chi_{n-r}^{2}$, $\frac{SS_A}{\sigma^2}$ ~ $\chi_{r-1}^{2}$,
$F = \frac{MS_A}{MS_A} = \frac{SS_A/(r-1)}{SS_E/(n-r)}$ ~ $F(r-1,n-r)$

```R
X <- c(4.2, 3.3, 3.7, 4.3, 4.1, 3.3, 4.5, 4.4, 3.5, 4.2, 4.6, 4.2, 5.6, 3.6, 4.5, 5.1, 4.9, 4.7)
A <- factor(rep(1:3, each=6))
my.data <- data.frame(X, A)
my.aov <- aov(X~A, data = my.data)
summary(my.aov)
```

### [双因素方差分析](#目录)

**1. 无交互作用的分析**

先将受试对象配成区组，再将各区组内的受试对象随机分配到不同的处理组，各处理组分别接受不同的处理，实验结束后比较各组均值之间差别有误统计学意义。

* **总变异：** $SS_T = \sum_{i=1}^{r}\sum_{j=1}^{k}(x_{ij}-\bar{x})^2 = SS_A+SS_B+SS_E$
* **处理组间变异：** $SS_A = \sum_{i=1}^{r}\sum_{j=1}^{k}(\bar{x_i}-\bar{x})^2$
* **区块组间变异：** $SS_B = \sum_{i=1}^{r}\sum_{j=1}^{k}(\bar{x_j}-\bar{x})^2$
* **随机误差：** $SS_E = \sum_{i=1}^{r}\sum_{j=1}^{k}(x_{ij}-\bar{x_i}-\bar{x_j}-\bar{x})^2$
* **均方差：** $MS_A = \frac{SS_A}{r-1}, MS_B = \frac{SS_B}{k-1}, MS_E = \frac{SS_E}{(r-1)(k-1)}$
* **F统计量：** $F_A = \frac{MS_A}{MS_E}$ ~ $F(r-1,(r-1)(n-1))$, $F_B = \frac{MS_B}{MS_E}$ ~ $F(N-1,(r-1)(n-1))$

```R
x <- c(64, 65, 73, 53, 54, 59, 71, 68, 79, 41, 46, 38, 50, 58, 65, 42, 40, 46)
my.data <- data.frame(x, A = gl(6, 3), B = gl(3, 1, 18))

my.aov <- aov(x ~ A+B, data = my.data)
summary(my.aov)
```

**2. 有交互作用的分析**

* **总变异：** $SS_T = \sum_{i=1}^{r}\sum_{j=1}^{s}\sum_{k=1}^{t}(x_{ijk}-\bar{x})^2 = SS_A+SS_A+SS_E+SS_{A\times{B}}$
* **因素A变异：** $SS_A = rt\sum_{j=1}^{s}(\bar{x_j}-\bar{x})^2$
* **因素B变异：** $SS_B = st\sum_{i=1}^{r}(\bar{x_i}-\bar{x})^2$
* **交互变异：** $SS_{A\times{B}} = t\sum_{i=1}^{r}\sum_{j=1}^{s}(\bar{x_{ij}}-\bar{x_i}-\bar{x_j}+\bar{x})^2$
* **随机误差：** $SS_E = \sum_{i=1}^{r}\sum_{j=1}^{s}\sum_{k=1}^{t}(x_{ijk}-\bar{x_{ij}}-\bar{x_i}-\bar{x_j}-\bar{x})^2 $
* **F统计量：** $F_A = \frac{MS_A}{MS_E} = \frac{SS_A/(r-1)}{SS_E/[rs(t-1)]}$ ~ $F(r-1,rs(t-1))$,  
$F_B = \frac{MS_B}{MS_E} = \frac{SS_B/(s-1)}{SS_E/[rs(t-1)]}$ ~ $F(s-1,rs(t-1))$,
$F_{A\times{B}} = \frac{MS_{A\times{B}}}{MS_E} = \frac{SS_{A\times{B}}/(r-1)(s-1)}{SS_E/[rs(t-1)]}$ ~ $F((r-1)(s-1),rs(t-1))$

```R
#e.g. 是否添加增味剂和乳清用量对蛋糕口感的影响
 # 输入数据
 pancakes <- data.frame(supp = rep(c("no supplement", "supplement"), each = 12), whey = rep(rep(c("0%", "10%", "20%", "30%"), each = 3), 2), quality = c(4.4, 4.5, 4.3, 4.6, 4.5, 4.8, 4.5, 4.8, 4.8, 4.6, 4.7, 5.1, 3.3, 3.2, 3.1, 3.8, 3.7, 3.6, 5, 5.3, 4.8, 5.4, 5.6, 5.3))

 # 制成表格
 round(tapply(pancakes$quality, pancakes[, 1:2], mean), 2)

 # 绘制交互作用图
 library(stats)
 interaction.plot(pancakes$whey, pancakes$supp, pancakes$quality)

 # 借助lm()执行有交互的双因素方差分析
 pancakes.lm <- lm(quality ~ supp * whey, data = pancakes)
 anova(pancakes.lm)

 my.aov <- aov(quality ~ supp * whey, data = pancakes)
 summary(my.aov) # 与上述的代码功能一致
```

### [多重比较](#目录)

要得到各组均值间更详细的信息，需要在方差分析的基础上进行多个样本均值的两两比较，此方法称为**多重比较法**。  
Bonferroni修正法的思路：如果在同一数据集同时进行n个独立的假设检验，那么用于每一个假设的统计显著水平应该为仅检验一个假设时显著水平的1/n，**即$\alpha' = \alpha/n$, n是多重t检验的次数**。

**1. 多重t检验**

多重t检验是对每个处理下的数据均值进行两两比较的t检验。多次重复使用t检验时会增大犯第一类错误的概率，因此在进行较多次重复比较时，要对**P值进行调整**。

```R
p.adjust.method # 输出P修正的方法
pairwise.t.test() # 执行均值的多重t检验
 -x # 响应向量
 -g # 因子向量
 -p.adjust.method # P值修正方法
 -alternative
 -paired

 X <- c(4.2, 3.3, 3.7, 4.3, 4.1, 3.3, 4.5, 4.4, 3.5, 4.2, 4.6, 4.2, 5.6, 3.6, 4.5, 5.1, 4.9, 4.7)
 A <- factor(rep(1:3, each=6))
 pairwise.t.test(X,A,p.adjust.method = "bonferroni")
```

**2. Dunnett检验**

Dunnett检验法是一种与对照组进行多重比较的方法。当进行多个实验组与一个对照组均值差别的多重比较，统计量定义为：$t_D = \frac{|\bar{X_i}-\bar{X_c}|}{\sqrt{MSE(\frac{1}{n_i} + \frac{1}{n_c}}}$  
其中，$\bar{X_i}-\bar{X_c}$表示每个处理的均值与对照组均值之差，$n_i$是每个处理的样本容量，$n_c$是对照组的样本容量，MSE是残差均方（均方误差）。

```R
X <- c(4.2, 3.3, 3.7, 4.3, 4.1, 3.3, 4.5, 4.4, 3.5, 4.2, 4.6, 4.2, 5.6, 3.6, 4.5, 5.1, 4.9, 4.7)
group <- factor(rep(LETTERS[1:3], each=6))
mice.data <- data.frame(X, group)
mice.aov <- aov(X~group, data = mice.data)
mice.mean <- round(tapply(mice.data[,1], mice.data[,2], mean), 3)
mice.MSE = summary(mice.aov)[[1]]$`Mean Sq`[2]
(tBD = abs(mice.mean['A']-mice.mean['B'])/sqrt(mice.MSE*(1/6+1/6)))
(tCD = abs(mice.mean['A']-mice.mean['C'])/sqrt(mice.MSE*(1/6+1/6)))

glht() # 用该函数完成Dunnett检验
library(multcomp)
mice.Dunnett <- glht(mice.aov, linfct=mcp(group = "Dunnett"))
summary(mice.Dunnett)

# 可视化
windows(width=5,height=3,pointsize=10)
plot(mice.Dunnett,sub="Mice Data")
mtext("Dunnet's Method",side=3,line=0.5)
```

**3. Tukey的HSD检验**

该方法为了控制每一对比较的错误率。

在进行检验时，首先对g个样本均值进行排序。如果$|\bar{X_i}-\bar{X_j}| \ge W$，则连个总体均值$\mu_i$和$\mu_j$不相等，其中：$W = q_\alpha(g,v)\sqrt{MSE/n}$。  
MSE是自由度为v的样本组内均方差，$q_\alpha(g,v)$是比较g个不同总体是学生化极差的上侧尾部临界值，n是每个样本的观察值个数。

```R
X <- c(4.2, 3.3, 3.7, 4.3, 4.1, 3.3, 4.5, 4.4, 3.5, 4.2, 4.6, 4.2, 5.6, 3.6, 4.5, 5.1, 4.9, 4.7)
group <- factor(rep(LETTERS[1:3], each=6))
mice.data <- data.frame(X, group)
mice.aov <- aov(X~group, data = mice.data)

mice.mean <- round(tapply(mice.data[,1], mice.data[,2], mean), 3)
n <- length(mice.mean)
mice.diff <- matrix(rep(mice.mean,times = n), nrow = n, byrow = T)
colnames(mice.diff) <- LETTERS[1:n]
rownames(mice.diff) <- LETTERS[1:n]
for (i in c(1:n)){
  mice.diff[i,] <- mice.diff[i,] - mice.mean[i]
}

mice.MSE = summary(mice.aov)[[1]]$`Mean Sq`[2]
q <- qtukey(0.05, 3, 15, lower.tail = F)
W <- q*sqrt(mice.MSE/6)
mice.which <- which(mice.diff > W, arr.ind = T)

result <- data.frame(NULL)
for (i in c(1,dim(mice.which)[1])){
  result[i,1] <- paste(LETTERS[mice.which[i,1]],LETTERS[mice.which[i,2]], sep = '-')
  result[i,2] <- mice.diff[mice.which[i,1],mice.which[i,2]]
}
colnames(result) <- c('groups', 'value')
result

(posthoc <- TukeyHSD(mice.aov, 'group'))
```
