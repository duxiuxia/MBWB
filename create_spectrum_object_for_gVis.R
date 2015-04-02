# Create data object for gVis

# Written by Xiuxia Du in April 2015.



create_spectrum_object_for_gVis <- function(x, y) {
    x <- as.numeric(x)
    y <- as.numeric(y)
    
    x <- rbind(x, x, x)
    x <- as.vector(x)
    
    y1 <- rbind(rep(0, length(y)), y[1:length(y)], rep(0, length(y)))
    
    
    y1 <- as.vector(y1)
    
    data_for_gVis <- data.frame(x=x, y=y1)
    
    object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                        options=list(
                                            explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.05}",
                                            # chartArea="{width:'85%',height:'80%'}",
                                            tooltip="{isHtml: 'True'}",              
                                            crosshair="{trigger: 'both'}",                         
                                            legend="none", 
                                            lineWidth=1, pointSize=0, 
#                                             title=paste("scan = ", i),
                                            vAxis="{title: 'intensity', gridlines: {color: 'transparent'}}",                        
                                            hAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                     
                                            width=750, height=500
                                        )
    )  
    
    return(object_for_gVis)
}

