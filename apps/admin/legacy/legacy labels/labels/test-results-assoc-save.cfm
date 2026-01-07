<cfif NOT StructKeyExists(session,"email")>
	<cfabort>
</cfif>

<cftry>

	<cfif NOT StructKeyExists(URL,"client_id") AND NOT StructKeyExists(URL,"label_id") AND NOT StructKeyExists(URL,"label_type")>
		<cfabort>
	</cfif>
	
	<!--- remove any previous associations --->
	<cfquery name="removeAssociations" datasource="#application.datasource#">
	DELETE FROM `#application.schema#`.`lab_test_label_assoc`
	WHERE `lab_test_label_assoc`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.client_id#"> and
		  <cfif URL.label_type EQ 'password'>
			`lab_test_label_assoc`.`password_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_id#">
		  <cfelse>
			`lab_test_label_assoc`.`range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_id#">
		  </cfif>
	</cfquery>
	
	<!--- add back all selected associations --->
	<cfloop index="i" list="#FORM['SelectedVals[]']#"> 
		<cfquery name="insertAssociation" datasource="#application.datasource#">
		INSERT INTO `#application.schema#`.`lab_test_label_assoc`
		(`client_id`,
		`lab_test_id`,
		<cfif URL.label_type EQ 'password'>
			`password_detail_id`,
		<cfelse>
			`range_id`,
		</cfif>
		`create_dt`,
		`create_user_id`)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.client_id#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.label_id#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.user_id#">)	
		</cfquery>
	</cfloop>

<cfcatch type="any">
	<!--- add logging --->
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>