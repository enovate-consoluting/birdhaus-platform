<cfparam name="URL.error" default="">
<cfparam name="URL.client" default="">
<cfparam name="URL.note" default="">
<cfparam name="URL.verify_once" default="">
<cfparam name="URL.verify_once_msg" default="">
<cfparam name="URL.label_validation_msg" default="">
<cfparam name="URL.exclude_from_stats" default="">
<cfset includePath = "../">

<!--- Create functions component object --->
<cfset functionsObj = createObject('component','functions') >
<cfset getClients = functionsObj.getClientsFunc('labels-add')>
<cfset getNfcGen = functionsObj.getNfcGenFunc()>

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
                            <h2><i class="material-icons">add</i><span>Generate NFCs</span></h2>
       
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/admin/dashboard.cfm">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Generate NFCs</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-header">                                    
                                <div class="btn-box">		
                                    <button type="button" class="ThemeBtn" onclick="addNfc(<cfoutput>#session.user_id#</cfoutput>)">
                                        <i class="material-icons">add</i>Add New
                                    </button>
                                </div>
                                <div class="btn-box">
									<button type="button" class="ThemeBtn" data-bs-toggle="modal" data-bs-target="#importSrNo">
                                        <i class="material-icons">publish</i>Import Sr No
                                    </button>
                                    <button type="button" class="ThemeBtn" onclick="deleteTags();">
                                        <i class="material-icons">delete</i>Delete Tags
                                    </button>		
                                    <button type="button" class="ThemeBtn" onclick="addvideoURL();">
                                        <i class="material-icons">add</i>Add/Edit
                                    </button>
                                </div>
                            </div>
                                <div class="card-body">                                
                                    <div class="card card-border">
                                        <div class="card-header">
                                            <h6>NFC Generation List</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table id="nfcGenerateTable" class="table table-bordered" style="width:100%">
                                                    <thead>
                                                        <tr>
                                                        <th></th>
                                                        <th class="min-th"></th>
                                                        <th>Client</th>
                                                        <th>Spool Number(s)</th>
                                                        <th>Number of NFCs</th>
														<th>Note</th>
                                                        <th>Video URL</th>
                                                        <th>Created</th>
														<th>Actions</th>
                                                        </tr>
                                                    </thead>
													<tbody class="loading-data">
														<tr>
															<td colspan="9" class="text-center">
																<span>
																	<img src="../../img/spinner.gif">Loading...
																</span>
															</td>
														</tr>
													</tbody>
                                                    <tbody id="nfcGenerateTableData" style="display:none;">
                                                        <cfoutput query="getNfcGen">
                                                            <cfquery name="getNfcVideoUrl" datasource="#application.datasource#">
                                                                SELECT DISTINCT `video_url`
                                                                FROM 
                                                                    `#application.schema#`.`tag`
                                                                WHERE 
                                                                    `tag`.`spool_id` = #getNfcGen.first_spool_id#               
                                                            </cfquery>    

                                                            <tr>
                                                                <td>
                                                                    <input type="checkbox" name="addurl" value="#getNfcGen.nfc_gen_id#" class="spoolIdsCheckbox" title="Check to add video url">
                                                                </td>
                                                                <td>
                                                                    <cfif Len(getNfcGen.spreadsheet_name) GT 0>
                                                                        <a href="tags/#encodeForHTML(getNfcGen.spreadsheet_name)#" target="_blank"><img src="#includePath#assets/images/icon/excel.gif"></a>														
                                                                    <cfelse>
                                                                        &nbsp;
                                                                    </cfif>
                                                                </td>
                                                                <td>#getNfcGen.company_name#</td>
                                                                <cfif getNfcGen.first_spool_id EQ getNfcGen.last_spool_id>
                                                                    <td>#getNfcGen.first_spool_id# (#getNfcGen.nfcs_per_spool# per spool)</td>
                                                                <cfelse>
                                                                    <td>#getNfcGen.first_spool_id# - #getNfcGen.last_spool_id# (#getNfcGen.nfcs_per_spool# per spool)</td>
                                                                </cfif>
                                                                <td>#NumberFormat(getNfcGen.num_tags,',^')#</td>
																<td>#getNfcGen.note#</td>
                                                                <td><a href="#getNfcVideoUrl.video_url#" target="_blank">#getNfcVideoUrl.video_url#</a></td>
                                                                <td>#DateTimeFormat(getNfcGen.create_dt,'short')#</td>
																<td>
																	<div class="action-btn">
																		<button type="button" class="ThemeBtn" onclick="viewSeqNum('#getNfcGen.spreadsheet_name#')">View Seq</button>
																	</div>
																</td>
                                                            </tr>
                                                        </cfoutput>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>        
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Column -->
                </div>                
  
            </div>
            <cfinclude template="#includePath#includes/footer/footer.cfm">
        </div>

        <!--Add New Modal -->
        <div class="modal fade" id="addNewModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
           aria-labelledby="addNewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                <div class="modal-content" >
					<div id="loader" class="loader-add-nfc" style="display:none";>
                        <img src="../../img/spinner.gif">Loading...
                    </div>
                    <div class="modal-header">
                        <h6 class="modal-title" id="addNewModalLabel">Generate NFCs</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
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
                    <div class="modal-body" id="addNfcBody">
                    
                    </div>
                </div>
            </div>
        </div>  
        
        <!--Add New Modal -->
        <div class="modal fade" id="addvideourl" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
           aria-labelledby="addNewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                <div class="modal-content" >
                    <div class="modal-header">
                        <h6 class="modal-title">Add/Edit</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="edit-options-data">
                        
                    </div>
                </div>
            </div>
        </div>   

		<div class="modal fade" id="viewSeqNum_model" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="EditTrackingModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
				<div class="modal-content">
					<div id="loader" class="loader-add-nfc" style="display:none";>
                        <img src="../../img/spinner.gif">Loading...
                    </div>
                    <div class="modal-header">
						<h6 class="modal-title" id="">Sequence Numbers</h6>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
                    <div class="modal-body" id="viewSeqNumData">
					</div>
					<div class="modal-footer">
                           <button type="button" class="ThemeBtn cancel" data-bs-dismiss="modal" aria-label="Close">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		
		<div class="modal fade" id="importSrNo" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
           aria-labelledby="importSrNo" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                <div class="modal-content" >
                    <div class="modal-header">
                        <h6 class="modal-title">Import Serial numbers</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="importSrNoForm">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label for="excel-sheet">Excel Sheet</label>
                                    <input class="form-control fileInput" type="file" id="excel-sheet" name="sheet" accept=".xlsx, .xls">
                                </div>
                            </div>
                            <div class="btn-box mt-4">
                                <button type="button" id="importSr" class="ThemeBtn" onClick="importSerials();">Import</button>
                                <button type="button" id="cancelBtn" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    
        <div class="chat-windows"></div>
        <cfinclude template="#includePath#includes/footer/js_files.cfm">
        <!-- This Page JS -->
        <script src="assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
        <script src="assets/libs/magnific-popup/meg.init.js"></script>
        <script src="assets/libs/jscolor/jscolor.js"></script>
    </body>
</html>