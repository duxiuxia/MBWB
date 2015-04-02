# Create an object for googleVis scatter plot.
# Written by Xiuxia Du in April 2015.


create_object_for_gVis <- function(x, y) {
    
    data_for_gVis <- data.frame(x=x, y=y)
    
    object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                        options=list(
                                            explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.05}",
                                            chartArea="{width:'85%',height:'80%'}",
                                            tooltip="{isHtml: 'True'}",              
                                            crosshair="{trigger: 'both'}",                         
                                            legend="none", 
                                            lineWidth=0, pointSize=2, 
                                            # title=paste("scan = ", i),
                                            vAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                        
                                            hAxis="{title: 'RT', gridlines: {color: 'transparent'}}",                     
                                            width=750, height=500
                                        )
    ) 
    return(object_for_gVis)
}