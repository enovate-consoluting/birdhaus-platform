<cfcomponent>
	<cfsetting requestTimeOut = "9600" />
	<cffunction name="generatePasswords" access="public" returntype="string">
		<cfargument name="numPasswords" type="numeric" required="yes">
		<cfargument name="clientId" type="string" required="yes">
		<cfargument name="verifyOnce" type="boolean" required="yes">
		<cfargument name="verifyOnceMsg" type="string" required="yes">
		<cfargument name="includeSerial" type="boolean" required="yes">
		<cfargument name="logId" type="string" required="yes">
		<cfargument name="userId" type="numeric" required="yes">
		<cfargument name="verification_url" default="">
		
		<cftry>
		
			<cfset local.logBasePath = '#ExpandPath(".")#\log\'>			
			<cfset local.logFullPath = local.logBasePath & 'passwordService#Trim(arguments.logId)#.txt'>
			<cfset local.logErrorFullPath = local.logBasePath & 'error.txt'>
		
			<cfif NOT DirectoryExists(local.logBasePath)>
				<cfdirectory action="create" directory="#local.logBasePath#">
			</cfif>
			
			<cffile action="write" file="#local.logErrorFullPath#" nameconflict="overwrite" output="">
			<cffile action="write" file="#local.logFullPath#" nameconflict="overwrite" output="Begin password generator...<br>">
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#DateTimeFormat(now(),'iso')#<br>Generating #arguments.numPasswords# passwords<br>">
		
			<!--- setup values for logic --->
			<cfset local.numSuccessfulPasswords = 0>
			<cfset strLowerCaseAlpha = "abcdfghijklmnpqrstuvwxyz012345678901234567890123456789abcdfghijklmnpqrstuvwxyz" />
			<cfset strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
			<cfset strNumbers = "0123456789" />	
			<cfset strAllValidChars = (strUpperCaseAlpha) />
			<cfset arrPassword = ArrayNew( 1 ) />		
			
			<!--- insert to detail table to manage passwords --->
			<cfinvoke component="PasswordService" method="insertPasswordDetail" returnvariable="labelPassDetailId">
				<cfinvokeargument name="clientId" value="#arguments.clientId#">
				<cfinvokeargument name="verifyOnce" value="#arguments.verifyOnce#">
				<cfinvokeargument name="verifyOnceMsg" value="#arguments.verifyOnceMsg#">
				<cfinvokeargument name="numPasswords" value="#arguments.numPasswords#">
				<cfinvokeargument name="logPath" value="#local.logFullPath#">
				<cfinvokeargument name="userId" value="#arguments.userId#">
				<cfinvokeargument name="verification_url" value="#arguments.verification_url#">
			</cfinvoke>		
			
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="label_pass_detail.GENERATED_KEY: #labelPassDetailId#<br>">				
			
			<cfif labelPassDetailId EQ 0>
				<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="A database insert error occurred">
				<cfabort>
			</cfif>
			
			<cfquery name="getMaxSerial" datasource="#application.datasource#">
			select max(serial_num) as serial
			from `#application.schema#`.`label_password`
			</cfquery>
			
			<cfset local.serial = getMaxSerial.serial + 1>	
			<cfset local.firstSerial = getMaxSerial.serial + 1>
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Serial numbers start with: #local.serial#<br>">		
			<cfset local.processingComplete = false>
			<cfset dupPasswords = ArrayNew(1,false)>
			
			<cfloop condition="local.processingComplete EQ false">
			
				<cfset arrPassword[ 1 ] = Mid(
					strUpperCaseAlpha,
					RandRange( 1, Len( strUpperCaseAlpha ) ),
					1
					) />			
			
				<cfloop
					index="intChar"
					from="#(ArrayLen( arrPassword ) + 1)#"
					to="#RandRange(5,6)#"
					step="1">
				
					<cfset arrPassword[ intChar ] = Mid(
						strAllValidChars,
						RandRange( 1, Len( strAllValidChars ) ),
						1
						) />
				
				</cfloop>
				
				<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(arrPassword) />
				<cfset local.strPassword = ArrayToList(arrPassword,"") />					
				<cfset local.finalPassword = local.strPassword>			

				<!---<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#local.finalPassword# generated">--->
				
				<!--- attempt to insert to password table --->
				<cfif NOT ArrayContains(dupPasswords,local.finalPassword) AND
					Left(local.finalPassword,1) NEQ '0' AND
					Left(local.finalPassword,2) NEQ '00' AND
					Left(local.finalPassword,3) NEQ '000' AND
					Left(local.finalPassword,4) NEQ '0000' AND
					REFind('[^a-z]', local.finalPassword) GT 0>
					<cfinvoke component="PasswordService" method="insertPassword" returnvariable="labelPassword">
						<cfinvokeargument name="clientId" value="#arguments.clientId#">
						<cfinvokeargument name="serialNum" value="#local.serial#">
						<cfinvokeargument name="password" value="#local.finalPassword#">
						<cfinvokeargument name="labelPassDetailId" value="#labelPassDetailId#">
					</cfinvoke>		
				
					<cfif labelPassword	EQ true>
						<cfset local.numSuccessfulPasswords = local.numSuccessfulPasswords + 1>
						<cfset local.serial = local.serial + 1>
						<cfset local.display = true>
						<cfset ArrayAppend(dupPasswords,local.finalPassword)>
					<cfelse>
						<!---<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#local.finalPassword# skipped (already existed)<br>">--->						
						<cfset local.display = false>
					</cfif>					
				
					<cfif local.numSuccessfulPasswords EQ arguments.numPasswords>
						<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#local.numSuccessfulPasswords# unique passwords generated and inserted<br>">
						<cfset local.processingComplete = true>
						
						<!--- serial was incremented for next iteration, so reduce by one --->
						<cfset local.serial = local.serial - 1>	
												
						<!--- update serial numbers --->
						<cfquery name="updateSerials" datasource="#application.datasource#">
						UPDATE `#application.schema#`.`label_pass_generation`
						SET `first_serial_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.firstSerial#">,
							`last_serial_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#local.serial#">
						WHERE `label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#labelPassDetailId#">	
						</cfquery>								
	
						<cfbreak>
					</cfif>
					
					<cfif local.numSuccessfulPasswords mod 1000 is 0 AND local.display EQ true>
						<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#local.numSuccessfulPasswords# passwords generated<br>">
					</cfif>	
				<cfelse>
					<cffile action="append" file="#logErrorFullPath#" addnewline="yes" output="#DateTimeFormat(now(),'iso')# - #local.finalPassword# exists in the array<br>">
				</cfif>	
			
			</cfloop>	
			
			<cfif IsNumeric(arguments.clientId)>
				<cfquery name="getClient" datasource="#application.datasource#">
				select company_name
				from `#application.schema#`.`client`
				where client_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.clientId#">
				</cfquery>
				<cfset local.clientName = getClient.company_name>
			<cfelse>
				<cfset local.clientName = 'Generic'>
			</cfif>
			
			
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Adding unique passwords to spreadsheet<br>">						
			<!--- add passwords to spreadsheet --->
			<cfinvoke component="PasswordService" method="createSpreadsheet" returnvariable="createSpreadsheetResult">
				<cfinvokeargument name="labelPassDetailId" value="#labelPassDetailId#">
				<cfinvokeargument name="fileName" value="#local.clientName#_#arguments.numPasswords#_#local.firstSerial#_#local.serial#">
				<cfinvokeargument name="includeSerial" value="#arguments.includeSerial#">
			</cfinvoke>
			<cfif createSpreadsheetResult EQ true>
				<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Complete<br>">
			<cfelse>
				<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="An error occurred<br>">
			</cfif>	
			
			<!--- email design@scanacart.com --->	
			<cfinvoke component="PasswordService" method="emailSpreadsheet" returnvariable="emailSpreadsheetResult">
				<cfinvokeargument name="quantity" value="#arguments.numPasswords#">
				<cfinvokeargument name="fileName" value="#local.clientName#_#arguments.numPasswords#_#local.firstSerial#_#local.serial#">
				<cfinvokeargument name="clientName" value="#local.clientName#">
			</cfinvoke>		
			
			<cfif emailSpreadsheetResult EQ true>
				<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Email sent">
			<cfelse>
				<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="An error occurred">
			</cfif>								
						
			<cfset myResult="complete">
			<cfreturn myResult>		
		
		<cfcatch type="any">
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#cfcatch.Message# #cfcatch.Detail#<br>">
			<cfset myResult = "An error occurred">
			<cfreturn myResult>
		</cfcatch>
		</cftry>
		

	</cffunction>
	
	<cffunction name="insertPasswordDetail" access="public" returntype="numeric">
		<cfargument name="clientId" type="string" required="yes">
		<cfargument name="verifyOnce" type="boolean" required="yes">
		<cfargument name="verifyOnceMsg" type="string" required="yes">
		<cfargument name="numPasswords" type="numeric" required="yes">		
		<cfargument name="logPath" type="string" required="yes">
		<cfargument name="userId" type="numeric" required="yes">
		<cfargument name="verification_url" default="">
		
		<cftry>
	
			<!--- label detail --->
			<cfquery name="insertLabelpassDetail" datasource="#application.datasource#" result="label_pass_detail">
			INSERT INTO `#application.schema#`.`label_password_detail`
			(`client_id`,
			`create_user_id`,
			`update_dt`,
			`update_user_id`,
			`active`,
			`verify_once`,
			`verify_once_msg`,
			`label_validation_msg`,
			`label_note`,
			`exclude_from_stats`,
			`app_validation_allowed`,
			`verification_url`)
			VALUES
			(
			<cfif arguments.clientId GT 0>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_numeric" null="yes">,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">,
			<cfif arguments.clientId GT 0>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
			</cfif>
			<cfif arguments.verifyOnce EQ true>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.verifyOnceMsg#" null="#NOT Len(Trim(arguments.verifyOnceMsg))#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.verification_url#" null="#NOT Len(Trim(arguments.verification_url))#">
			)
			</cfquery>
			
			<cfquery name="insertLabelPassGen" datasource="#application.datasource#">
			INSERT INTO `#application.schema#`.`label_pass_generation`
			(`label_pass_detail_id`,
			`client_id`,
			`num_passwords`,
			`password_length`,
			`include_alpha`,
			`alpha_char`,
			`alpha_random_ind`,
			`alpha_position`,
			`create_user_id`)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_numeric" value="#label_pass_detail.GENERATED_KEY#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.numPasswords#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="6">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">)
			</cfquery>			
						
			<cfreturn label_pass_detail.GENERATED_KEY>
		
		<cfcatch type="any">	
			<cffile action="append" file="#arguments.logPath#" addnewline="yes" output="#cfcatch.Message# #cfcatch.Detail#<br>">		
			<cfreturn 0>
		</cfcatch>
		</cftry>
				
	</cffunction> 
	
	<cffunction name="insertPassword" access="public" returntype="boolean">
		<cfargument name="clientId" type="string" required="yes">
		<cfargument name="serialNum" type="numeric" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="labelPassDetailId" type="numeric" required="yes">
	
		<cftry>
	
			<cfquery name="insertLabelPassword" datasource="#application.datasource#">
			INSERT INTO `#application.schema#`.`label_password`
			(`label_pass_detail_id`,
			`serial_num`,
			`password`,
			`client_id`)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.labelPassDetailId#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.serialNum#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.clientId#" null="#NOT IsNumeric(arguments.clientId)#">)
			</cfquery>	
			
			<cfreturn true>
			
		<cfcatch type="any">			
			<cfset local.logFullPath = '#ExpandPath(".")#\log\error.txt'>			
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#cfcatch.Message# #cfcatch.Detail#<br>">		
			<cfreturn false>
		</cfcatch>
		</cftry>
					
	</cffunction>	
	
	<cffunction name="createSpreadsheet" access="public" returntype="boolean">
		<cfargument name="labelPassDetailId" type="numeric" required="yes">
		<cfargument name="fileName" type="string" required="yes">
		<cfargument name="includeSerial" type="boolean" required="yes">
	
		<cftry>
				
				<cfif arguments.includeSerial>
					<cfquery name="getPassGen" datasource="#application.datasource#">
					SELECT `label_password`.`serial_num` as serial,`label_password`.`password`
					FROM `#application.schema#`.`label_password`
					WHERE `label_password`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.labelPassDetailId#">
					ORDER BY `label_password`.`serial_num`
					</cfquery>

					<cfset strOutput = QueryToCSV(
					getPassGen,
					"serial,password"
					) />					
				<cfelse>
					<cfquery name="getPassGen" datasource="#application.datasource#">
					SELECT `label_password`.`password`
					FROM `#application.schema#`.`label_password`
					WHERE `label_password`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.labelPassDetailId#">
					</cfquery>	

					<cfset strOutput = QueryToCSV(
					getPassGen,
					"password"
					) />								
				</cfif>
				
				<cfif NOT DirectoryExists(application.passwordDir)>
					<cfdirectory action="create" directory="#application.passwordDir#">
				</cfif>

				<cffile action="write" file="#application.passwordDir##arguments.fileName#.csv" output="#strOutput#">
				
				<cfquery name="updateSpreadsheetName" datasource="#application.datasource#">
				UPDATE `#application.schema#`.`label_pass_generation`
				SET	`spreadsheet_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileName#.csv">
				WHERE `label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.labelPassDetailId#">			
				</cfquery>			
			
			<cfreturn true>
			
		<cfcatch type="any">	
			<cfreturn false>
		</cfcatch>
		</cftry>
					
	</cffunction>
	
	<cffunction name="emailSpreadsheet" access="public" returntype="boolean">		
		<cfargument name="fileName" type="string" required="yes">
		<cfargument name="quantity" type="numeric" required="yes">
		<cfargument name="clientName" type="string" required="yes">
	
		<cftry>
			
			<CFMAIL to = "#application.designEmail#" 
					from = "postmaster@mg.scanacart.com"
					username="postmaster@mg.scanacart.com"
					subject = "#arguments.clientName# - #arguments.fileName#.csv"
					password = "#application.emailPass#" 
					port="587"
					useTLS="yes"
					server="smtp.mailgun.org"
					type="html">	
					<cfmailparam file="#application.passwordDir##arguments.fileName#.csv">
					#DateTimeFormat(now(),'short')#<br>
					#arguments.clientName#<br>
					#arguments.quantity#
			</CFMAIL>				
			
			<cfreturn true>
			
		<cfcatch type="any">	
			<cfset local.logFullPath = '#ExpandPath(".")#\log\error.txt'>			
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#cfcatch.Message# #cfcatch.Detail#<br>">		
			<cfreturn false>
		</cfcatch>
		</cftry>
					
	</cffunction>		

	<cffunction
		name="QueryToCSV"
		access="public"
		returntype="string"
		output="false"
		hint="I take a query and convert it to a comma separated value string.">

		<!--- Define arguments. --->
		<cfargument
			name="Query"
			type="query"
			required="true"
			hint="I am the query being converted to CSV."
			/>

		<cfargument
			name="Fields"
			type="string"
			required="true"
			hint="I am the list of query fields to be used when creating the CSV value."
			/>

		<cfargument
			name="CreateHeaderRow"
			type="boolean"
			required="false"
			default="true"
			hint="I flag whether or not to create a row of header values."
			/>

		<cfargument
			name="Delimiter"
			type="string"
			required="false"
			default=","
			hint="I am the field delimiter in the CSV value."
			/>

		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />

		<!---
			First, we want to set up a column index so that we can
			iterate over the column names faster than if we used a
			standard list loop on the passed-in list.
		--->
		<cfset LOCAL.ColumnNames = {} />

		<!---
			Loop over column names and index them numerically. We
			are going to be treating this struct almost as if it
			were an array. The reason we are doing this is that
			look-up times on a table are a bit faster than look
			up times on an array (or so I have been told).
		--->
		<cfloop
			index="LOCAL.ColumnName"
			list="#ARGUMENTS.Fields#"
			delimiters=",">

			<!--- Store the current column name. --->
			<cfset LOCAL.ColumnNames[ StructCount( LOCAL.ColumnNames ) + 1 ] = Trim( LOCAL.ColumnName ) />

		</cfloop>

		<!--- Store the column count. --->
		<cfset LOCAL.ColumnCount = StructCount( LOCAL.ColumnNames ) />


		<!---
			Now that we have our index in place, let's create
			a string buffer to help us build the CSV value more
			effiently.
		--->
		<cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />

		<!--- Create a short hand for the new line characters. --->
		<cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />


		<!--- Check to see if we need to add a header row. --->
		<cfif ARGUMENTS.CreateHeaderRow>

			<!--- Loop over the column names. --->
			<cfloop
				index="LOCAL.ColumnIndex"
				from="1"
				to="#LOCAL.ColumnCount#"
				step="1">

				<!--- Append the field name. --->
				<cfset LOCAL.Buffer.Append(
					JavaCast(
						"string",
						"""#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#"""
						)
					) />

				<!---
					Check to see which delimiter we need to add:
					field or line.
				--->
				<cfif (LOCAL.ColumnIndex LT LOCAL.ColumnCount)>

					<!--- Field delimiter. --->
					<cfset LOCAL.Buffer.Append(
						JavaCast( "string", ARGUMENTS.Delimiter )
						) />

				<cfelse>

					<!--- Line delimiter. --->
					<cfset LOCAL.Buffer.Append(
						JavaCast( "string", LOCAL.NewLine )
						) />

				</cfif>

			</cfloop>

		</cfif>


		<!---
			Now that we have dealt with any header value, let's
			convert the query body to CSV. When doing this, we are
			going to qualify each field value. This is done be
			default since it will be much faster than actually
			checking to see if a field needs to be qualified.
		--->

		<!--- Loop over the query. --->
		<cfloop query="ARGUMENTS.Query">

			<!--- Loop over the columns. --->
			<cfloop
				index="LOCAL.ColumnIndex"
				from="1"
				to="#LOCAL.ColumnCount#"
				step="1">

				<!--- Append the field value. --->
				<cfset LOCAL.Buffer.Append(
					JavaCast(
						"string",
						"""#ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ]#"""
						)
					) />

				<!---
					Check to see which delimiter we need to add:
					field or line.
				--->
				<cfif (LOCAL.ColumnIndex LT LOCAL.ColumnCount)>

					<!--- Field delimiter. --->
					<cfset LOCAL.Buffer.Append(
						JavaCast( "string", ARGUMENTS.Delimiter )
						) />

				<cfelse>

					<!--- Line delimiter. --->
					<cfset LOCAL.Buffer.Append(
						JavaCast( "string", LOCAL.NewLine )
						) />

				</cfif>

			</cfloop>

		</cfloop>


		<!--- Return the CSV value. --->
		<cfreturn LOCAL.Buffer.ToString() />
	</cffunction>	
	
</cfcomponent>