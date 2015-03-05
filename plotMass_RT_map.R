# This function plots the mass-vs-retention time map of MS data.

# The function returns the total number of scans displayed on the map

# Written by Xiuxia Du in February 2015.




plotMass_RT_map <- function(file_path, file_name, scans, allScan) {
    
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
        
        for (i in scans) {
            if (i==min(scans)){
                point_start <- sum(point_count[1:i-1]) + 1
                point_end <- sum(point_count[1:i])
                
                if (point_start != point_end) {
                    current_scan_acquisition_time <- scan_acquisition_time[i]
                    current_scan_mass <- mass_values[point_start:point_end]
                    current_intensity_values <- intensity_values[point_start:point_end]
                    
                    plot(rep(current_scan_acquisition_time, point_count[i]), current_scan_mass, pch=16, cex=.4, xlim=c(0, max(scan_acquisition_time)), ylim=c(min(mass_values)-1, max(mass_values)+1), main=file_name, xlab="RT", ylab="mass")
                    
                }
            }
            else {
                point_start <- sum(point_count[1:i-1])+1
                point_end <- sum(point_count[1:i])
                
                if (point_start != point_end){
                    current_scan_acquisition_time <- scan_acquisition_time[i]
                    current_scan_mass <- mass_values[point_start:point_end]
                    current_intensity_values <- intensity_values[point_start:point_end]
                    
                    points(rep(current_scan_acquisition_time, point_count[i]), current_scan_mass, pch=16, cex=.4)
                }
            }
        }
        return(scan_count)
        
    } else if (ind_mzXML != -1) {
        cat("Processing a mzXML file ......\n")
        
        library("readMzXmlData")
        
        re <- readMzXmlFile(in_file_full_name)
        
        if (allScan) {
            scans <- 1:length(re)
        } else {
            scans <- sort(scans)
        }
        
        count <- 0
        
        start_acquisition_time <- re[[scans[1]]]$metaData$retentionTime
        end_acquisition_time <- re[[scans[length(scans)]]]$metaData$retentionTime
        
        for (i in scans) {
            
            cat(i, "\n")
            
            spectrum_length <- length(re[[i]]$spectrum$mass)
                
            if (re[[i]]$metaData$msLevel == 1) {
                if (count == 0) {
                    
                    plot(rep(re[[i]]$metaData$retentionTime, spectrum_length), re[[i]]$spectrum$mass, 
                         pch=16, cex=.4, xlim=c(start_acquisition_time, end_acquisition_time), 
                         ylim=c(0, 2000), main=file_name, xlab="RT", ylab="mz")
                    
                    count <- count + 1
                    
                } else {
                    
                    points(rep(re[[i]]$metaData$retentionTime, spectrum_length), re[[i]]$spectrum$mass, pch=16, cex=.4)
                    count <- count + 1
                    
                }
            }
        }
        
        return(count)
        
    } else {
        cat("Error: unknown file format!")
        
        return(0)
    }
}