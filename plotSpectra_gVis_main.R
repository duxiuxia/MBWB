# Written by Xiuxia Du.
# Started in March 2015.


graphics.off()
rm(list=ls())



file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"
in_file_name <- "D_C12_10SPLIT_1.CDF"





library(googleVis)




code_path <- "/Users/xdu4/Documents/Duxiuxia/myGitHub/MBWB"
setwd(code_path)




function_file_name <- paste(code_path, "plotSpectra_gVis_function.R", sep=.Platform$file.sep)
source(function_file_name)



scans <- 500:700
re <- plotSpectra_gVis_function(file_path=file_path, file_name=in_file_name, scans)



