library(dplyr)
library(stringr)
library(Rcpp)

fileList=list.files("MortalityData")
fileList=fileList[grepl(".txt",fileList)]

mortData=data.frame()
for (i in seq_along(fileList)){
  targetFile=fileList[i]
  m=read.table(paste0("MortalityData/",targetFile), quote = "",sep="\t",header=FALSE,skip=9L,stringsAsFactors=FALSE)
  if(ncol(m)!=5){
    stop(paste0("There is a problem with ",targetFile,"!"))
  }

  mortData=rbind(mortData,m)
}
colnames(mortData)=c("County","Year","Deaths","Population","CrudeRate")


mortData$Deaths=gsub(",","",mortData$Deaths)
mortData$Population=gsub(",","",mortData$Population)
mortData$CrudeRate=gsub(",","",mortData$CrudeRate)

mortData$CrudeRate=str_replace(mortData$CrudeRate," \\(Unreliable\\)","")
mortData=mortData[-which(mortData$Year=="Total"),]
mortData=mortData[-which(mortData$County=="Total"),]

mortData$Deaths=as.numeric(mortData$Deaths)
mortData$Population=as.numeric(mortData$Population)
mortData$CrudeRate=as.numeric(mortData$CrudeRate)

sourceCpp("FillTable.cpp")
mortData$County=fillTableCpp(mortData$County)

mortData=arrange(mortData,Year)
save(mortData,file="mortDataV1.rda")
