
<cffunction  name="edit_label" access="remote" returntype="any">
    <cfargument  name="label_pass_gen_id" defaul="0">
    <cfargument  name="user_id" defaul="0">

    <cfquery name="getLabelGenDetail" datasource="#application.datasource#">
        SELECT `label_pass_generation`.`label_pass_gen_id`,
                `label_pass_generation`.`label_pass_detail_id`,
                `label_pass_generation`.`client_id`,
                `label_password_detail`.`label_pass_detail_id`,
                `label_password_detail`.`verify_once`,
                `label_password_detail`.`verify_once_msg`,
                `label_password_detail`.`label_validation_msg`,
                `label_password_detail`.`label_note`,
                `label_password_detail`.`exclude_from_stats`,
				`label_password_detail`.`verification_url`
        FROM `#application.schema#`.`label_pass_generation`,
             `#application.schema#`.`label_password_detail`
        WHERE `label_password_detail`.`label_pass_detail_id` = `label_pass_generation`.`label_pass_detail_id` and
              `label_pass_generation`.`label_pass_gen_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_pass_gen_id#">
        </cfquery>

        <cfquery name="getClients" datasource="#application.datasource#">
            SELECT `client`.`client_id`,
                `client`.`company_name`
            FROM `#application.schema#`.`client`
            WHERE `client`.`status` = 'Approved'
            ORDER BY 2
        </cfquery>
        <div class="gl-groups">
            <cfform id="genForm" action="#iif(arguments.label_pass_gen_id GT 0,'"labels-generate-edit-save.cfm"','"labels-generate-save.cfm"')#" enctype="multipart/form-data" method="post">
                <div class="row">
                    <div class="col-lg-12">
                        <h6 class="subTitle">Password Details</h6>
                    </div>

                    <div class="col-lg-6 col-md-6 col-12">
                        <div class="form-group custom-select">
                            <label for="">Client</label>
                            <select name="client" class="flat-select select_data">
                                <option value="choose" selected>Choose Client</option>
                                <cfloop query="getClients">
                                    <cfoutput>
                                        <cfif getClients.client_id EQ getLabelGenDetail.client_id>
                                            <option selected="selected" value="#getClients.client_id#">#getClients.company_name#</option>
                                        <cfelse>
                                            <option value="#getClients.client_id#">#getClients.company_name#</option>
                                        </cfif>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <cfif arguments.label_pass_gen_id EQ 0 >
                        <div class="col-lg-6 col-md-6 col-12">
                            <div class="form-group">
                                <label for="">Number of Passwords Needed</label>
                                <input type="text" name="numPasswords" id="numPasswords" class="form-control" placeholder="Enter a number">
                            </div>
                        </div>
                    <cfelse>
                        <div class="col-lg-6 col-md-6 col-12">
                            <label for="label_validation_msg">Label Validation Message</label>
                            <div class="col-sm-9">
                                <cftextarea name="label_validation_msg" id="label_validation_msg" maxlength="400" richtext="no" style="width:100%; height:80px;"><cfoutput>#getLabelGenDetail.label_validation_msg#</cfoutput></cftextarea>
                            </div>
                        </div>
                    </cfif>
					
					<div class="col-12 mb-3">
						<label for="verification_url">Verification URL</label>
						<cfoutput>
							<input type="text" name="verification_url" id="verification_url" class="form-control" placeholder="Enter a url" value="#getLabelGenDetail.verification_url#">
						</cfoutput>
					</div>
					
                    <div class="col-lg-12">
                        <div class="form-group">
                            <label for="note">Note</label>
                            <cfoutput>
                                <input name="note" id="note" type="text" maxlength="200" class="form-control" placeholder="Internal Note" value="#getLabelGenDetail.label_note#" />
                            </cfoutput>
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <h6 class="subTitle">Options</h6>

                        <div class="form-group">
                            <label for="">Verify Once Message</label>
                            <textarea name="verify_once_message" id="verify_once_message" rows="2" class="form-control" placeholder="Enter Message"><cfif arguments.label_pass_gen_id GT 0><cfoutput>#getLabelGenDetail.verify_once_msg#</cfoutput><cfelse><cfoutput>#application.verifyOnceMessageDefault#</cfoutput></cfif></textarea>
                        </div>

                        <div class="form-group custom-checkbox">
                            <cfif getLabelGenDetail.verify_once EQ 'Y'>
                                <input name="verify_once" type="checkbox" id="verify_once" value="Y" checked="checked">
                            <cfelse>
                                <input name="verify_once" type="checkbox" id="verify_once" value="Y">
                            </cfif>
                            <label for="verify_once">Verfiy Only Once?</label>
                        </div>

                        <div class="form-group custom-checkbox">
                            <cfif getLabelGenDetail.exclude_from_stats EQ 1>
                                <input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y" checked="checked">
                            <cfelse>
                                <input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y">
                            </cfif>
                            <label for="exclude_stats">Exclude from statistics?</label>
                        </div>

                        <div class="form-group custom-checkbox">
                            <input type="checkbox" class="form-check" id="spreadsheet" name="include_serial">
                            <label for="spreadsheet">Include Serial Number column in spreadsheet?</label>
                        </div>

                        <div class="btn-box mt-4">
                            <cfif arguments.label_pass_gen_id GT 0>
                                <button type="submit" class="ThemeBtn">Save</button>
                            <cfelse>
                                <button type="submit" id="submitForm" class="ThemeBtn">Save</button>
                            </cfif>
                            <button type="button"id="cancelBtn" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                            <cfoutput>
                                <cfif arguments.label_pass_gen_id GT 0>
                                    <input type="hidden" name="label_pass_detail_id" value="#getLabelGenDetail.label_pass_detail_id#">
                                <cfelse>
                                    <input type="hidden" name="logId" id="logId" value="#DateTimeFormat(now(),'mmddyyHHnnss')#">
                                </cfif>
                            </cfoutput>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="col-lg-12">
                        <h6 class="subTitle">Log Output</h6>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <div id="logData"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </div>
</cffunction>


<cffunction  name="manage_label" access="remote" returntype="any">
    <cfargument  name="label_pass_detail_id" defaul="0">
    <cfquery name="getLabelPassDetail" datasource="#application.datasource#">
        SELECT `label_password_detail`.`label_pass_detail_id`,
            `label_password_detail`.`client_id`,
            `label_password_detail`.`create_dt`,
            `label_password_detail`.`create_user_id`,
            `label_password_detail`.`update_dt`,
            `label_password_detail`.`update_user_id`,
            `label_password_detail`.`verify_once`,
            `label_password_detail`.`verify_once_msg`,
            `label_password_detail`.`label_validation_msg`,
            `label_password_detail`.`label_note`,
            `label_password_detail`.`exclude_from_stats`,
            `label_password_detail`.`app_validation_allowed`,
            `label_password_detail`.`video_url`,
            `label_password_detail`.`verification_url`
        FROM `#application.schema#`.`label_password_detail`
        WHERE `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_pass_detail_id#">
    </cfquery>

    <cfquery name="getClients" datasource="#application.datasource#">
        SELECT `client`.`client_id`,
            `client`.`company_name`
        FROM `#application.schema#`.`client`
        WHERE `client`.`status` = 'Approved'
        ORDER BY 2
    </cfquery>
    <div class="gl-groups">
        <cfform action="labels-edit-save.cfm" enctype="multipart/form-data" method="post">
            <div class="row">
                <div class="col-lg-12">
                    <h6 class="subTitle">Label Details</h6>
                </div>

                <div class="col-lg-6 col-md-6 col-12">
                    <div class="form-group custom-select">
                        <label for="">Client</label>
                        <select name="client" class="flat-select">
                            <cfoutput>
                                <cfloop query="getClients">
                                    <cfif getClients.client_id EQ getLabelPassDetail.client_id>
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
                            <input name="note" id="note" type="text" maxlength="200" class="form-control" placeholder="Internal Note" value="#getLabelPassDetail.label_note#" />
                        </cfoutput>
                    </div>
                </div>
				
				<div class="col-12 mb-3">
                    <label for="verification_url">Verification URL</label>
                    <cfoutput>
                        <input type="text" name="verification_url" id="verification_url" class="form-control" placeholder="Enter a url" value="#getLabelPassDetail.verification_url#">
                    </cfoutput>
                </div>

                <div class="col-lg-12">
                    <h6 class="subTitle">Options</h6>

                    <div class="form-group">
                        <label for="">Verify Once Message</label>
                        <textarea name="verify_once_message" id="verify_once_message" maxlength="400" richtext="no" rows="2" class="form-control" placeholder="Enter Message"><cfoutput>#getLabelPassDetail.verify_once_msg#</cfoutput></textarea>
                    </div>

                    <div class="form-group">
                        <label for="">Label Validation Message</label>
                        <textarea name="label_validation_msg" id="label_validation_msg" maxlength="400" richtext="no" rows="2" class="form-control" placeholder="Enter message"><cfoutput>#getLabelPassDetail.label_validation_msg#</cfoutput></textarea>
                    </div>

                    <div class="form-group">
                        <label for="video_url">Video URL</label>
                        <input class="form-control fileInput" type="file" id="video_url" name="video_url" accept="/*">
						<div class="col-lg-12 mt-3">
							<div class="form-group">
								<div class="or-divider">OR</div>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label for="cloud-link">Cloud Link</label>
								<input class="form-control" type="text" id="cloud-link" name="cloud_link">
							</div>
						</div>
                        <div class="col-4 mb-2 product_image">
                            <div class="previewImageWrap">
                                <img id="previewImage" src="<cfoutput>
                                    <cfif getLabelPassDetail.video_url NEQ "">#application.siteUrl#labels/videos/#getLabelPassDetail.video_url#<cfelse>""</cfif>
                                </cfoutput>" alt="" style="width: 100%; height: auto;">
                            </div>
                        </div>
                    </div>
                    <div class="form-group custom-checkbox">
                        <cfif getLabelPassDetail.verify_once EQ 'Y'>
                            <input name="verify_once" type="checkbox" id="verify_once" value="Y" checked="checked">
                        <cfelse>
                            <input name="verify_once" type="checkbox" id="verify_once" value="Y">
                        </cfif>
                        <label for="verify_once">Verfiy Only Once?</label>
                    </div>

                    <div class="form-group custom-checkbox">
                        <cfif getLabelPassDetail.exclude_from_stats EQ 1>
                            <input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y" checked="checked">
                        <cfelse>
                            <input name="exclude_stats" type="checkbox" id="exclude_stats" value="Y">
                        </cfif>
                        <label for="exclude_stats">Exclude from statistics?</label>
                    </div>

                    <div class="form-group custom-checkbox">
                        <cfif getLabelPassDetail.app_validation_allowed EQ 1>
                            <input name="app_validation_allowed" type="checkbox" id="app_validation_allowed" value="Y" checked="checked">
                        <cfelse>
                            <input name="app_validation_allowed" type="checkbox" id="app_validation_allowed" value="Y">
                        </cfif>
                        <label for="app_validation_allowed">Allow Validation From Mobile App?</label>
                    </div>

                    <div class="btn-box mt-4">
                        <button type="submit" class="ThemeBtn">Save</button>
                        <button type="button" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                    </div>
                    <cfoutput>
                        <input type="hidden" name="label_pass_detail_id" value="#getLabelPassDetail.label_pass_detail_id#">
                    </cfoutput>
                </div>
            </div>
        </cfform>
    </div>
</cffunction>
