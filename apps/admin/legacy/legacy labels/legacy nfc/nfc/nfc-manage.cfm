<cfset local.tag_from = ''>
<cfset local.tag_to = ''>
<cfset local.tag_url = ''>
<cfset local.company_name = ''>
<cfset local.decryptedId = 0>
<cfset includePath = "../">

<cfif StructKeyExists(form,"search") AND IsValid('URL',form.search)>
	<cftry>
		<cfset theUrl = listRest(form.search, "?")>
		<cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
		<cfset local.decryptedId = Decrypt(listLast(theUrl, "="),local.key,'BLOWFISH','Hex')>
	<cfcatch type="any"></cfcatch>
	</cftry>
	<cfif StructKeyExists(local,"decryptedId") AND IsNumeric(local.decryptedId)>
		<!--- query DB --->
		<cfquery name="getTag" datasource="#application.datasource#">
		SELECT `tag`.`tag_id`,
			`tag`.`seq_num`,
			`tag`.`product_page`,
			`tag`.`live`,
			`tag`.`client_id`,
			`tag`.`video_url`
		FROM `#application.schema#`.`tag`
		WHERE `tag`.`seq_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.decryptedId#">
		</cfquery>
		<cfif IsNumeric(getTag.client_id)>
			<cfquery name="getClient" datasource="#application.datasource#">
			select company_name,
				   client_url,
				   logo_path
			from #application.schema#.client 
			where client_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getTag.client_id#">
			</cfquery>
			<cfset local.company_name = getClient.company_name>
		</cfif>
	</cfif>
</cfif>

<cfif StructKeyExists(URL,"tag_from")>
	<cfset local.tag_from = URL.tag_from>
</cfif>
<cfif StructKeyExists(URL,"tag_to")>
	<cfset local.tag_to = URL.tag_to>
</cfif>
<cfif StructKeyExists(URL,"tag_url")>
	<cfset local.tag_url = URL.tag_url>  <!---encodeForURL(--->
</cfif>

<!DOCTYPE html>
<html dir="ltr" lang="en">
	<cfinclude template="#includePath#includes/header/header.cfm">
	<body>
		<div id="mainLayout">
			<cfinclude template="#includePath#includes/navigation/left_nav.cfm">
			<div onclick="removeMenu()" class="sideOverlay"></div>
			<cfinclude template="#includePath#includes/header/top_bar.cfm">

			<div class="mainBody">
				<div class="row">
					<div class="col-lg-12">
					<div class="pageTitle">
						<h2><i class="material-icons">rss_feed</i><span>Manage NFC Tags</span></h2>

							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Manage NFC Tags</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-lg-12">
						<div class="card">
							<div class="card-header">
								<h6 class="card-title">Manage Tags</h6>	
							</div>
							<div class="card-body">
								<div class="card card-border mb-4">
									<form action="nfc-manage.cfm" method="post">
										<div class="card-header">
											<h6>Find NFC</h6>
										</div>
										<div class="card-body">
											<div class="findInput mb-4">
												<input type="input" name="search" value="" class="form-control" placeholder="Enter NFC URL">								
												<button type="submit" class="ThemeBtn"> <i class="material-icons">search</i></button>
											</div>
										</div>
									</form>
									<cfif StructKeyExists(form,"search") AND IsNumeric(getTag.seq_num)>
										<div class="table-responsive">
											<table class="table tagList table-bordered">
												<thead>
													<tr>
														<th>Tag Num</th>
														<th>Client</th> 
														<th>URL</th> 
														<th>Video URL</th>                                          
														<th>Edit</th>
													</tr>
												</thead>
												<tbody>
													<cfoutput query="getTag">												
														<tr>
															<td>#getTag.seq_num#</td>
															<td>#local.company_name#</td>
															<td><span id="tag-url"><cfif Len(getTag.product_page) GT 0>#getTag.product_page#<cfelse>Not Assigned</cfif></span></td>
															<td>#getTag.video_url#</td>
															<td>
															  <div class="action-btn">
																<a href="##" class="iconBox" data-bs-toggle="modal" data-bs-target="##responsive-modal">
																<i class="material-icons">mode_edit</i></a>
															  </div>
															</td>															
														</tr>
													</cfoutput>
												</tbody>
											</table>
										</div>
									</cfif>	
								</div>		
								<form id="nfc-redirect-batch-form" method="post">
									<cfoutput>
										<div class="card card-border">
											<div class="card-header">
												<h6>Set NFC URL Redirect</h6>
											</div>								
											<div class="card-body">
												<div class="row">
													<div class="col-lg-3 col-md-3 col-12">
														<input type="input" name="tag_from" value="#local.tag_from#" class="form-control" placeholder="Tag Number From">
													</div>	

													<div class="col-lg-3 col-md-3 col-12">
														<input type="input" name="tag_to" value="#local.tag_to#" class="form-control" placeholder="Tag Number To">
													</div>															
													<div class="col-lg-6 col-md-6 col-12">
														<div class="multiInput-group">
															<input type="input" name="tag_redirect" value="#local.tag_url#" class="form-control" placeholder="Redirect To">
															<button type="submit" id="proceed-btn" class="ThemeBtn" data-bs-toggle="modal" data-bs-target="NFCUpdatedModal"><i class="material-icons">arrow_circle_right</i>Proceed</button>
														</div>
													</div>							
												</div>	
											</div>				
										</div>
									</cfoutput>
								</form>	
							</div>
						</div>
					</div>		
				</div>
			</div>
			<cfinclude template="#includePath#includes/footer/footer.cfm">
		</div>
		
		<cfif IsDefined("getTag.product_page")>

			<!--- Create functions component object --->
			<cfset functionsObj = createObject('component','functions') >
			<cfset getClients = functionsObj.getClientsFunc('nfc-manage')>

			<div id="responsive-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
							<!---<h4 class="modal-title">Modal Content is Responsive</h4>--->
						</div>
						<div class="modal-body">
							<form id="redirect-form" enctype="multipart/form-data">
								<div class="form-group">
									<label for="client" class="control-label">Client</label>
									<select name="client" class="flat-select"> 
										<option data-display="Client">Client</option>
										<cfoutput query="getClients">
											<cfif getTag.client_id EQ getClients.client_id>
												<option value="#getClients.client_id#" selected="selected">#getClients.company_name#</option>
											<cfelse>
												<option value="#getClients.client_id#">#getClients.company_name#</option>
											</cfif>
										</cfoutput>
									</select>									
								</div>
								<div class="form-group">
									<label for="logo-img" class="control-label">Replace Company Logo:</label>
									<cfoutput>
									<input type="file" name="logoImg" id="logo-img" class="form-control" placeholder="Logo Image">
									</cfoutput>
								</div>	
								<div class="form-group">								
									<cfif IsDefined('getClient.logo_path') AND getClient.logo_path CONTAINS 'yourlogohere.png'>
										<input type="checkbox" name="useGenericLogo" id="generic-logo" checked="checked">
									<cfelse>
										<input type="checkbox" name="useGenericLogo" id="generic-logo">
									</cfif>
									<label for="generic-logo" class="control-label">Use "Your Logo Here"?</label>
								</div>										
								<div class="form-group">
									<label for="redirect-url" class="control-label">Redirect URL:</label>
									<cfoutput>
									<input type="text" class="form-control" name="redirectUrl" id="redirect-url" value="#getTag.product_page#">									
									</cfoutput>
								</div>
								<div class="form-group">
									<label for="video-url" class="control-label">Video URL:</label>
									<cfoutput>
									<input type="text" class="form-control" name="videoUrl" id="video-url" value="#getTag.video_url#">
									<input type="hidden" name="tagNum" value="#getTag.seq_num#">
									</cfoutput>
								</div>																						
							</form>
						</div>
						<div class="modal-footer">
							<button type="button" class="ThemeBtn-outline" data-bs-dismiss="modal">Close</button>
							<button type="button" id="save-btn" class="ThemeBtn">Save</button>
						</div>
					</div>
				</div>
			</div>
		</cfif>	
		<cfinclude template="#includePath#/includes/footer/js_files.cfm">
		<script>
			$( document ).ready(function() {
				$( "#save-btn" ).on( "click", function(e) {
					e.preventDefault();
					//var form = $("#redirect-form");
					var form_data = new FormData($('#redirect-form')[0]);
					
					$.ajax({
						type: "POST",
						url: "nfc-url-save.cfm",
						data: form_data, // serializes the form's elements.
						processData: false,
						contentType: false,
						async: false,
						cache: false,
						statusCode: {
								200: function() {							  
									$('#responsive-modal').modal('hide');
									Swal.fire({
									title: 'NFC Updated',
									icon: 'success',
									confirmButtonText: 'OK'
									}).then(function() {
										window.location.reload();
									});	
								},
								400: function() {
									Swal.fire({
										text: "The URL provided is not valid. Please try again.",
										icon: "warning",
										buttonsStyling: false,
										confirmButtonText: "OK",
										width: 'auto',
										customClass: {
											confirmButton: "btn btn-primary"
										}
									});							
								},
								500: function() {
									Swal.fire({
										text: "An unexpected error has occurred. System Administrators have been notified.",
										icon: "error",
										buttonsStyling: false,
										confirmButtonText: "OK",
										width: 'auto',
										customClass: {
											confirmButton: "btn btn-primary"
										}
									});								
								}							
							}
						});

				});
				
				$( "#proceed-btn" ).on( "click", function(e) {
					e.preventDefault();
					$('#proceed-btn').prop("disabled",true);
					
					var form = $("#nfc-redirect-batch-form");	
					
					$.ajax({
						type: "POST",
						url: "nfc-assign-batch-url.cfm",
						data: form.serialize(), // serializes the form's elements.
						statusCode: {
								200: function() {
									Swal.fire({
									title: 'Redirect URLs Updated',
									icon: 'success',
									confirmButtonText: 'OK'
									}).then(function() {
										$('#proceed-btn').prop("disabled",false);
									});	
								},
								400: function() {
									Swal.fire({
										text: "The URL provided is not valid or the tag numbers are not numeric. Please try again.",
										icon: "warning",
										buttonsStyling: false,
										confirmButtonText: "OK",
										width: 'auto',
										customClass: {
											confirmButton: "btn btn-primary"
										}
									});		
									$('#proceed-btn').prop("disabled",false);					
								},
								500: function() {
									Swal.fire({
										text: "An unexpected error has occurred. System Administrators have been notified.",
										icon: "error",
										buttonsStyling: false,
										confirmButtonText: "OK",
										width: 'auto',
										customClass: {
											confirmButton: "btn btn-primary"
										}
									});	
									$('#proceed-btn').prop("disabled",false);							
								}							
							}
						});

				});		
									
			});
		</script>	
	</body>
</html>