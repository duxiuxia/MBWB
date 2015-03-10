# Written by Xiuxia Du.
# Started in March 2015.


graphics.off()
rm(list=ls())


library(googleVis)

file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"





code_path <- "/Users/xdu4/Documents/Duxiuxia/myGitHub/MBWB"
setwd(code_path)






# plot mass vs RT time
function_file_name <- paste(code_path, "plotMass_RT_map.R", sep=.Platform$file.sep)
source(function_file_name

in_file_name <- "D_C12_10SPLIT_1.CDF"

scans <- 500:700

plotSpectra_gVis(file_path=file_path, file_name=in_file_name, scans)




re <- plotMass_RT_map(file_path=file_path, file_name=in_file_name, scans=scans, allScan=F)






# plot spectra
source(paste(code_path, "plotSpectra.R", sep=.Platform$file.sep))
# in_file_name <- "CYSTEINE02.CDF"
# in_file_name <- "2014-0910_4_MeOH,H2O_Ecoli_LowResCID_8MSMS.mzXML"
# scans <- c(2001,2002,2003,2004,2005,2006,2007,2008,2009)
in_file_name <- "DC12_10SPLIT_CI_1.CDF"
scans <- 1001:1050
re <- plotSpectra(file_path=file_path, file_name=in_file_name, scans)




in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
re <- readMzXmlFile(in_file_full_name)
i <- 1756
plot(re[[i]]$spectrum$mass, 100*re[[i]]$spectrum$intensity/max(re[[i]]$spectrum$intensity), type="l", xlab="mass", ylab="intensity", ylim=c(-10, 10), xlim=c(120, 130))
i <- 1765
points(re[[i]]$spectrum$mass, (-100)*re[[i]]$spectrum$intensity/max(re[[i]]$spectrum$intensity), col="red", type="l", xlab="mass", ylab="intensity")
zm()

