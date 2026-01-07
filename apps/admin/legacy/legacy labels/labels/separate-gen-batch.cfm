<cfif StructKeyExists(form,"override")>
	<cfset local.override = true>
<cfelse>
	<cfset local.override = false>
</cfif>

<cfif NOT StructKeyExists(form,"serial_from") OR NOT StructKeyExists(form,"serial_to") OR NOT StructKeyExists(form,"client")>
	<cfabort>
</cfif>

<cfif NOT IsNumeric(form.serial_from) OR NOT IsNumeric(form.serial_to) OR Len(form.client) EQ 0>
	<cflocation addtoken="no" url="labels-generate.cfm?serial_from=#form.serial_from#&serial_to=#form.serial_to#&client=#form.client#&error=non-numeric">
</cfif> 

<cfset local.serial_num_start = form.serial_from>
<cfset local.serial_num_end = form.serial_to>
<cfset local.client_id = form.client>

<cftry>

	
	<cfquery name="verifyClient" datasource="#application.datasource#">
	select distinct client_id
	from #application.schema#.label_password
	where serial_num between <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_start#"> and 
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_end#">
	</cfquery>
	
	<cfif local.override EQ false>
		<cfloop query="verifyClient">
			<cfif Len(verifyClient.client_id) GT 0>
				<cflocation addtoken="no" url="labels-generate.cfm?serial_from=#form.serial_from#&serial_to=#form.serial_to#&client=#form.client#&error=in-use">
				<!---Len(verifyClient.client_id) GT 0<br>
				<cfdump var="#verifyClient#">
				<cfabort>--->
			</cfif> 
		</cfloop>	
	</cfif>	
	
	<cfquery name="verifyData" datasource="#application.datasource#">
	select count(*) as cnt
	from #application.schema#.label_password
	where serial_num between <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_start#"> and 
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_end#">
	</cfquery>
	
	<cfif (local.serial_num_end - local.serial_num_start + 1) NEQ verifyData.cnt AND local.override EQ false>
		<cflocation addtoken="no" url="labels-generate.cfm?serial_from=#form.serial_from#&serial_to=#form.serial_to#&client=#form.client#&error=in-use">
		<!---(local.serial_num_end - local.serial_num_start + 1) NEQ verifyData.cnt<br>
		<cfoutput>
		local.serial_num_end: #local.serial_num_end#<br>
		local.serial_num_start: #local.serial_num_start#<br>
		verifyData.cnt: #verifyData.cnt#<br>
		</cfoutput>
		<cfabort>--->		
	</cfif> 	
		
	<cfif (verifyClient.recordcount EQ 1 AND Len(verifyClient.client_id) EQ 0 AND (local.serial_num_end - local.serial_num_start + 1) EQ verifyData.cnt) OR local.override EQ true>
		
		<!--- create label_pass_detail record for this group --->
		<cftransaction>
			<cfquery name="insertLabelpassDetail" datasource="#application.datasource#" result="label_pass_detail">
			INSERT INTO `#application.schema#`.`label_password_detail`
			(`client_id`,
			`create_dt`,
			`create_user_id`,
			`update_dt`,
			`update_user_id`,
			`active`,
			`verify_once`,
			`verify_once_msg`,
			`label_validation_msg`,
			`label_note`,
			`exclude_from_stats`,
			`app_validation_allowed`)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_numeric" value="#local.client_id#" null="#NOT IsNumeric(local.client_id)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
			<!---<cfif StructKeyExists(form,"verify_once")>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.verify_once_message#" null="#NOT Len(Trim(form.verify_once_message))#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			</cfif>--->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="This product has already been verified and can only be verified once. Please void if seal was tampered or broken.">,		
			<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Separated - Serial Numbers #local.serial_num_start# - #local.serial_num_end#">,
			<!---<cfif StructKeyExists(form,"exclude_stats")>
				<cfqueryparam cfsqltype="cf_sql_bit" value="1">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_bit" value="0">
			</cfif>--->
			<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="1">
			)
			</cfquery>
			
			<cfquery name="updateLabelPassword" datasource="#application.datasource#">
			UPDATE `#application.schema#`.`label_password`
			SET	`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail.GENERATED_KEY#">,
			    `client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.client_id#" null="#NOT IsNumeric(local.client_id)#">
			WHERE serial_num between <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_start#"> and 
		  		                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial_num_end#">
			</cfquery>
					
		</cftransaction>
		
		<cflocation addtoken="no" url="labels-generate.cfm?status=complete">
		
	<cfelse>
		The range of serial numbers provided either does match the client or the range doesn't exist in the DB
		<!--- use if statements to display a user friendly message --->
	</cfif>
	
	
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>