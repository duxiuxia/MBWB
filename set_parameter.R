# Written by Xiuxia Du in April 2015.




file_path <- "/Users/xdu4/Documents/Duxiuxia/Dataset"
file_name <- "col-0_1.mzXML"
in_file_full_name <- paste(file_path, file_name, sep=.Platform$file.sep)



# Define the default parameters for LC Project
PARAMS <- data.frame(file = in_file_full_name,
                     scanStart = 50, 
                     scanEnd = 1200, 
                     ROI_ppm_Th = 40, 
                     MinimumEIC_Count = 10, 
                     Hit_Miss_Count = 3, 
                     cutoffIntensity = 500, 
                     Top_number = 500, 
                     Quantile_Percentnumber = 0.1, 
                     Cutoff_Mode = 1, 
                     AdductFileName = "", 
                     Isotope_AdductFileName = "", 
                     hmdb_library_FileName = "",
                     Max_Iso = 0.011, 
                     Max_CS = 2, 
                     mass_tol = 0.1, 
                     Group_Scan_Shift = 3, 
                     SNR_Th = 10.0, 
                     PeakWidth_Low = 7, 
                     PeakWidth_High = 60, 
                     Group_Cluster_Angle_Th = 30, 
                     Refinement_Cluster_Angle_Th = 15, 
                     Align_Window_Phase1 = 0.2, 
                     Align_Window_Phase2 = 0.2,
                     Two_Phase = 1, 
                     Cluster_num = 2)  




# The following parameters are related to the module of Mass trace based EIC_Extraction 
PARAMS$Scan_Start<-200                        # unit(scan)
PARAMS$Scan_End  <-210                      # unit(scan)
PARAMS$ROI_ppm_Th<-20
PARAMS$MinimumEIC_Count<-10                   # unit(scan)
PARAMS$Hit_Miss_Count<-3                      # unit(scan)
PARAMS$Cutoff_Intensity<-50                  # Cutoff Intensity, Only the data point with intensity>500 of a scan are considered 
PARAMS$Top_number<- 200                       # Top 500 data points of a scan are considered 
PARAMS$Quantile_Percentnumber<-0.1            # Quantile point, 10 percent of the lowest data point of each scan are not considered.
PARAMS$Cutoff_Mode <-1                        # Cutoff Mode, 1: CutOff directly by specific value Cutoff_Intensity, 2: Only the Top_Number data point for each spectrum are kept; 3: The data point of the specific percenttage of a spectrum are not considered.   

# The following parameters are related to the module of Peak filtering
PARAMS$SNR_Th                       <- 10.0
PARAMS$PeakWidth_Low                <- 7      # unit(scan)
PARAMS$PeakWidth_High               <- 160     # unit(scan)

# The following parameters are related to the modules of Peak group, Annotation, and refinement 
PARAMS$Group_Scan_Shift             <- 3      # unit(scan)                
PARAMS$Group_Cluster_Angle_Th       <- 30     # unit(degree)   

# The following parameters are related to the modules of Peak Annotation, and Refinement 
# PARAMS$AdductFileName <- AdductFileName
# PARAMS$Isotope_AdductFileName <- Isotope_AdductFileName
# PARAMS$hmdb_library_FileName <- hmdb_library_FileName
PARAMS$Max_Iso<-2
PARAMS$Max_CS <-1
PARAMS$mass_tol<-0.011  # Da
PARAMS$Refinement_Cluster_Angle_Th  <- 15  # unit(degree) 

# The following parameters are related to the module of Compound Alignment
PARAMS$Align_Window_Phase1<- 0.3   # unit(minutes)
PARAMS$Align_Window_Phase2<-0.2    # unit(minutes)
PARAMS$Two_Phase <- 1              # 1-> Two phase alignment, 0-> One phase alignment


PARAMS$Cluster_num<- 1