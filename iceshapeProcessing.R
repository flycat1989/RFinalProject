library(rnoaa)
library(stringr)
urls = seaiceeurls(pole = "N")
urls=urls[-which(grepl("198801",urls))]
urls=urls[-which(grepl("198712",urls))]
url_adj_id=which(grepl("2013010",urls))
urls[url_adj_id]=gsub("2013010","201310",urls[url_adj_id])
url_adj_id=which(grepl("2013011",urls))
urls[url_adj_id]=gsub("2013011","201311",urls[url_adj_id])
url_adj_id=which(grepl("2013012",urls))
urls[url_adj_id]=gsub("2013012","201312",urls[url_adj_id])

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
