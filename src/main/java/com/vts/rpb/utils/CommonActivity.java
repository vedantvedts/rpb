package com.vts.rpb.utils;

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

}
