# This function plots the mass-vs-retention time map of MS data.

# The function returns the total number of scans displayed on the map

# Written by Xiuxia Du in February 2015.




plotMass_RT_gVis_function <- function(file_path, file_name, scans, allScan) {
    
    if( !is.element("googleVis", installed.packages()[,1]) )
        install.packages("googleVis")
    
    library(googleVis)
    
    
    in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
    
    ind_CDF <- regexpr(".CDF", file_name, ignore.case=T)
    ind_mzXML <- regexpr(".mzXML", file_name, ignore.case=T)
#     file_extension <- substr(in_file_name, start=ind, stop=nchar(in_file_name))
#     grepl(".CDF", file_extension)


    if (ind_CDF != -1) {
        cat("Processing a .CDF file ......")
        
        library(ncdf)
        
        
        ncid <- open.ncdf(in_file_full_name)
        #   print(ncid)
        
        point_count <- get.var.ncdf(ncid, "point_count")
        scan_acquisition_time <- get.var.ncdf(ncid, "scan_acquisition_time") 
        mass_values <- get.var.ncdf(ncid, "mass_values")
        intensity_values <- get.var.ncdf(ncid, "intensity_values")
        
        scan_count <- length(point_count)
        
        if (allScan) {
            scans <- 1:scan_count
        } else {
            scans <- sort(scans)
        }
        
        close.ncdf(ncid)
        
        part_acquisition_time_values <- numeric(0)
        part_mass_values <- numeric(0)
        for (i in scans) {

            point_start <- sum(point_count[1:i-1]) + 1
            point_end <- sum(point_count[1:i])
            
            current_scan_acquisition_time <- scan_acquisition_time[i]
            
            part_acquisition_time_values<- c(part_acquisition_time_values, rep(current_scan_acquisition_time, point_count[i]))
            
            part_mass_values <- c(part_mass_values, mass_values[point_start:point_end])
            
        } 
        
        data_for_gVis <- data.frame(x=part_acquisition_time_values, y=part_mass_values)
        
        object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                            options=list(
                                                explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.0000001}",
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
        plot(object_for_gVis)
        
        return(scan_count)
        
    } else {
        
        cat("Processing a .mzXML file ......")
            
        library("readMzXmlData")
        
        re <- readMzXmlFile(in_file_full_name)
        
#         plot TIC
        scan_acquisition_time <- vector(mode="numeric", length=length(re))
        totalIonCurrent <- vector(mode="numeric", length=length(re))
        for (i in 1:length(re)) {
            scan_acquisition_time <- c(scan_acquisition_time, re[[i]]$metaData$retentionTime)
            totalIonCurrent <- c(totalIonCurrent, sum(re[[i]]$spectrum$intensity))
        }
        
        data_for_gVis <- data.frame(x=scan_acquisition_time, y=totalIonCurrent)
        
        object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                    options=list(
                                        explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.0000001}",
                                        chartArea="{width:'85%',height:'80%'}",
                                        tooltip="{isHtml: 'True'}",              
                                        crosshair="{trigger: 'both'}",                         
                                        legend="none", 
                                        lineWidth=1, pointSize=0, 
                                        title=paste("TIC"),
                                        vAxis="{title: 'intensity', gridlines: {color: 'transparent'}}",                        
                                        hAxis="{title: 'RT', gridlines: {color: 'transparent'}}",                     
                                        width=750, height=500
                                    )
        ) 

        plot(object_for_gVis)
        

#         plot mass vs RT map
        part_acquisition_time_values <- numeric(0)
        part_mass_values <- numeric(0)
        
        for (i in scans) {
            current_scan_acquisition_time <- re[[i]]$metaData$retentionTime
            current_mass <- re[[i]]$spectrum$mass
            current_intensity <- re[[i]]$spectrum$intensity
            
            part_acquisition_time_values<- c(part_acquisition_time_values, rep(current_scan_acquisition_time, length(current_mass)))
            part_mass_values <- c(part_mass_values, current_mass)
        }
        
        data_for_gVis <- data.frame(x=part_acquisition_time_values, y=part_mass_values)
        
        object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                            options=list(
                                                explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.0000001}",
                                                chartArea="{width:'85%',height:'80%'}",
                                                tooltip="{isHtml: 'True'}",              
                                                crosshair="{trigger: 'both'}",                         
                                                legend="none", 
                                                lineWidth=0, pointSize=0.5, 
                                                # title=paste("scan = ", i),
                                                vAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                        
                                                hAxis="{title: 'RT', gridlines: {color: 'transparent'}}",                     
                                                width=750, height=500
                                            )
        ) 
        
        plot(object_for_gVis)
        
        return(1)
    }       
}