# This function plots a sequence of spectra.

# Written by Xiuxia Du in February 2015. 



plotSpectra <- function(file_path, file_name, scans, zoom) {
    
    library(googleVis)
    
    in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
    
    ind_CDF <- regexpr(".CDF", file_name, ignore.case=T)
    ind_mzXML <- regexpr(".mzXML", file_name, ignore.case=T)
    
    if (ind_CDF != -1) {
        cat("Processing a cdf file ... \n")
        
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
            if (i <= scan_count){
                
                point_start <- sum(point_count[1:i-1])+1
                point_end <- sum(point_count[1:i])
                
                if (point_start != point_end){
                    current_scan_mass <- mass_values[point_start:point_end]
                    current_intensity_values <- intensity_values[point_start:point_end]
                    current_scan_time <- i * inter_scan_time[1]
                    
                    if (zoom == T) {
                        current_spectrum <- data.frame(mass=current_scan_mass, intensity=current_intensity_values)
                        
                        
                        Hist <- gvisHistogram(current_spectrum, options=list(
                            legend="{ position: 'top', maxLines: 2 }",
                            colors="['#5C3292', '#1A8763', '#871B47']",
                            width=400, height=360))
                        plot(Hist)
                        
                        
                        
                    } else {
                        main_title <- paste("scan = ", i)
                        plot(current_scan_mass, current_intensity_values, type="h", main=main_title, xlab="mass", ylab="intensity")
                    }
  
                }
                readline(prompt="")
            } else {
                error_message <- paste("Error: scan ", i, " out of range!")
                print(error_message)
                
                return(0)
            }
        }
        
        print("Done!")
        return(1)
        
    } else if (ind_mzXML != -1) {
        cat("Processing a mzXML file ...... \n")
        
        library("readMzXmlData")
        
        re <- readMzXmlFile(in_file_full_name)
        
        for (i in scans) {
            if (i <= length(re)) {
                main_title <- paste("scan = ", i, ", msLevel = ", re[[i]]$metaData$msLevel, sep="")
                
                if (re[[i]]$metaData$msLevel == 1) {
                    plot(re[[i]]$spectrum$mass, re[[i]]$spectrum$intensity, type="l", main=main_title, xlab="mass", ylab="intensity", xlim=c(120, 130))
                    
                    readline(prompt="")
                } else {
                    plot(re[[i]]$spectrum$mass, re[[i]]$spectrum$intensity, type="h", main=main_title, xlab="mass", ylab="intensity")
                    
                    readline(prompt="")
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