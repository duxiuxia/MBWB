rm(list=ls())
graphics.off()



if( !is.element("googleVis", installed.packages()[,1]) )
  install.packages("googleVis")

library(googleVis)

x <- c(1,2,3,4,5,6,7,8,9)
y <- c(2,4,4,2,7,3,9,2,5)

x1 <- rbind(x, x, x)
x1 <- as.vector(x1)

y1 <- rbind(rep(0, length(y)), y, rep(0, length(y)))
y1 <- as.vector(y1)

d <- data.frame(x=x1, y=y1)

object_for_gVis <- gvisScatterChart(d,                                                           
                             options=list(
                               explorer="{actions: ['dragToZoom', 
                                          'rightClickToReset'],
                                           maxZoomIn:0.05}",
                               #chartArea="{width:'85%',height:'80%'}",
                               tooltip="{isHtml:'True'}",              
                               crosshair="{trigger:'both'}",                         
                               legend="none", lineWidth=2, pointSize=1,                                                     
                               vAxis="{title: 'intensity', 
                                  gridlines: {color: 'transparent'}}",                        
                               hAxis="{title: 'm/z',
                                  gridlines: {color: 'transparent'}}",                     
                               width=750, height=500))  

plot(object_for_gVis)







data_for_gVis <- data.frame(x=rnorm(10), y=rnorm(10))
object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                    options=list(
                                        explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.05}",
                                        chartArea="{width:'85%',height:'80%'}",
                                        tooltip="{isHtml: 'True'}",              
                                        crosshair="{trigger: 'both'}",                         
                                        legend="none", 
                                        lineWidth=2, pointSize=1,                                                     
                                        vAxis="{title: 'intensity', gridlines: {color: 'transparent'}}",                        
                                        hAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                     
                                        width=750, height=500
                                    )
)  
plot(object_for_gVis)

