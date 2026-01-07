<cfset includePath = "../">

<cfif StructKeyExists(form,"company_name")>
	
    <cfif StructKeyExists(form,"logo_img") AND Len(form.logo_img) GT 0 AND NOT StructKeyExists(form,'useGenericLogo')>
        <cffile action="upload" filefield="logo_img" destination="C:\home\scanacart.com\wwwroot\assets\img\logo\" nameconflict="MAKEUNIQUE"  />
        <cfset local.img_path = 'assets/img/logo/' & cffile.serverfile>
    <cfelse>
        <cfset local.img_path = 'assets/img/logo/yourlogohere.png'>
    </cfif>

	<cfquery name="insertClient" datasource="#application.datasource#" result="insertClientResult">
	INSERT INTO `#application.schema#`.`client`
	(`email_addr`,
	`contact_name`,
	`company_name`,
	`company_description`,
	`instagram`,
	`facebook`,
	`website`,
	`city_state`,
	`create_dt`,
	`status`,
	`phone_num`,
	`monthly_units`,
	`comments`,
	`twitter`,
	`snapchat`,
	`temp_pass`,
	`temp_pass_valid`,
	`password`,
	`update_dt`,
	`logo_path`,
	`logo_width`,
	`logo_height`,
	`total_label_cnt`,
	`custom_verify_page`,
	`large_logo`,
	`client_url`,
	`redirect_to_url`,
	`telegram`,
	`display_generic_validation`,
	`app_logo`,
	`app_client_url`,
	`video_url`,
	`app_validation_allowed`)
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_varchar" value="demo@scanacart.com">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="Demo User">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.company_name#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="Demo">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.img_path#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.URL#" null="#NOT IsValid('URL',form.URL)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.videoURL#" null="#NOT IsValid('URL',form.videoURL)#">,
	<cfqueryparam cfsqltype="cf_sql_bit" value="1">)
	</cfquery>

	<cftry>
		<cfset theUrl = listRest(form.nfcUrl, "?")>
		<cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
		<cfset local.decryptedId = Decrypt(listLast(theUrl, "="),local.key,'BLOWFISH','Hex')>

		<cfquery name="updateTag" datasource="#application.datasource#">
		UPDATE `#application.schema#`.`tag`
	    SET    `tag`.`product_page` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.URL#" null="#NOT IsValid('URL',form.URL)#">,
			   `tag`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertClientResult.GENERATED_KEY#">,
			   `tag`.`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.videoURL#" null="#NOT IsValid('URL',form.videoURL)#">,
			   `tag`.`bypass_sr_no` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		WHERE `tag`.`seq_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.decryptedId#">
		</cfquery>

	<cfcatch type="any"></cfcatch>
	</cftry>


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
						<h2><i class="material-icons">rss_feed</i><span>Manage NFC Demo Tag</span></h2>

							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Manage NFC Demo Tag</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-lg-12">
						<div class="card">
							<div class="card-header">
								<h6 class="card-title">Manage Demo Tag</h6>	
							</div>
							<div class="card-body">										
								<form id="nfc-redirect-batch-form" method="post" enctype="multipart/form-data">
									<cfoutput>
										<div class="card card-border">
											<div class="card-header">
												<h6>Set Demo NFC Details</h6>
											</div>								
											<div class="card-body">
												<div class="row">
													<div class="col-lg-12 col-md-12 col-12">
														<input type="input" name="nfcUrl" class="form-control" placeholder="NFC URL">
													</div>	
												</div>											
												<div class="row mt-4">
													<div class="col-lg-12 col-md-12 col-12">
														<input type="input" name="company_name" class="form-control" placeholder="Company Name">
													</div>	
												</div>
												<div class="row mt-4">
													<div class="col-lg-12 col-md-12 col-12">
														<input type="input" name="URL" class="form-control" placeholder="Website URL">
													</div>		
                                                </div>
												<div class="row mt-4">
													<div class="col-lg-12 col-md-12 col-12">
														<input type="input" name="videoURL" class="form-control" placeholder="Video URL">
													</div>		
                                                </div>																								
												<div class="row mt-4">                                                       													
													<div class="col-lg-12 col-md-12 col-12">
														<div class="multiInput-group">
															<input type="file" name="logo_img" class="form-control" placeholder="Logo Image">
															<button type="submit" id="proceed-btn" class="ThemeBtn"><i class="material-icons">arrow_circle_right</i>Save</button>
														</div>
													</div>							
												</div>	
												<div class="row mt-4">
													<div class="col-lg-12 col-md-12 col-12">
														<input type="checkbox" name="useGenericLogo" id="generic-logo">
														<label for="generic-logo" class="control-label">Use "Your Logo Here"?</label>
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
		
		
		<cfinclude template="#includePath#/includes/footer/js_files.cfm">
	
	</body>
</html>