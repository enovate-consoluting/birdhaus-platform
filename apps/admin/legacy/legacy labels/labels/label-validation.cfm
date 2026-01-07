<cfset includePath = "../">
<cfif StructKeyExists(form,"code") AND Len(form.code) GT 0>
	
	<cfif StructKeyExists(form,"reset") AND StructKeyExists(form,"label_type") AND form.label_type EQ 'legacy'>
		<cfquery name="resetVerifyOnceLegacy" datasource="#application.datasource#">
		UPDATE `#application.schema#`.`label_validation`
		SET `label_validation`.`reset` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		WHERE `label_validation`.`validation_code` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.code)#"> and
		      `label_validation`.`validation_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.validation_id#">
		</cfquery>			
	<cfelseif StructKeyExists(form,"reset") AND StructKeyExists(form,"label_type") AND form.label_type EQ 'password'>
		<cfquery name="resetVerifyOncePassword" datasource="#application.datasource#">
		UPDATE `#application.schema#`.`label_password_validation`
		SET `label_password_validation`.`reset` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		WHERE `label_password_validation`.`password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.code)#"> and
		      `label_password_validation`.`label_pass_val_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.validation_id#">
		</cfquery>
	<cfelseif StructKeyExists(form,"override") AND StructKeyExists(form,"label_type") AND form.label_type EQ 'password'>
	
		<cfquery name="verifyOnceOverride" datasource="#application.datasource#">
		UPDATE `#application.schema#`.`label_password`
		<cfif StructKeyExists(form,"verify_once_override")>
			SET `label_password`.`verify_once_override` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
		<cfelse>
			SET `label_password`.`verify_once_override` = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">
		</cfif>
		WHERE `label_password`.`password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.code)#">     
		</cfquery>			
	</cfif>
	
	<!--- Create functions component object --->
	<cfset functionsObj = createObject('component','functions') >
	<cfset getLabelValidations = functionsObj.getLabelValidationsFunc(form.code)>
	
	<cfset local.verify_once = getLabelValidations.verify_once>
	<cfset local.verify_once_override = ''>
	<cfset local.validation_id = getLabelValidations.validation_id>
	<cfset local.label_type = 'legacy'>	
	
	<cfif getLabelValidations.recordcount EQ 0>	

		<cfset getPasswordDetail = functionsObj.getPasswordDetailFunc(form.code)>
		<cfset getPasswordValidations = functionsObj.getPasswordValidationsFunc(form.code)>
		
		<cfset local.verify_once = getPasswordDetail.verify_once>
		<cfset local.verify_once_override = getPasswordDetail.verify_once_override>
		<cfset local.validation_id = getPasswordValidations.label_pass_val_id>
		<cfset local.label_type = 'password'>
		
	</cfif>
</cfif>

<!DOCTYPE html>
<html dir="ltr" lang="en">
	<cfinclude template="#includePath#/includes/header/header.cfm">
	<body>
		<div id="mainLayout">
			<cfinclude template="#includePath#includes/navigation/left_nav.cfm">
			<div onclick="removeMenu()" class="sideOverlay"></div>
			<cfinclude template="#includePath#includes/header/top_bar.cfm">
			<div class="mainBody">
				<div class="row">
					<div class="col-lg-12">
						<div class="pageTitle">
							<h2><i class="material-icons">search</i><span>Manage Validations</span></h2>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="/admin/dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Manage Validations</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-lg-12">
						<div class="card">
							<form action="label-validation.cfm" method="post">
								<div class="card-header">	
									<h6>Search Label</h6>
								</div>
								<div class="card-body">
									<div class="findInput">
										<input type="text" class="form-control" name="code" placeholder="Enter label">
										<button type="submit" class="ThemeBtn">
											<i class="material-icons">search</i>
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<cfif StructKeyExists(form,"code") AND Len(form.code) GT 0>	
					<div class="row mb-4">
						<div class="col-lg-12">
							<div class="card">
								<div class="card-header">
									<h6>Verify Once</h6>
								</div>
								<cfif local.verify_once EQ 'Y' AND local.verify_once_override NEQ 'N' AND IsDefined('getPasswordValidations.recordcount') AND (getPasswordValidations.recordcount GT 0 OR getLabelValidations.recordcount GT 0)>
									<div class="btn-box mt-4">																
										<form action="label-validation.cfm" method="post">
											
											<button type="submit" class="ThemeBtn"> Reset Validation</button>
											<input type="hidden" name="reset" value="reset">
											<cfoutput>
												<input type="hidden" name="code" value="#Trim(form.code)#">
												<input type="hidden" name="validation_id" value="#local.validation_id#">	
												<input type="hidden" name="label_type" value="#local.label_type#">									
											</cfoutput>
										</form>
									</div>
								</cfif>
								<div class="card-body">
									<form action="label-validation.cfm" method="post">
										<div class="form-group custom-checkbox">
											<cfif local.verify_once_override EQ 'Y' OR (local.verify_once EQ 'Y' AND local.verify_once_override NEQ 'N')>
												<input type="checkbox" name="verify_once_override" value="Y" checked="checked" class="form-check" id="VerfiyData"> 
											<cfelse>
												<input type="checkbox" name="verify_once_override" value="Y" class="form-check" id="VerfiyData">
											</cfif>
											<label for="VerfiyData">Verify once?</label>
										</div>
										<div class="btn-box mt-4">
											<button type="submit" class="ThemeBtn"> Save</button>
											<input type="hidden" name="override" value="override">
										</div>
										<cfoutput>
											<input type="hidden" name="code" value="#Trim(form.code)#">
											<input type="hidden" name="validation_id" value="#local.validation_id#">	
											<input type="hidden" name="label_type" value="#local.label_type#">						
										</cfoutput>
									</form>
								</div>
							</div>
						</div>
					</div>
					<cfif getLabelValidations.recordcount GT 0>
						<div class="material-card card">
							<div class="card-body">
								<div class="table-responsive">
									<table class="table product-overview" id="zero_config">
										<thead>
											<tr>
												<th>Date</th>
												<th>Client</th>
												<th>IP</th>
												<th>Label</th> 
											</tr>
										</thead>
										<tbody>
											<cfoutput query="getLabelValidations">
											<tr>
												<td>#DateTimeFormat(getLabelValidations.create_dt,'short')#</td>	
												<td>#getLabelValidations.company_name#</td>												
												<td>#getLabelValidations.IP_addr#</td>
												<td>#getLabelValidations.validation_code#</td>
											</tr>
											</cfoutput>
										</tbody>
									</table>
								</div>
							</div>
						</div>						
					</cfif>	
					<div class="row">
						<div class="col-lg-12">
							<div class="card">
								<cfif IsDefined('getPasswordValidations.recordcount') AND getPasswordValidations.recordcount GT 0>
									<div class ="card-header">
										<div class="table-responsive">
											<table class="table product-overview" id="zero_config">
												<thead>
													<tr>
														<th>Date</th>
														<th>Client</th>
														<th>IP</th>
														<th>Label</th> 
													</tr>
												</thead>
												<tbody>
													<cfoutput query="getPasswordValidations">
													<tr>
														<td>#DateTimeFormat(getPasswordValidations.create_dt,'short')#</td>	
														<td>#getPasswordValidations.company_name#</td>												
														<td>#getPasswordValidations.IP_addr#</td>
														<td>#getPasswordValidations.password#</td>
													</tr>
													</cfoutput>
												</tbody>
											</table>
										</div>
									</div>
								</cfif>
								<cfif NOT IsDefined('getPasswordValidations.recordcount') OR (getPasswordValidations.recordcount EQ 0 AND getLabelValidations.recordcount EQ 0)>
									<div class="card-body">
										<p>No validations found for label <strong><cfoutput>#form.code#</cfoutput></strong></p>
									</div>					
								</cfif>	
							</div>
						</div>		
					</div>									
				</cfif>   
			</div>
			<cfinclude template="#includePath#includes/footer/footer.cfm">
		</div>
		
		<div class="chat-windows"></div>
		
		<cfinclude template="#includePath#/includes/footer/js_files.cfm">
		<!-- This Page JS -->
		<script src="assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
		<script src="assets/libs/magnific-popup/meg.init.js"></script>
		<script src="assets/libs/jscolor/jscolor.js"></script>
		<script>
			function validateForm() {
				var range_start = $('#range_start').val();
				var range_end = $('#range_end').val();
				var doc = $('#doc').val();
				debugger;
				if (!doc) {
					alert('Please select a PDF to display when this label is verfied');
					return false;
				}
				
				
				if (isNaN(range_start) || isNaN(range_end)) {
					alert('Please enter only numeric values for Range Start and End fields');
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		
		<cfif StructKeyExists(form,"reset")>
			<cfoutput>	
				<script>						
				Swal.fire({
				title: 'Label #form.code# Reset',
				icon: 'success',
				confirmButtonText: 'OK'
				})
				</script>
			</cfoutput>
		</cfif>	
				
	</body>
</html>