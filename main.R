# Written by Xiuxia Du in February 2015.


graphics.off()
rm(list=ls())


library(zoom)


# file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset/DHMRI"
# file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset/Stein/LC_EColi"
# file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset/Sumner/Weiss/CDF"
# file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset/Kurland/IROA"
file_path <- "/Users/xdu4/Downloads"




# code_path <- "/Users/xdu4/Documents/Duxiuxia/Code/Library/R"
code_path <- "/Users/xdu4/Documents/Duxiuxia/myGitHub/MBWB"
setwd(code_path)






# plot mass vs RT time
source(paste(code_path, "plotMass_RT_map.R", sep=.Platform$file.sep))
# in_file_name <- "CYSTEINE02.CDF"
# in_file_name <- "2014-0910_4_MeOH,H2O_Ecoli_LowResCID_8MSMS.mzXML"
# in_file_name <- "SD_08292013_Weiss_Ret_Pos_08152013_D401.CDF"
# in_file_name <- "DC12_10SPLIT_CI_1.CDF"
in_file_name <- "150220_EF_PMA_PSN473_LN-1004-f_ddMS2_pos.mzXML"

scans <- 500:700

re <- plotMass_RT_map(file_path=file_path, file_name=in_file_name, scans=scans, allScan=F)






# plot spectra
source(paste(code_path, "plotSpectra.R", sep=.Platform$file.sep))
# in_file_name <- "CYSTEINE02.CDF"
# in_file_name <- "2014-0910_4_MeOH,H2O_Ecoli_LowResCID_8MSMS.mzXML"
# scans <- c(2001,2002,2003,2004,2005,2006,2007,2008,2009)
# in_file_name <- "DC12_10SPLIT_CI_1.CDF"
in_file_name <- "150220_EF_PMA_PSN473_LN-1004-f_ddMS2_pos.mzXML"
scans <- 1013
re <- plotSpectra(file_path=file_path, file_name=in_file_name, scans)




in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)
re <- readMzXmlFile(in_file_full_name)
i <- 1756
plot(re[[i]]$spectrum$mass, 100*re[[i]]$spectrum$intensity/max(re[[i]]$spectrum$intensity), type="l", xlab="mass", ylab="intensity", ylim=c(-10, 10), xlim=c(120, 130))
i <- 1765
points(re[[i]]$spectrum$mass, (-100)*re[[i]]$spectrum$intensity/max(re[[i]]$spectrum$intensity), col="red", type="l", xlab="mass", ylab="intensity")
zm()

