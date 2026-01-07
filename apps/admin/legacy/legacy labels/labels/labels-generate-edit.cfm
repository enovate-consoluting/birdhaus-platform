<cfif NOT StructKeyExists(URL,"label_pass_gen_id")>
	<cflocation addtoken="no" url="labels-generate.cfm">
	<cfabort>
</cfif>

<cfquery name="getLabelGenDetail" datasource="#application.datasource#">
SELECT `label_pass_generation`.`label_pass_gen_id`,
    `label_pass_generation`.`label_pass_detail_id`,
    `label_pass_generation`.`client_id`,
    `label_password_detail`.`label_pass_detail_id`,
    `label_password_detail`.`verify_once`,
    `label_password_detail`.`verify_once_msg`,
    `label_password_detail`.`label_validation_msg`,
    `label_password_detail`.`label_note`,
	`label_password_detail`.`exclude_from_stats`
FROM `#application.schema#`.`label_pass_generation`,
     `#application.schema#`.`label_password_detail`
WHERE `label_password_detail`.`label_pass_detail_id` = `label_pass_generation`.`label_pass_detail_id` and
      `label_pass_generation`.`label_pass_gen_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_pass_gen_id#">
</cfquery>

<cfquery name="getClients" datasource="#application.datasource#">
SELECT `client`.`client_id`,
    `client`.`company_name`
FROM `#application.schema#`.`client`
WHERE `client`.`status` = 'Approved'
ORDER BY 2
</cfquery>

<cfajaximport tags="cftextarea">

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
                        <h5 class="font-medium text-uppercase mb-0">Edit Password Set</h5>
                    </div>
                    <div class="col-lg-9 col-md-8 col-xs-12 align-self-center">                       
                        <nav aria-label="breadcrumb" class="mt-2 float-md-right float-left">
                            <ol class="breadcrumb mb-0 justify-content-end p-0 bg-white">
                                <li class="breadcrumb-item"><a href="dashboard.cfm">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Password Set</li>
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
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <cfform action="labels-generate-edit-save.cfm" enctype="multipart/form-data" method="post">
                                    <div class="form-body">
                                        <h5 class="card-title">Password Set Details</h5>
                                        <hr>									
                                        <div class="row">											
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label class="control-label">Client</label>
                                                    <select name="client" class="form-control">
														<option></option>
														<cfoutput>
															<cfloop query="getClients">
																<cfif getClients.client_id EQ getLabelGenDetail.client_id>
																	<option selected="selected" value="#getClients.client_id#">#getClients.company_name#</option>
																<cfelse>
																	<option value="#getClients.client_id#">#getClients.company_name#</option>
																</cfif>
															</cfloop>
														</cfoutput>					
													</select>
												</div>
                                            </div>										
                                            <!--/span-->
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="control-label">Note</label>
													<cfoutput>
                                                    <input name="note" id="note" type="text" maxlength="200" class="form-control" placeholder="Internal Note" value="#getLabelGenDetail.label_note#" />
													</cfoutput>
												</div>
                                            </div>											
                                        </div>
										<hr>
										<div class="row">
											<div class="col-md-12">
												<h5 class="card-title">Options</h5>		
												<div class="form-group row">                                                    
													<label for="verify_once" class="col-sm-3 control-label col-form-label">Verfiy Only Once?</label>
													<div class="col-sm-9">
															<cfif getLabelGenDetail.verify_once EQ 'Y'>
																<input name="verify_once" type="checkbox" id="verify_once" value="Y" checked="checked">
															<cfelse>
																<input name="verify_once" type="checkbox" id="verify_once" value="Y">
															</cfif>
													</div>							
                                                </div>												
												<div class="form-group row">                                                    
													<label for="verify_once_message" class="col-sm-3 control-label col-form-label">Verify Once Message</label>
													<div class="col-sm-9">
														<cftextarea name="verify_once_message" id="verify_once_message" maxlength="400" richtext="no" style="width:100%; height:80px;"><cfoutput>#getLabelGenDetail.verify_once_msg#</cfoutput></cftextarea>
													</div>							
                                                </div>
												<div class="form-group row">                                                    
													<label for="label_validation_msg" class="col-sm-3 control-label col-form-label">Label Validation Message</label>
													<div class="col-sm-9">
														<cftextarea name="label_validation_msg" id="label_validation_msg" maxlength="400" richtext="no" style="width:100%; height:80px;"><cfoutput>#getLabelGenDetail.label_validation_msg#</cfoutput></cftextarea>
													</div>							
                                                </div>	
												<div class="form-group row">                                                    
													<label for="exclude_stats" class="col-sm-3 control-label col-form-label">Exclude from statistics?</label>
													<div class="col-sm-9">
														<cfif getLabelGenDetail.exclude_from_stats EQ 1>
															<input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y" checked="checked">
														<cfelse>
															<input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y">
														</cfif>
													</div>							
                                                </div>																																			
                                            </div>
										</div>																			
									  </div>
                                    <div class="form-actions mt-5">
                                        <button type="submit" class="btn btn-success"> <i class="fa fa-check"></i> Save</button>
                                        <a href="labels-manage.cfm"> <button type="button" class="btn btn-dark">Cancel</button></a>
                                    </div>
									<cfoutput>
									<input type="hidden" name="label_pass_detail_id" value="#getLabelGenDetail.label_pass_detail_id#">
									</cfoutput>
                                </cfform>
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
	
</body>

</html>