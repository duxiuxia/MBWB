# This function plots the mass-vs-retention time map of MS data.

# The function returns the total number of scans displayed on the map

# Written by Xiuxia Du in February 2015.




plotMass_RT_map_gVis <- function(file_path, file_name, scans, allScan) {
    
    
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
            
            part_acquisition_time_values <- c(part_acquisition_time_values, rep(current_scan_acquisition_time, point_end-point_start+1))
            part_mass_values <- c(part_mass_values, mass_values[point_start:point_end])
        } 
        
        data_for_gVis <- data.frame(x=part_acquisition_time_values, y=part_mass_values)
        
        return(data_for_gVis)
    } else {
        cat("Processing a .mzXML file ......")
            
        return(1)
    }       
}

