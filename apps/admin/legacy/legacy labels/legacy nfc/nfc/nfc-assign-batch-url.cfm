<!---<cfdump var="#form#"><cfabort>--->
<cftry>

	<cfif IsValid("URL",form.tag_redirect) EQ false OR NOT IsNumeric(form.tag_from)>
		<cfheader statuscode="400">
		<cfabort>
	</cfif>
	
	<!--- form.tag_to is optional; only reject if it's provided --->
	<cfif Len(form.tag_to) GT 0 AND NOT IsNumeric(form.tag_to)>
		<cfheader statuscode="400">
		<cfabort>
	</cfif>
	
	<cfquery name="updateUrl" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`tag`
	SET	`product_page` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tag_redirect#">
		<cfif StructKeyExists(form,"tag_to") AND IsNumeric(form.tag_to)>
		WHERE `seq_num` >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tag_from#"> and
			  `seq_num` <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tag_to#">
		<cfelse>
		WHERE `seq_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tag_from#">
		</cfif>
	</cfquery>

<cfcatch type="any">
	<cfheader statuscode="500">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>