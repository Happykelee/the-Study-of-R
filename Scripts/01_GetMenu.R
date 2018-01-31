
rm(list = ls())

# load packages of XML/xlsx
no_lib <- try(library(XML),silent=TRUE)
if('try-error' %in% class(no_lib)){ 
  install.packages('XML')
  library(XML)
}
no_lib <- try(library(xlsx),silent=TRUE)
if('try-error' %in% class(no_lib)){ 
  install.packages('xlsx')
  library(xlsx)
}


gurl <-  "http://www.dianping.com/shop/4657406/dishlist/p"
menu <- list()
for (i in c(1:48)){
  # 48 pages in all
  address <- paste(gurl,i,sep = "")
  raw <- readHTMLList(address,encoding = "UTF-8")
  raw <- raw[[2]]
  raw <- strsplit(raw, split = '\n')
  
  for (j in c(1:length(raw))){
    raw[[j]] <- raw[[j]][c(1:2,7)]
  }
  menu <-c(menu,raw)
}

menu <- t(as.data.frame(menu,col.names = c(1:length(menu)),row.names = c('菜名','推荐','价格')))
menu <-sub("\\s+","",menu) # trim

menu.name <- "menu"
no_lib <- try(write.xlsx(menu,paste(menu.name,".xls",sep = ""),row.names = F),silent=TRUE)
if('try-error' %in% class(no_lib)){ 
  menu.name <- paste(menu.name,"_new",sep = "")
  write.xlsx(menu,paste(menu.name,".xls",sep = ""),row.names = F)
}

