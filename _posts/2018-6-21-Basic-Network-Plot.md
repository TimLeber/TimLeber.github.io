---
layout: post
title: Basic Network Plot
---

One of the things that is useful to understand in analysis is to see how things are related to each other.
An easy way to visualize that is by creating a **Network Diagram**.  These can become very complicated with the 
addition of extra information, but at the core they are simply a visual representation of how two things are 
connected to each other and then to the larger assemblage.

I will use a very simple case of how the characters in [The Venture Bros](http://www.adultswim.com/videos/the-venture-bros/ "The Venture Bros") 
are related to each other.  I will then plot out the relationships and add a basic title to the plot.  This is 
coded using **R** and the **igraph** package.  The same package is available in _Python_.

The program has three basic steps:
1. Load The DATA
2. Transform the DATA into a plot
3. Render the plot.

## DATA

The data for this plot is a simple TeamVenture.csv file which can be found in the files section of this blog.  
It consists of three columns, **Node1**, **Node2**, and **_Affiliation_**.  Affiliation is not used 
in this example.  The Nodes represent the vertices of the network, the dots if you will.  The relationship 
between the two given nodes is the edge.

| Node1               | Node2               | Affiliation          |
| ------------------- |:------------------- | :-------------------:|
|Dr. Rusty Venture    | Hank Venture        | Team Venture         |
|Dr. Rusty Venture    | Dean Venture        | Team Venture         |
|Dr. Rusty Venture    | HELPeR              | Team Venture         |
|Dr. Rusty Venture    | Sgt. Hatred         | Team Venture         |

## Code

The code for this process is pretty simple too.  I will also include TeamVentureCode.R in the files section.  But it 
is so simple all of it is included below.

```R
setwd("/Users/youruserid/Documents/R/");

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
```

That is the whole thing.  It just reads in the data file, creates an object to hold the plot data and then renders the plot.

## Output

After rendering the plot you will get something that looks like this:

![Go Team Venture!](/images/TeamVentureBasicNetworkPlot.png)

## Final Thoughts

I realize this is a pretty simplistic example.  But the main point of this is for me to figure out 
how to use markdown to write these blog posts, not to teach you something groundbreaking.