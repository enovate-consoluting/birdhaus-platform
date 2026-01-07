<cffunction name="getInventry" access="remote">
    <cfargument name="spool_id" default="">
    <cftry>
        <cfquery name="spoolData" datasource="#application.datasource#">
            SELECT s.spool_id, s.num_tags, s.delivery_dt, s.active, c.company_name, c.client_id, s.product_page, s.tag_inactive_msg, s.verification_text_color, s.video_url, s.template_id
            FROM #application.schema#.spool s
            LEFT OUTER JOIN #application.schema#.client c ON s.client_id = c.client_id
            WHERE s.spool_id = "#arguments.spool_id#"        
        </cfquery>

        <cfquery name="getClients" datasource="#application.datasource#">
            SELECT c.company_name, c.client_id 
                FROM #application.schema#.client c
            WHERE status = 'Approved'
            ORDER BY c.company_name
        </cfquery>

		<cfquery name="getTemplates" datasource="#application.datasource#">
            SELECT 
				`templates`.`template_id`,
                `templates`.`template_name`
            FROM
				`#application.schema#`.`templates`
        </cfquery>

        <cfoutput>
            <cfform enctype="multipart/form-data" method="post" id="spoolUpdateForm">
                <div class="modal-body" id="edit-inventory">
                    <div class="AT-groups">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-12">
                                <div class="form-group">
                                    <div class="custom-select">
                                        <label for="">Client</label>
                                        <select name="client" class="flat-select"> 
                                            <option></option>
                                            <cfloop query="getClients">
                                                <option value="#getClients.client_id#"<cfif getClients.client_id EQ spoolData.client_id>selected</cfif>>#getClients.company_name#</option>
                                            </cfloop>
                                        </select>
                                    </div>	
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-6 col-12">
                                <div class="form-group">
                                    <label for="">Spool ID</label>
                                    <cfinput type="text" name="spool_id" value="#spoolData.spool_id#" required="yes" id="" class="form-control" placeholder="Spool id" disabled>
                                </div>
                            </div>

                            <div class="col-lg-12 col-md-12 col-12">
                                <div class="form-group">
                                    <label for="">NFC URL</label>
                                    <cfinput type="text" name="product_page" required="yes" value="#spoolData.product_page#" id="" class="form-control" placeholder="NFC URL"><br>
                                    (for mobile app validation, set to https://www.scanacart.com/get_app.cfm)
                                </div>   
                            </div>   

							<div class="col-lg-12 col-md-12 col-12">
                                <div class="form-group">
                                    <label for="">Inactive Message</label>
                                    <cfoutput>
                                        <input name="tagInactiveMsg" type="text" maxlength="250" class="form-control" placeholder="Inactive Message" value="#spoolData.tag_inactive_msg#"/>
                                    </cfoutput>
                                </div>
                            </div>
                            
                            <div class="col-lg-12 col-md-12 col-12">
                                <div class="form-group">
                                    <label for="video">Video</label>
                                    <input class="form-control fileInput" type="file" id="video" name="video" accept=".mp4">
                                </div>
                            </div>

                            <div class="col-lg-12 col-md-12 col-12">
                                <div class="form-group">
                                    <div class="or-divider">OR</div>
                                </div>
                            </div>

                            <div class="col-lg-12 col-md-12 col-12">
                                <div class="form-group">
                                    <label for="video_url">Video Url</label>
                                    <input class="form-control" type="text" id="video_url" name="video_url" value="#spoolData.video_url#">
                                </div>
                            </div>

							<div class="col-lg-6 col-md-6 col-12">
								<div class="form-group">
									<label for="">Verification Template</label>
									<cfoutput>
										<select name="template_id" class="flat-select select_data">
											<cfloop query="getTemplates">
												<option value="#template_id#" <cfif spoolData.template_id EQ template_id>selected</cfif>>#template_name#</option>
											</cfloop>
										</select>
									</cfoutput>
								</div>
							</div>

							<div class="col-lg-6 col-md-6 col-6">
                                <div class="form-group">
                                    <label for="ver_icon">Verification Icon</label>
                                    <input class="form-control fileInput" type="file" id="ver_icon" name="ver_icon" accept=".png,.jpg,.jpeg,.gif">
                                </div>
                            </div>

                            <div class="col-lg-6 col-md-6 col-12">
                                <div class="form-group">
                                    <label for="">Active</label>
                                    <div class="form-check form-switch form-switch-sm form-check-custom form-check-solid">                                        
                                        <input class="form-check-input" type="checkbox" name="spool_active" value="active" <cfif spoolData.active GT 0>checked="checked"</cfif>>                                                                
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="btn-box mt-2">
                                    <input type="hidden" name="spool_id" value="#spoolData.spool_id#">
                                    <button type="button" class="ThemeBtn" onclick="UpdateSpoolData('#spoolData.spool_id#')">Save</button>
                                    <button type="button" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </cfoutput>
        <cfcatch type="any">
            <cfdump var="#cfcatch#" abort="true">
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="add_nfc" access="remote" returntype="any">
    <cfargument name="user_id" defaul="0">

        
        <cfquery name="getClients" datasource="#application.datasource#">
            SELECT `client`.`client_id`,
                `client`.`company_name`
            FROM `#application.schema#`.`client`
            WHERE `client`.`status` = 'Approved'
            ORDER BY 2
        </cfquery>

		<cfquery name="getTemplates" datasource="#application.datasource#">
            SELECT 
				`templates`.`template_id`,
                `templates`.`template_name`
            FROM
				`#application.schema#`.`templates`
        </cfquery>

        <div class="gl-groups">
            <form id="genNfcForm" enctype="multipart/form-data">
                <div class="row">
                    <div class="col-lg-12">
                        <h6 class="subTitle">NFC Details</h6>
                    </div>

                    <div class="col-lg-6 col-md-6 col-12">
                        <div class="custom-select">                    
                            <label for="client-dropdown">Client</label>
                            <div class="select-flex">
                                <select name="client" class="form-control client-dropdown" id="client-dropdown">
                                    <option value="" selected disabled>Select Client</option>
                                    <cfoutput query="getClients">
                                        <option value="#getClients.client_id#">#getClients.company_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>	
                    <div class="col-lg-6 col-md-6 col-12">
                        <div class="form-group">
                            <label for="num_tags">Number of NFCs</label>
                            <cfoutput>
                                <input name="num_tags" id="num_tags" type="number" class="form-control" placeholder="Number of NFCs" />
                            </cfoutput>
                        </div>
                    </div>
					
					<div class="col-lg-6 col-md-6 col-12">
                        <div class="form-group">
                            <label for="">Per Spool</label>
                            <cfoutput>
                                <input name="per_spool" type="number" class="form-control" placeholder="NFCs per Spool" />
                            </cfoutput>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-6">
                        <div class="form-group">
                            <label for="">NFC Redirect URL</label>
                            <cfoutput>
                                <input name="product_page" type="text" maxlength="200" class="form-control" placeholder="Redirect URL" />
                            </cfoutput>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6 col-6">
                        <div class="form-group">
                            <label for="">Note</label>
                            <cfoutput>
                                <input name="note" type="text" maxlength="40" class="form-control" placeholder="Specify flavor, etc." />
                            </cfoutput>
                        </div>
                    </div>
					
					<div class="col-lg-6 col-md-6 col-6">
                        <div class="form-group">
                            <label for="">Percentage</label>
                            <cfoutput>
                                <input name="percentage" type="text" maxlength="40" class="form-control" placeholder="Percentage" value="10"/>
                            </cfoutput>
                        </div>
                    </div>

					<div class="col-lg-12 col-md-12 col-12">
                        <div class="form-group">
                            <label for="">Inactive Message</label>
                            <cfoutput>
                                <input name="tagInactiveMsg" type="text" maxlength="250" class="form-control" placeholder="Inactive Message"/>
                            </cfoutput>
                        </div>
                    </div>
					
                    <div class="col-lg-12">
                        <div class="form-group">
                            <label for="video">Video</label>
                            <input class="form-control fileInput" type="file" id="video" name="video" accept=".mp4">
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <div class="form-group">
                            <div class="or-divider">OR</div>
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <div class="form-group">
                            <label for="video_url">Video Url</label>
                            <input class="form-control" type="text" id="video_url" name="video_url">
                        </div>
                    </div>

					<div class="col-lg-6 col-md-6 col-12">
                        <div class="form-group">
                            <label for="">Verification Template</label>
                            <cfoutput>
                                <select name="template_id" class="flat-select select_data">
									<cfloop query="getTemplates">
										<option value="#template_id#">#template_name#</option>
									</cfloop>
								</select>
                            </cfoutput>
                        </div>
                    </div>

					<div class="col-lg-6">
                        <div class="form-group">
                            <label for="ver_icon">Verification Icon</label>
                            <input class="form-control fileInput" type="file" id="ver_icon" name="ver_icon" accept=".png,.jpg,.jpeg,.gif">
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <h6 class="subTitle">Options</h6>
	
						<div class="row" id="direct_to_app_section">
							<div class="col-5">
								<div class="form-group">
									<input name="client_url" type="radio" id="direct_to_app" value="N">
									<label for="direct_to_app" class="">NFC validation via mobile app</label>
								</div>
							</div>
							<div class="col-7">
								<span id="direct_to_app_url_demo" class="url-demo">https://www.scanacart.com/nfc/?id=98A6F998B76C4C10</span>
							</div>
						</div>

						<div class="row" id="client_url_section">
							<div class="col-5">
								<div class="form-group">
									<input name="client_url" type="radio" id="client_url" value="Y">
									<label for="client_url" class="">NFC URL should use client website</label>
								</div>
							</div>
							<div class="col-7">
								<span id="client_url_demo" class="url-demo"></span>
							</div>
						</div>
						
						<!---<div class="form-group custom-checkbox">
                            <input name="create_path" type="checkbox" id="create_path" value="Y">
                            <label for="create_path" class="">Create NFC Redirection Path</label>
                        </div>--->

                        <!---<div class="form-group custom-checkbox">
                            <input name="active" type="checkbox" id="active" value="Y" checked="checked">
                            <label for="active" class="">Active</label>
                        </div>--->

                        <div class="row">
                            <div class="col-5">
                                <div class="form-group custom-checkbox">
                                    <input name="bypass_sr" type="checkbox" id="bypass_sr" value="Y" checked="checked">
                                    <label for="bypass_sr" class="">Bypass Serial Number</label>
                                </div>
                            </div>
                            <div class="col-7 form-switch" style="padding-left:12px;">
                                <label for="show_scan">Scan Count: </label>
                                <input class="form-check-input" type="checkbox" role="switch" name="show_scan" id="show_scan" value="Y" checked="" style="margin-left:0;">
                            </div>
                        </div>

                        <div class="btn-box mt-4">
                            <button type="button" id="nfcAddSubmit" class="ThemeBtn" onClick="javascript:addNfcSave();">Save</button>
                            <button type="button" id="cancelBtn" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
                            <cfoutput>
                                <input type="hidden" name="logId" id="logId" value="#DateTimeFormat(now(),'mmddyyHHnnss')#">   
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
            </form>
        </div>
</cffunction> 

<cffunction name="updateVideoUrl" access="remote">
    <cfargument name="spools" default="">

    <cftry>
        <cfset local.videoUrl = "">
		<cfset local.show_scan = 0>
		<cfset local.bypass_sr = 0>
		
		<cfif structKeyExists(form,'bypass_sr')>
			<cfif form.bypass_sr EQ "Y">
				<cfset local.bypass_sr = 1>
			<cfelse>
				<cfset local.bypass_sr = 0>
			</cfif>
		</cfif>
		
		<cfif structKeyExists(form,'show_scan')>
			<cfif form.show_scan EQ "Y">
				<cfset local.show_scan = 1>
			<cfelse>
				<cfset local.show_scan = 0>
			</cfif>
		</cfif>

		<cfset local.videoUrl = "">
        <cfif structKeyExists(form,'video')>
            <cftry>
                <cfset local.videosPath = expandPath('/assets/video')>

                <cfif Not directoryExists('#local.videosPath#')>
                    <cfdirectory action="create" directory="#local.videosPath#">
                </cfif>

                <cffile action="upload" fileField="form.video" destination="#local.videosPath#" nameConflict="makeunique" result="videoUploadResult">

                <cfset local.videoUrl = application.siteUrl & "assets/video/" & videoUploadResult.serverFile>

                <cfcatch>
                </cfcatch>
            </cftry>
        </cfif>

        <cfif structKeyExists(form,'videoUrl') AND form.videoUrl NEQ "">
            <cfset local.videoUrl = form.videoUrl>
        </cfif>
		
		<cfset local.productImageUrl = "">
		<cfif structKeyExists(form,'product_img')>
            <cftry>
                <cfset local.videosPath = expandPath('/assets/video')>

                <cfif Not directoryExists('#local.videosPath#')>
                    <cfdirectory action="create" directory="#local.videosPath#">
                </cfif>

                <cffile action="upload" fileField="form.product_img" destination="#local.videosPath#" nameConflict="makeunique" result="imageUploadResult">

                <cfset local.productImageUrl = application.siteUrl & "assets/video/" & imageUploadResult.serverFile>

                <cfcatch>
                </cfcatch>
            </cftry>
        </cfif>

        <cfif structKeyExists(form,'product_image_url') AND form.product_image_url NEQ "">
            <cfset local.productImageUrl = form.product_image_url>
        </cfif>

		<cfset local.iconCloudUrl = "">
		<cfif structKeyExists(form,'ver_icon')>
			<cftry>
				<cfset local.verIconPath = expandPath('/assets/img/logo/')>

				<cfif Not directoryExists('#local.verIconPath#')>
					<cfdirectory action="create" directory="#local.verIconPath#">
				</cfif>

				<cffile action="upload" fileField="form.ver_icon" destination="#local.verIconPath#" nameConflict="makeunique" result="iconUploadResult">
				<cfset local.iconUrl = application.siteUrl & "assets/img/logo/" & iconUploadResult.serverFile>

				<cfhttp url="https://api.cloudflare.com/client/v4/accounts/#application.cloudflare_account_id#/images/v1" 
						method="POST"
						multipart="yes"
						result="httpResponse">

					<cfhttpparam type="header" name="Content-Type" value="multipart/form-data">
					<cfhttpparam type="header" name="Authorization" value="Bearer #application.cloudflare_api_token#">

					<cfhttpparam type="formfield" name="url" value="#local.iconUrl#">
				</cfhttp>
				
				<cfset responseJSON = DeserializeJSON(httpResponse.FileContent)>
				
				<cfif responseJSON.success>
					<cfset uid = responseJSON.result.id>
					<cfloop array="#responseJSON.result.variants#" index="variant">
						<cfif findNoCase("/public", variant)>
							<cfset local.iconCloudUrl = variant>
						</cfif>
					</cfloop>

					<cfif local.iconCloudUrl EQ "">
						<cfset local.iconCloudUrl = responseJSON.result.variants[1]>
					</cfif>
				<cfelse>
					<cfset uid = "">
					<cfset local.iconCloudUrl = "">
				</cfif>

				<cfcatch>
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfquery datasource="#application.datasource#">
			UPDATE
				`#application.schema#`.`nfc_generation`
			SET
				`nfc_generation`.`note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#">
			WHERE
				`nfc_generation`.`nfc_gen_id` IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spools#" list="true">)
		</cfquery>
        
        <cfquery name="getSpools" datasource="#application.datasource#">
            SELECT 
                `nfc_generation`.`nfc_gen_id`,
                `nfc_generation`.`first_spool_id`,
                `nfc_generation`.`last_spool_id`
            FROM
                `#application.schema#`.`nfc_generation`
            WHERE
                `nfc_generation`.`nfc_gen_id` IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spools#" list="true">)
        </cfquery>
        
        <cfloop query="getSpools">
            <cfquery datasource="#application.datasource#">
                UPDATE
                    `#application.schema#`.`tag`
                SET
                    `tag`.`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.videoUrl#">,
					`tag`.`product_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_name#">,
					`tag`.`product_image` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productImageUrl#">,
					`tag`.`bypass_sr_no` = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.bypass_sr#">,
					`tag`.`show_scan` = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.show_scan#">
                WHERE
                    `tag`.`spool_id` >= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.first_spool_id#">
                    AND `tag`.`spool_id` <= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.last_spool_id#">
            </cfquery>

			<cfquery datasource="#application.datasource#">
                UPDATE
                    `#application.schema#`.`spool`
                SET
                    `spool`.`template_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.template_id#">,
					<cfif local.iconCloudUrl NEQ "">
						`spool`.`verification_icon` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.iconCloudUrl#" null="#NOT Len(Trim(local.iconCloudUrl))#">,
					</cfif>
					`spool`.`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.videoUrl#"  null="#NOT Len(Trim(local.videoUrl))#">,
					`spool`.`product_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_name#"  null="#NOT Len(Trim(form.product_name))#">,
					`spool`.`product_image` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productImageUrl#"  null="#NOT Len(Trim(local.productImageUrl))#">,
					`spool`.`bypass_sr_no` = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.bypass_sr#">,
					`spool`.`show_scan` = <cfqueryparam cfsqltype="cf_sql_bit" value="#local.show_scan#">
                WHERE
                    `spool`.`spool_id` >= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.first_spool_id#">
                    AND `spool`.`spool_id` <= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.last_spool_id#">
            </cfquery>
        </cfloop>

        <cfoutput>#serializeJSON({"success":true})#</cfoutput>
        <cfcatch>
			<cfdump var="#cfcatch#" abort="true">
            <cfoutput>#serializeJSON({"success":false})#</cfoutput>
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="deleteTags" access="remote">
    <cfargument name="spools" default="">

    <cftry>
        
        <cfquery name="getSpools" datasource="#application.datasource#">
            SELECT 
                `nfc_generation`.`nfc_gen_id`,
                `nfc_generation`.`first_spool_id`,
                `nfc_generation`.`last_spool_id`
            FROM
                `#application.schema#`.`nfc_generation`
            WHERE
                `nfc_generation`.`nfc_gen_id` IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spools#" list="true">)
        </cfquery>
        
        <cfloop query="getSpools">
            <cfquery datasource="#application.datasource#">
                DELETE FROM
                    `#application.schema#`.`tag`
                WHERE
                    `tag`.`spool_id` >= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.first_spool_id#">
                    AND `tag`.`spool_id` <= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.last_spool_id#">
            </cfquery>
            
            <cfquery datasource="#application.datasource#">
                DELETE FROM
                    `#application.schema#`.`spool`
                WHERE
                    `spool`.`spool_id` >= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.first_spool_id#">
                    AND `spool`.`spool_id` <= <cfqueryparam cfsqltype="cf_sql_integer" value="#getSpools.last_spool_id#">
            </cfquery>
        </cfloop>

        <cfquery datasource="#application.datasource#">
            DELETE FROM
                `#application.schema#`.`nfc_generation`
            WHERE
                `nfc_generation`.`nfc_gen_id` IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spools#" list="true">)
        </cfquery>

        <cfoutput>#serializeJSON({"success":true})#</cfoutput>
        <cfcatch>
            <cfoutput>#serializeJSON({"success":false})#</cfoutput>
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="ViewTrackingDetail" access="remote">
    <cfargument name="tag_id" required="true">

    <cfset returnStruct = structNew()>
    <cfset returnStruct['success'] = true>

    <cftry>
        <cfquery name="getLocationQuery" datasource="#Application.datasource#">
            SELECT
                `tap_location`.`tag_id`,
                `tap_location`.`ip`,
                `tap_location`.`continent_name`,
                `tap_location`.`country_name`,
                `tap_location`.`region_name`,
                `tap_location`.`create_dt`,
                `tap_location`.`city`,
                `tap_location`.`zip`,
                `tag`.`seq_num`
            FROM
                `#Application.schema#`.`tap_location` AS `tap_location`
            JOIN 
                `#Application.schema#`.`tag` AS `tag` ON `tap_location`.`tag_id` = `tag`.`tag_id`
            WHERE
                `tap_location`.`tag_id` = <cfqueryparam value="#tag_id#" cfsqltype="cf_sql_integer">
                ORDER BY
            `tap_location`.`create_dt` asc

        </cfquery>
        <cfset customerLocation = []>
        <cfoutput>
                <div class="modal-content">
                     <div class="modal-header1">
						<h6 class="modal-title" id="EditTrackingModalLabel">Seq number: #getLocationQuery.seq_num#</h6>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<!---<div class="modal-url">
						<cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
							<cfset local.encryptedVal = Encrypt(getLocationQuery.seq_num,local.key,'BLOWFISH','Hex')>
							<cfset local.nfcUrl = "https://scanacart.com/nfc/?id=#local.encryptedVal#">
							<h6 class="modal-title" id="EditTrackingModalLabel">NFC Url: <a href="#local.nfcUrl#" target="_blank">#local.nfcUrl#</a></h6>
					</div>--->
                     <div class="modal-body" id="">
                        <div class="table-responsive">
                            <table id="EditTrackingModalLabelTable" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th scope="col">IP</th>
                                    <th scope="col">City</th>
                                    <th scope="col">Region</th>
                                    <th scope="col">Country</th>
                                    <th scope="col">Continent</th>
                                    <th scope="col">Zip</th>
                                    <th scope="col">Scanned at</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop query="#getLocationQuery#">
                                    <tr>
                                        <td>#getLocationQuery.ip#</td>
                                        <td>#getLocationQuery.city#</td>
                                        <td>#getLocationQuery.region_name#</td>
                                        <td>#getLocationQuery.country_name#</td>
                                        <td>#getLocationQuery.continent_name#</td>
                                        <td>#getLocationQuery.zip#</td>
                                         <td>#DateFormat(getLocationQuery.create_dt, "dd mmm yyyy")# #LSDateTimeFormat(getLocationQuery.create_dt, "HH:mm:ss.SSS")#</td>
                                </tr>
                                </cfloop>
                            </tbody>
                            </table>
                        </div>    
                        <div class="modal-footer">
                           <button type="button" class="ThemeBtn cancel" data-bs-dismiss="modal" aria-label="Close">Close</button>
                        </div>
                    </div>
                </div>
            </cfoutput>

        <cfcatch type="any">
            <cfdump var ="#cfcatch#" abort="true">
            <cfset returnStruct['message'] = '#cfcatch.message#'>
            <cfset returnStruct['detail'] = '#cfcatch.detail#'>
            <cfset returnStruct['success'] = false>
        </cfcatch>

    </cftry>
</cffunction>

<cffunction name="updatetrackingValidation" access="remote">
    <cfargument name="tag_id" default="">
    <cfargument name="trackingvalidation" default="">
    
    <cftry>
        <cfquery datasource="#application.datasource#">
            UPDATE
                `#application.schema#`.`tag`
            SET
                `tag`.`live` = <cfqueryparam cfsqltype="cf_sql_bit" value="#trackingvalidation#">
            WHERE
                `tag`.`tag_id` = <cfqueryparam value="#tag_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfoutput>#serializeJSON({"success":true})#</cfoutput>
        <cfcatch>
            <cfoutput>#serializeJSON({"success":false})#</cfoutput>
        </cfcatch>
    </cftry>
        
</cffunction>

<cffunction name="getRecordsByAjax" access="remote" returntype="any">
    <cfargument name="client_name" type="string" required="false" default="">
    <cfargument name="scan_count" default="">
    <cfargument name="status" default="">
	<cfargument name="seq_num" default="">
    <cfargument name="enc_id" default="">
	<cfargument name="countries" default="">
    
    <cfparam name="draw" default="1" type="integer" />
    <cfparam name="start" default="0" type="integer" />
    <cfparam name="length" default="10" type="integer" />
    <cfparam name="search" default="" type="string" />

    <cfquery name="returnData" datasource="#application.datasource#">
        SELECT
            t.seq_num,
            t.tag_id,
            t.product_page,
            t.client_id,
            t.spool_id,
            c.company_name,
            t.live,
            l.cnt AS scanCount
        FROM
            #application.schema#.tag t
        JOIN
            #application.schema#.client c ON t.client_id = c.client_id
        JOIN
            (
                SELECT tag_id, COUNT(*) AS cnt
                FROM #application.schema#.tap_location
                <cfif arguments.countries NEQ "">
                    WHERE country_name IN (<cfqueryparam value="#arguments.countries#" cfsqltype="cf_sql_varchar" list="true">)
                </cfif>
                GROUP BY tag_id
                <cfif arguments.scan_count NEQ "">
                    HAVING COUNT(tap_loc_id) > <cfqueryparam value="#arguments.scan_count#" cfsqltype="cf_sql_integer">
                </cfif>
            ) l ON l.tag_id = t.tag_id
        WHERE 1=1
        <cfif arguments.client_name NEQ "">
            AND c.company_name = <cfqueryparam value="#arguments.client_name#" cfsqltype="cf_sql_varchar">
        </cfif>
        <cfif arguments.status NEQ "">
            AND t.live = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_bit">
        </cfif>
		<cfif arguments.seq_num NEQ "">
            AND t.seq_num = <cfqueryparam value="#arguments.seq_num#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif arguments.enc_id NEQ "">

            <cftry>
                <cfset var local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
                <cfset var local.decryptedId = Decrypt(arguments.enc_id,local.key,'BLOWFISH','Hex')>
            <cfcatch type="any"></cfcatch>
            </cftry>
            <cfif StructKeyExists(local,"decryptedId") AND IsNumeric(local.decryptedId)>
                AND t.seq_num = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            <cfelse>
                AND t.seq_num = 0
            </cfif>
        </cfif>
        ORDER BY
            scanCount DESC
        LIMIT #arguments.length# OFFSET #arguments.start#
    </cfquery>

    <cfquery name="recCount" datasource="#application.datasource#">
        SELECT
            COUNT(*) AS cnt
        FROM
            #application.schema#.tag t
        JOIN
            #application.schema#.client c ON t.client_id = c.client_id
        JOIN
            (
                SELECT tag_id, COUNT(*) AS cnt
                FROM #application.schema#.tap_location
                <cfif arguments.countries NEQ "">
                    WHERE country_name IN (<cfqueryparam value="#arguments.countries#" cfsqltype="cf_sql_varchar" list="true">)
                </cfif>
                GROUP BY tag_id
                <cfif arguments.scan_count NEQ "">
                    HAVING COUNT(tap_loc_id) > <cfqueryparam value="#arguments.scan_count#" cfsqltype="cf_sql_integer">
                </cfif>
            ) l ON l.tag_id = t.tag_id
        WHERE 1=1
        <cfif arguments.client_name NEQ "">
            AND c.company_name = <cfqueryparam value="#arguments.client_name#" cfsqltype="cf_sql_varchar">
        </cfif>
        <cfif arguments.status NEQ "">
            AND t.live = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_bit">
        </cfif>
		<cfif arguments.seq_num NEQ "">
            AND t.seq_num = <cfqueryparam value="#arguments.seq_num#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif arguments.enc_id NEQ "">
            <cftry>
                <cfset var local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
                <cfset var local.decryptedId = Decrypt(arguments.enc_id,local.key,'BLOWFISH','Hex')>
            <cfcatch type="any"></cfcatch>
            </cftry>
            <cfif StructKeyExists(local,"decryptedId") AND IsNumeric(local.decryptedId)>
                AND t.seq_num = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            <cfelse>
                AND t.seq_num = 0
            </cfif>
        </cfif>       
    </cfquery>

    <cfcontent reset="true">
    
    {
        "draw": <cfoutput>#val(draw)#</cfoutput>,
        "recordsTotal": <cfoutput>#val(length)#</cfoutput>,
        "recordsFiltered": <cfoutput>#val(recCount.cnt)#</cfoutput>,
        "status": "<cfoutput>#arguments.status#</cfoutput>",
        "data":
        [
            <cfloop query="returnData">
                <cfif currentrow GT 1>,</cfif>
                <cfoutput>
                    {
                        "spool_id": "#returnData.spool_id#",
                        "seq_num": "#returnData.seq_num#",
                        "company_name":"#returnData.company_name#",
                        "product_page": "#returnData.product_page#",
                        "scanCount": "#returnData.scanCount#",
                        "live": "#returnData.live#",
                        "client_id":"#returnData.client_id#",
                        "tag_id":"#returnData.tag_id#"
                    }
                </cfoutput>
            </cfloop>                  
        ]
    }
</cffunction>

<cffunction name="getTotalScanCount" access="remote" returntype="any">
    <cfargument name="client_name" type="string" required="false" default="">
    <cfargument name="scan_count" default="">
    <cfargument name="status" default="">
	<cfargument name="seq_num" default="">
    <cfargument name="enc_id" default="">
	<cfargument name="countries" default="">

    <cfquery name="getScanCount" datasource="#application.datasource#">
        SELECT
            t.seq_num,
            t.tag_id,
            t.product_page,
            t.client_id,
            t.spool_id,
            c.company_name,
            t.live,
            l.cnt AS scanCount
        FROM
            #application.schema#.tag t
        JOIN
            #application.schema#.client c ON t.client_id = c.client_id
        JOIN
            (
                SELECT tag_id, COUNT(*) AS cnt
                FROM #application.schema#.tap_location
                <cfif arguments.countries NEQ "">
                    WHERE country_name IN (<cfqueryparam value="#arguments.countries#" cfsqltype="cf_sql_varchar" list="true">)
                </cfif>
                GROUP BY tag_id
                <cfif arguments.scan_count NEQ "">
                    HAVING COUNT(tap_loc_id) > <cfqueryparam value="#arguments.scan_count#" cfsqltype="cf_sql_integer">
                </cfif>
            ) l ON l.tag_id = t.tag_id
        WHERE 1=1
        <cfif arguments.client_name NEQ "">
            AND c.company_name = <cfqueryparam value="#arguments.client_name#" cfsqltype="cf_sql_varchar">
        </cfif>
        <cfif arguments.status NEQ "">
            AND t.live = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_bit">
        </cfif>
		<cfif arguments.seq_num NEQ "">
            AND t.seq_num = <cfqueryparam value="#arguments.seq_num#" cfsqltype="cf_sql_integer">
        </cfif>
        <cfif arguments.enc_id NEQ "">
            <cftry>
                <cfset var local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
                <cfset var local.decryptedId = Decrypt(arguments.enc_id,local.key,'BLOWFISH','Hex')>
            <cfcatch type="any"></cfcatch>
            </cftry>
            <cfif StructKeyExists(local,"decryptedId") AND IsNumeric(local.decryptedId)>
                AND t.seq_num = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            <cfelse>
                AND t.seq_num = 0
            </cfif>
        </cfif>        
        ORDER BY
            scanCount DESC
    </cfquery>

	<cfset totalSum = 0>
    <cfquery name="getTotalScanCount" dbtype="query">
        SELECT SUM(scanCount) AS totalScanCount FROM getScanCount
    </cfquery>

	<cfif getTotalScanCount.totalScanCount NEQ"">
		<cfset totalSum = getTotalScanCount.totalScanCount>
	</cfif>
    <cfoutput>
        {
            "totalNFCs":"#getScanCount.recordCount#",
            "totalScanCount":"#totalSum#"
        }
    </cfoutput>
</cffunction>

<cffunction name="getClientAppURL" access="remote">
	<cfargument name="client_id" default="0">
	
	<cfquery name="getUrl" datasource="#application.datasource#">
		SELECT
			`client`.`app_client_url`
		FROM
			`#application.schema#`.`client`
		WHERE
			`client`.`client_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.client_id#">
	</cfquery>
	
	<cfif getUrl.app_client_url NEQ "">
		<cfset local.baseUrlPattern = "^(https?://[^/]+)">
		<cfset local.baseURL = REFind(local.baseUrlPattern, getUrl.app_client_url, 1, true)>
		<cfif local.baseURL.len[1] GT 0>
			<cfset local.app_client_url = Mid(getUrl.app_client_url, local.baseURL.pos[1], local.baseURL.len[1])>
		<cfelse>
			<cfset local.app_client_url = getUrl.app_client_url>
		</cfif>
	<cfelse>
		<cfset local.app_client_url = "">
	</cfif>
	
	<cfoutput>#local.app_client_url#</cfoutput>
</cffunction>

<cffunction name="viewSeqNum" access="remote">
    <cfargument name="filename" required="true">

    <cfset returnStruct = structNew()>
    <cfset returnStruct['success'] = true>

    <cftry>
		
		<cffile action="read" file="#expandpath('/admin/nfc/tags/')##arguments.filename#" variable="spreadsheetData">
		<cfset nfcData = listToArray(spreadsheetData, Chr(10))>
		
        <cfoutput>
			<div class="table-responsive">
				<table id="viewSeqNumTable" class="table table-bordered">
					<thead>
						<tr>
							<th scope="col">Sr No.</th>
							<th scope="col">NFC URL</th>
							<th scope="col">Seq Num</th>
						</tr>
					</thead>
					<tbody>
						<cfset srNo = 1>
						<cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
						<cfloop array="#nfcData#" index="i">
							<cfif trim(i) NEQ "">
								<tr>
									<td>#srNo#</td>
									<td>#i#</td>
									<cfset local.decryptedId = Decrypt(ListLast(i,"="),local.key,'BLOWFISH','Hex')>
									<td>#local.decryptedId#</td>
								</tr>
								<cfset srNo = srNo + 1>
							</cfif>
						</cfloop>
					</tbody>
				</table>
			</div>
		</cfoutput>

        <cfcatch type="any">
            <cfdump var ="#cfcatch#" abort="true">
            <cfset returnStruct['message'] = '#cfcatch.message#'>
            <cfset returnStruct['detail'] = '#cfcatch.detail#'>
            <cfset returnStruct['success'] = false>
        </cfcatch>

    </cftry>
</cffunction>

<cffunction name="getClientDetails" access="remote">
	<cfargument name="client_id" default="0">
	
	<cfquery name="getUrl" datasource="#application.datasource#">
		SELECT
			`client`.`app_client_url`,
            `client`.`white_label`
		FROM
			`#application.schema#`.`client`
		WHERE
			`client`.`client_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.client_id#">
	</cfquery>

    <cfquery name="getNfcUrls" datasource="#application.datasource#">
        SELECT
            `nfc_site_urls`.`url`
        FROM
            `#application.schema#`.`nfc_site_urls`
        WHERE
            `nfc_site_urls`.`client_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.client_id#">
    </cfquery>
	
	<cfif getUrl.app_client_url NEQ "">
		<cfset local.baseUrlPattern = "^(https?://[^/]+)">
		<cfset local.baseURL = REFind(local.baseUrlPattern, getUrl.app_client_url, 1, true)>
		<cfif local.baseURL.len[1] GT 0>
			<cfset local.app_client_url = Mid(getUrl.app_client_url, local.baseURL.pos[1], local.baseURL.len[1])>
		<cfelse>
			<cfset local.app_client_url = getUrl.app_client_url>
		</cfif>
	<cfelse>
		<cfset local.app_client_url = "">
	</cfif>
	
	<cfoutput>#serializeJSON({'app_url':'#local.app_client_url#','white_label':'#getUrl.white_label#','urls':'#valueList(getNfcUrls.url)#'})#</cfoutput>
</cffunction>

<cffunction name="advanceFilter" access="remote">

	<cfquery name="getCountries" datasource="#application.datasource#">
		SELECT DISTINCT country_name FROM activity_location
		WHERE country_name IS NOT NULL AND country_name != '';
	</cfquery>
	
	<cfoutput>
		<div class="modal-box">
			<div class="sd-multiSelect form-group">
			  <label for="current-job-role">Advance Filter</label>
			  <select multiple id="country" class="sd-CustomSelect">
				<cfloop query="getCountries">
					<option value="#getCountries.country_name#">#getCountries.country_name#</option>
				</cfloop>
			  </select>
			</div>
		</div>
	</cfoutput>
		
</cffunction>

<cffunction name="importSrNo" access="remote">
	<cfsetting requesttimeout="3000">
    <cftry>
        <cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
        <cfspreadsheet action="read" src="#form.file#" query="mySpreadsheet" sheet="11">
        
        <cfloop query="mySpreadsheet">
            <cfif mySpreadsheet.col_1 EQ "">
                <cfcontinue>
            </cfif>
            <cfif listLen(mySpreadsheet.col_1, "?id=") GT 1>
                <cfset local.seq_num = decrypt(listLast(mySpreadsheet.col_1, "?id="), local.key, 'BLOWFISH', 'Hex')>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        `#application.schema#`.`tag`
                    SET
                        `tag`.`serial_no` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mySpreadsheet.col_3#">
                    WHERE
                        `tag`.`seq_num` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.seq_num#">
                </cfquery>
            </cfif>
        </cfloop>

        <cfoutput>#serializeJSON({"success":true})#</cfoutput>

        <cfcatch>
            <cfdump var ="#cfcatch#" abort="true">
        </cfcatch>
    </cftry>
</cffunction>

<cffunction name="getErrLog" access="remote" returntype="any">
    <cfargument name="log_id" default="0">

    <cfargument name="start_date" type="string" required="true">
    <cfargument name="end_date" type="string" required="true">
    <cfargument name="ip_address_search" type="string" default="">
	<cfargument name="showArchived" type="integer" default="0">

    <cfparam name="draw" default="1" type="integer" />
    <cfparam name="start" default="0" type="integer" />
    <cfparam name="length" default="10" type="integer" />
    <cfparam name="search" default="" type="string" />

    <cfset var qWhere = " 1=1 ">
    <cfset var startDateParam = CreateDateTime(Year(arguments.start_date), Month(arguments.start_date), Day(arguments.start_date), 0, 0, 0)>
    <cfset var endDateParam = CreateDateTime(Year(arguments.end_date), Month(arguments.end_date), Day(arguments.end_date), 23, 59, 59)>

    <cfif Len(arguments.ip_address_search) GT 0>
        <cfset qWhere = qWhere & " AND ip_address = <cfqueryparam value='#arguments.ip_address_search#' cfsqltype='cf_sql_varchar'> ">
    </cfif>
	
	<cfif Len(form["search[value]"]) GT 0>
        <cfset qWhere = qWhere & " AND nfc_url = <cfqueryparam value='#form["search[value]"]#' cfsqltype='cf_sql_varchar'> ">
    </cfif>

	<cfset local.archived = 0>
	<cfif arguments.showArchived EQ 1>
		<cfset local.archived = 1>
	</cfif>

    <cfquery name="getErrLogData" datasource="#application.datasource#">
        SELECT
            `nfc_error_logs`. `log_id`,
            REPLACE(REPLACE(`nfc_error_logs`. `nfc_url`, '\r\n', '\\n'), '\n', '\\n') as nfc_url,
            `nfc_error_logs`. `ip_address`,
            `nfc_error_logs`. `message`,
            `nfc_error_logs`. `details`,
            `nfc_error_logs`. `serial_no`,
            `nfc_error_logs`. `client_app`,
            `nfc_error_logs`. `created_at`,
            `nfc_error_logs`. `seq_num`,
			`nfc_error_logs`. `archived`,
            case
              when `nfc_error_logs`. `seq_num` is not null then
                case
                  when (select t.live from #application.schema#.tag t where t.seq_num = nfc_error_logs.seq_num and
                        t.tag_id = (select min(t2.tag_id) from #application.schema#.tag t2 where t2.seq_num = nfc_error_logs.seq_num) = b'1') then
                    1
                  else 
                    0
                  end
              else
                null
            end live,
            case
              when `nfc_error_logs`. `seq_num` is not null then
                (select min(t.tag_id) from #application.schema#.tag t where t.seq_num = nfc_error_logs.seq_num)
              else
                null
            end tag_id,
            case
              when `nfc_error_logs`. `domain_valid` = b'1' then
                'Yes'
              else
                'No'
            end domain_valid,
            case
              WHEN (LENGTH(LOWER(`nfc_error_logs`. `nfc_url`)) - LENGTH(REPLACE(LOWER(`nfc_error_logs`. `nfc_url`), 'http', ''))) / LENGTH('http') > 1 THEN
                'Yes'
              else
                'No'
            end double_https              
        FROM
            `#application.schema#`.`nfc_error_logs`
        WHERE
            created_at BETWEEN
            <cfqueryparam value="#startDateParam#" cfsqltype="cf_sql_timestamp">
            AND
            <cfqueryparam value="#endDateParam#" cfsqltype="cf_sql_timestamp">
            <cfif Len(arguments.ip_address_search) GT 0>
                AND `nfc_error_logs`.`ip_address` = <cfqueryparam value="#arguments.ip_address_search#" cfsqltype="cf_sql_varchar">
            </cfif>
			<cfif Len(form["search[value]"]) GT 0>
				AND nfc_url LIKE "%#form["search[value]"]#%"
			</cfif>
			AND archived = <cfqueryparam value='#local.archived#' cfsqltype='cf_sql_bit'>
            ORDER BY 
        <cfif Len(form["order[0][column]"]) GT 0>
            <cfswitch expression="#form["order[0][column]"]#"> 
                <cfcase value="0">log_id</cfcase>
                <cfcase value="1">client_app</cfcase>
                <cfcase value="2">serial_no</cfcase>
                <cfcase value="3">nfc_url</cfcase>
                <cfcase value="4">seq_num</cfcase>
                <cfcase value="5">domain_valid</cfcase>
                <cfcase value="6">double_https</cfcase>
                <cfcase value="7">live</cfcase>
                <cfcase value="8">details</cfcase>
                <cfdefaultcase>created_at</cfdefaultcase> 
            </cfswitch>
            
            #form["order[0][dir]"]#
		<cfelse>
            created_at DESC 
        </cfif>
        LIMIT <cfqueryparam value="#val(arguments.length)#" cfsqltype="cf_sql_integer"> OFFSET <cfqueryparam value="#val(arguments.start)#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfquery name="getErrLogDataCnt" datasource="#application.datasource#">
        SELECT
            COUNT(*) AS cnt
        FROM
            `#application.schema#`.`nfc_error_logs`
        WHERE
            created_at BETWEEN
            <cfqueryparam value="#startDateParam#" cfsqltype="cf_sql_timestamp">
            AND
            <cfqueryparam value="#endDateParam#" cfsqltype="cf_sql_timestamp">
            <cfif Len(arguments.ip_address_search) GT 0>
                AND `nfc_error_logs`.`ip_address` = <cfqueryparam value="#arguments.ip_address_search#" cfsqltype="cf_sql_varchar">
            </cfif>
			<cfif Len(form["search[value]"]) GT 0>
				AND nfc_url LIKE "%#form["search[value]"]#%"
			</cfif>
			AND archived = <cfqueryparam value='#local.archived#' cfsqltype='cf_sql_bit'>            
    </cfquery>

    <cfcontent reset="true">
    
    {
        "draw": <cfoutput>#val(draw)#</cfoutput>,
        "recordsTotal": <cfoutput>#val(getErrLogDataCnt.cnt)#</cfoutput>, 
        "recordsFiltered": <cfoutput>#val(getErrLogDataCnt.cnt)#</cfoutput>,
        "data":
        [
            <cfloop query="getErrLogData">
                <cfif currentrow GT 1>,</cfif>
                <cfoutput>
                    {
                        "log_id": "#getErrLogData.log_id#",
                        "client_app": "#getErrLogData.client_app#",
                        "serial_no": "#getErrLogData.serial_no#",
                        "nfc_url": "#getErrLogData.nfc_url#",
                        "seq_num": "#getErrLogData.seq_num#",
                        "domain_valid": "#getErrLogData.domain_valid#",
                        "double_https":"#getErrLogData.double_https#",
                        "live":"#getErrLogData.live#",
                        "tag_id":"#getErrLogData.tag_id#",
                        "ip_address":"#getErrLogData.ip_address#",
                        "message": "#getErrLogData.message#",
                        "details": "#getErrLogData.details#",
                        "created_at": "#DateFormat(getErrLogData.created_at, 'yyyy-mm-dd')# #TimeFormat(getErrLogData.created_at, 'hh:mm:ss')#",
						"archived": "#getErrLogData.archived#"
                    }
                </cfoutput>
            </cfloop>                  
        ]
    }
</cffunction>

<cffunction name="archiveLog" access="remote">
	<cfargument name="log_id" default="0">
	
	<cftry>
		<cfquery datasource="#application.datasource#">
			UPDATE
				`#application.schema#`.`nfc_error_logs`
			SET
				`nfc_error_logs`.`archived` = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
			WHERE
				`nfc_error_logs`.`log_id` = <cfqueryparam value="#arguments.log_id#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfoutput>1</cfoutput>
	<cfcatch>
		<cfoutput>0</cfoutput>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="editOptionsData" access="remote">
	<cfargument name="gen_id" default="0">
	
	<cftry>

		<cfset note = "">
		<cfset temp_id = "0">
		<cfset product_name = "">
		<cfset product_image = "">
		<cfset video_url = "">
		<cfset show_scan = "1">
		<cfset bypass_sr_no = "1">

		<cfquery name="getTemplates" datasource="#application.datasource#">
			SELECT 
				`templates`.`template_id`,
				`templates`.`template_name`
			FROM
				`#application.schema#`.`templates`
		</cfquery>

		<cfquery name="getGenData" datasource="#application.datasource#">
			SELECT
				`nfc_generation`.`first_spool_id`,
				`nfc_generation`.`note`
			FROM
				`#application.schema#`.`nfc_generation`
			WHERE
				`nfc_generation`.`nfc_gen_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gen_id#">
		</cfquery>

		<cfif getGenData.recordCount>
			<cfset note = getGenData.note>

			<cfquery name="getSpoolData" datasource="#application.datasource#">
				SELECT
					`spool`.`template_id`,	
					`spool`.`product_name`,
					`spool`.`product_image`,
					`spool`.`video_url`,
					`spool`.`show_scan`,
					`spool`.`bypass_sr_no`
				FROM
					`#application.schema#`.`spool`
				WHERE
					`spool`.`spool_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#getGenData.first_spool_id#">
			</cfquery>

			<cfset temp_id = getSpoolData.template_id>
			<cfset product_name = getSpoolData.product_name>
			<cfset product_image = getSpoolData.product_image>
			<cfset video_url = getSpoolData.video_url>
			<cfset show_scan = getSpoolData.show_scan>
			<cfset bypass_sr_no = getSpoolData.bypass_sr_no>
		</cfif>

		<cfoutput>
			<form id="addVideoForm">
				<div class="row">
					<div class="col-lg-6">
						<div class="form-group">
							<label for="note">Note</label>
							<input class="form-control" type="text" id="note" name="note" placeholder="Enter Note" value="#note#">
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label for="product_name">Product Name</label>
							<input class="form-control" type="text" id="product_name" name="product_name" placeholder="Enter Product Name" value="#product_name#">
						</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<label for="product_img">Product Image</label>
						<input class="form-control fileInput" type="file" id="product_img" name="product_img" accept=".png,.jpg,.jpeg">
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<div class="or-divider">OR</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<label for="product_img_url">Product Image Url</label>
						<input class="form-control" type="text" id="product_img_url" name="product_img_url" placeholder="Enter Product Image Url" value="#product_image#">
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<label for="video">Video</label>
						<input class="form-control fileInput" type="file" id="video" name="video" accept=".mp4">
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<div class="or-divider">OR</div>
					</div>
				</div>
				<div class="col-lg-12">
					<div class="form-group">
						<label for="videoUrl">Video Url</label>
						<input class="form-control" type="text" id="videoUrl" name="videoUrl"  placeholder="Enter Video Url" value="#video_url#">
					</div>
				</div>

				<div class="row">
					<div class="col-lg-6 col-md-6 col-12">
						<div class="form-group">
							<label for="">Verification Template</label>
							<cfoutput>
								<select name="template_id" class="flat-select select_data">
									<cfloop query="getTemplates">
										<option value="#template_id#" <cfif template_id EQ  temp_id>selected</cfif>>#template_name#</option>
									</cfloop>
								</select>
							</cfoutput>
						</div>
					</div>

					<div class="col-lg-6">
						<div class="form-group">
							<label for="ver_icon">Verification Icon</label>
							<input class="form-control fileInput" type="file" id="ver_icon" name="ver_icon" accept=".png,.jpg,.jpeg,.gif">
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-5">
						<div class="form-group custom-checkbox">
							<input name="bypass_sr" type="checkbox" id="bypass_sr" value="Y" <cfif bypass_sr_no EQ 1>checked="checked"</cfif>>
							<label for="bypass_sr" class="">Bypass Serial Number</label>
						</div>
					</div>
					<div class="col-7 form-switch" style="padding-left:12px;">
						<label for="show_scan">Scan Count: </label>
						<input class="form-check-input" type="checkbox" role="switch" name="show_scan" id="show_scan" value="Y" <cfif show_scan EQ 1>checked="checked"</cfif> style="margin-left:0;">
					</div>
				</div>
				<div class="btn-box mt-4">
					<button type="button" id="nfcAddurl" class="ThemeBtn" onClick="updateVideoUrl();">Save</button>
					<button type="button" id="cancelBtn" class="ThemeBtn-outline" data-bs-dismiss="modal" aria-label="Close">Cancel</button>
				</div>
			</form>
		</cfoutput>

		<cfcatch>
			<cfdump var="#cfcatch#" abort="true">
		</cfcatch>
	</cftry>
</cffunction>