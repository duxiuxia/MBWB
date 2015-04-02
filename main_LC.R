# main

# Written by Xiuxia Du in April 2015.




rm(list=ls())
graphics.off()




code_path <- getwd()
source(paste(code_path, "set_parameter.R", sep=.Platform$file.sep))




extractEIC(PARAMS)
