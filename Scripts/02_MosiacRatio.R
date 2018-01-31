
rm(list = ls())

# 安装并加载XML程序包
no_lib <- try(library(XML),silent=TRUE)
if('try-error' %in% class(no_lib)){ 
  install.packages('XML')
  library(XML)
}
rm('no_lib')


#-----------------------------------------------------#

get.datasum <- function(data.sum){
  # 输入文件及样本的参数
  while(is.null(data.sum)){
    website.address <- readline("Please input the website address:\n")
    website.address.split <- unlist(strsplit(website.address,split = "/"))
    flowcell.name <- website.address.split[length(website.address.split)-2]
    machine.name <- unlist(strsplit(flowcell.name,split = "_"))[2]
    sample.name <- website.address.split[length(website.address.split)]
    
  # 判断本地或外地批次
    all_flowcell <- unlist(readHTMLList('http://***.**.*.**'))
    out_machine <- unlist(readHTMLList('http://***.**.*.**'))
    if(length(grep(flowcell.name,all_flowcell))){
      #本地
      sumtxt.address <- paste("http://***.**.*.**/",flowcell.name,"/",flowcell.name,".sum.txt",sep = "")
    }
    else if(grep(machine.name,out_machine)){
      #外地
      sumtxt.address <- paste("http://***.**.*.**/",machine.name,"/",flowcell.name,"/",flowcell.name,".sum.txt",sep = "")
    }
    else{
      stop('Not find the data!')
    }
      
  # 读取数据并修饰
    data.sum <- read.table(sumtxt.address,header = TRUE,as.is = TRUE,check.names = FALSE)
    # header设置为true，列名中%会变成.,check.names设置为FALSE，%不会变成.
    data.sum.Sample.split <- unlist(strsplit(data.sum$Sample,split = "_")) # 简化data.sum中Sample的名称
    data.sum$Sample <- data.sum.Sample.split[3*1:(length(data.sum.Sample.split)/3)]
  }
  
  return(list(data.sum, flowcell.name, sample.name))
}

#------------------------#

get.SandC <- function(sample.name, chr.number){
  
  count_err <- 0
  
 # 数据处理(读取样本和染色体号)
  while(is.null(sample.name)){
    sample.name <- readline("Please input sample name:\n")
  }
  while(length(grep(sample.name,data.sum$Sample)) !=  1){
    count_err <- count_err + 1
    if(count_err <= 10){
      sample.name <- readline("NOT FOUND or NOT ONLY ONE SAMPLE! Please input again:\n")
    }
    else{
      stop('over ten times of entering wrong sample name!\n
Maybe the sample does not belong to the flowcell')
    }
  }
  sample.name <- data.sum$Sample[grep(sample.name,data.sum$Sample)]
  
  options(warn = -1) # 输入为字符时，会有警告暂时将其关闭
  chr.number <- as.numeric(readline("Please input the chromosome number[Range:1~24,23(X),24(Y)]:\n"))
  
  error <- is.numeric(chr.number) && as.integer(chr.number) == chr.number && chr.number>= 1 && chr.number<= 24
  while(is.na(error) || !error){ 
    # is.na(error) || !error 有点小逻辑
    chr.number <- as.numeric(readline("ERROR! Please input an integar(1~24) again:\n"))
    error <- is.numeric(chr.number) && as.integer(chr.number) == chr.number && chr.number>= 1 && chr.number<= 24
  }
  options(warn = 0)
  
  return(list(sample.name, chr.number))
  
}

#------------------------#

MasiacRatio <- function(data.org,sample,chr){
  
  sample.pos <- grep(sample,data.org$Sample)
  while(length(sample.pos) !=  1){
    sample <- readline("NOT FOUND or NOT ONLY ONE! Please input again:\n")
    sample.pos <- grep(sample,data.org$Sample)
  }
  # sample.name <- data.org$Sample[sample.pos]


  while(!(as.integer(chr) == as.numeric(chr) && chr>= 1 && chr<= 24)){
    chr <- as.numeric(readline("ERROR! Please input again:\n"))
  }
  chr.col = paste("chr",chr,"%",sep = "")

  if(chr <= 22){
    chr.A.data <- data.org[-sample.pos,chr.col]
    chr.stats <- boxplot.stats(chr.A.data)
    # chr.stats <- quantile(chr.A.data) not better
    chr.valid <- which(chr.A.data >= chr.stats$stats[1] & chr.A.data <= chr.stats$stats[5])
    chr.mean <- mean(chr.A.data[chr.valid])
    chr.ratio <- (data.org[sample.pos,chr.col]-chr.mean)/chr.mean * 2
  }

  else if(chr == 23){
    chr.XY.data <- data.org[-sample.pos,c("chr23%","chr24%")]

    if(data.org[sample.pos,chr.col] >= 0.01){
      chr.Xmale.data <-chr.XY.data[chr.XY.data[,"chr24%"]>0.01,chr.col]
      chr.stats <- boxplot.stats(chr.Xmale.data)
      chr.valid <- which(chr.Xmale.data >= chr.stats$stats[1] & chr.Xmale.data <= chr.stats$stats[5])
      chr.mean <- mean(chr.Xmale.data[chr.valid])
      chr.ratio <- (data.org[sample.pos,chr.col]-chr.mean)/chr.mean
    }
    else{
      chr.Xfemale.data <-chr.XY.data[chr.XY.data[,"chr24%"]<=0.01,chr.col]
      chr.stats <- boxplot.stats(chr.Xfemale.data)
      chr.valid <- which(chr.Xfemale.data >= chr.stats$stats[1] & chr.Xfemale.data <= chr.stats$stats[5])
      chr.mean <- mean(chr.Xfemale.data[chr.valid])
      chr.ratio <- (data.org[sample.pos,chr.col]-chr.mean)/chr.mean*2
    }
  }

  else{
    chr.XY.data <- data.org[-sample.pos,c("chr23%","chr24%")]

    if(data.org[sample.pos,chr.col] >= 0.01){
      chr.Ymale.data <-chr.XY.data[chr.XY.data[,"chr24%"]>0.01,chr.col]
      chr.stats <- boxplot.stats(chr.Ymale.data)
      chr.valid <- which(chr.Ymale.data >= chr.stats$stats[1] & chr.Ymale.data <= chr.stats$stats[5])
      chr.mean <- mean(chr.Ymale.data[chr.valid])
      chr.ratio <- (data.org[sample.pos,chr.col]-chr.mean)/chr.mean
    }
    else{
      write("Are you kidding?", stdout())
    }
  }
  
  return(round(chr.ratio, 2))
}

#-----------------------------------------------------#

# 数据初始化
data.sum <- NULL
flowcell.name <- NULL
sample.name <- NULL
chr.number <- NULL
chr.ratio <- NULL
data.out <- data.frame(Sample = character(0), ChrNum = factor(NULL, levels = c(1:24)),
                       Ratio = numeric(0), flowcell = character(0), stringsAsFactors = F)

datasum.temp <-  get.datasum(data.sum)
data.sum <- datasum.temp[[1]]
flowcell.name <- datasum.temp[[2]]
sample.name <- datasum.temp[[3]]

SandC.temp <-  get.SandC(sample.name, chr.number)
sample.name <- SandC.temp[[1]]
chr.number <- SandC.temp[[2]]

chr.ratio <- round(MasiacRatio(data.sum, sample.name, chr.number), 2)

# 输出数据
data.out <- data.frame(sample.name, chr.number, chr.ratio, flowcell.name, stringsAsFactors = F)
names(data.out) <- c('Sample', 'ChrNum', 'Ratio', 'Flowcell')
write('\n',stdout())

# 后续操作
input <- NULL
while(is.null(input)){
  input <- readline("* No more operations: input 'q'or'Q'
* Calculate another chromosome(same sample): input 1~24,23(X),24(Y)
* Calculate another sample: sample name\n")
  write('\n',stdout())
  
  options(warn = -1)
  info = is.na(as.numeric(input)) || !(as.integer(input) == as.numeric(input) && as.numeric(input)>= 1 && as.numeric(input)<= 24)
  if(input == 'q' || input == 'Q'){
    show(data.out)
  }
  
  else if(info){ #如果非数值，as.numeric(input)为NA
    stderr()
    sample.name <- input 
    SandC.temp <-  get.SandC(sample.name, chr.number)
    sample.name <- SandC.temp[[1]]
    chr.number <- SandC.temp[[2]]
    chr.ratio <- MasiacRatio(data.sum, sample.name, chr.number)
    data.out <- rbind(data.out, c(sample.name, chr.number, chr.ratio, flowcell.name))
    input <- NULL
  }
  
  else{
    chr.number <- as.integer(input)
    chr.ratio <- MasiacRatio(data.sum, sample.name, chr.number)
    data.out <- rbind(data.out, c(sample.name, chr.number, chr.ratio, flowcell.name))
    input <- NULL
  }
  options(warn = 0)
}


# 删除无用数据
rm(list = c('datasum.temp', 'SandC.temp', 'input', 'info', 
            'chr.number', 'chr.ratio', 'flowcell.name', 'sample.name'))


