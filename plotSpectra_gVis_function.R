# This function plots a sequence of spectra.

# Written by Xiuxia Du in February 2015. 



plotSpectra_gVis_function <- function(file_path, file_name, scans) {
    
    if( !is.element("googleVis", installed.packages()[,1]) )
        install.packages("googleVis")
  
    library(googleVis)
    
    
    in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
    
    ind_CDF <- regexpr(".CDF", file_name, ignore.case=T)
    ind_mzXML <- regexpr(".mzXML", file_name, ignore.case=T)
    
    if (ind_CDF != -1) {
        cat("Processing a cdf file ... \n")
        
        if( !is.element("ncdf", installed.packages()[,1]) )
            install.packages("ncdf")
        
        library(ncdf)
        

        
        in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
        
        
        
        ncid <- open.ncdf(in_file_full_name)
        #     print(ncid)
        
        point_count <- get.var.ncdf(ncid, "point_count")
        mass_values <- get.var.ncdf(ncid, "mass_values")
        intensity_values <- get.var.ncdf(ncid, "intensity_values")
        inter_scan_time <- get.var.ncdf(ncid, "inter_scan_time")
        
        scan_count <- length(point_count)
        
        
        
        close.ncdf(ncid)
        
        
        
        for (i in scans) {
            if (i <= scan_count) {
                
                point_start <- sum(point_count[1:i-1])+1
                point_end <- sum(point_count[1:i])
                
                if (point_start != point_end) {
                    current_scan_mass <- mass_values[point_start:point_end]
                    current_intensity_values <- intensity_values[point_start:point_end]
                    current_scan_time <- i * inter_scan_time[1]
                    
                    main_title <- paste("scan = ", i)
                    plot(current_scan_mass, current_intensity_values, type="h", xlim=c(354, 370), ylim=c(0, 20000), main=main_title)
                    
                    
                    current_scan_mass <- as.numeric(current_scan_mass)
                    current_intensity_values <- as.numeric(current_intensity_values)
                    
                    current_scan_mass <- rbind(current_scan_mass, current_scan_mass, current_scan_mass)
                    current_scan_mass <- as.vector(current_scan_mass)
                    
                    current_intensity_values1 <- rbind(rep(0, length(current_intensity_values)), 
                                                       current_intensity_values[1:length(current_intensity_values)],
                                                       rep(0, length(current_intensity_values)))
            
                    
                    current_intensity_values1 <- as.vector(current_intensity_values1)
                    
                    
                    data_for_gVis <- data.frame(x=current_scan_mass, y=current_intensity_values1)
                    
                    
                    object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                                        options=list(
                                                            explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.00000001}",
                                                            # chartArea="{width:'85%',height:'80%'}",
                                                            tooltip="{isHtml: 'True'}",              
                                                            crosshair="{trigger: 'both'}",                         
                                                            legend="none", 
                                                            lineWidth=1, pointSize=1, 
                                                            title=paste("scan = ", i),
                                                            vAxis="{title: 'intensity', gridlines: {color: 'transparent'}}",                        
                                                            hAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                     
                                                            width=750, height=500
                                                            )
                                                        )  
                    
                    
                    plot(object_for_gVis)
  
                } # if (point_start != point_end)
                
                readline(prompt="")
                
            } else {
                error_message <- paste("Error: scan ", i, " out of range!")
                print(error_message)
                
                return(0)
            } # end if (i <= scan_count)
        } # for (i in scans)
        
        print("Done!")
        return(1)
        
    } else if (ind_mzXML != -1) {
        cat("Processing a mzXML file ...... \n")
        
        library("readMzXmlData")
        
        re <- readMzXmlFile(in_file_full_name)
        
        for (i in scans) {
            if (i <= length(re)) {
                main_title <- paste("scan = ", i, ", msLevel = ", re[[i]]$metaData$msLevel, sep="")
                
                if (re[[i]]$metaData$centroided == 0) {
                    
                    
                    
#                     pdf(paste("/Users/xdu4/Downloads", figure_name, sep="")
#                         
#                     plot(re[[i]]$spectrum$mass, re[[i]]$spectrum$intensity, type="l", 
#                          main=main_title, xlab="mass", ylab="intensity", 
#                          xlim=c(120, 130))
#                     
#                     dev.off()
                    
#                     readline(prompt="")
                } else {
                    
                    figure_name <- paste("level_6_scan_", i, "_msLevel_", re[[i]]$metaData$msLevel, ".pdf", sep="")
                    
                    pdf(paste("/Users/xdu4/Downloads", figure_name, sep=.Platform$file.sep))
                        
                    plot(re[[i]]$spectrum$mass, re[[i]]$spectrum$intensity, type="h", 
                             main=main_title, xlab="mass", ylab="intensity", 
                             xlim=c(448, 452), ylim=c(0, 1500))
                        
                    dev.off()
                    
                    plot(re[[i]]$spectrum$mass, re[[i]]$spectrum$intensity, type="h", main=main_title, xlab="mass", ylab="intensity")
                    
                    data_for_gVis <- create_spectrum_data_for_gVis(x=re[[i]]$spectrum$mass, y=re[[i]]$spectrum$intensity)
                    
                    object_for_gVis <- gvisScatterChart(data_for_gVis, 
                                                        options=list(
                                                            explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn: 0.00000005}",
                                                            chartArea="{width:'85%',height:'80%'}",
                                                            tooltip="{isHtml: 'True'}",              
                                                            crosshair="{trigger: 'both'}",                         
                                                            legend="none", 
                                                            lineWidth=1, pointSize=0, 
                                                            title=paste("scan = ", i),
                                                            vAxis="{title: 'intensity', gridlines: {color: 'transparent'}}",                        
                                                            hAxis="{title: 'm/z', gridlines: {color: 'transparent'}}",                     
                                                            width=750, height=500
                                                        )
                    )  
                    
                    plot(object_for_gVis)
                    
#                     readline(prompt="")
                }

            } else {
                error_message <- paste("Error: scan ", i, " out of range!")
                cat(error_message)
                
                return(0)
            }
        }
        
        print ("Done!")
        
        return(1)
        
    } else {
        cat("Error: unknown file format!")
        
        return(0)
    }
}
