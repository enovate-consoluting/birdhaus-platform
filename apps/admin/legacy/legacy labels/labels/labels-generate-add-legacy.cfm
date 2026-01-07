<cfparam name="URL.error" default="">
<cfparam name="URL.client" default="">
<cfparam name="URL.note" default="">
<cfparam name="URL.verify_once" default="">
<cfparam name="URL.verify_once_msg" default="">
<cfparam name="URL.label_validation_msg" default="">
<cfparam name="URL.exclude_from_stats" default="">

<cfquery name="getClients" datasource="#application.datasource#">
SELECT `client`.`client_id`,
    `client`.`company_name`
FROM `#application.schema#`.`client`
WHERE `client`.`status` = 'Approved'
ORDER BY 2
</cfquery>

<!DOCTYPE html>
<html dir="ltr" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Favicon icon -->
    <link rel="icon" type="image/png" sizes="16x16" href="assets/images/favicon.png">
    <title>Scan-a-Cart Admin</title>
    <!-- This Page CSS -->
    <link href="assets/libs/magnific-popup/dist/magnific-popup.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="dist/css/style.min.css" rel="stylesheet">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
</head>

<body>
    <!-- ============================================================== -->
    <!-- Preloader - style you can find in spinners.css -->
    <!-- ============================================================== -->
    <div class="preloader">
        <div class="lds-ripple">
            <div class="lds-pos"></div>
            <div class="lds-pos"></div>
        </div>
    </div>
    <!-- ============================================================== -->
    <!-- Main wrapper - style you can find in pages.scss -->
    <!-- ============================================================== -->
    <div id="main-wrapper">
        <!-- ============================================================== -->
        <!-- Topbar header - style you can find in pages.scss -->
        <!-- ============================================================== -->
        <cfinclude template="includes/header/top_bar.cfm">
        <!-- ============================================================== -->
        <!-- End Topbar header -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- Left Sidebar - style you can find in sidebar.scss  -->
        <!-- ============================================================== -->
        <aside class="left-sidebar">
            <!-- Sidebar scroll-->
            <div class="scroll-sidebar">
                <!-- Sidebar navigation-->
                <cfinclude template="includes/navigation/left_nav.cfm">
                <!-- End Sidebar navigation -->
            </div>
            <!-- End Sidebar scroll-->
        </aside>
        <!-- ============================================================== -->
        <!-- End Left Sidebar - style you can find in sidebar.scss  -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        <div class="page-wrapper">
            <!-- ============================================================== -->
            <!-- Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <div class="page-breadcrumb bg-white">
                <div class="row">
                    <div class="col-lg-3 col-md-4 col-xs-12 align-self-center">
                        <h5 class="font-medium text-uppercase mb-0">Generate Labels</h5>
                    </div>
                    <div class="col-lg-9 col-md-8 col-xs-12 align-self-center">                       
                        <nav aria-label="breadcrumb" class="mt-2 float-md-right float-left">
                            <ol class="breadcrumb mb-0 justify-content-end p-0 bg-white">
                                <li class="breadcrumb-item"><a href="dashboard.cfm">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Generate Labels</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <!-- ============================================================== -->
            <!-- End Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- Container fluid  -->
            <!-- ============================================================== -->
            <div class="page-content container-fluid">
                <!-- ============================================================== -->
                <!-- Start Page Content -->
                <!-- ============================================================== -->
                <div class="row">
                    <!-- Column -->
                    <div class="col-lg-6">
						<cfif StructKeyExists(URL,"error") AND URL.error EQ 'filetype'>
							<div class="alert alert-danger">
								<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
								<h3 class="text-danger"><i class="fa fa-exclamation-circle"></i> Error</h3> The file attached was not in Excel format.
							</div>	
						</cfif>
						<cfif StructKeyExists(URL,"error") AND URL.error EQ 'invalid'>				
							<div class="alert alert-danger">
								<button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
								<h3 class="text-danger"><i class="fa fa-exclamation-circle"></i> Error</h3> The file attached did not contain column names: "serial" and "password".
							</div>	
						</cfif>
                        <div class="card">
                            <div class="card-body">
                                <cfform id="genForm" action="labels-generate-save.cfm" enctype="multipart/form-data" method="post">
                                    <div class="form-body">
                                        <h5 class="card-title">Password Details</h5>
                                        <hr>									
                                        <div class="row">											
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Client</label>
                                                    <select name="client" class="form-control"> 
														<option></option>
														<cfoutput query="getClients">																
															<option value="#getClients.client_id#">#getClients.company_name#</option>
														</cfoutput>
													</select>
												</div>
                                            </div>	
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Number of Passwords Needed</label>
													<cfoutput>
                                                    <input name="numPasswords" id="numPasswords" type="text" maxlength="200" class="form-control" placeholder="Enter a number" />
													</cfoutput>
												</div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Length of Password</label>
													<select name="passLength" class="form-control">
													<cfoutput>
													<cfloop from="1" to="30" index="i">
														<option>#i#</option>
													</cfloop>
													</cfoutput>
													</select>
												</div>
                                            </div>	
										</div>
										<hr>
										<div class="row">	
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Include a Letter?</label>
													<select name="includeLetter" class="form-control">
														<option value="0">No</option>
														<option value="1">Yes - Start with a Letter I Provide</option>
														<option value="2">Yes - End with a Letter I Provide</option>
														<option value="3">Yes - Start with a Random Letter</option>
														<option value="4">Yes - End with a Random Letter</option>														
													</select>
												</div>
                                            </div>	
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Letter</label>
													<cfoutput>
                                                    <input name="letter" id="letter" type="text" maxlength="1" class="form-control" placeholder="Enter a letter" />
													</cfoutput>
												</div>
                                            </div>																													
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Note</label>
													<cfoutput>
                                                    <input name="note" id="note" type="text" maxlength="200" class="form-control" placeholder="Internal Note" />
													</cfoutput>
												</div>
                                            </div>																				
                                            <!--/span-->
                                        </div>																													
                                        <hr> 										
										<div class="row">
											<div class="col-md-12">
											<h5 class="card-title">Options</h5>

												<div class="form-group row">                                                    
													<label for="verify_once" class="col-sm-6 control-label col-form-label">Verfiy Only Once?</label>
													<div class="col-sm-6">
														<input name="verify_once" type="checkbox" id="verify_once" value="Y">
													</div>							
                                                </div>												
												<div class="form-group row">                                                    
													<label for="verify_once_message" class="col-sm-12 control-label col-form-label">Verify Once Message</label>
													<div class="col-sm-12">
														<cftextarea name="verify_once_message" id="verify_once_message" maxlength="400" richtext="no" style="width:100%; height:80px;">
															<cfoutput>#application.verifyOnceMessageDefault#</cfoutput>													
														</cftextarea>
													</div>							
                                                </div>	
												<div class="form-group row">                                                    
													<label for="exclude_stats" class="col-sm-10 control-label col-form-label">Exclude from statistics?</label>
													<div class="col-sm-2">
														<input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y">
													</div>							
                                                </div>	
												<div class="form-group row">                                                    
													<label for="include_serial" class="col-sm-10 control-label col-form-label">Include Serial Number column in spreadsheet?</label>
													<div class="col-sm-2">
														<input name="include_serial" type="checkbox" id="include_serial" value="Y" checked="checked">
													</div>							
                                                </div>																																			
                                            </div>
										</div>										
									  </div>
                                    <div class="form-actions mt-5">
                                        <button id="submitForm" type="submit" class="btn btn-success"> <i class="fa fa-check"></i> Save</button>
                                        <button id="cancelBtn" type="button" class="btn btn-dark">Cancel</button>
										<cfoutput>
										<input type="hidden" name="logId" id="logId" value="#DateTimeFormat(now(),'mmddyyHHnnss')#">
										</cfoutput>
                                    </div>
                                </cfform>
                            </div>
                        </div>
                    </div>
					<div class="col-lg-6">
                        <div class="card">
                            <div class="card-body">
								<div class="form-body">
									<h5 class="card-title">Log Output</h5>
									<hr>									
									<div class="row">											
										<div class="col-md-12">							
											<div id="logData"></div>
										</div>
									</div>
								</div>
							</div>
						</div>			
					</div>
                    <!-- Column -->
                </div>
                <!-- ============================================================== -->
                <!-- End PAge Content -->
                <!-- ============================================================== -->
                <!-- ============================================================== -->
                <!-- Right sidebar -->
                <!-- ============================================================== -->
                <!-- .right-sidebar -->
                <!-- ============================================================== -->
                <!-- End Right sidebar -->
                <!-- ============================================================== -->
            </div>
            <!-- ============================================================== -->
            <!-- End Container fluid  -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- footer -->
            <!-- ============================================================== -->
            <cfinclude template="includes/footer/footer.cfm">
            <!-- ============================================================== -->
            <!-- End footer -->
            <!-- ============================================================== -->
        </div>
        <!-- ============================================================== -->
        <!-- End Page wrapper  -->
        <!-- ============================================================== -->
    </div>
    <!-- ============================================================== -->
    <!-- End Wrapper -->
    <!-- ============================================================== -->
    <!-- ============================================================== -->
    <!-- customizer Panel -->
    <!-- ============================================================== -->
    
    <div class="chat-windows"></div>
    <!-- ============================================================== -->
    <!-- All Jquery -->
    <!-- ============================================================== -->
    <script src="assets/libs/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap tether Core JavaScript -->
    <script src="assets/libs/popper.js/dist/umd/popper.min.js"></script>
    <script src="assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- apps -->
    <script src="dist/js/app.min.js"></script>
    <script src="dist/js/app.init.minimal.js"></script>
    <script src="dist/js/app-style-switcher.js"></script>
    <!-- slimscrollbar scrollbar JavaScript -->
    <script src="assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
    <script src="assets/extra-libs/sparkline/sparkline.js"></script>
    <!--Wave Effects -->
    <script src="dist/js/waves.js"></script>
    <!--Menu sidebar -->
    <script src="dist/js/sidebarmenu.js"></script>
    <!--Custom JavaScript -->
    <script src="dist/js/custom.min.js"></script>
    <!-- This Page JS -->
    <script src="assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
    <script src="assets/libs/magnific-popup/meg.init.js"></script>
	<script src="assets/libs/jscolor/jscolor.js"></script>
	<cfinclude template="includes/session-timeout.cfm">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>

	<script>
	$( document ).ready(function() {
		$( "#submitForm" ).on( "click", function(e) {
		    e.preventDefault();
			var form = $("#genForm");
			var logId = $("#logId").val();
			var x = 0;
			
			$('#submitForm').prop("disabled", true);
			$("#submitForm").addClass('disabled');
			$('#cancelBtn').prop("disabled", true);
			$("#cancelBtn").addClass('disabled');
			
			window.scrollTo(0, 0);
			
			var interval = setInterval(function(){			
				$.get( "log/passwordService" + logId + ".txt", function( data ) {
				  $("#logData").html(data);
				});			
			}, 5000);			
			
			$.ajax({
				   type: "POST",
				   url: "labels-generate-save.cfm?legacy=true",
				   data: form.serialize(), // serializes the form's elements.
				   success: function(data)
				   {	
					window.clearInterval(interval); // stop the original interval
					
					//add one more interval that will run for a couple more seconds to ensure all data is read
					var lastInterval = setInterval(function () {
					
						$.get( "log/passwordService" + logId + ".txt", function( data ) {
						  $("#logData").html(data);
						});	
						
					   if (++x === 5) {
						   window.clearInterval(lastInterval);
					   }
					}, 500);		
					
					Swal.fire({
					  title: 'Passwords Generated Successfully',
					  icon: 'success',
					  confirmButtonText: 'OK'
					}).then(function() {
						location.href = 'labels-generate.cfm';
					});
											
				   }
				 });

		});
							
	});
	</script>	
</body>

</html>