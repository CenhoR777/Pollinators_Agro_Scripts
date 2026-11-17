##Extract Fragmentation Variables ORIGINAL LAYERS separated in small landscapes 
# with the moddelling environment tools because they were too big and took long to run.

library(raster)
library(SDMTools)

setwd("/home/saraema/MEOCloud/10_Niche_Modelling/SDM_analyses/landuse_vars_100m/by_tile/")

raslist<-Sys.glob("*.tif")# LIST THE RASTERS
for(i in 1:length(raslist)){
  ras<-raster(raslist[i])
  b<-ClassStat(ras,100)
  if(is.null(b)==FALSE) {
    byclass<-subset(b, class == "36")
      if(nrow(byclass) == 0){
      byclass[1,(1:38)] = -3.4e+38 #code for "no data"; depois na tabela achei melhor substituir por zero
      }
    filename<-as.character(names(ras))
    byclass$landscape<-filename		#CAPTURE THE LANDSCAPE NUMBER I THE ROW
    byclass<-byclass[,c(4,39)]	#EXTRACT ONLY IMPORTANT COLUMNS
    coords<-as.data.frame(c(xmax(ras)+xmin(ras), ymax(ras)+ymin(ras))/2)
    byclass$longitude<-coords[1,]
    byclass$latitude<-coords[2,]
    write.table(byclass,paste(filename,".txt"))
    print(paste("tif",i,"on", length(raslist)))
  }
}

#PUT ALL LANDSCAPES (TABLES) TOGETHER
tablist<-Sys.glob("*.txt")
full_lgn<-do.call("rbind", lapply(tablist, read.table, header = TRUE))
write.table(full_lgn,"Prop_of_class_36.txt")



