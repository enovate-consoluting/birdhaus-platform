<cfset includePath="../">
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
						<h2><i class="material-icons">add</i><span>Add Labels</span></h2>
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb">
									<li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">Add Labels</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
				<div class="row">
                    <div class="col-lg-12">
                        <div class="card">
							<div class="card-header">
								<h6 class="font-normal mb-1">The following labels <b>could not</b> be inserted, because they already exist in the database.</h6>
							</div>
							<div class="card-body">
								<div class="row gy-3 mb-4">
									<div class="col-xl-4 col-lg-6 col-md-6 col-12">
										<div class="card card-border reportList-box">
											<div class="card-body p-0 pb-1">
												<div class="reportList-info">
													<cfoutput>
														<cfloop from="1" to="#ArrayLen(local.failed_inserts)#" index="z">
															<div class="reportList">
																<h6>Serial</h6>
																<h6>#local.failed_inserts[z][1]#</h6>
															</div>					  
															<div class="reportList">
																<h6>Password</h6>
																<h6>#local.failed_inserts[z][2]#</h6>
															</div>
														</cfloop>
													</cfoutput>
													<div class="form-actions mt-5 text-center">
														<a href="labels-manage.cfm" class="ThemeBtn">Okay</a>
													</div>																		
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<cfinclude template="#includePath#includes/footer/footer.cfm">
		
	
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
	<cfinclude template="#includePath#includes/session-timeout.cfm">

</body>

</html>	