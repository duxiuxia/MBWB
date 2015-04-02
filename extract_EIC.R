# Written by Xiuxia Du in April 2015.





find_optimal_matched_EIC_mass_trace <- function(EICData_Node, EICInformation_list, ppm_Th)
{    
    current_node_mass      <- EICData_Node$mass

    
    vector_mass_cent <- NULL
    for (candidate_index in 1:length(EICInformation_list))
    {
        vector_mass_cent <- c(vector_mass_cent, EICInformation_list[[candidate_index]]$mass_cent)
    }
    
    
    vector_distance_in_ppm <- abs((current_node_mass - vector_mass_cent)) / vector_mass_cent * 1000000
    
    II <- which(vector_distance_in_ppm == min(vector_distance_in_ppm))
    
    if (vector_distance_in_ppm[II] <= ppm_Th)
    {
        return(II)
    }
    else
    {
        return(NULL)
    }
}
    
    
    
    
    
    
    
    
    

extractEIC <- function(PARAMS)
    #Extract_EIC<-function(mass_values, intensity_values, scan_index, scan_number, Scan_start, Scan_end, ROI_ppm_Th, point_num_Th, hit_miss_count_Th, cutoff_intensity, Top_number, Quantile_Percentnumber, cutoff_mode)
{
    cat("In Extract_EIC \n")
    
    if( !is.element("readMzXmlData", installed.packages()[,1]) )
        install.packages("readMzXmlData")
    
    library("readMzXmlData")
    
    
    
    
    
    re <- readMzXmlFile(in_file_full_name)
    
    
    
    
    EICData_list = vector("list",0)	#create a null list for storing each EICData
    EICInformation_list =vector("list", 0) #create a null list for saving each EICInformation
    

    
    for (i in PARAMS$scanStart:PARAMS$scanEnd)
        #	for(i in Start_Scan:End_Scan)
    {
        # get the mass-spectrum data for the current scan 
        # Use a database to store the raw spectral data later on to speed up the query
        
        if (i%%1 == 0) 
        {
            cat("current scan is", i, "\r")
        }
        


        current_scan_mass <- re[[i]]$spectrum$mass
        current_scan_intensity <- re[[i]]$spectrum$intensity
        
        

        ind <- which(current_scan_intensity >= PARAMS$cutoffIntensity)
        current_scan_mass <- current_scan_mass[ind]
        current_scan_intensity <- current_scan_intensity[ind]	 
        
        
        
        
        
        # need to sort the current scan according to mass asscending sequence 
        if (length(mass_values_tempscan) > 0) {
            
            II <- order(current_scan_mass)
            current_scan_mass <- current_scan_mass[II]
            current_scan_intensity <- current_scan_intensity[II]
            
            
            
            
            
            if (i == PARAMS$scanStart) {			 
                
                for (index in 1:length(current_scan_mass)) {
                    
                    EICData_list[[index]] <- data.frame(mass=current_scan_mass[index], 
                                                        intensity=current_scan_intensity[index], 
                                                        scan_index=i)

                    
                    EICInformation_list[[index]] <- data.frame(mass_cent=current_scan_mass[index], 
                                                               mass_max=current_scan_mass[index], 
                                                               mass_min=current_scan_mass[index], 
                                                               point_num=1, 
                                                               hit_miss_count=-1, 
                                                               newnode_mass=current_scan_mass[index], 
                                                               newnode_intensity=current_scan_intensity[index], 
                                                               newnode_scanindex=i)
			
                }
                
            }#over initialization of ROI(EICData_list and EICInformation_list)  
            else  #Append feature point into EICData_list and EICInformation_list 
            {
                
                for (index in 1:length(current_scan_mass))
                {							
                    current_mass <- current_scan_mass[index]
                    current_intensity <- current_scan_intensity[index]
                    
                    EICData_Node<- data.frame(mass=current_mass, intensity=current_intensity, scan_index=i)
                    
                    
                    
                    

                    #trying to find out the matched EIC_MassTrace to select the corresponding EICData_Node 			 
                    MatchedTrace_Index <- find_optimal_matched_EIC_mass_trace(EICData_Node, EICInformation_list, PARAMS$ROI_ppm_Th) 	
		 														 			 			 			
                    
#                     HERE
                    
                    
                    
                    if (is.null(MatchedTrace_Index)) # Need to insert a new EIC trace
                        #					if (MatchedTrace_Index <=0) # Commented out by Xiuxia on 5/15/2012 # Can't find a matched mass trace, need to insert a new mass trace in the exisiting mass list at its correponding mass position 
                    {
                        position <- Find_position_addingnode(EICData_Node, EICInformation_list) # find the suitable position in the mass trace list for the new mass trace, mainly according to the mass value order  
                        EICData_list        <- add_list_node(EICData_list, position, EICData_Node)   
                        
                        EICInformation_Node <- data.frame(mass_cent=current_mass, mass_max=current_mass, mass_min=current_mass, point_num=1, hit_miss_count=0, newnode_mass=current_mass, newnode_intensity=current_intensity, newnode_scanindex=i) 
                        #						EICInformation_Node <- data.frame(mass_cent=c( mass_values_tempscan[index]), mass_max=c( mass_values_tempscan[index]), mass_min=c( mass_values_tempscan[index]), point_num=c(1), hit_miss_count=c(0), newnode_mass=c( mass_values_tempscan[index]), newnode_intensity=c(intensity_values_tempscan[index]), newnode_scanindex=c(i)) 
                        
                        EICInformation_list <- add_list_node(EICInformation_list, position, EICInformation_Node)
                        
                        ##################################################################################
                        # 						Code below was commented out by Xiuxia on 5/16/2012 since this appears to be unnecessary
                        #						if(length(EICData_list)!= length(EICInformation_list))
                        #							stop("EICDatalist and EICInformation_list are not equal in length after adding new mass trace!")				
                        ##################################################################################
                        
                    } 
                    else #find a matched mass trace, then add the feature point into the corresponding EICData Mass trace and update the corresponding EICInfomration Node
                    {
                        EICData_list[[MatchedTrace_Index]] <- rbind(EICData_list[[MatchedTrace_Index]], EICData_Node)
                        # by row binding, add a EICData_Node into the corresponding mass trace.   
                        EICInformation_list[[MatchedTrace_Index]]<- Update_EICInformation_Node(EICInformation_list[[MatchedTrace_Index]], EICData_Node)
                        # add EICData node into EICMass trace, need to update the EICInformation Node,inclduing recalculating mass parameters for the corresponding EIC Mass trace and add 1 to mass trace count and clear hit_miss_count.                                    	         
                    }                           
                    
                } # end of for
                
            }	# end of else # over appending
            
            
            
            #################################################################			
            #	Commented out the sorting loop below by Xiuxia to speed up the sorting			
            #			for(j in 1:(length(mass_values_tempscan)-1))
            #			{
            #				for(k in (j+1):length(mass_values_tempscan))
            #				{
            #					if (mass_values_tempscan[j]> mass_values_tempscan[k])
            #					{
            #						# swap mz 
            #						temp_mass <- mass_values_tempscan[j]
            #						mass_values_tempscan[j] <- mass_values_tempscan[k]
            #						mass_values_tempscan[k] <- temp_mass
            #						# sawp intensity
            #						temp_intensity <- intensity_values_tempscan[j]
            #						intensity_values_tempscan[j] <- intensity_values_tempscan[k]
            #						intensity_values_tempscan[k] <- temp_intensity
            #					}	  					  
            #				}		  
            #			}#over sorting as ascending	 
            #################################################################	
        }	# end of one scan
        
        cat("After one scan \n")
        browser()
        
        vector_node_to_remove <- NULL
        
        if (length(EICInformation_list) > 0)
        {
            temp <- 1:length(EICInformation_list)
            
            #for(k in 1:length(EICInformation_list)){
            for(k in temp){			
                EICInformation_list[[k]]$hit_miss_count <- EICInformation_list[[k]]$hit_miss_count + 1
                
                if ((EICInformation_list[[k]]$point_num < PARAMS$MinimumEIC_Count) & (EICInformation_list[[k]]$hit_miss_count > PARAMS$Hit_Miss_Count))
                {
                    vector_node_to_remove <- c(vector_node_to_remove, k)
                    #					EICInformation_list <- remove_list_node(EICInformation_list, k)
                    #					EICData_list <- remove_list_node(EICData_list, k)
                }
            }
        }	
        
        if (!is.null(vector_node_to_remove))
        {
            EICData_list <- EICData_list[-vector_node_to_remove]
            EICInformation_list <- EICInformation_list[-vector_node_to_remove]	
        }
        
        
        ##################################################################################				
        # This section below was commented out by Xiuxia
        
        # After a loop for a whole scan, need to remove some mass traces from the EIC mass trace list if their length is smaller than a fix threshold, also the length keep unchanged for several scans, 
        #		temp_EICData_list <- vector("list",0)	     #create a null list for saving the 
        #		temp_EICInformation_list <- vector("list", 0) #create a null list for saving each EICInformation
        #		temp_position <- 1	
        #		
        #		if(length(EICInformation_list)>0)  #Ensure the 
        #		{
        #			for (k in 1:length(EICInformation_list)) 
        #			{
        #				
        #			
        #				temp_EICInformation<- EICInformation_list[[k]]
        #				temp_EICInformation$hit_miss_count<- temp_EICInformation$hit_miss_count+1 # temp_EICInformation[1,5], miss count +1 for each scan loop, if the current mass trace find a node, it must be revert 0 by add 1
        #		
        ##				if(((temp_EICInformation$point_num) <point_num_Th) && ((temp_EICInformation$hit_miss_count)>hit_miss_count_Th))
        ##				{
        ##					  EICInformation_list<- remove_list_node(EICInformation_list, k) 
        ##					  EICData_list       <- remove_list_node(EICData_list, k)			  
        #					
        ##					if(length(EICData_list)!= length(EICInformation_list))
        ##						stop("EICDatalist and EICInformation_list are not equal in length after removing random mass trace!")
        ##				} 	
        ##				else
        ##				{
        #					# EICInformation_list[[k]]$hit_miss_count<- temp_EICInformation$hit_miss_count
        #			
        #			
        #					temp_EICData  <- EICData_list[[k]]
        #					temp_EICInformation_list[[temp_position]]<- temp_EICInformation		       
        #					temp_EICData_list[[temp_position]]       <- temp_EICData
        #					temp_position <- temp_position + 1
        #					
        #				
        ##					if(length(temp_EICData_list)!= length(temp_EICInformation_list))
        ##						stop("temp_EICData_list and temp_EICInformation_list are not equal in length after removing random mass trace!")
        #			
        ##				}			  
        #			}
        #		}
        
        #		EICInformation_list<- temp_EICInformation_list
        #		EICData_list       <- temp_EICData_list
        ####################################################################################	
        
    } # end of all scans # over scan loop	
    
    #print out the extracted mass trace (EICs)
    EICData_list
    
}# over Extract_EIC function
# 