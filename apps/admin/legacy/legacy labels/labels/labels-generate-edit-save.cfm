<cfif NOT StructKeyExists(form,"label_pass_detail_id")>
	<cflocation addtoken="no" url="labels-manage.cfm">
	<cfabort>
</cfif>

<cftry>

	<!--- password detail --->
	<cfquery name="editLabelDetail" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`label_password_detail`
	SET
	<cfif Len(form.client) GT 0>
		`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#">,
		`active` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
	<cfelse>
		`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" null="yes">,
		`active` = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,	
	</cfif>
	`update_dt` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	`update_user_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfif StructKeyExists(form,"verify_once")>
		`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
		`verify_once_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.verify_once_message#" null="#NOT Len(Trim(form.verify_once_message))#">,
	<cfelse>
		`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
	</cfif>	
	`label_validation_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.label_validation_msg#" null="#NOT Len(Trim(form.label_validation_msg))#">,
	`label_note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#" null="#NOT Len(Trim(form.note))#">,
	<cfif StructKeyExists(form,"exclude_stats")>
		`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	<cfelse>
		`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	</cfif>	
	WHERE `label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.label_pass_detail_id#">
	</cfquery>
	
	<!--- password detail --->
	<cfquery name="editPassGenDetail" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`label_pass_generation`
	SET	`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#" null="#NOT Len(form.client)#">
	WHERE `label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.label_pass_detail_id#">
	</cfquery>
	
	<cfquery name="editLabelPass" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`label_password`
	SET	`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#" null="#NOT Len(form.client)#">
	WHERE `label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.label_pass_detail_id#">
	</cfquery>

	<cflocation addtoken="no" url="labels-generate.cfm">

<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>