<!---<cfquery name="getClients" datasource="#application.datasource#">
SELECT `client`.`client_id`,
    `client`.`company_name`
FROM `#application.schema#`.`client`
WHERE `client`.`status` = 'Approved'
ORDER BY 2
</cfquery>--->

<cfif NOT StructKeyExists(URL,"client_id") AND NOT StructKeyExists(URL,"label_id") AND NOT StructKeyExists(URL,"label_type")>
	<cflocation url="test-results-manage.cfm" addtoken="no">
	<cfabort>
</cfif>

<cfset includePath = "../">

<!--- Create functions component object --->
<cfset functionsObj = createObject('component','functions') >

<cfif URL.label_type EQ 'password'>
	<cfset getLabelPassDetail = functionsObj.getLabelPassDetailFunc(URL.label_id,URL.client_id)>
	
	<cfset local.label_name = getLabelPassDetail.label_note>
	<cfset local.company_name = getLabelPassDetail.company_name>
	<cfset local.client_id = getLabelPassDetail.client_id>
	<cfset local.label_id = getLabelPassDetail.label_pass_detail_id>

<cfelse>

	<!--- add legacy query here --->
	<cfset getLabelRange = functionsObj.getLabelRangeFunc(URL.label_id,URL.client_id)>
	
	<cfset local.label_name = getLabelRange.label_note>
	<cfset local.company_name = getLabelRange.company_name>
	<cfset local.client_id = getLabelRange.client_id>
	<cfset local.label_id = getLabelRange.range_id>
	
</cfif>

<cfquery name="getTestResults" datasource="#application.datasource#">
SELECT `lab_test_result`.`lab_test_id`,
       `lab_test_result`.`client_id`,
       `lab_test_result`.`expiration_date`,
	   `lab_test_result`.`name`,
       `lab_test_result`.`note`,
       `lab_test_result`.`file_name`,
       `lab_test_result`.`create_dt`,
       `lab_test_result`.`create_user_id`,
       `lab_test_result`.`active`
FROM `#application.schema#`.`lab_test_result`
WHERE `lab_test_result`.`active` = 'Y' and
	  `lab_test_result`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.client_id#"> and
	  NOT EXISTS (select 'x' 
	              from `#application.schema#`.`lab_test_label_assoc` 
				  where `lab_test_label_assoc`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.client_id#"> and
				        `lab_test_result`.`lab_test_id` = `lab_test_label_assoc`.`lab_test_id` and
				  		  <cfif URL.label_type EQ 'password'>
							`lab_test_label_assoc`.`password_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.label_id#">
						  <cfelse>
							`lab_test_label_assoc`.`range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.label_id#">
						  </cfif>
	  )
ORDER BY `lab_test_result`.`name`
</cfquery>

<cfif URL.label_type EQ 'password'>
	
	<cfset getAssociations = functionsObj.getAssociationsFunc(URL.label_id,local.client_id,'1')>
	
<cfelse>

	<cfset getAssociations = functionsObj.getAssociationsFunc(URL.label_id,local.client_id,'0')>
	
</cfif>

<!DOCTYPE html>
<html dir="ltr" lang="en">

<head>
	<link rel="icon" type="image/png" sizes="16x16" href="<cfoutput>#includePath#</cfoutput>assets/images/favicon.png">
	<link href="<cfoutput>#includePath#</cfoutput>assets/libs/magnific-popup/dist/magnific-popup.css" rel="stylesheet">
    <!-- Custom CSS -->
     <link href="<cfoutput>#includePath#</cfoutput>dist/css/style.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<cfoutput>#includePath#</cfoutput>dist/css/richwidgets.min.css">	
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
                        <h2><i class="material-icons">format_list_bulleted_add</i><span>Test Result</span></h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="dashboard.cfm">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Test Result/Label Assoc.</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <cfoutput>
                            <cfform action="labels-add-save.cfm" enctype="multipart/form-data" method="post" onsubmit="return validateForm()">
                                <div class="card-header">
                                    <h6>Test Result/Label Association</h6>
                                </div>								
                                <div class="card-body">
                                    <div class="row mb-4 gy-3">
                                        <div class="col-lg-6 col-md-6 col-12">
                                            <p class="m-0"><b>Client</b></p>
                                            <span>#local.company_name#</span>
                                        </div>	
                                        <div class="col-lg-6 col-md-6 col-12 ps-md-4">
                                            <p class="m-0"><b>Label</b></p>
                                            <span>#local.label_name#</span>
                                        </div>												
                                    </div>												
                                    <div id="list">
                                        <ol class="source">
                                            <cfloop query="getTestResults">
                                                <li data-key="#getTestResults.lab_test_id#" class="num">#getTestResults.name#</li>
                                            </cfloop>  
                                        </ol>
                                        <ol class="target">
                                            <cfloop query="getAssociations">
                                                <li data-key="#getAssociations.lab_test_id#" class="num">#getAssociations.name#</li>
                                            </cfloop>
                                        </ol>
                                    </div>
                                    <div class="form-actions btn-box mt-4">
                                        <button id="saveBtn" type="button" class="ThemeBtn">Save</button>
                                        <cfif URL.label_type EQ 'password'>
                                            <a href="labels-manage.cfm"><button type="button" class="ThemeBtn-outline">Cancel</button></a>
                                        <cfelse>
                                            <a href="labels-manage-legacy.cfm"><button type="button" class="ThemeBtn-outline">Cancel</button></a>
                                        </cfif>
                                    </div>
                                </div>
                            </cfform>
                        </cfoutput>
                    </div>
                </div>
            </div>
        </div>
        <cfinclude template="#includePath#includes/footer/footer.cfm">
    </div>
	<cfinclude template="#includePath#includes/footer/js_files.cfm">
    <!-- This Page JS -->
    <script src="<cfoutput>#includePath#</cfoutput>assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
    <script src="<cfoutput>#includePath#</cfoutput>assets/libs/magnific-popup/meg.init.js"></script>
	<script src="<cfoutput>#includePath#</cfoutput>assets/libs/jscolor/jscolor.js"></script>
	<script src="<cfoutput>#includePath#</cfoutput>dist/js/picklist.js"></script>
	<script src="<cfoutput>#includePath#</cfoutput>dist/js/ordering-list.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>

	<cfoutput>
	<script>
		$('##list').pickList({
		header: null
		});
		
		$("##saveBtn").on("click", function (event) {
			//$('##saveBtn').addClass('kt-spinner kt-spinner--right kt-spinner--md kt-spinner--light');
			event.preventDefault();
			var json = {
			selectedVals: []
			};

			$(".target li").each(function (i, li) {
			json.selectedVals.push($(li).data('key'));
			});		
		
			$.ajax({
				type: "post",
				url: "test-results-assoc-save.cfm?client_id=#URL.client_id#&label_id=#local.label_id#&label_type=#URL.label_type#",
				data: json ,
				success: function(responseData, textStatus, jqXHR) {				
					swal.fire("Success", "Test Result/Label Associations Saved", "success");
				},
				error: function(jqXHR, textStatus, errorThrown) {
					swal.fire("Error", "An unexpected error has occurred", "error");
					console.log(errorThrown);
				}
			})			
		
	});		
   </script>
   </cfoutput>
</body>
</html>