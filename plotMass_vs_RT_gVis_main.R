# Written by Xiuxia Du.
# Started in March 2015.


graphics.off()
rm(list=ls())



file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"
in_file_name <- "col-0_1.mzXML"



code_path <- getwd()




function_file_name <- paste(code_path, "plotMass_RT_gVis_function.R", sep=.Platform$file.sep)
source(function_file_name)




scans <- 500:520

re <- plotMass_RT_gVis_function(file_path=file_path, file_name=in_file_name, scans=scans, allScan=F)