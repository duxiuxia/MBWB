# Written by Xiuxia Du in April 2015.




source("http://bioconductor.org/biocLite.R")


biocLite("mzR")
library(mzR)


biocLite("msdata")
library(msdata)








file_name <- "PhK_FT_IT.mzML"
aa <- openMSfile(file_name)


runInfo(aa)

instrumentInfo(aa)

scan <- 130972
header(aa, scan)

spectrum <- peaks(aa, scan)
plot(spectrum[,1], spectrum[,2], type="h")
close(aa)


II <- sort(spectrum[,2])
