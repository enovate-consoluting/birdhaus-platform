<cfset includePath = "../">
    <!DOCTYPE html>
    <html dir="ltr" lang="en">
    	<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
       <cfinclude template="#includePath#includes/header/header.cfm">
	   <style>

input::-webkit-input-placeholder {
    color: #7f757d;
  opacity: 1;
}

input::-moz-placeholder {
    color: #7f757d;
  opacity: 1;
}

input::-ms-placeholder {
    color: #7f757d;
  opacity: 1;
}

input::placeholder {
    color: #7f757d;
  opacity: 1;
}
#report_date{color: #7f757d;}

.flatpickr-current-month input.cur-year
{
    display:none !important;
}


.year-dropdown
{
    margin-left: -40px !important;
    appearance: menulist;
    background: transparent;
    border: none;
    border-radius: 0;
    box-sizing: border-box;
    color: inherit;
    cursor: pointer;
    font-size: inherit;
    font-family: inherit;
    font-weight: 300;
    height: auto;
    line-height: inherit;
    margin: -1px 0 0 0;
    outline: none;
    padding: 0 0 0 .5ch;
    position: relative;
    vertical-align: initial;
    -webkit-box-sizing: border-box;
    -webkit-appearance: menulist;
    -moz-appearance: menulist;
    width: auto;
}
	   </style>
            <body>
                <div id="mainLayout">
                    <cfinclude template="#includePath#includes/navigation/left_nav.cfm">
				    <cfinclude template="#includePath#includes/header/top_bar.cfm">

                    <div class="mainBody">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="pageTitle">
                                    <h2><i class="material-icons">rss_feed</i><span>Error Logs</span></h2>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Error Logs</li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                        </div>
                        <cfoutput>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6>Error Logs</h6>
                                        </div>
                                        <form method="post" class="card-body">
                                            <div class="row align-items-end">
                                                <div class="col-lg-3"> 
                                                    <div class="range-date">
                                                        <label for="report_date" class="fw-bold">Select Date Range</label>
                                                        <div class="applybtn-dash">
                                                            <div class="form-group mb-0">
                                                                <input type="text" id="report_date" name="report_date" class="form-control report_date" placeholder="YYYY-MM-DD - YYYY-MM-DD" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-lg-3"> 
                                                    <div class="form-group custom-checkbox">
														<input name="archived" type="checkbox" id="archived" value="1">
														<label for="archived" class="">Show Archived</label>
													</div>
                                                </div>

                                                <div class="col-lg-2">
                                                    <div class="btn-box d-flex justify-content-end">
                                                        <button type="button" name="filter_rec" id="filter_rec" class="ThemeBtn" onClick="getRecordsNfcErrorLogByAjax();">Apply</button>
                                                    </div>
                                                </div>	
                                            </div>
                                        </form>
                                        <div class="card-body">
					<div style="font-size: 18px; font-weight: 500; margin-bottom: 10px;">Total Records: <span id="totalRecords"></span> </div>					
                                            <div class="table-responsive">
                                                <table id="ManageErrLogTable" class="table table-bordered" style="width:100%">
                                                    <thead>
                                                        <tr>
                                                            <th>Log ID</th>
															<th>Client App</th>
															<th>Serial No</th>
                                                            <th>NFC URL</th>
                                                            <th>Seq ##</th>
                                                            <th>Our Domain</th>
                                                            <th>Double HTTPS</th>
                                                            <th>Active</th>
                                                            <th>Message</th>
                                                            <th>Created At</th>
															<th>Action</th>
                                                        </tr>
                                                    </thead>
												    <tbody id="ManageErrLogTableData" >
												    </tbody>
											    </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cfoutput>
                    </div>
                </div>
                <!--- </div> --->
				<cfinclude template="#includePath#includes/footer/footer.cfm">
			</div>

            <script src="//cdn.jsdelivr.net/npm/flatpickr"></script>
			<cfinclude template="#includePath#includes/footer/js_files.cfm">
            <script src="<cfoutput>#includePath#</cfoutput>nfc/assets/custom.js"></script>
			<script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
            <script>
                $(document).ready(function () {
                    
                    
                    const fp = flatpickr("#report_date", {
                        mode: "range",
                        dateFormat: "Y-m-d",
                        altInput: true,
                        altFormat: "F j, Y",
                        allowInput: true
                    });
                    var currYear = new Date().getFullYear();
                    var endYear = currYear - 99;

                    var yearDropdown = document.createElement("select");
                    yearDropdown.className = "year-dropdown";
                    for (var i = currYear; i >= endYear; i--) {
                        var option = document.createElement("option");
                        option.value = i;
                        option.text = i;
                        yearDropdown.appendChild(option);
                    }

                    $(".flatpickr-current-month").append(yearDropdown);

                    yearDropdown.addEventListener('change', function (evt) {
                        debugger;
                        var dates = fp.selectedDates;
                        var year = evt.target.value;
                        var cmonth = fp.currentMonth;
                        
                        if (dates.length === 0) {
                            fp.setDate(new Date(year, cmonth, 1),new Date(currYear, cmonth, 1));
                        } else {
                            fp.setDate(new Date(year, cmonth, 1));
                        }
                    });                   
                });
            </script>

</body>
</html>
