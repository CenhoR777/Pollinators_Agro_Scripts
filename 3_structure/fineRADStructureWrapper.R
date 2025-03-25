#! /bin/bash

args = commandArgs(trailingOnly = T)

if (length(args) != 3) {stop("VCF file, output directory , and FinestructureLibrary.R location must be provided!", call.=FALSE)}

vcfLocation = args[1]
outdir = args[2]
finestructureLib = args[3]

analysisName = tools::file_path_sans_ext(basename(vcfLocation))

hapsFile = paste0(outdir, '/', analysisName, '_haps.txt')
chunksFile = paste0(outdir, '/', analysisName, '_haps_chunks.out')
chunksMcmcFile = paste0(outdir, '/', analysisName, '_haps_chunks.mcmc.xml')
chunksMcmcTreeFile = paste0(outdir, '/', analysisName, '_haps_chunks.mcmcTree.xml')

source(finestructureLib)

# RUN RADPAINTER AND FINESTRUCTURE #############################################


system(paste0('RADpainter hapsFromVCF ', vcfLocation, ' > ', hapsFile))

system(paste0('RADpainter paint ', hapsFile))

system(paste0('finestructure -x 100000 -y 100000 -z 1000 ', chunksFile, ' ', chunksMcmcFile))

system(paste0('finestructure -m T -x 10000 ', chunksFile, ' ', chunksMcmcFile, ' ', chunksMcmcTreeFile))

# READ FINESTRUCTURE INPUT #####################################################
# Code adapted from https://github.com/millanek/fineRADstructure/blob/master/fineRADstructurePlot.R

maxIndv <- 10000
maxPop<-10000

## make some colours
some.colors<-MakeColorYRP() # these are yellow-red-purple
some.colorsEnd<-MakeColorYRP(final=c(0.2,0.2,0.2)) # as above, but with a dark grey final for capped values

###### READ IN THE CHUNKCOUNT FILE
dataraw<-as.matrix(read.table(chunksFile,row.names=1,header=T,skip=1)) # read in the pairwise coincidence 

###### READ IN THE MCMC FILES
mcmcxml<-xmlTreeParse(chunksMcmcFile) ## read into xml format
mcmcdata<-as.data.frame.myres(mcmcxml) ## convert this into a data frame

###### READ IN THE TREE FILES
treexml<-xmlTreeParse(chunksMcmcTreeFile) ## read the tree as xml format
ttree<-extractTree(treexml) ## extract the tree into ape's phylo format

## Reduce the amount of significant digits printed in the posteror assignment probabilities (numbers shown in the tree):
ttree$node.label[ttree$node.label!=""] <-format(as.numeric(ttree$node.label[ttree$node.label!=""]),digits=2)
# convert to dendrogram format
tdend<-myapetodend(ttree,factor=1)
## Now we work on the MAP state
mapstate<-extractValue(treexml,"Pop") # map state as a finestructure clustering
mapstatelist<-popAsList(mapstate) # .. and as a list of individuals in populations
popnames<-lapply(mapstatelist,NameSummary) # population names IN A REVERSIBLE FORMAT (I.E LOSSLESS)
## NOTE: if your population labels don't correspond to the format we used (NAME<number>) YOU MAY HAVE TROUBLE HERE. YOU MAY NEED TO RENAME THEM INTO THIS FORM AND DEFINE YOUR POPULATION NAMES IN popnamesplot BELOW
popnamesplot<-lapply(mapstatelist,NameMoreSummary) # a nicer summary of the populations
names(popnames)<-popnamesplot # for nicety only
names(popnamesplot)<-popnamesplot # for nicety only
popdend<-makemydend(tdend,mapstatelist) # use NameSummary to make popdend
popdend<-fixMidpointMembers(popdend) # needed for obscure dendrogram reasons
popdendclear<-makemydend(tdend,mapstatelist,"NameMoreSummary")# use NameMoreSummary to make popdend
popdendclear<-fixMidpointMembers(popdendclear) # needed for obscure dendrogram reasons


# PLOT #########################################################################
## Plot 1: COANCESTRY MATRIX
fullorder<-labels(tdend) # the order according to the tree
datamatrix<-dataraw[fullorder,fullorder] # reorder the data matrix

tmpmat<-datamatrix 
tmpmat[tmpmat>maxIndv]<-maxIndv #  # cap the heatmap
svg(file=paste0(outdir, "/", analysisName,"_SimpleCoancestry.svg"),height=25,width=25)
plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=some.colorsEnd,cex.axis=1.1,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=1.2))
dev.off()

## Plot 2: POPULATIONS AND COANCESTRY AVERAGES
popmeanmatrix<-getPopMeanMatrix(datamatrix,mapstatelist)

tmpmat<-popmeanmatrix
tmpmat[tmpmat>maxPop]<-maxPop # cap the heatmap
svg(file=paste0(outdir, "/", analysisName,"_PopAveragedCoancestry.svg"),height=25,width=25)
plotFinestructure(tmpmat,dimnames(tmpmat)[[1]],dend=tdend,cols=some.colorsEnd,cex.axis=1.1,edgePar=list(p.lwd=0,t.srt=90,t.off=-0.1,t.cex=1.2))
dev.off()

