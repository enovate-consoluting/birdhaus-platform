<cftry>

    <cfparam name="local.video_url" default="">

	<cfif IsNumeric(form.spool_id) EQ false>
		<cfheader statuscode="400">
	</cfif>

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
	<cfif structKeyExists(form,'ver_icon') AND len(form.ver_icon) GT 0>
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
				<cfdump var="#cfcatch#" abort="true">
            </cfcatch>
        </cftry>
    </cfif>

    <cfquery name="updateSpool" datasource="#application.datasource#">
        UPDATE #application.schema#.spool
        SET product_page = <cfqueryparam value="#form.product_page#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim(form.product_page))#">,
            client_id = <cfqueryparam value="#form.client#" cfsqltype="cf_sql_integer" null="#NOT IsNumeric(form.client)#">,
			tag_inactive_msg = <cfqueryparam value="#form.tagInactiveMsg#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim(form.tagInactiveMsg))#">,
            <cfif StructKeyExists(form,"spool_active") AND form.spool_active EQ 'active'>
                active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
            <cfelse>
                active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
            </cfif>
			<cfif local.iconCloudUrl NEQ "">
				verification_icon = <cfqueryparam value="#local.iconCloudUrl#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim(local.iconCloudUrl))#">,
			</cfif>
			template_id = <cfqueryparam value="#form.template_id#" cfsqltype="cf_sql_integer" null="#NOT IsNumeric(form.template_id)#">
        WHERE spool_id = <cfqueryparam value="#form.spool_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfquery name="updateTag" datasource="#application.datasource#">
        UPDATE #application.schema#.tag
        SET product_page = <cfqueryparam value="#form.product_page#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim(form.product_page))#">,
            client_id = <cfqueryparam value="#form.client#" cfsqltype="cf_sql_integer" null="#NOT IsNumeric(form.client)#">,
            video_url = <cfqueryparam value="#local.video_url#" cfsqltype="cf_sql_varchar" null="#NOT Len(local.video_url)#">
        WHERE spool_id = <cfqueryparam value="#form.spool_id#" cfsqltype="cf_sql_integer">
    </cfquery>   

<cfcatch type="any">
	<cfheader statuscode="500">
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>