# 概率与统计

[>>返回R学习笔记主页!](https://github.com/Happykelee/the-Study-of-R)


## 目录

* [基础](#基础)
  * [概率分布模型](#概率分布模型)
  * [统计推断](#统计推断)
    * [参数估计](#参数估计)
    * [参数假设检验](#参数假设检验)
    * [非参数假设检验](#非参数假设检验)
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

### [统计推断](#目录)


|Tables             |genres                       |
|:-----------------:|:---------------------------:|
|[参数估计](#参数估计)|点估计：矩方法/极大似然估计    |
|                   |区间估计                      |
|假设检验            |[参数假设检验](#参数建假设检验)|
|                   |[非参数假设检验](#非参数假设检验)|

#### 参数估计

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

#### 参数假设检验

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

#### 非参数假设检验

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
* **核心思想：** 分析数据中正负号出现的频率，并确定它们是否有显著差异
* 以**二项分布**为基础的一种假设检验；当n大于25时，近似认为结果分布服从正态N(0,1)分布。
