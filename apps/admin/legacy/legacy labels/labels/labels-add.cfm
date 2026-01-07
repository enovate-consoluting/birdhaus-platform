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
                                    <li class="breadcrumb-item"><a href="/admin/dashboard.cfm">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Add Labels</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>

                <cfform action="labels-add-save.cfm" enctype="multipart/form-data" method="post" onsubmit="return validateForm()">
                   
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
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Label Details Information</h6>
                                </div>
            
                                <div class="card-body">
                                    <div class="card card-border mb-4">
                                        
                                            <div class="card-header">
                                                <h6>Label Details</h6>
                                            </div>
                                                                    
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-12">
                                                        <div class="form-group custom-select">
                                                            <label for="">Client</label>
                                                            <select name="client" class="flat-select"> 
                                                                <option data-display="Client">Client</option>
                                                                <cfoutput query="getClients">
                                                                    <cfif URL.client EQ getClients.client_id>
                                                                        <option value="#getClients.client_id#" selected="selected">#getClients.company_name#</option>
                                                                    <cfelse>
                                                                        <option value="#getClients.client_id#">#getClients.company_name#</option>
                                                                    </cfif>
                                                                </cfoutput>
                                                            </select>
                                                        </div>
                                                    </div>	
                                                    <div class="col-lg-6 col-md-6 col-12">
                                                        <div class="form-group">
                                                            <label for="">Note</label>
                                                            <cfoutput>
                                                                <input name="note" id="note" type="text" maxlength="200" class="form-control" placeholder="Internal Note" value="#DecodeFromURL(URL.note)#" />
                                                            </cfoutput>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>    
                                    </div>
                                    <div class="card card-border mb-4">
                                        <div class="card-header">
                                            <h6>Label Spreadsheet</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="toast show spreadsheetToast" role="alert" aria-live="assertive"
                                                aria-atomic="true">
                                                <div class="toast-body">
                                                    <button type="button" class="btn-close" data-bs-dismiss="toast"
                                                        aria-label="Close"></button>
                                                    <h4><i class="material-icons">info</i>Information</h4>
                                                        <p>The file you attach must be in Excel format, containing serial numbers (numeric only) and passwords (alpha numeric) on the first sheet. Column names must be "serial" and "password".</p>
                                                </div>
                                            </div>                                            
                                            <input name="doc" id="formFile" class="form-control fileInput" type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />												
                                        </div>
                                    </div>									
                                    <div class="card card-border mb-4">
                                        <div class="card-header">
                                            <h6>Options</h6>
                                        </div>

                                        <div class="card-body">
                                            <div class="form-group">                                                  
                                                <label for="label_validation_msg" class="">Verify Once Message</label>
                                                    <cftextarea name="verify_once_message" id="verify_once_message" class="form-control" maxlength="400" richtext="no">
                                                        <cfif Len(URL.verify_once_msg) GT 0>
                                                            <cfoutput>#DecodeFromURL(URL.verify_once_msg)#</cfoutput>
                                                        <cfelse>
                                                            <cfoutput>#application.verifyOnceMessageDefault#</cfoutput>
                                                        </cfif>														
                                                    </cftextarea>
                                            </div>

                                            <div class="form-group">                                                    
                                                <label for="label_validation_msg" class="">Label Validation Message</label>
                                            
                                                <cftextarea name="label_validation_msg" id="" rows="2" class="form-control" placeholder="Enter Message">
                                                    <cfoutput>#DecodeFromURL(URL.label_validation_msg)#</cfoutput>
                                                </cftextarea>
                                            </div>

                                            <div class="form-group custom-checkbox">
                                                <cfif URL.verify_once EQ 'Y'>
                                                    <input name="verify_once" type="checkbox" id="verify_onceData" value="Y" checked="checked">
                                                <cfelse>
                                                    <input name="verify_once" type="checkbox" id="verify_onceData" value="Y">
                                                </cfif>
                                                <label for="verify_onceData" class="">Verfiy Only Once?</label>
                                            </div>

                                            <div class="form-group custom-checkbox">  
                                                <cfif URL.exclude_from_stats EQ 'Y'>
                                                    <input name="exclude_stats" type="checkbox" id="statistics3" value="Y" checked="checked">
                                                <cfelse>
                                                    <input name="exclude_stats" class="form-check" type="checkbox" id="statistics3" value="Y">
                                                </cfif>
                                                <label for="statistics3" class="">Exclude from statistics?</label>
                                            </div>  
                                            
                                           
                                        </div>
                                    </div>

                                    <div class="btn-box">
                                        <button type="submit" class="ThemeBtn">Save</button>
                                        <button type="reset" class="ThemeBtn-outline">Clear</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>        
                </cfform>    
            </div>
            <cfinclude template="#includePath#includes/footer/footer.cfm">
        </div>
    
        <div class="chat-windows"></div>
        <cfinclude template="#includePath#includes/footer/js_files.cfm">
        <!-- This Page JS -->
        <script src="assets/libs/magnific-popup/dist/jquery.magnific-popup.min.js"></script>
        <script src="assets/libs/magnific-popup/meg.init.js"></script>
        <script src="assets/libs/jscolor/jscolor.js"></script>
        
        <script>
            function validateForm() {
                var doc = $('#formFile').val();
                if (!doc) {
                    alert('Please select a spreadsheet containing serial numbers and passwords');
                    return false;
                }
                return true;
            }
        </script>	
    </body>
</html>