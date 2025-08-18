package com.vts.rpb.utils;

import java.text.DateFormat;
import java.text.DateFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.TemporalAdjusters;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Stack;
import java.util.concurrent.TimeUnit;

public class DateTimeFormatUtil 
{
	private static SimpleDateFormat regularDateFormat=new SimpleDateFormat("dd-MM-yyyy");
	private static SimpleDateFormat regularDateFormatnew=new SimpleDateFormat("dd-MM-yy");
	private static SimpleDateFormat sqlDateFormat=new SimpleDateFormat("yyyy-MM-dd");
	private static DateTimeFormatter regularDateFormatLocalDate =  DateTimeFormatter.ofPattern("dd-MM-yyyy");
	private static DateTimeFormatter regularDateFormatLocalDateTime = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
	private static DateTimeFormatter regularDateFormatnewLocalDate=DateTimeFormatter.ofPattern("dd-MM-yy");
	private static DateTimeFormatter sqlDateFormatLocalDate = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	private static DateTimeFormatter sqlDateFormatLocalDateTime = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	
	
	public static SimpleDateFormat getregularDateWithTime() {
		return new SimpleDateFormat("dd-MM-yyyy HH:mm:ss ");
	}
	
	public static  SimpleDateFormat getMonthNameAndYear() {
		return new SimpleDateFormat("MMM-yyyy");
	}
	
	public static  SimpleDateFormat getTime() {
		return new SimpleDateFormat("HH:mm:ss");
	}
	
	
	public DateTimeFormatter getSqlDateFormatLocalDate() {
		return sqlDateFormatLocalDate;
	}


	public static  DateTimeFormatter getSqlDateFormat() {
		return sqlDateFormatLocalDate;
	}
	public static  DateTimeFormatter getSqlDateAndTimeFormat() {
		return sqlDateFormatLocalDateTime;
	}
	public static  DateTimeFormatter getRegularDateFormat() {
		return regularDateFormatLocalDate;
	}
	public static  SimpleDateFormat getDateMonthShortName() {
		return new SimpleDateFormat("dd-MMM-yyyy");
	}
	public static  SimpleDateFormat getDateMonthFullName() {
		return new SimpleDateFormat("dd-MMMM-yyyy");
	}
	
	public static long getDifferenceDays(Date d1, Date d2) {
	    long diff = d2.getTime() - d1.getTime();
	    return TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
	}
	

	public static  int getYearFromRegularDate(String datestring) 
	{
		
		LocalDate ldate=LocalDate.parse(datestring,regularDateFormatLocalDate);
		return ldate.getYear();
	}
	public static  int getYearFromSqlDate(String datestring) 
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate ldate=LocalDate.parse(datestring,formatter);
		return ldate.getYear();
		
	}
	public static  int getYearFromSqlDateAndTime(String datetimestring)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime ldatetime=LocalDateTime.parse(datetimestring,formatter);
		return ldatetime.getYear();
		
	}
	
	public static  int getMonthFromRegularDate(String datestring) 
	{
		LocalDate ldate=LocalDate.parse(datestring,regularDateFormatLocalDate);
		return ldate.getMonthValue();
	}
	public static  int getMonthFromSqlDate(String datestring) 
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate ldate=LocalDate.parse(datestring,formatter);
		return ldate.getMonthValue();
		
	}
	public static  int getMonthFromSqlDateAndTime(String datetimestring)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime ldatetime=LocalDateTime.parse(datetimestring,formatter);
		return ldatetime.getMonthValue();
		
	}
	
	public static  String getMonthValFromRegularDate(String datestring) 
	{

		LocalDate ldate=LocalDate.parse(datestring,regularDateFormatLocalDate);
		return ldate.getMonth().getDisplayName(TextStyle.SHORT,Locale.ENGLISH);
	}
	
	public static  String getMonthValFullFromRegularDate(String datestring) 
	{
	
		LocalDate ldate=LocalDate.parse(datestring,regularDateFormatLocalDate);
		return ldate.getMonth().getDisplayName(TextStyle.FULL,Locale.ENGLISH);
	}
	public static  String getMonthValFromSqlDate(String datestring) 
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate ldate=LocalDate.parse(datestring,formatter);
		return ldate.getMonth().getDisplayName(TextStyle.SHORT,Locale.ENGLISH);
		
	}
	public static  String getMonthValFromSqlDateAndTime(String datetimestring)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime ldatetime=LocalDateTime.parse(datetimestring,formatter);
		return ldatetime.getMonth().getDisplayName(TextStyle.SHORT,Locale.ENGLISH);		
	}
	
	
	public static  String getCurrentYear()
	{		
		return  String.valueOf(LocalDate.now().getYear());
	}
	
	public static  String getCurrentMonthShortName()
	{
		return new DateFormatSymbols().getShortMonths()[LocalDate.now().getMonthValue()];
	}
	
	public static  String getCurrentMonthFullName()
	{
		return new DateFormatSymbols().getMonths()[LocalDate.now().getMonthValue()-1];
	}
	
	public static  String getMonthFullName(int monthNumber)
	{
	String monthName = Month.of(monthNumber + 1).getDisplayName(TextStyle.FULL, Locale.getDefault());
	return monthName;
	}
	
	/*---------------------------------------------*/
	
	public static  String getFirstDayofCurrentMonthSqlFormat()
	{
		String firstday=LocalDate.now().with(TemporalAdjusters.firstDayOfMonth()).toString();
		return firstday;
	}
	
	public static  String getLastDayofCurrentMonthSqlFormat()
	{
		String lastday=LocalDate.now().with(TemporalAdjusters.lastDayOfMonth()).toString();
		return lastday;
	}
	
	public static  String getFirstDayofCurrentMonthRegularFormat() throws Exception
	{
		String firstday=regularDateFormat.format(sqlDateFormat.parse(LocalDate.now().with(TemporalAdjusters.firstDayOfMonth()).toString()));
		return firstday;
	}
	
	public static  String getLastDayofCurrentMonthRegularFormat() throws Exception
	{
		String lastday=regularDateFormat.format(sqlDateFormat.parse(LocalDate.now().with(TemporalAdjusters.lastDayOfMonth()).toString()));
		return lastday;
	}	
	
	
	
	public static  String getFinancialYearStartDateSqlFormat()
	{
		String firstday=null;
		if(LocalDate.now().getMonthValue() > 3)
		{
			firstday=LocalDate.now().getYear()+"-04-01";
		}
		else
		{
			firstday=(LocalDate.now().getYear()-1)+"-04-01";
		}
		
		return firstday;
	}
	
	public static String getFinancialYearStartDateInRegularFormat()
	{
	    String firstday = null;
	    if (LocalDate.now().getMonthValue() > 3)
	    {
	        firstday = "01-04-" + LocalDate.now().getYear();
	    }
	    else
	    {
	        firstday = "01-04-" + (LocalDate.now().getYear() - 1);
	    }
	    
	    return firstday;
	}

	
	
	public static  String getFinancialYearStartDateSqlFormat(String RegularDate)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
	    LocalDate date = LocalDate.parse(RegularDate, formatter);
	    String firstDay = null;
	    if (date.getMonthValue() > 3) 
	    {
	        firstDay = date.getYear() + "-04-01";
	    } 
	    else 
	    {
	        firstDay = (date.getYear() - 1) + "-04-01";
	    }
	    return firstDay;
	}	
	
	public static  String getFinancialYearEndDateSqlFormat()
	{
		String lastday=null;
		if(LocalDate.now().getMonthValue() < 3)
		{
			lastday=LocalDate.now().getYear()+"-03-31";
		}
		else
		{
			lastday=(LocalDate.now().getYear()+1)+"-03-31";
		}
		
		return lastday;
	}
	public static  String getFinancialYearEndDateSqlFormat(String RegularDate)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
	    LocalDate date = LocalDate.parse(RegularDate, formatter);
		String lastday=null;
		if(LocalDate.now().getMonthValue() < 3)
		{
			lastday=date.getYear()+"-03-31";
		}
		else
		{
			lastday=(date.getYear()+1)+"-03-31";
		}
		
		return lastday;
	}
	
	public static  String getFinancialYearStartDateRegularFormat() throws Exception
	{
		String firstday="01-04-"+LocalDate.now().getYear();
		return firstday;
	}
	
	public static  String getFinancialYearEndDateRegularFormat() throws Exception
	{
		String lastday="31-03-"+LocalDate.now().getYear();
		return lastday;
	}
	
	public static  String getPreviousFinancialYearStartDateRegularFormat() throws Exception
	{
		String pfirstday="01-04-"+LocalDate.now().minusYears(1).getYear();
		return pfirstday;
	}
	public static  String getPreviousFinancialYearStartDateSqlFormat()
	{
		String pfirstday=LocalDate.now().minusYears(1).getYear()+"-04-01";
		return pfirstday;
	}	
	
	
	public static  String getCurrentYearStartDateSqlFormat()
	{
		String firstday=LocalDate.now().getYear()+"-01-01";
		return firstday;
	}	
	
	public static  String getCurrentYearStartDateRegularFormat()
	{
		String pfirstday="01-01-"+LocalDate.now().getYear();
		return pfirstday;
	}	
	
	public static String getLocalDateAsString() throws ParseException
	{
		return sqlDateFormatLocalDate.format(LocalDate.now());
	}
	public static  String getSqlToRegularDate (String sqldate) throws ParseException
	{
		return regularDateFormatLocalDate.format(LocalDate.parse(sqldate));
	}
	
	public static LocalDate getSqlToLocalDate (String sqlDate) throws ParseException
	{
		return LocalDate.parse(sqlDate);
	}
	public static LocalDateTime getSqlToLocalDateTime (String sqlDate) throws ParseException
	{
		return LocalDateTime.parse(sqlDate);
	}
	
	public static  String getSqlToRegularDateTime (String sqlDateTime) throws ParseException
	{
		return regularDateFormatLocalDateTime.format(LocalDate.parse(sqlDateTime));
	}
	
	public static LocalDate getRegularToSqlDate (String regularDate) throws ParseException
	{
		return LocalDate.parse(regularDate,regularDateFormatLocalDate);
	}
	
	public static String getRegularToSqlDateAsString (String regularDate) throws ParseException
	{
		return sqlDateFormatLocalDate.format(LocalDate.parse(regularDate,regularDateFormatLocalDate));
	}

	
	public static  String getSqlToRegularDateNew (String sqldate) throws ParseException
	{
		return regularDateFormatnewLocalDate.format(LocalDate.parse(sqldate));
	}
	
	public static java.sql.Date dateConversionSql(String sDate) {
		java.sql.Date ddate = null;

		SimpleDateFormat sdf4 = new SimpleDateFormat("dd-MM-yyyy");
		try {
			java.util.Date jdate = sdf4.parse(sDate);
			long ms = jdate.getTime();
			ddate = new java.sql.Date(ms);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return (ddate);
	}
	
	public static java.sql.Date  todayDateInSqlFormat()
	{
 		java.sql.Date datetodaydb =null;
		try
		{
			Date dd=new Date();	
			SimpleDateFormat sdf=new SimpleDateFormat("dd-MM-yyyy ");
	     	String datetoday=sdf.format(dd);
	        datetodaydb=dateConversionSql(datetoday);
	 		 
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return datetodaydb;
	}
	
	 public static String getCurrentFinancialYear () {
		 
			String date = regularDateFormat.format(new Date());
			String[] str = date.split("-");
			int month = Integer.parseInt(str[1]);
			int year = Integer.parseInt(str[2]);
			String finYear = null;
			if (month > 3) {
				finYear = year + "-" + (year + 1);
			} else {
				finYear = (year - 1) + "-" + year;
			}

			
			return finYear;
		}
		    
		    public static String getCurrentYearStart () {
	            String finyear = getCurrentFinancialYear();
				String[] str = finyear.split("-");
				String YearStart = str[0];
				
				return YearStart;
			}
		    
		    
		    public static String getCurrentYearEnd () {
		    	 String finyear = getCurrentFinancialYear();
			     String[] str = finyear.split("-");
				 String YearEnd = str[1];
		    	
		    	return YearEnd;
		    	
		    }
		    

		    
	public static String getTodayDateInRegularFormat(){
		Date today=new Date();	
		String todaysDate=regularDateFormat.format(today);
		return todaysDate;
	
	}
	public static String getTodayDateInSqlFormat(){
		Date today=new Date();	
		String todaysDate=sqlDateFormat.format(today);
		return todaysDate;
	
	}
	


  public static String getThirtyDaysPriorToCurrDateInRegularFormat(){
	  Date today=new Date();	
	  Calendar cal = new GregorianCalendar();
	  cal.setTime(today);
	  cal.add(Calendar.DAY_OF_MONTH, -30);
	  Date prior30Date = cal.getTime();
	  String ThirtyDaysPriorDate = regularDateFormat.format(prior30Date);
	  return ThirtyDaysPriorDate;
	  

  }
  
  public static String getOneYearPriorToCurrDtInDMYFormat() {
	  LocalDate currentDate = LocalDate.now();
	// Subtract one year from the current date
	  LocalDate oneYearBefore = currentDate.minusYears(1);
	  
	  String yearString = String.valueOf(oneYearBefore.getYear());
	  String monthString = String.format("%02d", oneYearBefore.getMonthValue());
	  String dayString = String.format("%02d", oneYearBefore.getDayOfMonth());
	  String oneYearBeforeDate = dayString+"-"+monthString+"-"+yearString;
	  
	  return oneYearBeforeDate;
  }
	
  public static  String getFYFromSqlDate(String sqlDateString) throws Exception
	{
		String date = sqlDateString;
		String[] str = date.split("-");
		int month = Integer.parseInt(str[1]);
		int year = Integer.parseInt(str[0]);
		String finYear = null;
		if (month > 3) {
			finYear = year + "-" + (year + 1);
		} else {
			finYear = (year - 1) + "-" + year;
		}
		return finYear;
	}	
  
  public static  String getFYFromRegularDate(String regularDateString) throws Exception
	{
		String date = regularDateString;
		String[] str = date.split("-");
		int month = Integer.parseInt(str[1]);
		int year = Integer.parseInt(str[2]);
		String finYear = null;
		if (month > 3) {
			finYear = year + "-" + (year + 1);
		} else {
			finYear = (year - 1) + "-" + year;
		}
		return finYear;
	}	 
  
  public static String getFirstDayDtOfPrevMonth(){
		 // Get today's date
	    LocalDate today = LocalDate.now();
	    LocalDate firstDay = today.minusMonths(1).with(TemporalAdjusters.firstDayOfMonth());
	    String firstDayDtOfPrevMonth = regularDateFormatLocalDate.format(firstDay);
	    return firstDayDtOfPrevMonth;
	}

	public static String getLastDayDtOfPrevMonth(){
		 // Get today's date
	   LocalDate today = LocalDate.now();
	   LocalDate LastDay = today.minusMonths(1).with(TemporalAdjusters.lastDayOfMonth());
	   String LastDayDtOfPrevMonth = regularDateFormatLocalDate.format(LastDay);
	   return LastDayDtOfPrevMonth;
	}
	
	public static String getLastDayDtOfPrevMonthSqlFormat(String regularDate) {

	    LocalDate inputDate = LocalDate.parse(regularDate, regularDateFormatLocalDate);
	    LocalDate lastDay = inputDate.minusMonths(1).with(TemporalAdjusters.lastDayOfMonth());
	    return sqlDateFormatLocalDate.format(lastDay);
	}

	
  public static Stack<String> getPrevMonthStartEndDate() throws ParseException 
	{
		String fromDate=null;
		String toDate=null;
		Date date = new Date();  
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int month = cal.get(Calendar.MONTH);
		int Year = cal.get(Calendar.YEAR);
		if(month==0)
		{
			fromDate=(Year-1)+"-12-01";
			toDate=(Year-1)+"-12-31";
		}else if(month==1)
		{
			fromDate=Year+"-01-01";
			toDate=Year+"-01-31";
		}else if(month==2)
		{
			fromDate=Year+"-02-01";
			toDate=Year+"-02-28";
		}
		else if(month==3)
		{
			fromDate=Year+"-03-01";
			toDate=Year+"-03-31";
		}
		else if(month==4)
		{
			fromDate=Year+"-04-01";
			toDate=Year+"-04-30";
		}
		else if(month==5)
		{
			fromDate=Year+"-05-01";
			toDate=Year+"-05-31";
		}
		else if(month==6)
		{
			fromDate=Year+"-06-01";
			toDate=Year+"-06-30";
		}
		else if(month==7)
		{
			fromDate=Year+"-07-01";
			toDate=Year+"-07-31";
		}
		else if(month==8)
		{
			fromDate=Year+"-08-01";
			toDate=Year+"-08-31";
		}
		else if(month==9)
		{
			fromDate=Year+"-09-01";
			toDate=Year+"-09-30";
		}
		else if(month==10)
		{
			fromDate=Year+"-10-01";
			toDate=Year+"-10-31";
		}
		else if(month==11)
		{
			fromDate=Year+"-11-01";
			toDate=Year+"-11-30";
		}
		 Stack<String> stack = new Stack<String>();
		 stack.add(fromDate);
		 stack.add(toDate);
		return stack;
	}
  
  public static String getLastDate(int month, int year) {
	    Calendar calendar = Calendar.getInstance();
	    // passing month-1 because 0-->jan, 1-->feb... 11-->dec
	    calendar.set(year, month - 1, 1);
	    calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
	    Date date = calendar.getTime();
	    DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
	    return DATE_FORMAT.format(date);
	}

	public static String getFirstDate(int month, int year) {
	    Calendar calendar = Calendar.getInstance();
	    // passing month-1 because 0-->jan, 1-->feb... 11-->dec
	    calendar.set(year, month - 1, 1);
	    calendar.set(Calendar.DATE, calendar.getActualMinimum(Calendar.DATE));
	    Date date = calendar.getTime();
	    DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
	    return DATE_FORMAT.format(date);
	}
	
	
	
	public static String getMonthName(int month)
	{
		
	        String monthString;
	        switch (month) {
	            case 1:  monthString = "January";
	                     break;
	            case 2:  monthString = "February";
	                     break;
	            case 3:  monthString = "March";
	                     break;
	            case 4:  monthString = "April";
	                     break;
	            case 5:  monthString = "May";
	                     break;
	            case 6:  monthString = "June";
	                     break;
	            case 7:  monthString = "July";
	                     break;
	            case 8:  monthString = "August";
	                     break;
	            case 9:  monthString = "September";
	                     break;
	            case 10: monthString = "October";
	                     break;
	            case 11: monthString = "November";
	                     break;
	            case 12: monthString = "December";
	                     break;
	            default: monthString = "Invalid month";
	                     break;
	        }
	        return monthString;
	}
	

public static String getMonthValue(String month)
	{
		
	        String monthValue;
	        switch (month) {
	            case "January":  monthValue = "01";
	                     break;
	            case "February":  monthValue = "02";
	                     break;
	            case "March":  monthValue = "03";
	                     break;
	            case "April":  monthValue = "04";
	                     break;
	            case "May":  monthValue = "05";
	                     break;
	            case "June":  monthValue = "06";
	                     break;
	            case "July":  monthValue = "07";
	                     break;
	            case "August":  monthValue = "08";
	                     break;
	            case "September":  monthValue = "09";
	                     break;
	            case "October": monthValue = "10";
	                     break;
	            case "November": monthValue = "11";
	                     break;
	            case "December": monthValue = "12";
	                     break;
	            default: monthValue = "0";
	                     break;
	        }
	        return monthValue;
	}


public static String getPreviousDate(String selectedDate) throws ParseException {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	Date myDate = dateFormat.parse(selectedDate);
	Calendar cal1 = Calendar.getInstance();
	cal1.setTime(myDate);
	cal1.add(Calendar.DAY_OF_YEAR, -1);
	return dateFormat.format(cal1.getTime());
}


public static Date getOneMonthBackDateFromCurrentDate() {
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.MONTH, -1);
	Date result = cal.getTime();
	return result;
}


public static Object getPastYearDate(int Number) {
	Calendar cal = Calendar.getInstance();
	Date today = cal.getTime();
	cal.add(Calendar.YEAR, Number); 
	return cal.getTime();
}

public static String getFinancialYearStartDateSqlFormatFromFinancialYear(String finYear) {
	
	if(finYear!=null)
	{
		finYear=finYear.split("-")[0];   // spliting FromYear
	}
    
    return finYear+ "-04-01";
}

public static String getFinancialYearEndDateSqlFormatFromFinancialYear(String finYear) {
	
	if(finYear!=null)
	{
		finYear=finYear.split("-")[1];   // spliting ToYear
	}
	return finYear+ "-03-31";
}

	public static String getPreviousFinYearByUserSelectedFinYear(String FinYear) 
	{
		if(FinYear!=null)
		{
			 String[] years = FinYear.split("-");
		     int fromYear = Integer.parseInt(years[0]) - 1;
		     int toYear = Integer.parseInt(years[1]) - 1;
		     return fromYear + "-" + toYear;
		}
		else
		{
			return FinYear;
		}
	}

	public static String getFinancialYearFromRegularDate(String strDate) {
		 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
	        LocalDate date = LocalDate.parse(strDate, formatter);

	        int year = date.getYear();
	        int month = date.getMonthValue();

	        if (month >= 4) {
	            return year + "-" + (year + 1);
	        } else {
	            return (year - 1) + "-" + year;
	        }
	}
	
	public static String getFinancialYearFromSqlDate(String strDate) {
		 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	        LocalDate date = LocalDate.parse(strDate, formatter);

	        int year = date.getYear();
	        int month = date.getMonthValue();

	        if (month >= 4) {
	            return year + "-" + (year + 1);
	        } else {
	            return (year - 1) + "-" + year;
	        }
	}
	
	public static String getCurrentQuarterAndOldQtrLastDate(String currentDate) {
		String oldQtrLastDate = null;
		String[] datearr = currentDate.split("-");
		int month = Integer.parseInt(datearr[1]);
		int year = Integer.parseInt(datearr[2]);
		if (month > 3 && month < 7) {
			oldQtrLastDate = year + "-" + "03" + "-" + "31";
		} else if (month > 6 && month < 10) {
			oldQtrLastDate = year + "-" + "06" + "-" + "30";
		} else if (month > 9 && month < 13) {
			oldQtrLastDate = year + "-" + "09" + "-" + "30";
		} else if (month > 0 && month < 4) {
			year = year - 1;
			oldQtrLastDate = year + "-" + "12" + "-" + "31";
		}
		return oldQtrLastDate;
	}


	public static String getActualYearFromMonthandFinYear(String month, String finYear) {
		String year=null;
		int monthValue=Integer.parseInt(month);
		String[] yearArray=finYear.split("-");
		if(monthValue > 3)
		{
			year=yearArray[0];
		}
		else
		{
			year=yearArray[1];
		}
		return year;
	}
	
	

	
}
