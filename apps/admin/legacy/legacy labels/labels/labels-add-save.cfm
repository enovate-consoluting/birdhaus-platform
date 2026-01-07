<cfif NOT StructKeyExists(session,"email")>	
	<cflocation addtoken="no" url="labels-manage.cfm">
	<cfabort>
</cfif>

<cfsetting requestTimeOut="4000">
<cfset local.failed_inserts = ArrayNew(2)> <!--- [1] is serial, [2] is password --->
<cfset i = 1>
<cfparam name="form.verify_once" default="">

<cftry>
	
	<!--- label detail --->
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
	(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
	<cfif StructKeyExists(form,"verify_once") AND form.verify_once EQ 'Y'>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.verify_once_message#" null="#NOT Len(Trim(form.verify_once_message))#">,
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.label_validation_msg#" null="#NOT Len(Trim(form.label_validation_msg))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#" null="#NOT Len(Trim(form.note))#">,
	<cfif StructKeyExists(form,"exclude_stats") AND form.exclude_stats EQ 'Y'>
		<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_bit" value="1">
	)
	</cfquery>
	
	<cfif NOT DirectoryExists('#application.labelsFolder#/#DateFormat(now(),'MMDDYY')#')>
		<cfdirectory action="create" directory="#application.labelsFolder#/#DateFormat(now(),'MMDDYY')#">
	</cfif>
	
	<!--- save document --->
	<cfif StructKeyExists(form,"doc") AND Len(form.doc) GT 0>
		<cffile action="upload" filefield="doc" destination="#application.labelsFolder##DateFormat(now(),'MMDDYY')#" nameconflict="MAKEUNIQUE" />
	</cfif>
	
	<cfset local.myFile = '#application.labelsFolder##DateFormat(now(),'MMDDYY')#/#cffile.serverfile#'>
	
	<cfif FilegetMimeType(local.myFile) EQ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' OR
		  FilegetMimeType(local.myFile) EQ 'application/vnd.ms-excel'>
		  
		  <cftry>
			  <cfspreadsheet action="read" 
							 src="#local.myFile#" 
							 query="mySpreadsheet" 
							 sheet="1" 
							 columns="1,2"
							 excludeHeaderRow="true"
							 headerrow="1"> 
			  
			  <cfif StructKeyExists(mySpreadsheet,"serial") AND StructKeyExists(mySpreadsheet,"password")>
			  
			  	  <cfif NOT Len(mySpreadsheet.serial)>
				      <cfquery name="getMaxSerial" datasource="#application.datasource#">
					  select max(serial_num) as serial
					  from `#application.schema#`.`label_password`
					  </cfquery>
					  
					  <cfset local.serial = getMaxSerial.serial>
				  </cfif>
				  				  
				  <cfset local.rowcount = 0>
				  <cfset local.fileIndex = 1>
				  <cfset local.outputFile = "#ExpandPath('.')#\insertScript_#DateFormat(now(),'hhmmss')#_#local.fileIndex#.sql">
				  <cffile action="write" file="#local.outputFile#" output="" nameconflict="overwrite">
			  
				  <cfloop query="mySpreadsheet">
					<cftry>
						
						<cfquery name="verifyLabelPassword" datasource="#application.datasource#">
						select count(*)
						from `#application.schema#`.`label_password`
						where `password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mySpreadsheet.password#">
						</cfquery>
						
						<cfif verifyLabelPassword.recordcount EQ 1 AND form.client EQ 2>					
							
							<cfquery name="deleteLabelPassword" datasource="#application.datasource#">
							delete from `#application.schema#`.`label_password`
							where `password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mySpreadsheet.password#">
							</cfquery>
							
							<cfquery name="deleteLabelPasswordValidation" datasource="#application.datasource#">
							delete from `#application.schema#`.`label_password_validation`
							where `password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mySpreadsheet.password#">
							</cfquery>							
							
							<cfset local.rowcount = local.rowcount + 1>
							
							<cfset local.insertStatement = 'INSERT INTO `krtverif_prod`.`label_password`
							(`label_pass_detail_id`,
							`serial_num`,
							`password`)
							VALUES
							(71,
							 #local.serial#,
							 ''#mySpreadsheet.password#'');'>
							
							<cfif local.rowcount EQ 15000>
								<cfset local.fileIndex = local.fileIndex + 1>
								<cfset local.rowcount = 0>
								<cfset local.outputFile = "#ExpandPath('.')#\insertScript_#DateFormat(now(),'hhmmss')#_#local.fileIndex#.sql">
								<cffile action="write" file="#local.outputFile#" output="" nameconflict="overwrite">
							</cfif>
							
							<cffile action="append" file="#local.outputFile#" output="#local.insertStatement#" addnewline="yes">							
							
						</cfif>
												
						<cfquery name="insertLabelPassword" datasource="#application.datasource#">
						INSERT INTO `#application.schema#`.`label_password`
						(`label_pass_detail_id`,
						`serial_num`,
						`password`,
						`client_id`)
						VALUES
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail.GENERATED_KEY#">,
						<cfif Len(mySpreadsheet.serial)>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#mySpreadsheet.serial#">,
						<cfelse>
							<cfset local.serial = local.serial + 1>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mySpreadsheet.password#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#">)
						</cfquery>			
					
					<cfcatch type="any">
						<cfset local.failed_inserts[i][1] = mySpreadsheet.serial>
						<cfset local.failed_inserts[i][2] = mySpreadsheet.password>
						<cfset i = i + 1>
					</cfcatch>
					</cftry>				
				  </cfloop>
				
			<cfelse>

			  	<cfquery name="removePrevInsert" datasource="#application.datasource#">
				delete from `#application.schema#`.`label_password_detail`
				where `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail.GENERATED_KEY#">				
				</cfquery>

				<cflocation addtoken="no" url="labels-add.cfm?error=invalid&client=#form.client#&note=#EncodeForURL(form.note)#&verify_once=#form.verify_once#&verify_once_msg=#EncodeForURL(form.verify_once_message)#&label_validation_msg=#EncodeForURL(form.label_validation_msg)#">			    
				<cfabort>	
			</cfif>			  

		<cfcatch type="any">
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
		</cftry>	
				  
	<cfelse>
	
		<cfquery name="removePrevInsert" datasource="#application.datasource#">
		delete from `#application.schema#`.`label_password_detail`
		where `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail.GENERATED_KEY#">				
		</cfquery>
					
		<cflocation addtoken="no" url="labels-add.cfm?error=filetype&client=#form.client#&note=#EncodeForURL(form.note)#&verify_once=#form.verify_once#&verify_once_msg=#EncodeForURL(form.verify_once_message)#&label_validation_msg=#EncodeForURL(form.label_validation_msg)#">			    
		<cfabort>
	</cfif>
	
	<cfif ArrayLen(local.failed_inserts) GT 0>
		<cfinclude template="labels-add-error.cfm">
		<cfabort>
	</cfif>

	<cflocation addtoken="no" url="labels-manage.cfm">

<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>