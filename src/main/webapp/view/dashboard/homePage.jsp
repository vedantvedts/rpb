<%@page import="java.util.Arrays"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.util.Date"%>
<%@page import="com.vts.rpb.utils.AmountConversion"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="../static/header.jsp"></jsp:include>

<title>Home Page</title>

<!-- <style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        overflow-x: hidden;
        overflow-y: auto;
    }

    .container.dashboard-card {
        min-height: 100vh; /* Fill the entire viewport */
    }

    .card {
        height: 100%; /* optional: make all cards same height */
    }

    .card-body {
        min-height: 150px; /* optional: keep card content from collapsing */
    }

    .row {
        margin-bottom: 1rem;
    }
</style> -->
<style>
body {
    background-color: #f4f9ff;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.card{
	border: 0px solid rgba(0, 0, 0, .125) !important;
	
}

.page.card.dashboard-card {
    display: flex;
    flex-wrap: wrap;
    gap: 25px; /* Space between cards */
    padding: 20px;
    overflow-y: auto; /* Enable vertical scrolling */
    min-height:auto !important;
    max-height: calc(110vh - 250px) !important; /* Adjust based on your header height */
    align-content: flex-start; /* Align items to the top */
    justify-content: center; /* Center cards horizontally */
    flex-direction: row;
}

.custom-card {
    flex: 0 0 calc(33.333% - 40px); /* 3 cards per row with gap */
    min-width: 300px;
    max-width: 430px;
    min-height: 162px; /* Fixed minimum height */
    margin-bottom: 20px; /* Space between rows */
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.07);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

/* .custom-card {
    flex: 1 1 calc(33.333% - 40px);
    min-width: 300px;
    max-width: 430px;
    min-height: 100px;
    max-height: 162px;
    background-color: white;
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.07);
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
} */

.custom-card:hover {
    transform: scale(1.04) translateY(-6px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
    z-index: 10;
    position: relative;
}

.custom-card .card-name {
    background-color: #00007e;
    color: white;
    font-weight: 600;
    text-align: center;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    padding: 12px;
    font-size: 18px;
    letter-spacing: 0.5px;
}

.custom-card .card-body {
    padding: 16px;
}

.card-title {
    font-size: 16px;
    margin-bottom: 5px;
}

.card-body p {
    margin: 5px 0;
    font-size: 16px;
}

.Repopup, .Fbepopup {
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.Repopup:hover, .Fbepopup:hover {
    transform: scale(1.01) translateY(-3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    position: relative;
}

@media screen and (max-width: 991px) {
    .custom-card {
        flex: 1 1 calc(50% - 40px);
    }
}

@media screen and (max-width: 767px) {
    .custom-card {
        flex: 1 1 100%;
    }

    .card-body p {
        font-size: 15px;
    }

    .card-title {
        font-size: 15px;
    }
}

</style>

</head>

<body id="HomeBody">
<%
List<Object[]> DivisionList=(List<Object[]>)request.getAttribute("DivisionList"); 
List<Object[]> DivisionDetailsList=(List<Object[]>)request.getAttribute("DivisionDetailsList"); 
String ProjectFlag=(String)request.getAttribute("ProjectFlag");
String AmtFormat =(String)request.getAttribute("amountFormat");
String loginType=(String)session.getAttribute("LoginType");
String Date=(String)request.getAttribute("dateForCCM");
Integer DigitValue = (Integer)request.getAttribute("digitValueSel");
String MemberType =(String)request.getAttribute("MemberType");
String fromYear =(String)request.getAttribute("fromYear");
String toYear =(String)request.getAttribute("toYear");

String divisionId="",estimateType="",fbeYear="",reYear="";
FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto)session.getAttribute("FundApprovalAttributes");
if(fundApprovalDto!=null)
{
	divisionId=fundApprovalDto.getDivisionId();
	estimateType=fundApprovalDto.getEstimatedTypeBackBtn();
	fbeYear=fundApprovalDto.getFBEYear();
	reYear=fundApprovalDto.getREYear();
}
%>
<div class="card-header page-top" style="height: 2.2rem !important; background: transparent !important; box-shadow: none !important;">
    <div class="row" style="margin-top: 1px;">
        <div class="col-md-3 closeSideBar" style="background: transparent;"></div>

        <div class="col-md-9 d-flex justify-content-end align-items-center " style="background: transparent; margin-top: -3px;">
            <form action="#" id="DashboardActionForm" class="d-flex flex-wrap align-items-center justify-content-end w-100 gap-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="dateG" value="<%=Date%>">
                <input type="hidden" name="ccmReportUpdate" value="D">
                <input type="hidden" name="digitValueG" value="<%=DigitValue%>">

                <!-- Division -->
              <div class="d-flex align-items-center">
				    <label for="divisionSearch" class="fw-bold " style="width:50%;"><b>Search Division:</b>&nbsp;&nbsp;</label>
				    <input type="text" id="divisionSearch" class="form-control" placeholder="Search using Division name" style="min-width: 350px;" onkeyup="filterCards()" />
				</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                <!-- Financial Year From -->
                <div class="d-flex align-items-center me-3">
                    <label for="FromYear" class="fw-bold me-2"><b>Financial Year:</b>&nbsp;&nbsp;</label>
                    <input type="text" id="FromYear" name="FromYear" style="width: 100px; background-color: white;"
                        class="form-control" onchange="this.form.submit()"
                        value="<% if(fromYear != null) { %><%= fromYear %><% } %>"
                        required readonly>&nbsp;&nbsp;
                </div>

                <!-- Financial Year To -->
                <div class="d-flex align-items-center me-3">
                    <label for="ToYear" class="fw-bold me-2"><b>To</b>&nbsp;&nbsp;</label>
                    <input type="text" id="ToYear" name="ToYear" style="width: 100px; background-color: white;"
                        class="form-control"
                        value="<% if(toYear != null) { %><%= toYear %><% } %>"
                        required readonly>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </div>

   <%if("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType)){ %>
                <!-- Cost Format -->
                <div class="d-flex align-items-center">
                    <label for="CostFormat" class="fw-bold me-2"><b>Cost:</b>&nbsp;&nbsp;&nbsp;</label>
                    <select class="form-control select2" style="width: 120px;" name="AmountFormat" id="CostFormat">
                        <option value="R" <%if(AmtFormat!=null && "R".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Rupees</option>
                        <option value="L" <%if((AmtFormat==null) || "L".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Lakhs</option>
                        <option value="C" <%if("C".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Crores</option>
                    </select>
                </div>
                <%} %>
            </form>
        </div>
    </div>
</div>
<%-- 
                <div style="font-weight: 600;color:#ff8f00;text-align: center;margin-top: 40px;font-size: 20px;">
                <form action="FundRequest.htm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-sm">&nbsp;&nbsp;Go&nbsp;&nbsp;</button>
                </form>  </div> --%>
         
<div style="text-align: center; margin-bottom: 20px;">
   <span style="font-weight: 700;font-size: 16px;">RE - </span>
    <span style="color: #8f550b; font-weight: 600;font-size: 14px;background-color:white;border-radius: 20px;padding: 5px 5px;border: solid"> Fund Request Amount</span> &nbsp; &nbsp;<span style="font-size: 40px">|</span> &nbsp; &nbsp;
    <span style="font-weight: 700;font-size: 16px;">FBE - </span>
    <span style="color: #004a8b; font-weight: 600;font-size: 14px;background-color:white;border-radius: 20px;padding: 5px 5px;border: solid"> Fund Request Amount</span>
</div>

	<div id="noResultMessage" style="display: none; text-align: center; color: red; margin-top: 20px;font-size: 20px;">
	    No matching Division(s) found
	</div>
	
<div class="page card dashboard-card" style="border: 0px;">
    <% if (DivisionDetailsList != null && !DivisionDetailsList.isEmpty()) {
        for (Object[] row : DivisionDetailsList) {
            String divisionName = (String) row[1];
            
            long reCount = row[3] != null && row[3] != "" ? Long.valueOf(row[3].toString()) : 0;
            long fbeCount = row[4] != null && row[4] != "" ? Long.valueOf(row[4].toString()) : 0;
            
            BigDecimal reAmount = new BigDecimal(row[5].toString());
            BigDecimal fbeAmount = new BigDecimal(row[6].toString());
    %>
    <div class="custom-card">
    <div class="card-name" style="font-size: 16px;background-image: linear-gradient(rgb(89 147 191), rgb(28 32 175 / 73%) 50%) !important;" >

            <%= divisionName %> <span>(<%= row[7]%>)</span>
        </div>
        <div class="card-body">
            <div class="row">
                <!-- RE DETAILS -->
                <div class="col-6 border-end Repopup" style="border-right: 1px solid #ccc;" align="center" title="RE Details">
                        <div style="position: absolute; top: -16px;left: -1px;padding: 2px 6px; font-weight: 600; font-size: 16px;color: black;
                        /* border-radius: 4px; */background-image: linear-gradient(rgb(179 157 122), rgb(253 227 204) 50%) !important;border-bottom-right-radius: 12px;"> RE
                        </div>
                        
                <form action="estimateTypeParticularDivList.htm" onclick="this.form.submit()">
                <input type="hidden" name="divisionId" value="<%=row[0]%>">
                <input type="hidden" name="estimateType" value="R">
                <input type="hidden" name="FromYear" value="<%=fromYear%>">
                <input type="hidden" name="ToYear" value="<%=toYear%>">
                
                 <button type="submit" style="all: unset; cursor: pointer; display: block; width: 100%;">
                    <!-- <h5 class="card-title" style="color: #2f3247;"><b>RE DETAILS</b></h5> -->
                    <p style="display: flex; justify-content: center; align-items: center; position: relative;">
					  <span style="font-weight: 600;/*  color: #8f550b; */ font-size: 32px;background-color: #068b35; padding: 4px 10px; border-radius: 50%;color: white;"><%= reCount %></span>
					</p>
                   <hr style="margin: 5px 0; border: none; border-top: 1px solid #ccc;">
                    <p><span style="color: #8f550b;font-weight: 600;<%if(AmtFormat!=null && "R".equalsIgnoreCase(AmtFormat)){ %>font-size: 19px;<%}%><%else if(AmtFormat!=null && "L".equalsIgnoreCase(AmtFormat)){ %>font-size: 24px;<%} %><%else if(AmtFormat!=null && "C".equalsIgnoreCase(AmtFormat)){ %>font-size: 27px;<%} %>"> <%= AmountConversion.amountConvertion(reAmount, AmtFormat) %></span></p>
          	    </button>
                </form>
                </div>

                <!-- FBE DETAILS -->
                <div class="col-6 Fbepopup" align="center" title="FBE Details">
                
                   <div style="position: absolute;top: -16px;left: -1px;padding: 2px 6px;font-weight: 600;
                   font-size: 16px;color: black;/*  border-radius: 4px; */background-color: white;background-image: linear-gradient(rgb(150, 145, 196), rgb(221, 218, 253) 50%) !important;border-bottom-right-radius: 12px;">FBE </div> <!-- linear-gradient(rgb(126 185 223), rgb(176 233 253) 50%) !important -->
            
                <form action="estimateTypeParticularDivList.htm" onclick="this.form.submit()">
                <input type="hidden" name="divisionId" value="<%=row[0]%>">
                <input type="hidden" name="estimateType" value="F">
                <input type="hidden" name="fromYear" value="<%=fromYear%>">
                <input type="hidden" name="toYear" value="<%=toYear%>">
                
                <button type="submit" style="all: unset; cursor: pointer; display: block; width: 100%;">
                    <p style="display: flex; justify-content: center; align-items: center; position: relative;">
					  <span style="font-weight: 600; font-size: 32px; background-color: #d56e04; padding: 4px 10px; border-radius: 50%;color: white;"><%= fbeCount %></span> 
					</p>
                	<hr style="margin: 5px 0; border: none; border-top: 1px solid #ccc;" />
                    <p><span style="color: #004a8b;font-weight: 600;<%if(AmtFormat!=null && "R".equalsIgnoreCase(AmtFormat)){ %>font-size: 19px;<%}%><%else if(AmtFormat!=null && "L".equalsIgnoreCase(AmtFormat)){ %>font-size: 24px;<%} %><%else if(AmtFormat!=null && "C".equalsIgnoreCase(AmtFormat)){ %>font-size: 27px;<%} %>"><%= AmountConversion.amountConvertion(fbeAmount, AmtFormat) %></span></p>
               </button>
                </form>
                </div>
            </div>
        </div>
        
    </div>
    <% } } else {%>
  		<span style="color: red;font-size:20px;font-weight: 600;">No Details Found for the <%=fromYear %> - <%=toYear %> Financial Year</span>
	 <%} %>
</div>



                                


<script>
$("#CostFormat").change(function(){
  var form=$("#DashboardActionForm");
  if(form!=null)
	  {
	  form.submit();
	  }
});

</script>
<script>
   $("#FromYear").datepicker({
	   format: "yyyy",
	     viewMode: "years", 
	     minViewMode: "years",
	     autoclose:true,
         updateViewDate: true,
	     changeYear: true,
	     endDate: new Date().getFullYear().toString()
	});
      $("#FromYear").change(function(){
         var FromYear=$("#FromYear").val();
         var value=parseInt(FromYear)+1;
         $("#ToYear").val(value);
      });
  </script>
<script>
    function filterCards() {
        const input = document.getElementById("divisionSearch");
        const filter = input.value.toLowerCase();
        const cards = document.querySelectorAll(".custom-card");
        let visibleCount = 0;

        cards.forEach(card => {
            const name = card.querySelector(".card-name").textContent.toLowerCase();
            if (name.includes(filter)) {
                card.style.display = "";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });

        // Show or hide "no result" message
        const noResult = document.getElementById("noResultMessage");
        if (visibleCount === 0) {
            noResult.style.display = "block";
        } else {
            noResult.style.display = "none";
        }
    }
</script>

  
</body>

</html>