<cfset includePath = "../">
<cfset client_name = "">
<cfset scan_count = "">
<cfset status = "">
<cfif isDefined('form.filter_rec')>
	<cfset client_name = form.client_name />
	<cfset scan_count = form.scan_count />
	<cfset status = form.status>
</cfif>

<cfset functionsObj = CreateObject("component","functions")>
<cfset data = functionsObj.getSpecificTrackingData(client_name,scan_count,status)>

<cfset getApprovedClients = functionsObj.getApprovedClients()>

<!DOCTYPE html>
<html dir="ltr" lang="en">
	<cfinclude template="#includePath#includes/header/header.cfm">
	<body>
		<div id="mainLayout">
			<cfinclude template="#includePath#includes/navigation/left_nav.cfm">
			<cfinclude template="#includePath#includes/header/top_bar.cfm">

			<div class="mainBody">
				<div class="row">
					<div class="col-lg-12">
						<div class="pageTitle">
							<h2><i class="material-icons">rss_feed</i><span>Tracking</span></h2>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Tracking</li>
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
									<h6>Tracking</h6>
								</div>
								<form method="post" class="card-body">
									<div class="row align-items-end">
										<div class="col-lg-4">
											<div class="form-group mb-0">
												<label class="fw-bold" for="client_name" >Select Client</label>
												<select name="client_name" id="client_name" class="form-control nice-select" style="width: 50%;">
													<option value="" selected>Select a client</option>
													<cfloop query="getApprovedClients">
														<option value="#getApprovedClients.company_name#" <cfif isDefined('FORM.client_name') AND FORM.client_name EQ "#getApprovedClients.company_name#">selected</cfif>>#getApprovedClients.company_name#</option>
													</cfloop>
												</select>
											</div>
										</div>
				
										<div class="col-lg-3">
											<label class="fw-bold" for="scan_count">Select Scan Count</label>
											<select name="scan_count" class="nice-select" style="width: 50%;" id="scan_count">
												<option value="" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "">selected</cfif>>All</option>
												<option value="5" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "5">selected</cfif>>More than 5</option>
												<option value="10" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "10">selected</cfif>>More than 10</option>
												<option value="20" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "20">selected</cfif>>More than 20</option>
											</select>
										</div>
										<div class="col-lg-3">
											<label class="fw-bold" for="status">Select Status</label>
											<select name="status" class="nice-select" style="width: 50%;" id="status">
												<option value="" <cfif isDefined('FORM.status') AND FORM.status EQ "">selected</cfif>>All</option>
												<option value="1" <cfif isDefined('FORM.status') AND FORM.status EQ "1">selected</cfif>>Active</option>
												<option value="0" <cfif isDefined('FORM.status') AND FORM.status EQ "0">selected</cfif>>Inactive</option>
											</select>
										</div>
										<div class="col-lg-2">
											<div class="btn-box">
												<button type="button" name="filter_rec" id="filter_rec" class="ThemeBtn" onClick="getRecordsByAjax();">Apply</button>
											</div>
										</div>				
									</div>
								</form>
								<div class="card-body">
									<div class="row">
										<div class="col-lg-4">
											<span style="font-weight:500;">Total NFCs being scanned:</span><span id="totalNFCs"></span>
										</div>
										<div class="col-lg-4">
											<span style="font-weight:500;">Total Scan Count:</span><span id="totalScanCount"></span>
										</div>
									</div>
									<div class="table-responsive">
										<table id="ManageTrackingnfc" class="table table-bordered" style="width:100%">
											<thead>
												<tr>
													<th>Spool Id</th> 
													<th>Seq Number</th> 
													<th>Client</th>
													<th>Product Page</th>
													<th>Scan Counts</th>
													<th>Active</th>
													<th>Actions</th>
												</tr>
											</thead>
											
											<tbody id="ManageTrackingTableData">
												
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
		<div class="modal fade" id="viewTrackingdetail_model" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="EditTrackingModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable" id="productTrackingdetail">

            </div>
        </div>
			<cfinclude template="#includePath#includes/footer/footer.cfm">
        </div>
		<cfinclude template="#includePath#includes/footer/js_files.cfm">
		<script>
			getRecordsByAjax();
		</script>
	</body>
</html>