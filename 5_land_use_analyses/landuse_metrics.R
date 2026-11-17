##Extract Fragmentation Variables ORIGINAL LAYERS separated in small landscapes 
# with the moddelling environment tools because they were too big and took long to run.

library(raster)
library(SDMTools)

setwd("/home/saraema/MEOCloud/10_Niche_Modelling/SDM_analyses/by_tile/")

raslist<-Sys.glob("*.tif")# LIST THE RASTERS
for(i in 1:length(raslist)){
  ras<-raster(raslist[i])
#  is.not.null <- function(ras) ! is.null(ras)
#  if(is.null(ras)==FALSE)
  b<-ClassStat(ras,100)
  if(is.null(b)==FALSE) {
    b$NumClasses_J<-sum(as.numeric(b[,1]!=-3.4e+38))#CALCULATE NUMBER OF CLASSES TAKING -3.4e+38 (NODATA) AWAY
    b$ED_total_J<-sum(as.numeric(b[b$class!=-3.4e+38,7]))#SUM ED (SUM ED OF DIFFERENT CLASSES)
    b$Area_total_J<-mean(as.numeric(b[b$class!=-3.4e+38,3]))
    filename<-as.character(names(ras))
    b$landscape<-filename		#CAPTURE THE LANDSCAPE NUMBER I THE ROW
    b<-b[1,c(39:42)]	#EXTRACT ONLY IMPORTANT COLUMNS
    coords<-as.data.frame(c(xmax(ras)+xmin(ras), ymax(ras)+ymin(ras))/2)
    b$longitude<-coords[1,]
    b$latitude<-coords[2,]
    write.table(b,paste(filename,".txt"))
    print(paste("tif",i,"on", length(raslist)))
  }
 }

#PUT ALL LANDSCAPES (TABLES) TOGETHER
tablist<-Sys.glob("*.txt")
full_lgn<-do.call("rbind", lapply(tablist, read.table, header = TRUE))
write.table(full_lgn,"Full_frag_table.txt")

#If you have differen time periods that would like to compare then repeat 
#the processes above for all time periods and then do the next :

#MERGE all Tables: Here the terminations "_00" for example refers to year 1900, "_60" to 1960 etc
#t1<-read.table("1.1Full_frag_table_00.txt")
#t2<-read.table("1.2Full_frag_table_60.txt")
#t3<-read.table("1.3Full_frag_table_1980.txt",head=T) 
#t4<-read.table("1.4Full_frag_table_LGN6.txt")
#t5<-read.table("2.1Full_ManNat_table_00.txt")
#t6<-read.table("2.2Full_ManNat_table_60.txt")
#t7<-read.table("2.3Full_ManNat_table_1980.txt",head=T)
#t8<-read.table("2.4Full_ManNat_table_LGN.txt")

#m1=merge(t1,t2,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m2=merge(m1,t3,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m3=merge(m2,t4,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m4=merge(m3,t5,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m5=merge(m4,t6,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m6=merge(m5,t7,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)
#m7=merge(m6,t8,by.x="landscape1",by.y="landscape1",all.x=T,all.y=T)

#write.table(m7,"Fragmentation_Final.txt",sep=",")

