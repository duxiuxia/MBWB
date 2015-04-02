# Written by Xiuxia Du.
# Started in March 2015.


graphics.off()
rm(list=ls())



file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"
in_file_name <- "SD_08292013_Weiss_Ret_Pos_08262013_D401.CDF"



code_path <- "/Users/xdu4/Documents/Duxiuxia/myGitHub/MBWB"
setwd(code_path)




function_file_name <- paste(code_path, "plotSpectra_gVis_function.R", sep=.Platform$file.sep)
source(function_file_name)



scans <- 801:802
re <- plotSpectra_gVis_function(file_path=file_path, file_name=in_file_name, scans)