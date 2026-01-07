<cfset local.client_id = ''>
<cfset local.serial_from = ''>
<cfset local.serial_to = ''>
<cfparam name="URL.error" default="">
<cfparam name="URL.client" default="">
<cfparam name="URL.note" default="">
<cfparam name="URL.verify_once" default="">
<cfparam name="URL.verify_once_msg" default="">
<cfparam name="URL.label_validation_msg" default="">
<cfparam name="URL.exclude_from_stats" default="">
<cfparam name="URL.search" default="">

<cfset search = URL.search>

<cfif isDefined('form.search')>
    <cfset search = form.search>
</cfif>

<cfset includePath = "../">

<!--- Create functions component object --->
<cfset functionsObj = createObject('component','functions') >
<cfset getLabelGenDetail = functionsObj.getLabelGenDetailFunc()>
<cfset getPassGen = functionsObj.getPassGenFunc(search)>
<cfset getClients = functionsObj.getClientsFunc()>

<cfif StructKeyExists(URL,"client")>
	<cfset local.client_id = URL.client>
</cfif>
<cfif StructKeyExists(URL,"serial_from")>
	<cfset local.serial_from = URL.serial_from>
</cfif>
<cfif StructKeyExists(URL,"serial_to")>
	<cfset local.serial_to = URL.serial_to>
</cfif>

<!DOCTYPE html>
<html dir="ltr" lang="en">
    <cfinclude template="#includePath#includes/header/header.cfm">
    <body>
        <div id="mainLayout">
            <cfinclude template="#includePath#includes/navigation/left_nav.cfm">
            <cfinclude template="#includePath#includes/header/top_bar.cfm"> 

            <div class="mainBody">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="pageTitle">
                            <h2><i class="material-icons">format_list_numbered</i><span>Manage Password Generation</span></h2>
                        
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Manage Password Generation</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
                
                <div class="row mb-4">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-header">
                                <h6>Manage Password</h6>    
                                <div class="btn-box">		
                                    <!--- <a href="labels-generate-add.cfm"> --->
                                        <button type="button" class="ThemeBtn" onclick="editlabel(0,<cfoutput>#session.user_id#</cfoutput>)">
                                            <i class="material-icons">add</i>Add New
                                        </button>
                                    <!--- </a>									 --->
                                    <!--- <a href="labels-generate-add-legacy.cfm"> --->
                                        <button type="button" class="ThemeBtn btnSecondary" data-bs-toggle="modal" data-bs-target="#addLegacyModal">
                                            <i class="material-icons">add</i>Add Legacy
                                        </button>
                                    <!--- </a> --->
                                </div>
                            </div>
                                <div class="card-body">
                                        <div class="card card-border mb-4">
                                            <div class="card-header">
                                                <h6>Locate</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="findInput">
                                                    <form action="labels-generate.cfm" method="post">
                                                        <input type="text" class="form-control" placeholder="Find Password" name="search" value="<cfoutput>#search#</cfoutput>">							
                                                        <button type="submit" class="ThemeBtn">
                                                            <i class="material-icons">search</i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                                    <!---<cfoutput>
                                                    <input type="hidden" name="code" value="#Trim(form.code)#">								
                                                    </cfoutput>--->
                                        </div>
                                    <cfoutput>
                                        <div class="card card-border mb-4">
                                            <div class="card-header">
                                                <h6>Separate/Assign by Serial Number</h6>
                                            </div>
                                            <form action="separate-gen-batch.cfm" method="post">
                                                <div class="card-body">
                                                    <div class="multiInput-group">
                                                            <input type="text" name="serial_from" value="#local.serial_from#" class="form-control" placeholder="Serial Number From">
                                                            <input type="text" name="serial_to" value="#local.serial_to#" class="form-control" placeholder="Serial Number To">
                                                            <div class="custom-select">
                                                                <select name="client" class="flat-select"> 
                                                                    <option value="">Client</option>
                                                                    <option value="Unassigned">Unassigned</option>
                                                                       <cfloop query="getClients">
                                                                        <cfif getClients.client_id EQ local.client_id>
                                                                            <option value="#getClients.client_id#" selected="selected">#getClients.company_name#</option>
                                                                        <cfelse>
                                                                            <option value="#getClients.client_id#">#getClients.company_name#</option>
                                                                        </cfif>
                                                                    </cfloop>
                                                                </select>
                                                            </div>							
                                                            <div class="custom-checkbox">
                                                                <input type="checkbox" name="override" class="form-check" id="Override">
                                                                <label for="Override">Override</label>
                                                            </div>
                                                            <button type="submit" class="ThemeBtn"> 
                                                                <i class="material-icons">
                                                                    arrow_circle_right
                                                                </i>
                                                                Proceed
                                                            </button>
                                                        <cfif StructKeyExists(URL,"status") AND URL.status EQ 'complete'>
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    <span style="color:##00CC66">Labels have been separated and assigned successfully</span>
                                                                </div>
                                                            </div>																			
                                                        </cfif>
                                                    </div>     
                                                    <cfif StructKeyExists(URL,"error")>
                                                        <div class="row">
                                                            <div class="col-lg-12">
                                                                <span style="color:##FF0000">
                                                                    <cfif URL.error EQ 'non-numeric'>
                                                                        Please ensure serial number values contain only numbers and field is not blank; please select a client
                                                                    <cfelseif URL.error EQ 'not-found'>
                                                                        The serial number range provided cannot be found
                                                                    <cfelseif URL.error EQ 'in-use'>
                                                                        One or more serial numbers in the range provided are already assigned to a client and in-use											
                                                                    </cfif>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </cfif>
                                                </div>
                                            </form>    
                                        </div>
                                    </cfoutput>			
                                
                                    <div class="card card-border">
                                        <div class="card-header">
                                            <h6>Password Generation List</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table id="recipientsTable" class="table table-bordered" style="width:100%">
                                                    <thead>
                                                        <tr>
                                                        <th class="min-th"></th>
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
                                                        <cfoutput query="getPassGen">
                                                        
                                                            <cfif getPassGen.num_sub_spreadsheets GT 0>
                                                                <cfset local.company_name = ' - '>
                                                                <cfset local.serial_range = ' - '>
                                                                <cfset local.sub_sheets = true>
                                                            <cfelse>
                                                                <cfset local.company_name = getPassGen.company_name>
                                                                <cfset local.serial_range = '#getPassGen.first_serial_num#-#getPassGen.last_serial_num#'>
                                                                <cfset local.sub_sheets = false>
                                                            </cfif>
                                                            
                                                            <tr>
                                                                <td>
                                                                    <cfif Len(getPassGen.spreadsheet_name) GT 0 AND local.sub_sheets EQ false>
                                                                        <a href="../passwords/#encodeForHTML(getPassGen.spreadsheet_name)#" target="_blank"><img src="#includePath#assets/images/icon/excel.gif"></a>														
                                                                    <cfelseif local.sub_sheets>
                                                                        <a href="labels-generate-sub-spreadsheets.cfm?label_pass_gen_id=#getPassGen.label_pass_gen_id#"><img src="#includePath#assets/images/icon/excel.gif"></a>
                                                                    <cfelse>
                                                                        &nbsp;
                                                                    </cfif>
                                                                </td>
                                                                <td>#local.company_name#</td>
                                                                <td>#local.serial_range#</td>
                                                                <td>#NumberFormat(getPassGen.num_passwords,',^')#</td>												
                                                                <td>#getPassGen.password_length#</td>
                                                                <td>#getPassGen.alpha_char#</td>
                                                                <td>#DateTimeFormat(getPassGen.create_dt,'short')#</td>
                                                                <td>
                                                                    <cfif local.sub_sheets>
                                                                        <a href="labels-generate-sub-spreadsheets.cfm?label_pass_gen_id=#getPassGen.label_pass_gen_id#" class="iconBox" data-toggle="tooltip" title="Edit" ><i class="material-icons">mode_edit</i></a>
                                                                    <cfelse>
                                                                        <button type="button" class="iconBox" title="Edit" onclick="editlabel(#getPassGen.label_pass_gen_id# ,#session.user_id#)"><i class="material-icons">mode_edit</i></button>												
                                                                    </cfif>
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
                    <div class="modal-header">
                        <h6 class="modal-title" id="addNewModalLabel">Generate Labels</h6>
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
                    <div class="modal-body" id="editLabel">
                    
                    </div>
                </div>
            </div>
        </div>
     
        <!--Add Legacy Modal -->
        <div class="modal fade" id="addLegacyModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addLegacyModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h6 class="modal-title" id="addLegacyModalLabel">Generate Labels</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <cfform  action="labels-generate-save.cfm" enctype="multipart/form-data" method="post">
                            <div class="gl-groups">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <h6 class="subTitle">Password Details</h6>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group custom-select">
                                            <label for="">Client</label>
                                            <select name="client" class="flat-select">
                                            <option value="choose" selected>Choose Client</option>
                                            <cfoutput query="getClients">																
                                                <option value="#getClients.client_id#">#getClients.company_name#</option>
                                            </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group">
                                            <label for="">Number of Passwords Needed</label>
                                            <input type="text" name="numPasswords" id="numPasswords" maxlength="200" class="form-control" placeholder="Enter a number">
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group custom-select">
                                            <label for="">Length of Password</label>
                                            <select name="passLength" class="flat-select">
                                                <cfoutput>
                                                    <cfloop from="1" to="30" index="i">
                                                        <option>#i#</option>
                                                    </cfloop>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group custom-select">
                                            <label for="">Include a Letter?</label>
                                            <select name="includeLetter" class="flat-select">
                                                <option data-display="No" value="0" >No</option>
                                                <option value="1">Yes - Start with a Letter I Provide</option>
                                                <option value="2">Yes - End with a Letter I Provide</option>
                                                <option value="3">Yes - Start with a Random Letter</option>
                                                <option value="4">Yes - End with a Random Letter</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group">
                                            <label for="">Letter</label>
                                            <input type="text" name="letter" id="letter" maxlength="1" class="form-control" placeholder="Enter a letter">
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-12">
                                        <div class="form-group">
                                            <label for="">Note</label>
                                            <input type="text" name="note" id="note" maxlength="200" class="form-control" placeholder="Internal Note">
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <h6 class="subTitle">Options</h6>
                                        <div class="form-group">
                                            <label for="">Verify Once Message</label>
                                            <textarea name="verify_once_message" id="verify_once_message" maxlength="400" rows="2" richtext="no" class="form-control" placeholder="Enter Message"><cfoutput>#application.verifyOnceMessageDefault#</cfoutput></textarea>
                                        </div>
                                        <div class="form-group custom-checkbox">
                                            <input type="checkbox" name="verify_once" class="form-check" id="verify_once_check" value="Y">
                                            <label for="verify_once_check">Verfiy Only Once?</label>
                                        </div>
                                        <div class="form-group custom-checkbox">
                                            <input type="checkbox" name="exclude_stats" class="form-check" id="statistics2" value="Y">
                                            <label for="statistics2">Exclude from statistics?</label>
                                        </div>
                                        <div class="form-group custom-checkbox">
                                            <input type="checkbox" name="include_serial" class="form-check" id="spreadsheet2" value="Y" checked="checked">
                                            <label for="spreadsheet2">Include Serial Number column in spreadsheet?</label>
                                        </div>
                                        <div class="btn-box mt-4">
                                            <button type="button" class="ThemeBtn">Save</button>
                                            <button type="button" class="ThemeBtn-outline">Cancel</button>
                                        </div>
                                    </div>
                                    <hr class="my-4">
                                    <div class="col-lg-12">
                                        <h6 class="subTitle">Log Output</h6>
                                    </div>
                                </div>
                            </div>
                        </cfform>
                    </div>
                </div>
            </div>
        </div>
     
        <!--Edit Password Modal -->
        <div class="modal fade" id="EditPasswordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
           aria-labelledby="EditPasswordModalLabel" aria-hidden="true">
           <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
              <div class="modal-content">
                 <div class="modal-header">
                    <h6 class="modal-title" id="EditPasswordModalLabel">Edit Password Set</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                 </div>
                 <div class="modal-body">
                    <cfform action="labels-generate-edit-save.cfm" enctype="multipart/form-data" method="post">
                        <div class="gl-groups">
                            <div class="row">
                                <div class="col-lg-12">
                                    <h6 class="subTitle">Password Set Details</h6>
                                </div>
            
                                <div class="col-lg-6 col-md-6 col-12">
                                    <div class="form-group custom-select">
                                        <label for="">Client</label>
                                        <select name="client" class="flat-select">
                                        <option value="">Choose Client</option>
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
            
                                <div class="col-lg-6 col-md-6 col-12">
                                    <div class="form-group">
                                        <label for="">Note</label>
                                        <cfoutput>
                                            <input type="text" name="note" id="note" class="form-control" placeholder="Internal Note" value="#getLabelGenDetail.label_note#">
                                        </cfoutput>
                                    </div>
                                </div>
            
                                <div class="col-lg-12">
                                    <h6 class="subTitle">Options</h6>
                                
                                    <div class="form-group">
                                        <label for="">Verify Once Message</label>
                                        <textarea name="verify_once_message" id="verify_once_message" maxlength="400" rows="2" class="form-control" placeholder="Enter Message"><cfoutput>#getLabelGenDetail.verify_once_msg#</cfoutput> 
                                        </textarea>
                                    </div>
                                
                                    <div class="form-group">
                                        <label for="">Label Validation Message</label>
                                        <textarea name="label_validation_msg" id="label_validation_msg" maxlength="400" richtext="no" rows="2" class="form-control" placeholder="Enter Message"><cfoutput>#getLabelGenDetail.label_validation_msg#</cfoutput></textarea>
                                    </div>
            
                                    <div class="form-group custom-checkbox">
                                        <cfif getLabelGenDetail.verify_once EQ 'Y'>
                                            <input type="checkbox" class="form-check" id="verify_once" name="verify_once" value="Y" checked="checked">
                                        <cfelse>
                                            <input type="checkbox" class="form-check" name="verify_once" type="checkbox" id="verify_once" value="Y">
                                        </cfif>
                                            <label for="Verfiy3">Verfiy Only Once?</label>
                                    </div>
            
                                    <div class="form-group custom-checkbox">
                                        <cfif getLabelGenDetail.exclude_from_stats EQ 1>
                                            <input type="checkbox" name="exclude_stats" class="form-check" id="exclude_stats" value="Y" checked="checked">
                                        <cfelse>
                                            <input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y" class="form-check">
                                        </cfif>
                                        <label for="exclude_stats">Exclude from statistics?</label>
                                    </div>
            
                                    <div class="btn-box mt-4">
                                        <button type="submit" class="ThemeBtn">Save</button>
                                        <button type="button" class="ThemeBtn-outline" data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                    <cfoutput>
                                        <!--- <input type="hidden" name="label_pass_detail_id" value="#getLabelGenDetail.label_pass_detail_id#"> --->
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </cfform>
                 </div>
              </div>
           </div>
        </div>
        <cfinclude template="#includePath#includes/footer/js_files.cfm">
        <script>
            $( document ).ready(function() {
            $(document).on('click','#submitForm', function(e) {
                e.preventDefault();
                var form = $("#genForm");
                var logId = $("#logId").val();
                var x = 0;
                $('#submitForm').css("opacity","0.5");
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
                    url: "labels-generate-save.cfm",
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