# Written by Xiuxia Du.
# Started in March 2015.


graphics.off()
rm(list=ls())



file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"
in_file_name <- "col-0_1.mzXML"



code_path <- getwd()




function_file_name <- paste(code_path, "plotSpectra_gVis_function.R", sep=.Platform$file.sep)
source(function_file_name)


function_file_name <- paste(code_path, "create_spectrum_data_for_gVis.R", sep=.Platform$file.sep)
source(function_file_name)



scans <- 811:820
re <- plotSpectra_gVis_function(file_path=file_path, file_name=in_file_name, scans)