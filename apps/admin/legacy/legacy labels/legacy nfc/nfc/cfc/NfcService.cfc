<cfcomponent>
	<cfsetting requestTimeOut = "9600" />
	<cffunction name="generateNfcs" access="public" returntype="string">
		<cfargument name="numTags" type="numeric" required="yes">
		<cfargument name="clientId" type="string" required="yes">
        <cfargument name="productPage" type="string" required="yes">
		<cfargument name="tagInactiveMsg" type="string" default="">
		<cfargument name="active" type="boolean" required="yes">
        <!---<cfargument name="directToApp" type="boolean" required="yes">--->
        <cfargument name="useClientUrl" type="boolean" required="yes">
		<cfargument name="logId" type="string" required="yes">
		<cfargument name="userId" type="numeric" required="yes"> 
        <cfargument name="note" type="string" required="yes">
        <cfargument name="bypass_sr" type="boolean" required="yes">
		<cfargument name="perSpool" type="string" default="">
		<cfargument name="percentage" type="numeric" default="0">
		<cfargument name="template_id" type="numeric" default="0">

        <cfset local.nfcFolder = '#ExpandPath(".")#\log\'>
        <cfset local.logBasePath = '#ExpandPath(".")#\log\'>			
        <cfset local.logFullPath = local.logBasePath & 'NfcService#Trim(arguments.logId)#.txt'>
        <cfset local.logErrorFullPath = local.logBasePath & 'error.txt'>
    
        <cfif NOT DirectoryExists(local.logBasePath)>
            <cfdirectory action="create" directory="#local.logBasePath#">
        </cfif>
		
		<cftry>
			<cfset local.additionalTags = int(arguments.numTags * (arguments.percentage / 100))>
			<cfset local.numTags = arguments.numTags + local.additionalTags>
			
            <cfif arguments.perSpool EQ "">
                <cfset local.numPerSpool = 2500>
            <cfelse>
                <cfset local.numPerSpool = arguments.perSpool>
            </cfif>
			
	        <cfset local.key = 'zQmbEXgl2pYjf4f8xdA1/g=='>
            <cfset local.totalGenerated = 0>
            <cfset local.productPage = arguments.productPage>

			<cfif IsNumeric(arguments.clientId)>
				<cfquery name="getClient" datasource="#application.datasource#">
				select company_name, 
                    app_client_url,
					website_url,
					white_label
				from `#application.schema#`.`client`
				where client_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.clientId#">
				</cfquery>
				<cfset local.clientName = Replace(getClient.company_name,' ','_','all')>
                
                <cfset local.baseUrlPattern = "^(https?://[^/]+)">
				<cfset local.baseURL = REFind(local.baseUrlPattern, getClient.app_client_url, 1, true)>
				<cfif local.baseURL.len[1] GT 0>
					<cfset local.app_client_url = Mid(getClient.app_client_url, local.baseURL.pos[1], local.baseURL.len[1])>
				<cfelse>
					<cfset local.app_client_url = getClient.app_client_url>
				</cfif>
                
				<cfif getClient.white_label EQ 1>
					<cfif arguments.web_url EQ true>
						<cfset local.clientUrl = getClient.website_url>
						<cfset local.productPage = arguments.web_url_dropdown>
					<cfelse>
						<cfset local.clientUrl = local.app_client_url>
						<cfset local.productPage = local.app_client_url & "/get_app.cfm">
					</cfif>
				<cfelse>
					<cfif IsValid('URL',local.productPage) AND arguments.useClientUrl EQ true and IsValid('URL',local.app_client_url)> 
						<cfset local.clientUrl = local.app_client_url>
						
					<cfelseif IsValid('URL',local.app_client_url) AND arguments.useClientUrl EQ true>
						<cfset local.clientUrl = local.app_client_url>
						<cfset local.productPage = local.app_client_url & "/get_app.cfm">
					<cfelse>
						<cfset local.clientUrl = 'https://www.scanacart.com'>
						<cfset local.productPage = 'https://www.scanacart.com/get_app.cfm'>
					</cfif>
				</cfif>
			<cfelse>
				<cfset local.clientName = 'Generic'>
                <cfset local.clientUrl = 'https://www.scanacart.com'>
			</cfif>

            <cfset local.filename = "#local.clientName#_#local.numTags#_NFCs_#DateFormat(now(),'mm-dd-yyyy')#_#CreateUUID()#.csv">            
			<cffile action="write" file="#application.nfcDir##local.filename#" output="" nameconflict="overwrite">

			<cffile action="write" file="#local.logErrorFullPath#" nameconflict="overwrite" output="">
			<cffile action="write" file="#local.logFullPath#" nameconflict="overwrite" output="Begin NFC generator...<br>">
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#DateTimeFormat(now(),'iso')#<br>Generating #local.numTags# NFCs<br>">

            <cfset local.video_url = "">

            <cfif structKeyExists(form,'video')>
                <cftry>
                    <cfset local.videosPath = expandPath('/assets/video')>

                    <cfif Not directoryExists('#local.videosPath#')>
                        <cfdirectory action="create" directory="#local.videosPath#">
                    </cfif>

                    <cffile action="upload" fileField="form.video" destination="#local.videosPath#" nameConflict="makeunique" result="videoUploadResult">

                    <cfset local.video_url = application.siteUrl & "assets/video/" & videoUploadResult.serverFile>

                    <cfcatch>
                    </cfcatch>
                </cftry>
            </cfif>

            <cfif structKeyExists(form,'video_url') AND form.video_url NEQ "">
                <cfset local.video_url = form.video_url>
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
		      			
            <!--- do work --->
            <cfloop from="1" to="#Ceiling(local.numTags / local.numPerSpool)#" index="z">

                <cfquery name="getMaxTag" datasource="#application.datasource#">
                select IFNULL(max(seq_num),0) as cnt from #application.schema#.tag		
                </cfquery>

                <cfset local.tagCounter = getMaxTag.cnt>	
                
                <cfquery name="insertSpool" datasource="#application.datasource#" result="spoolResult">
                INSERT INTO `#application.schema#`.`spool`
                (`create_dt`,                
                `num_tags`,
                `product_page`,
                `client_id`,
				`tag_inactive_msg`,
                `active`,
				`verification_icon`,
				`template_id`,
				`video_url`,
				`show_scan`,
				`bypass_sr_no`)
                VALUES
                (<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">,
                <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#local.numPerSpool#">,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#local.productPage#" null="#NOT Len(Trim(local.productPage))#">,
                <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.tagInactiveMsg#" null="#NOT Len(Trim(arguments.tagInactiveMsg))#">,
                <cfif arguments.active EQ true>
                    <cfqueryparam cfsqltype="CF_SQL_BIT" value="1">,
                <cfelse>
                    <cfqueryparam cfsqltype="CF_SQL_BIT" value="0">,
                </cfif>
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#local.iconCloudUrl#" null="#NOT Len(Trim(local.iconCloudUrl))#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.template_id#" null="#NOT Len(Trim(arguments.template_id))#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#local.video_url#" null="#NOT Len(local.video_url)#">,
				<cfqueryparam cfsqltype="CF_SQL_BIT" value="#arguments.show_scan#">,
				<cfqueryparam cfsqltype="CF_SQL_BIT" value="#arguments.bypass_sr#" null="#NOT Len(arguments.bypass_sr)#">
                )
                </cfquery>

                <cfif z EQ 1>
                    <cfset local.firstSpoolId = spoolResult.GENERATED_KEY>                    
                </cfif>
                <cfset local.lastSpoolId = spoolResult.GENERATED_KEY>           

                <cfloop from="1" to="#local.numPerSpool#" index="i">

                    <cfset local.tagCounter = local.tagCounter + 1>
                    <cfset local.totalGenerated = local.totalGenerated + 1>

                    <cfset local.encryptedVal = Encrypt(local.tagCounter,local.key,'BLOWFISH','Hex')>		

                    <cfquery name="insertTag" datasource="#application.datasource#">
                        INSERT INTO `#application.schema#`.`tag`
                        (`seq_num`,
                        `product_page`,
                        `live`,
                        `spool_id`,
                        `client_id`,
                        `video_url`,
						`bypass_sr_no`,
						`show_scan`)
                        VALUES
                        (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#local.tagCounter#">,
                        <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#local.productPage#" null="#NOT Len(Trim(local.productPage))#">,
                        <cfqueryparam cfsqltype="CF_SQL_BIT" value="1">,
                        <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#spoolResult.GENERATED_KEY#">,
                        <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">,
                        <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#local.video_url#" null="#NOT Len(local.video_url)#">,
						<cfqueryparam cfsqltype="CF_SQL_BIT" value="#arguments.bypass_sr#" null="#NOT Len(arguments.bypass_sr)#">,
						<cfqueryparam cfsqltype="CF_SQL_BIT" value="#arguments.show_scan#">)
                    </cfquery>		 
                    
                    <cffile action="append" file="#application.nfcDir##local.filename#" output="#local.clientUrl#/nfc/?id=#local.encryptedVal#" addnewline="yes">		
                    
                    <cfif local.totalGenerated EQ local.numTags>
                        <cfbreak>
                    </cfif> 

                </cfloop>		

                <cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Spool #spoolResult.GENERATED_KEY# created with #local.numPerSpool# tags<br>">

            </cfloop> 

            <!--- rename file to include spool IDs --->            
            <cfset local.newFilename = "#local.clientName#_#local.numTags#_NFCs_#Trim(REReplace(arguments.note, "[^a-zA-Z0-9 ]", "", "ALL"))#_#DateFormat(now(),'mm-dd-yyyy')#_spool#local.firstSpoolId#_to_#local.lastSpoolId#.csv"> 
            <cffile action="rename" source="#application.nfcDir##local.filename#" destination="#application.nfcDir##local.newFilename#">

            <cfquery name="insertNfcGen" datasource="#application.datasource#">
            INSERT INTO `#application.schema#`.`nfc_generation`
            (`first_spool_id`,
            `last_spool_id`,
            `client_id`,
            `num_tags`,
            `create_dt`,
            `create_user_id`,
            `spreadsheet_name`,
            `note`,
            `nfcs_per_spool`)
            VALUES
            (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#local.firstSpoolId#">,
            <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#local.lastSpoolId#">,
            <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">,
            <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#local.numTags#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.newFilename#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.note)#" null="#NOT Len(Trim(arguments.note))#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.numPerSpool#">)
            </cfquery>
            
			<cfset myResult="complete">
			<cfreturn myResult>		
		
		<cfcatch type="any">
			<cfdump var="#cfcatch#" abort="true">
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#cfcatch.Message# #cfcatch.Detail#<br>">
			<cfset myResult = "An error occurred">
			<cfreturn myResult>
		</cfcatch>
		</cftry>
		

	</cffunction>
	
</cfcomponent>