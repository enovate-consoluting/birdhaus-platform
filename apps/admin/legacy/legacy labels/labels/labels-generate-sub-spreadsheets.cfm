<cfif NOT StructKeyExists(URL,"label_pass_gen_id")>
	<cflocation url="labels-generate.cfm" addtoken="no">
</cfif>

<cfquery name="getLabelPassGenDetail" datasource="#application.datasource#">
SELECT `label_pass_generation`.`label_pass_gen_id`,
    `label_pass_generation`.`label_pass_detail_id`,
    `label_pass_generation`.`client_id`,
    `label_pass_generation`.`num_passwords`,
    `label_pass_generation`.`password_length`,
    `label_pass_generation`.`include_alpha`,
    `label_pass_generation`.`alpha_char`,
    `label_pass_generation`.`alpha_random_ind`,
    `label_pass_generation`.`alpha_position`,
    `label_pass_generation`.`create_dt`,
    `label_pass_generation`.`create_user_id`,
    `label_pass_generation`.`first_serial_num`,
    `label_pass_generation`.`last_serial_num`,
    `label_pass_generation`.`spreadsheet_name`,
    `label_pass_generation`.`owner_label_pass_gen_id`,
	(select `client`.`company_name` from `#application.schema#`.`client` where `client`.`client_id` = `label_pass_generation`.`client_id`) as company_name
FROM `#application.schema#`.`label_pass_generation`
WHERE `label_pass_generation`.`label_pass_gen_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_pass_gen_id#"> or
      `label_pass_generation`.`owner_label_pass_gen_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_pass_gen_id#">
ORDER BY `label_pass_generation`.`label_pass_gen_id`
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
    <!-- This page plugin CSS -->
    <link href="assets/libs/datatables.net-bs4/css/dataTables.bootstrap4.css" rel="stylesheet">
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
                        <h5 class="font-medium text-uppercase mb-0">Manage Generated Labels</h5>
                    </div>
                    <div class="col-lg-9 col-md-8 col-xs-12 align-self-center">
                        <nav aria-label="breadcrumb" class="mt-2 float-md-right float-left">
                            <ol class="breadcrumb mb-0 justify-content-end p-0 bg-white">
                                <li class="breadcrumb-item"><a href="dashboard.cfm">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Manage Generated Labels</li>
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
                        <div class="material-card card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table product-overview" id="zero_config">
                                        <thead>
                                            <tr>
											    <th>&nbsp;</th>
												<th>Client</th> 
												<th>Serial Numbers</th>
												<th>Number of Passwords</th>												
												<th>Password Length</th>
												<th>Alpha Char</th> 
												<th>Created</th>                                           
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
											<cfoutput query="getLabelPassGenDetail">
                                            <tr>
											    <td>
													<cfif Len(getLabelPassGenDetail.spreadsheet_name) GT 0>
														<a href="passwords/#encodeForHTML(getLabelPassGenDetail.spreadsheet_name)#" target="_blank"><img src="assets/images/icon/excel.gif"></a>
													<cfelse>
														&nbsp;
													</cfif>
												</td>
                                                <td>#getLabelPassGenDetail.company_name#</td>
												<td>#getLabelPassGenDetail.first_serial_num#-#getLabelPassGenDetail.last_serial_num#</td>
												<td>#NumberFormat(getLabelPassGenDetail.last_serial_num-getLabelPassGenDetail.first_serial_num+1,',^')#</td>												
                                                <td>#getLabelPassGenDetail.password_length#</td>
												<td>#getLabelPassGenDetail.alpha_char#</td>
												<td>#DateTimeFormat(getLabelPassGenDetail.create_dt,'short')#</td>
                                                <td><a href="labels-generate-edit.cfm?label_pass_gen_id=#getLabelPassGenDetail.label_pass_gen_id#" class="text-inverse pr-2" data-toggle="tooltip" title="Edit"><i class="ti-marker-alt"></i></a> 													
													<!---<a href="test-results-delete.cfm?lab_test_id=#getPassGen.lab_test_id#" class="text-inverse" title="Delete" data-toggle="tooltip"><i class="ti-trash"></i></a>--->
												</td>                                            
											</tr>
											</cfoutput>
                                        </tbody>
                                    </table>
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
    <!--This page plugins -->
    <script src="assets/extra-libs/DataTables/datatables.min.js"></script>
    <script src="dist/js/pages/datatable/datatable-basic.init.js"></script>
	<cfinclude template="includes/session-timeout.cfm">
</body>

</html>