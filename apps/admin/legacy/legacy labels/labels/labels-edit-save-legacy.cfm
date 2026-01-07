<cfif NOT StructKeyExists(form,"rangeId")>
	<cflocation addtoken="no" url="labels-manage-legacy.cfm">
	<cfabort>
</cfif>

<cftry>

	<cfif StructKeyExists(form,"doc")>
		<cfif Len(form.doc)>
			<cffile action="upload" filefield="doc" destination="#application.labelsFolder#/#form.rangeId#" nameconflict="MAKEUNIQUE" />  <!---allowedExtensions=".jpg,.png"--->
		</cfif>
	</cfif>

	<!--- label --->
	<cfquery name="editLabel" datasource="#application.datasource#" result="product">
	UPDATE `#application.schema#`.`label_range`
	SET
	`range_start` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.range_start#">,
	`range_end` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.range_end#">,
	`range_alpha` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.alpha#">,
	`min_code_length` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Min(Len(form.range_end),Len(form.range_end)) + Len(form.alpha)#">,
	<cfif StructKeyExists(form,"doc") AND Len(form.doc)>
		`doc_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.serverfile#">,
	</cfif>
	<cfif StructKeyExists(form,"verify_once")>
		`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
		`verify_once_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.verify_once_message#" null="#NOT Len(Trim(form.verify_once_message))#">,
	<cfelse>
		`verify_once` = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
	</cfif>	
	`label_validation_msg` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.label_validation_msg#" null="#NOT Len(Trim(form.label_validation_msg))#">,
	`range_start_display` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.range_start#">,
	`range_end_display` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.range_end#">,
	`label_note` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#" null="#NOT Len(Trim(form.note))#">,
	`update_dt` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	`update_user_id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfif StructKeyExists(form,"exclude_stats")>
		`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	<cfelse>
		`exclude_from_stats` = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	</cfif>
	WHERE `range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rangeId#">
	</cfquery>

	<cflocation addtoken="no" url="labels-manage-legacy.cfm">

<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>