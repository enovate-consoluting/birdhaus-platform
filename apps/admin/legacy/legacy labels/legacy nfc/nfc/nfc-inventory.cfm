<cfset includePath = "../">
<cfset functionsObj = CreateObject("component","functions")>
<cfset data = functionsObj.getSpoolData()>

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
							<h2><i class="material-icons">rss_feed</i><span>Inventory</span></h2>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Inventory</li>
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
									<h6>Inventory</h6>
								</div>
								<div class="card-body">
									<div class="table-responsive">
										<table id="ManageTrackingTable" class="table table-bordered" style="width:100%">
											<thead>
												<tr>
													<th>Spool ID</th>
													<th>Quantity</th>
													<th>Created</th>
													<th>Client</th>
													<th>Video Url</th>
													<th>Active</th>
													<th>Actions</th>
												</tr>
											</thead>
											<tbody class="loading-data">
												<tr>
													<td colspan="7" class="text-center">
														<span>
															<img src="../../img/spinner.gif">Loading...
														</span>
													</td>
												</tr>
											</tbody>
											<tbody id="ManageTrackingTableData" style="display: none;">
												<cfif data.recordCount GT 0>
													<cfloop query="#data#">
														<tr>
															<td>
																<div class="d-flex align-items-center">
																	<div class="d-flex justify-content-start flex-column">
																		<span>#data.spool_id#</span>
																		<span></span>
																	</div>
																</div>
															</td>
															<td>
																<span>#data.num_tags#</span>
															</td>															
															<td>
																<span>#DateTimeFormat(data.create_dt,'short')#</span>
															</td>
															<td>
																<span>#data.company_name#</span>
															</td>
															<cfquery name="getVideoUrl" datasource="#application.datasource#">
																SELECT 
																	`tag`.`video_url`
																FROM
																	`#application.schema#`.`tag`
																WHERE
																	`tag`.`spool_id` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.spool_id#">
																LIMIT 1;
															</cfquery>
															<td>
																<a href="#getVideoUrl.video_url#" target="_blank">
																	<span>#getVideoUrl.video_url#</span>
																</a>
															</td>
															<td>
																<div class="form-check form-switch form-switch-sm form-check-custom form-check-solid">						
																	
																		<input class="form-check-input" type="checkbox" name="spool-active" value="active" disabled <cfif data.active GT 0>checked="checked"</cfif>>
																							
																</div>															
															</td>
															<td>
																<div class="action-btn">
																	<button onclick="getInventry('#data.spool_id#')" class="iconBox">
																		<i class="material-icons">mode_edit</i></a>
																	</button>
																</div>
															</td>
														</tr>
													</cfloop>
												</cfif>
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
		<div class="modal fade" id="addNfcInventory" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addNfcInventory" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
				<div class="modal-content">
					<div class="modal-header">
						<h6 class="modal-title" id="addUserModalLabel">Update Spool</h6>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div id="spoolModalData">

					</div>
				</div>
			</div>
        </div>
			<cfinclude template="#includePath#includes/footer/footer.cfm">
        </div>
		<cfinclude template="#includePath#includes/footer/js_files.cfm">
	</body>
</html>