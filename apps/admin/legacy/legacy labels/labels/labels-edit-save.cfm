<cfif NOT StructKeyExists(form,"label_pass_detail_id")>
	<cflocation addtoken="no" url="labels-manage.cfm">
	<cfabort>
</cfif>

<cftry>

	<!--- Uploading video to server --->
	<!--- <cfif StructKeyExists(form,"video_url")>
		<cfif Len(form.video_url)>
			<cffile action="upload" filefield="video_url" destination="#expandPath('/labels/videos')#" nameconflict="makeunique" />
			<cfset video_url = cffile.CLIENTFILE>
		</cfif>
	</cfif> --->

	<cfif StructKeyExists(form, "cloud_link") AND form.cloud_link NEQ "">
		<cfset video_url = form.cloud_link>
	<cfelse>
		<cfif StructKeyExists(form, "video_url") AND Len(form.video_url)>
			<cfset uploadPath = expandPath('/labels/videos')>
			<cfif Not directoryExists(uploadPath)>
				<cfdirectory action="create" directory="#uploadPath#">
			</cfif>
			<cffile action="upload" filefield="video_url" destination="#uploadPath#" nameconflict="makeunique" />
			<cfset video_url = cffile.CLIENTFILE>
		</cfif>
	</cfif>

	<!--- Setting variables from form data --->
	<cfset client_id = form.client>
	<cfset verify_once_message = form.verify_once_message>
	<cfset label_validation_msg = form.label_validation_msg>
	<cfset label_pass_detail_id = form.label_pass_detail_id>
	<cfset note = form.note>
	<cfset verification_url = form.verification_url>

	<!--- Query: Update label Details--->
	<cfquery name="editLabel" datasource="#application.datasource#">
		UPDATE
			`#application.schema#`.`label_password_detail`
		SET
			`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#client_id#">,
			`update_dt` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			`update_user_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
			<cfif StructKeyExists(form,"verify_once")>
				`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
				`verify_once_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#verify_once_message#" null="#NOT Len(Trim(verify_once_message))#">,
			<cfelse>
				`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
			</cfif>
			`label_validation_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#label_validation_msg#" null="#NOT Len(Trim(label_validation_msg))#">,
			`label_note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#note#" null="#NOT Len(Trim(note))#">,
			`verification_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#verification_url#" null="#NOT Len(Trim(verification_url))#">,
			<cfif StructKeyExists(form,"exclude_stats")>
				`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			<cfelse>
				`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
			</cfif>,
			<cfif StructKeyExists(form,"app_validation_allowed")>
				`app_validation_allowed` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			<cfelse>
				`app_validation_allowed` = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
			</cfif>
			<cfif isDefined("video_url")>,
				`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#video_url#">
			</cfif>
		WHERE
			`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail_id#">
	</cfquery>


	<cflocation addtoken="no" url="labels-manage.cfm">

	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>