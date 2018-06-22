setwd("/Users/lebert/Documents/R/");

library(igraph);

venture<- read.csv("Data/TeamVenture.csv", header=TRUE, sep = ",");
tv=graph.data.frame(venture,directed=FALSE)
par(mai=c(0,0,1,0))

plot(tv,
layout=layout.fruchterman.reingold,
vertex.size=10,
vertex.label.cex=.6,
edge.arrow.size=.75,
main="Go Team Venture!")