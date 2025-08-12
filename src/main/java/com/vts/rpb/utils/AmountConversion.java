package com.vts.rpb.utils;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public class AmountConversion {
	
	static DecimalFormat df = new DecimalFormat( "#####################");

	public static String DecimalRupeeFormat(String value) {
		String[] parts = value.split("\\.");
		String Firstvalue = parts[0];
		String lastDigit = null;
		if (parts.length > 1) {
			lastDigit = parts[1];
		} else {
			lastDigit = "00";
		}

		String result = "";
		int len = Firstvalue.length();
		int nDigits = 0;

		for (int i = len - 1; i >= 0; i--) {
			result = Firstvalue.charAt(i) + result;
			nDigits++;
			if (nDigits == 3 && i > 0) {
				result = "," + result;
			} else if (nDigits > 3 && (nDigits - 3) % 2 == 0 && i > 0) {
				result = "," + result;
			}
		}

		return (result + "." + lastDigit);
	}
	

	
	public static String amountConvertion(Object amount,String amountType) 
	{
		return amountConvertionDetails(amount,amountType);
	}
	
	private static String amountConvertionDetails(Object amount,String amountType)
	{
		String result="";
		if(amount!=null) 
		{
			if(isNumber(amount))
			{
				if(amountType!=null)
				{
					String finalAmount=amount.toString();
					if(amountType.equalsIgnoreCase("R") || amountType.equalsIgnoreCase("Rupees"))
					{
						result=rupeeFormat(finalAmount);
					}
					else
					{
						result=finalAmount;
					}
				}
			}
			else
			{
				result=amount.toString();
			}
		}
		else
		{
			result="0.00";
		}
		return result;
	}
	
	private static String amountConvertionDetailsWithoutDecimal(Object amount,String amountType)
	{
		String result="";
		if(amount!=null) 
		{
			if(isNumber(amount))
			{
				if(amountType!=null)
				{
					String finalAmount=amount.toString();
					if(amountType.equalsIgnoreCase("R") || amountType.equalsIgnoreCase("Rupees"))
					{
						result=rupeeFormat(finalAmount);
					}
					else
					{
						result=finalAmount;
					}
				}
			}
			else
			{
				result=amount.toString();
			}
		}
		else
		{
			result="0.00";
		}
		return df.format(result);
	}
	
	private static String rupeeFormat(String amount)
	{
		String result = "",minus="",decimal="";
		
		if(amount != null && !amount.equalsIgnoreCase("-")) 
		{
			if (amount.indexOf('.') != -1) // Remove Decimal Value
			{
				String[] amountarray=amount.split("\\.");
				if(amountarray!=null && amountarray.length>0) 
				{
					String number=amountarray[0];
					String paisa=amountarray[1];
					decimal="."+paisa;
					amount=number;
				}
			}

			amount = amount.replace(",", ""); // if value has Comma(,) this function will remove
			if (amount != null && (new BigDecimal(amount)).compareTo(new BigDecimal(0)) == -1) 
			{
				amount = amount.split("-")[1];
				minus = "-";
			}

			int len = amount.length();

			if (len == 1 || len == 2 || len == 3) 
			{
				result = amount;
			} else 
			{
				int a = 0;
				for (int i = len - 1; i >= 0; i--) 
				{
					a++;
					if (a == 1 || a == 2 || a == 3 || a % 2 == 1) 
					{
						result = result + amount.charAt(i);
					} 
					else if (a % 2 == 0) 
					{
						result = result + "," + amount.charAt(i);
					}
				}
				StringBuilder Reverse = new StringBuilder(result);
				result = Reverse.reverse().toString(); // reversing the Result
			}
		} else 
		{
			result = "0";
		}
		
		return minus + result + decimal;
	}
	
	private static boolean isNumber(Object amount) {
	    try {
	        new BigDecimal(amount.toString());
	        return true;
	    } catch (NumberFormatException | NullPointerException e) {
	        return false;
	    }
	}



	public static String[] getRupeePaisaSplit(String RupeeAndPaisa) {
		String[] RupeePaisaSplit = null;

		try {
			RupeePaisaSplit = RupeeAndPaisa.split("\\.");
		} catch (Exception e) {

		}

		return (RupeePaisaSplit);
	}

}
