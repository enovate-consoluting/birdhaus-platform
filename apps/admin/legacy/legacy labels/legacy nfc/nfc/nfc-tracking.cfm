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
<!---<cfset data = functionsObj.getSpecificTrackingData(client_name,scan_count,status)>--->

<cfset getApprovedClients = functionsObj.getApprovedClients()>
	
<!DOCTYPE html>
<html dir="ltr" lang="en">
	<cfinclude template="#includePath#includes/header/header.cfm">
		<style>
			.fil_icon {
		padding: .375rem 14px;
		font-size: 14px;
		line-height: 1.5;
		color: #000;
		border: 1px solid var(--clr-input-border);
		appearance: none;
		display: flex;
		font-weight: 600;
		align-items: center;
		margin-left: 10px;
		height: 40px;
		border-radius: 4px;
		width: max-content;
		cursor: pointer;
	}
	.fil_icon:hover{color: #000;}
	.fil_icon img {
		width: 20px;
		margin-right: 6px;
	}
	.form-group.seq {
margin-top: 20px;
position: relative;
top: 3px;
}
	.select2-container{z-index: 0;}



	.modal-box {
width: 100%;
max-width: 500px;
}

/* Custom Multi Select */
.sd-multiSelect {
position: relative;
}
.sd-multiSelect .placeholder {
opacity: 1;
background-color: transparent;
cursor: pointer;
}
.sd-multiSelect .ms-offscreen {
height: 1px;
width: 1px;
opacity: 0;
overflow: hidden;
display: none;
}

.sd-multiSelect .sd-CustomSelect {
width: 100% !important;
}

.sd-multiSelect .ms-choice {
position: relative;
text-align: left !important;
width: 100%;
border: 1px solid #e3e3e3;
background: #ffff;
box-shadow: none;
font-size: 15px;
height: 44px;
font-weight: 500;
color: #212529;
line-height: 1.5;
-webkit-appearance: none;
-moz-appearance: none;
appearance: none;
border-radius: 0.25rem;
transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.sd-multiSelect .ms-choice:after {
content: "expand_more";
font-family: "Material Icons";
position: absolute;
right: 10px;
top: 50%;
transform: translateY(-50%);
font-size: 26px;
}



.sd-multiSelect .ms-drop.bottom {
display: none;
background: #fff;
border: 1px solid #e5e5e5;
padding: 10px;
overflow:auto;
}

.sd-multiSelect .ms-drop li {
position: relative;
margin-bottom: 10px;
}

.sd-multiSelect .ms-drop li input[type="checkbox"] {
padding: 0;
height: initial;
width: initial;
margin-bottom: 0;
display: none;
cursor: pointer;
}

.sd-multiSelect .ms-drop li label {
cursor: pointer;
user-select: none;
-ms-user-select: none;
-moz-user-select: none;
-webkit-user-select: none;
}

.sd-multiSelect .ms-drop li label:before {
content: "";
-webkit-appearance: none;
background-color: #fff;
border:1px solid #6c757d;
padding: 8px;
display: inline-block;
position: relative;
vertical-align: middle;
cursor: pointer;
margin-right: 5px;
}

.sd-multiSelect .ms-drop li input:checked + span:after {
position: absolute;
content: '';
display: block;
width: 6px;
height: 12px;
border: solid #ffffff;
/* background: var(--clr-primary); */
border-width: 0 2px 2px 0;
transform: rotate(45deg);
z-index: 9;
top: 5px;
left: 6px;
}

.sd-multiSelect .ms-drop li input:checked + span:before{
background: var(--clr-primary);
position: absolute;
top: 3px;
left: 0px;
content: '';
display: block;
width: 18px;
height: 19px;
z-index: 0;
}

.ms-parent.nice-select.sd-CustomSelect {
display: none;
}
#filteringModalCenter .modal-dialog{max-width: 548px;}

		</style>
	<body>
		<div id="mainLayout">
			<cfinclude template="#includePath#includes/navigation/left_nav.cfm">
			<cfinclude template="#includePath#includes/header/top_bar.cfm">

			<div class="mainBody">
				<div class="row">
					<div class="col-lg-12">
						<div class="pageTitle">
							<h2><i class="material-icons">fingerprint</i><span>Identify</span></h2>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Identify</li>
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
									<h6>Identify</h6>
								</div>
								<form method="post" class="card-body">
									<div class="row align-items-end">
										<div class="col-lg-4">
											<div class="form-group mb-0">
												<label class="fw-bold" for="client_name" >Select Client</label>
			                                    <div class="select-flex">
				                                    <select name="client_name" id="client-dropdown" class="form-control client-dropdown" style="width: 50%;">
													    <option value="" selected>Select a client</option>
													    <cfloop query="getApprovedClients">
														    <option value="#getApprovedClients.company_name#" <cfif isDefined('FORM.client_name') AND FORM.client_name EQ "#getApprovedClients.company_name#">selected</cfif>>#getApprovedClients.company_name#</option>
													    </cfloop>
												    </select>
												</div>
											</div>
										</div>
				
										<div class="col-lg-4">
											<label class="fw-bold" for="scan_count">Select Scan Count</label>
											<select name="scan_count" class="nice-select" style="width: 50%;" id="scan_count">
												<option value="" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "">selected</cfif>>All</option>
												<option value="5" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "5">selected</cfif>>More than 5</option>
												<option value="10" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "10">selected</cfif>>More than 10</option>
												<option value="20" <cfif isDefined('FORM.scan_count') AND FORM.scan_count EQ "20">selected</cfif>>More than 20</option>
											</select>
										</div>
										<div class="col-lg-4">
											<label class="fw-bold" for="status">Select Status</label>
											<select name="status" class="nice-select" style="width: 50%;" id="status">
												<option value="" <cfif isDefined('FORM.status') AND FORM.status EQ "">selected</cfif>>All</option>
												<option value="1" <cfif isDefined('FORM.status') AND FORM.status EQ "1">selected</cfif>>Active</option>
												<option value="0" <cfif isDefined('FORM.status') AND FORM.status EQ "0">selected</cfif>>Inactive</option>
											</select>
										</div>
										<div class="col-lg-4">
											<div class="form-group seq">
												<label class="fw-bold" for="seq_num">Sequence Number</label>
												<input type="text" name="seq_num" id="seq_num" class="form-control" value="<cfif isDefined('FORM.seq_num')>#FORM.seq_num#</cfif>">
											</div>
										</div>
										<div class="col-lg-4">
											<div class="form-group seq">
												<label class="fw-bold" for="seq_num">Encrypted ID</label>
												<input type="text" name="enc_id" id="enc_id" class="form-control" value="<cfif isDefined('FORM.enc_id')>#FORM.enc_id#</cfif>">
											</div>
										</div>										
										<div class="col-lg-4">
											<div class="btn-box">
												<a class="fil_icon" class="btn btn-primary" onclick="openAdvanceFilter();"><img src="img/filtericon.svg"> Advance Filter </a>
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
		<div class="modal fade" id="advanceFilterModal" tabindex="-1" role="dialog" aria-labelledby="filterModalCenterTitle" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered" role="document">
			  <div class="modal-content">
				<div class="modal-header">
				  <h5 class="modal-title" id="exampleModalCenterTitle">Advance Filter</h5>
				  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				  </button>
				</div>
				<div class="modal-body">
					
				</div>
				<div class="modal-footer">
				  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				  <button type="button" class="btn btn-primary" onClick="getRecordsByAjax();">Apply</button>
				</div>
			  </div>
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
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script> 

		<script src="https://bsite.net/savrajdutta/cdn/multi-select.js"></script>
		
	</body>
</html>