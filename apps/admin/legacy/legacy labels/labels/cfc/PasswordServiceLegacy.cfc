<cfcomponent>
	<cfsetting requestTimeOut = "9600" />
	<cffunction name="generatePasswords" access="public" returntype="string">
		<cfargument name="numPasswords" type="numeric" required="yes">
		<cfargument name="lengthOfPassword" type="numeric" required="yes">
		<cfargument name="includeAlpha" type="boolean" required="yes">
		<cfargument name="alphaChar" type="string" required="no">
		<cfargument name="alphaCharPos" type="numeric" required="yes">
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
			<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#DateTimeFormat(now(),'iso')#<br>Generating #arguments.numPasswords# passwords<br>Length: #arguments.lengthOfPassword# characters<br>Include a letter: #arguments.includeAlpha#<br>">
		
			<!--- setup values for logic --->
			<cfset local.numSuccessfulPasswords = 0>
			<cfset strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz" />
			<cfset strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
			<cfset strNumbers = "0123456789" />	
			<cfset strAllValidChars = (strNumbers) />
			<cfset arrPassword = ArrayNew( 1 ) />
						
			<!--- include a letter? --->
			<cfif arguments.includeAlpha GT 0>
				<!--- subtract one from length to account for letter --->
				<cfset local.passwordLength = arguments.lengthOfPassword - 1>
				
				<!--- set static starting letter --->
				<cfif Len(arguments.alphaChar)>				
					<cfset local.alphaLetter = UCase(Left(arguments.alphaChar,1))>
					<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Alpha character: #local.alphaLetter#<br>">
					<cfset local.alphaRandomInd = false>
				<cfelse>
					<!--- generate random letter --->
					<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Alpha character: Random letter<br>">
					<cfset local.alphaLetter = Mid(strUpperCaseAlpha,RandRange(1,Len(strUpperCaseAlpha)),1) />	
					<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="Random letter generated: #local.alphaLetter#<br>">			
					<cfset local.alphaRandomInd = true>
				</cfif>
								
			<cfelse>	
				<cfset local.passwordLength = arguments.lengthOfPassword>			
				<cfset local.alphaRandomInd = false>
				<cfset local.alphaLetter = "">
			</cfif>			
			
			<!--- insert to detail table to manage passwords --->
			<cfinvoke component="PasswordService" method="insertPasswordDetail" returnvariable="labelPassDetailId">
				<cfinvokeargument name="clientId" value="#arguments.clientId#">
				<cfinvokeargument name="verifyOnce" value="#arguments.verifyOnce#">
				<cfinvokeargument name="verifyOnceMsg" value="#arguments.verifyOnceMsg#">
				<cfinvokeargument name="numPasswords" value="#arguments.numPasswords#">
				<cfinvokeargument name="passwordLength" value="#arguments.lengthOfPassword#">
				<cfinvokeargument name="includeAlpha" value="#arguments.includeAlpha#">
				<cfinvokeargument name="alphaChar" value="#local.alphaLetter#">
				<cfinvokeargument name="alphaRandomInd" value="#local.alphaRandomInd#">
				<cfinvokeargument name="alphaCharPos" value="#arguments.alphaCharPos#">
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
			
			<!---<cfloop
				index="i"
				from="1"
				to="#arguments.numPasswords + (arguments.numPasswords * 10)#"
				step="1">--->
			<cfloop condition="local.processingComplete EQ false">
			
				<cfset arrPassword[ 1 ] = Mid(
					strNumbers,
					RandRange( 1, Len( strNumbers ) ),
					1
					) />			
			
				<cfloop
					index="intChar"
					from="#(ArrayLen( arrPassword ) + 1)#"
					to="#local.passwordLength#"
					step="1">
				
					<cfset arrPassword[ intChar ] = Mid(
						strAllValidChars,
						RandRange( 1, Len( strAllValidChars ) ),
						1
						) />
				
				</cfloop>
				
				<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(arrPassword) />
				<cfset local.strPassword = ArrayToList(arrPassword,"") />
				
				<!--- alpha char position --->
				<cfif arguments.alphaCharPos EQ 1>
					<cfset local.finalPassword = '#local.alphaLetter##local.strPassword#'>
				<cfelse>
					<cfset local.finalPassword = '#local.strPassword##local.alphaLetter#'>
				</cfif>					

				<!---<cffile action="append" file="#local.logFullPath#" addnewline="yes" output="#local.finalPassword# generated">--->
				
				<!--- attempt to insert to password table --->
				<cfif NOT ArrayContains(dupPasswords,local.finalPassword)>
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
		<cfargument name="passwordLength" type="numeric" required="yes">
		<cfargument name="includeAlpha" type="boolean" required="yes">
		<cfargument name="alphaChar" type="string" required="yes">
		<cfargument name="alphaRandomInd" type="boolean" required="yes">
		<cfargument name="alphaCharPos" type="numeric" required="yes">
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
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.passwordLength#">,
			<cfif arguments.includeAlpha EQ true>
				<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alphaChar#" null="#NOT Len(arguments.alphaChar)#">,
			<cfif arguments.alphaRandomInd EQ true>
				<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
			</cfif>	
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.alphaCharPos#">,
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
				<cfelse>
					<cfquery name="getPassGen" datasource="#application.datasource#">
					SELECT `label_password`.`password`
					FROM `#application.schema#`.`label_password`
					WHERE `label_password`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.labelPassDetailId#">
					</cfquery>				
				</cfif>
				
				<cfif NOT DirectoryExists(application.passwordDir)>
					<cfdirectory action="create" directory="#application.passwordDir#">
				</cfif>
				
				<cfspreadsheet   
					action="write" 
					autosize="true" 
					filename = "#application.passwordDir##arguments.fileName#.xlsx"
					overwrite = "true"					
					query = "getPassGen" 
					sheetname = "Passwords">	
				
				<cfquery name="updateSpreadsheetName" datasource="#application.datasource#">
				UPDATE `#application.schema#`.`label_pass_generation`
				SET	`spreadsheet_name` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileName#.xlsx">
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
					subject = "#arguments.clientName# - #arguments.fileName#.xlsx"
					password = "#application.emailPass#" 
					port="587"
					useTLS="yes"
					server="smtp.mailgun.org"
					type="html">	
					<cfmailparam file="#application.passwordDir##arguments.fileName#.xlsx">
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
	
</cfcomponent>