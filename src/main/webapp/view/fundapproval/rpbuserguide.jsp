<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RPB User Guide</title>
    <link rel="stylesheet" href="./webjars/bootstrap/4.0.0/css/bootstrap.min.css" />
    <!-- ----------  fontawesome  ---------- -->
	<spring:url value="/webresources/fontawesome/css/all.css" var="fontawesome" />     
	<link href="${fontawesome}" rel="stylesheet" />
    <style>
        .main-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* Sticky sidebar */
        .sidebar {
            width: 200px;
            background: linear-gradient(to right, #021B79);
            color: #ffffff;
            padding: 20px 10px;
            display: flex;
            flex-direction: column;
            position: sticky;
            top: 0;
            height: 100vh;
        }

        .sidebar.expanded {
            width: 65px;
        }

        .toggle-btn {
            background: #cde3e2;
            border: 1px solid #cde3e2;
            cursor: pointer;
            font-size: 20px;
            margin-bottom: 20px;
        }

        .menu-container {
            flex: 1;
            overflow-y: auto;
            overflow-x: hidden;
            scrollbar-width: thin;
            scrollbar-color: #0d6efd #0d6efd;
            max-height: calc(100vh - 60px);
        }

        .menu-container::-webkit-scrollbar {
            width: 8px;
        }

        .menu-container::-webkit-scrollbar-track {
            background: #0d6efd;
            border-radius: 10px;
        }

        .menu-container::-webkit-scrollbar-thumb {
            background-color: #0d6efd;
            border-radius: 10px;
            border: 2px solid #0d6efd;
        }

        .menu-container::-webkit-scrollbar-thumb:hover {
            background-color: #0d6efd;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 18px;
            color: #ffffff;
            transition: background 0.2s;
        }

        .menu-item:hover {
            background-color: #f0f9f8;
            color: #0d6efd;
        }

        .menu-item.active {
            background-color: #e6f4f2;
            color: #0d6efd;
            font-weight: 500;
        }

        /* Content styling */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        .content-section {
            display: none;
        }

        .content-section.active {
            display: block;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            .main-wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-radius: 0;
                height: auto;
                position: relative;
            }

            .sidebar.collapsed {
                width: 100% !important;
                padding: 10px !important;
                align-items: flex-start;
            }

            .sidebar.collapsed .menu-item {
                justify-content: flex-start;
                font-size: 18px;
            }

            .sidebar.collapsed .menu-item span {
                display: inline;
            }
        }

        .toggle-btn:focus {
            outline: none;
            box-shadow: none;
        }

        .card-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            user-select: none;
            font-size: 18px;
        }

        .list-group-numbered {
            counter-reset: section;
            padding-left: 0;
            list-style: none;
        }

        .list-group-numbered>.list-group-item::before {
            counter-increment: section;
            content: counter(section) ". ";
            font-weight: bold;
            margin-right: 10px;
        }

        .card-hover {
            background: white !important;
        }

        .card-hover:hover {
            color: white !important;
            background: linear-gradient(to right, #106bce, #0ffcbe) !important;
            transition: width 0.4s ease-in-out;
        }

        a:hover {
            color: #333;
            text-decoration: none;
        }

        html {
            scroll-behavior: smooth;
        }

        .scrollable {
            height: 250px;
            /* or any height you want */
            overflow-y: auto;
            /* scrolls vertically */
        }

        /* COLLAPSED sidebar */
        .sidebar.collapsed {
            width: 70px !important;
            padding: 20px 5px !important;
            align-items: center;
        }

        .sidebar.collapsed .menu-item {
            justify-content: center;
            font-size: 20px;
        }

        .sidebar.collapsed .menu-item span:not(.tooltip-icon) {
            display: none;
        }

        .sidebar .sidebar-title {
            transition: opacity 0.3s ease;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Hide title when collapsed */
        .sidebar.collapsed .sidebar-title {
            display: none;
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }



        .sidebar .menu-item i {
            display: none;
        }

        .sidebar.collapsed .menu-item i {
            display: block;
        }

        .tooltip {
            pointer-events: none;
        }

        .tooltip-inner {
            background-color: #0d6efd !important;
            color: white !important;
            font-weight: bold;
        }

        .bs-tooltip-right .arrow {
            border-right: #0d6efd !important;
        }

        #topBtn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 999;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 50%;
            font-size: 16px;
            cursor: pointer;
            display: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        }

        #topBtn:hover {
            background-color: #1d7b34;
        }
    </style>
</head>

<body>
    <div class="main-wrapper">
        <!-- Starting line of Sidebar Content -->
        <div class="sidebar" id="sidebar"> <!-- 'collapsed' class controls the state -->
            <div class="d-flex gap-2 align-items-center sidebar-header">
                <h5 class="sidebar-title">RPB Guide</h5>
                <button class="toggle-btn" onclick="toggleSidebar()"><i class="fa fa-bars"></i></button>
            </div>
            <div class="menu-container mt-3">
                <div class="menu">
                    <a href="#" class="menu-item active" data-target="Fund Request" data-toggle="tooltip"
                        data-placement="right" title="Fund Request">
                        <i class="fa fa-caret-right"></i>
                        <span class="menu-text">Fund Request</span>
                    </a>
                    <a href="#" class="menu-item" data-target="Fund Approval" data-toggle="tooltip"
                        data-placement="right" title="Fund Approval">
                        <i class="fa fa-caret-right"></i>
                        <span class="menu-text">Fund Approval</span>
                    </a>
                    <a href="#" class="menu-item" data-target="Fund Report" data-toggle="tooltip" data-placement="right"
                        title="Fund Report">
                        <i class="fa fa-caret-right"></i>
                        <span class="menu-text">Fund Report</span>
                    </a>
                </div>
            </div>
        </div>
        <!-- Ending line of Sidebar Content -->
        <div class="main-content">
            <!-- Starting line of Fund Request Content -->
            <div id="Fund Request" class="content-section active">
                <div class="card border-primary">
                    <div class="card-header bg-primary text-white">
                        <h5 class="ml-3">
                            Fund Request
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            Users can submit fund requests either for <strong>RE (Revised Estimate)</strong> for current
                            financial year or <strong>FBE (Forecast Budget Estimate)</strong> for next financial year.
                        </div>
                        <div class="alert alert-info" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            Note: Users can initiate a new request or choose to carry forward from an existing demand,
                            an existing supply order, or a previous year's request, based on their requirement.
                        </div>
                        <div class="alert alert-info" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            At the top, users can select either <strong>RE (Revised Estimate)</strong> or <strong>FBE
                                (Forecast Budget Estimate)</strong>, depending on the type of request they need to
                            initiate.
                        </div>
                        <h5 class="text-primary">
                            To Initiate New Request
                        </h5>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Request</strong>
                                <i class="fa fa-chevron-right"></i> <strong class="text-success">New Request.</strong>
                            </li>
                            <li class="list-group-item">
                                <strong>Fill the Details:</strong>
                                <br>
                                <em>
                                    Budget-General, Budget Head, Budget Item, Probable Date of Demand Initiation,
                                    Initiating
                                    Officer,
                                    Nomenclature, Justification, <strong>Estimated Cost: Enter the cost as per the cash
                                        outgo for each month</strong> and
                                    <strong>Enclosures: Provision to upload supporting documents (if required),
                                        including Justification, Cost Estimation, BQS/LPO, etc.
                                    </strong>

                                </em> <i class="fa fa-chevron-right"></i> Click <strong
                                    class="text-success">Submit.</strong>
                            </li>
                            <h6 class="text-primary">To edit item details</h6>
                            <li class="list-group-item">Click <i class="fa fa-edit"></i>Edit item details <i
                                    class="fa fa-chevron-right"></i>
                                <strong class="text-success">Edit Item Details</strong> <i
                                    class="fa fa-chevron-right"></i> Click Submit.

                            </li>
                            <h6 class="text-primary mt-2">To forward item for approval</h6>
                            <div class="alert alert-info mt-2" role="alert">
                                <i class="fa fa-info-circle me-2"></i>
                                <strong>The approval workflow varies based on fund request amount.
                                    If amount is:</strong>
                                <ul class="list group list-group-numbered">
                                    <li class="list-group-item"> <strong> Up to Rs. 10 Lakhs:
                                            <i class="fa fa-chevron-right"></i> GH/GD/TD (User) <i
                                                class="fa fa-chevron-right"></i> RPB Member Secretary <i
                                                class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                        </strong></li>
                                    <li class="list-group-item"> <strong> Above Rs. 10 Lakhs & Up to Rs. 50 Lakhs:
                                            <i class="fa fa-chevron-right"></i> GD/TD (User)
                                            <i class="fa fa-chevron-right"></i> One RPB Member <i
                                                class="fa fa-chevron-right"></i> One Subject Expert <i
                                                class="fa fa-chevron-right"></i> RPB Member Secretary
                                            <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                        </strong></li>
                                    <li class="list-group-item"> <strong> Above Rs. 50 Lakhs & Up to Rs. 2 Crore:
                                            <i class="fa fa-chevron-right"></i> GD/TD (User)
                                            <i class="fa fa-chevron-right"></i> Two RPB Members <i
                                                class="fa fa-chevron-right"></i> One Subject Expert <i
                                                class="fa fa-chevron-right"></i> RPB Member Secretary
                                            <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                        </strong></li>
                                    <li class="list-group-item"> <strong>Above Rs. 2 Crore:
                                            <i class="fa fa-chevron-right"></i> GD/TD (User)
                                            <i class="fa fa-chevron-right"></i> Three RPB Members <i
                                                class="fa fa-chevron-right"></i> One Subject Expert <i
                                                class="fa fa-chevron-right"></i> RPB Member Secretary
                                            <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                        </strong></li>
                                </ul>
                            </div>
                            <li class="list-group-item">Click on <i class="fa fa-share"></i> Forward item for approval
                                <i class="fa fa-chevron-right"></i> Select the appropriate employee to approve the
                                request based on the estimated cost. <i class="fa fa-chevron-right"></i>
                                Click <strong class="text-success">Forward.</strong>
                                <div class="alert alert-info mt-2" role="alert">
                                    <i class="fa fa-info-circle me-2"></i>
                                    Note: If Recommending Officer has not recommended ,the user can revoke the request.
                                </div>
                            </li>

                        </ul>
                        <h5 class="text-primary">
                            To initiate request for an existing demand (Carry Forward Demand (CF))
                        </h5>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Request</strong>
                                <i class="fa fa-chevron-right"></i> <strong class="text-success">CF Demand</strong>
                            </li>
                            <li class="list-group-item">Select Demand's you need to transfer <i
                                    class="fa fa-chevron-right"></i>
                                <strong class="text-success">Enter the cost as per the cash
                                    outgo for each month.</strong> <i class="fa fa-chevron-right"></i>
                                Click <strong class="text-success">Submit.</strong>
                            </li>
                        </ul>
                        <h5 class="text-primary">
                            To initiate request for a supply order (Carry Forward Existing Supply Order)
                        </h5>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Request</strong>
                                <i class="fa fa-chevron-right"></i> <strong class="text-success">CF Supply
                                    Order</strong>
                            </li>
                            <li class="list-group-item">Select Demand's you need to transfer <i
                                    class="fa fa-chevron-right"></i>
                                <strong class="text-success">Enter the cost as per the cash
                                    outgo for each month.</strong> <i class="fa fa-chevron-right"></i>
                                Click <strong class="text-success">Submit.</strong>
                            </li>
                        </ul>
                        <h5 class="text-primary">
                            To initiate request for previous year's existing request (Carry Forward Previous Year
                            Existing Request)
                        </h5>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Request</strong>
                                <i class="fa fa-chevron-right"></i> <strong class="text-success">Carry Forward
                                    Request</strong>
                            </li>
                            <li class="list-group-item">Select Demand's you need to transfer <i
                                    class="fa fa-chevron-right"></i>
                                <strong class="text-success">Enter the cost as per the cash
                                    outgo for each month.</strong> <i class="fa fa-chevron-right"></i>
                                Click <strong class="text-success">Submit.</strong>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- Ending line of Fund Request Content -->
            <!-- Starting line of Fund Approval Content -->
            <div id="Fund Approval" class="content-section ">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h5 class="ml-3">
                            Fund Approval
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info mt-2" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            <strong>The approval workflow varies based on fund request amount.
                                If amount is:</strong>
                            <ul class="list group list-group-numbered">
                                <li class="list-group-item"> <strong> Up to Rs. 10 Lakhs:
                                        <i class="fa fa-chevron-right"></i> GH/GD/TD (User) <i
                                            class="fa fa-chevron-right"></i> RPB Member Secretary <i
                                            class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                    </strong></li>
                                <li class="list-group-item"> <strong> Above Rs. 10 Lakhs & Up to Rs. 50 Lakhs:
                                        <i class="fa fa-chevron-right"></i> GD/TD (User)
                                        <i class="fa fa-chevron-right"></i> One RPB Member <i
                                            class="fa fa-chevron-right"></i> One Subject Expert <i
                                            class="fa fa-chevron-right"></i> RPB Member Secretary
                                        <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                    </strong></li>
                                <li class="list-group-item"> <strong> Above Rs. 50 Lakhs & Up to Rs. 2 Crore:
                                        <i class="fa fa-chevron-right"></i> GD/TD (User)
                                        <i class="fa fa-chevron-right"></i> Two RPB Members <i
                                            class="fa fa-chevron-right"></i> One Subject Expert <i
                                            class="fa fa-chevron-right"></i> RPB Member Secretary
                                        <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                    </strong></li>
                                <li class="list-group-item"> <strong>Above Rs. 2 Crore:
                                        <i class="fa fa-chevron-right"></i> GD/TD (User)
                                        <i class="fa fa-chevron-right"></i> Three RPB Members <i
                                            class="fa fa-chevron-right"></i> One Subject Expert <i
                                            class="fa fa-chevron-right"></i> RPB Member Secretary
                                        <i class="fa fa-chevron-right"></i> RPB Standby Chairman / Chairman.
                                    </strong></li>
                            </ul>
                        </div>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Approval</strong> <i
                                    class="fa fa-chevron-right"></i>
                                Click on <strong class="text-success">Recommend/Approve</strong> button.</li>
                            <li class="list-group-item">Enter Remarks <i class="fa fa-chevron-right"></i> The
                                Recommending/Approving Officer can <strong class="text-success">
                                    Recommend/Approve
                                </strong> or <strong class="text-danger">Return</strong>.</li>
                        </ul>
                        <div class="alert alert-info mt-2" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            <strong>Note:</strong>
                            Once the Division Head has recommended the fund request, it shall proceed to the RPB Member
                            for recommendation based on the fund request amount. After the RPB Member's recommendation,
                            it will move to the RPB Member Secretary for forwarding. Finally, it will be sent to the RPB
                            Chairman or Stand-by Chairman for final approval. At each stage, only after approval by the
                            current authority, the next authority can take action.
                        </div>
                    </div>
                </div>
            </div>
            <!-- Ending line of Fund Approval Content -->
            <!-- Starting line of Fund Report Content -->
            <div id="Fund Report" class="content-section ">
                <div class="card border-success">
                    <div class="card-header bg-success text-white">
                        <h5 class="ml-3">
                            Fund Report
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info mt-2" role="alert">
                            <i class="fa fa-info-circle me-2"></i>
                            <strong>Note:</strong>
                            Users can filter the fund report based on From Date / To Date, RE or FBE Type, Approval Status, Budget Head, and Cost Range.
                        </div>
                        <ul class="list-group list-group-numbered">
                            <li class="list-group-item">Click <strong class="text-success">Fund Report</strong> from the main menu.
                            </li>
                            <li class="list-group-item">Apply the required filters(if needed). <i class="fa fa-chevron-right"></i>
                            Click on <i class="fa fa-file-pdf-o text-danger" aria-hidden="true"></i> or <i class="fa fa-file-excel-o text-success" aria-hidden="true"></i> to download in PDF/Excel format. </li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- Ending line of Fund Report Content -->
        </div>
    </div>
    </div>
    <!-- Back to Top Button -->
    <button onclick="scrollToTop()" id="topBtn" title="Go to top">
        <i class="fa fa-arrow-up"></i>
    </button>
    <script src="https://code.jquery.com/jquery-3.4.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script>
        // Show the button after scrolling down 100px
        window.onscroll = function () {
            const topBtn = document.getElementById("topBtn");
            if (document.body.scrollTop > 100
                || document.documentElement.scrollTop > 100) {
                topBtn.style.display = "block";
            } else {
                topBtn.style.display = "none";
            }
        };

        // Smooth scroll to top
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }
    </script>
    <script>
        $(function () {
            $('[data-toggle="tooltip"]').tooltip({
                container: 'body',
                boundary: 'window'
            })
        })
    </script>
    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('collapsed');
        }

        // Menu click handler to switch active menu and content
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', e => {
                e.preventDefault();

                // Remove active from all menu items
                document.querySelectorAll('.menu-item').forEach(mi => mi.classList.remove('active'));
                // Add active to clicked menu item
                item.classList.add('active');

                // Hide all content sections
                document.querySelectorAll('.content-section').forEach(section => {
                    section.classList.remove('active');
                });

                // Show the target content section if exists
                const targetId = item.getAttribute('data-target');
                const targetSection = document.getElementById(targetId);
                if (targetSection) {
                    targetSection.classList.add('active');
                }
            });
        });
    </script>

</body>

</html>