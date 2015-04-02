# Create data object for gVis

# Written by Xiuxia Du in April 2015.



create_spectrum_data_for_gVis <- function(x, y) {
    
    x <- as.numeric(x)
    y <- as.numeric(y)
    
    x <- rbind(x, x, x)
    x <- as.vector(x)
    
    y1 <- rbind(rep(0, length(y)), y[1:length(y)], rep(0, length(y)))
    y1 <- as.vector(y1)
    
    data_for_gVis <- data.frame(x=x, y=y1)

    return(data_for_gVis)
}

