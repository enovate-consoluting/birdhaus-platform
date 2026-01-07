<cfif NOT StructKeyExists(session,"email")>	
	<cflocation addtoken="no" url="labels-manage-legacy.cfm">
	<cfabort>
</cfif>

<cftry>

	<!--- product --->
	<cfquery name="insertLabelRange" datasource="#application.datasource#" result="range">
	INSERT INTO `#application.schema#`.`label_range`
	(`range_start`,
	`range_end`,
	`range_alpha`,
	`doc_name`,
	`min_code_length`,
	`create_dt`,
	`create_user_id`,
	`update_dt`,
	`update_user_id`,
	`active`,
	`verify_once`,
	`verify_once_msg`,
	`label_validation_msg`,
	`range_start_display`,
	`range_end_display`,
	`label_note`,
	`client_id`,
	`exclude_from_stats`)
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.range_start#">,
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.range_end#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.alpha#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="temp">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Min(Len(form.range_end),Len(form.range_end)) + Len(form.alpha)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
	<cfif StructKeyExists(form,"verify_once")>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.verify_once_message#" null="#NOT Len(Trim(form.verify_once_message))#">,
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.label_validation_msg#" null="#NOT Len(Trim(form.label_validation_msg))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.range_start#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.range_end#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#" null="#NOT Len(Trim(form.note))#">,
	(select MIN(client_id) from scanacart.client where company_name = 'KRT' and status = 'Approved'),
	<cfif StructKeyExists(form,"exclude_stats")>
		<cfqueryparam cfsqltype="cf_sql_bit" value="1">
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_bit" value="0">
	</cfif>
	) 
	</cfquery>
	
	<cfif NOT DirectoryExists('#application.labelsFolder#/#range.GENERATED_KEY#')>
		<cfdirectory action="create" directory="#application.labelsFolder#/#range.GENERATED_KEY#">
	</cfif>
	
	<!--- save document --->
	<cfif StructKeyExists(form,"doc") AND Len(form.doc) GT 0>
		<cffile action="upload" filefield="doc" destination="#application.labelsFolder#/#range.GENERATED_KEY#" nameconflict="MAKEUNIQUE" allowedExtensions=".pdf"  />
		<cfset local.doc_name = cffile.serverfile>
	<cfelse>
		<cfset local.doc_name = ''>
	</cfif>
	
	<cfquery name="updateDocName" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`label_range`
	SET	`doc_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.doc_name#" null="#NOT Len(local.doc_name)#">
	WHERE `range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#range.GENERATED_KEY#">	
	</cfquery>
	
	<cflocation addtoken="no" url="labels-manage-legacy.cfm">

<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>