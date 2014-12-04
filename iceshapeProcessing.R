library(rnoaa)
library(stringr)
urls = seaiceeurls(pole = "N")
urls=urls[-which(grepl("198801",urls))]
iceData=data.frame(RecordDate=character(),long=double(),lat=double(),order=integer(),hole=logical(),piece=integer(),group=double(),id=integer())
for(i in 1:length(urls)){
    selected_url=urls[i]
    detect_date=str_extract(selected_url,"[0-9]{6}")
    fileName=paste0("extent_N_",detect_date,"_polygon.zip")
    if(fileName %in% list.files("Cache/Shapefiles")){
       print("File already exits! Moving to the next file")
      next
    }else{
      selected_shape=seaice(selected_url, storepath = "Cache/Shapefiles/")
      selected_shape=cbind(detect_date,selected_shape)
      iceData=rbind(iceData,selected_shape)
    }
    Sys.sleep(2)
}
save(iceData, file="iceData.rda")
