package com.vts.rpb.utils;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class CommonActivity {
	
	public static String addingMonthValues(String month) 
	{
	    String[] months = { "04", "05", "06", "07", "08", "09", "10", "11", "12", "01", "02", "03"};
	    StringBuilder result = new StringBuilder();
	    for (String m : months) {
	        result.append(m);
	        if (m.equals(month)) break;
	        result.append(",");
	    }
	    return result.toString();
	}
	
	public static String[] getFundNextStatus(String fundStatus, Object rolesDetails, Object approvalsDetails) 
	{
		String[] statusDetails = new String[6];
		
		   String statusColor="",message="NA";
           
           if(fundStatus!=null) { 
           	
           	 if("N".equalsIgnoreCase(fundStatus)) {
	            	   statusColor = "#4b01a9";
	                   message = "Forward Pending";
	               } else if("R".equalsIgnoreCase(fundStatus)) {
	            	   statusColor = "red";
	                   message = "Returned";
				   } else if("E".equalsIgnoreCase(fundStatus)) {
	            	   statusColor = "#007e68";
	                   message = "Revoked";
				   } else if("A".equalsIgnoreCase(fundStatus)) {
	            	   statusColor = "green";
	            	   message = "Approved";
	               }
           }
		
           String dhStatus = null, csStatus = null, ccStatus = null, rcStatus = null;
           if(rolesDetails != null && approvalsDetails != null)
           {
	        	String rolesStr = rolesDetails.toString();
	        	String approvalsStr = approvalsDetails.toString();
	        	
	        	dhStatus = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("DH")).findFirst().orElse(null);
	        	csStatus = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CS")).findFirst().orElse(null);
	        	ccStatus = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CC")).findFirst().orElse(null);
	           	
	                String input = "RC"; 
	                Set<String> rcFilter = Set.of("CM", "SE");
	
	                String[] roles = rolesStr.split(",");
	                String[] approvals = approvalsStr.split(",");
	
	                List<String[]> filtered = IntStream.range(0, roles.length)
	                        .filter(i -> input.equals("RC") && rcFilter.contains(roles[i]))
	                        .mapToObj(i -> new String[]{roles[i], approvals[i]})
	                        .collect(Collectors.toList());
	
	                rcStatus = filtered.stream().map(a -> a[1]).collect(Collectors.joining(","));
	                
	                if("F".equalsIgnoreCase(fundStatus)) {
						   
					   if(dhStatus.equalsIgnoreCase("N")){
						   message = "DH Rec. Pending";
		            	   statusColor = "#03458c";
					   } else if(rcStatus.contains("N")){
						   message = "Member Rec. Pending";
		            	   statusColor = "#9b0186";
					   } else if(csStatus.equalsIgnoreCase("N")){
						   message = "Review Pending";
		            	   statusColor = "#8c2303";
					   } else if(ccStatus.equalsIgnoreCase("N")){
						   message = "Approval Pending";
		            	   statusColor = "#bd0707";
		               }
	                }
	                
           }
           
        statusDetails[0] = dhStatus;
       	statusDetails[1] = rcStatus;
       	statusDetails[2] = csStatus;
       	statusDetails[3] = ccStatus;
       	statusDetails[4] = message;
       	statusDetails[5] = statusColor;
       	
		return statusDetails;
	}

}
