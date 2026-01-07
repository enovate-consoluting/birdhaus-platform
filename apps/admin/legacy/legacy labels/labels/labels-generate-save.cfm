<cftry>
	<cfif NOT StructKeyExists(session,"email")>
		<cfabort>
	</cfif>
	
	<cfsetting requestTimeOut = "3600" />
	
	<cfif StructKeyExists(form,"verify_once")>
		<cfset local.verifyOnce = true>
	<cfelse>
		<cfset local.verifyOnce = false>
	</cfif>
	
	<cfif StructKeyExists(form,"include_serial")>
		<cfset local.includeSerial = true>
	<cfelse>
		<cfset local.includeSerial = false>
	</cfif>	
	
	<cfif StructKeyExists(URL,"legacy") AND URL.legacy EQ true>
	
		<cfif form.includeLetter GT 0>
			<cfset local.includeLetter = true>
		<cfelse>
			<cfset local.includeLetter = false>
		</cfif>
		
		<cfif form.includeLetter EQ 1 OR form.includeLetter EQ 3>
			<cfset local.alphaCharPos = 1>
		<cfelseif form.includeLetter EQ 2 OR form.includeLetter EQ 4>
			<cfset local.alphaCharPos = form.passLength>
		<cfelse>
			<cfset local.alphaCharPos = 0>	
		</cfif>	
		
		<cfinvoke component="cfc/PasswordServiceLegacy" method="generatePasswords">
			<cfinvokeargument name="numPasswords" value="#form.numPasswords#">
			<cfinvokeargument name="lengthOfPassword" value="#form.passLength#">
			<cfinvokeargument name="includeAlpha" value="#local.includeLetter#">
			<cfinvokeargument name="alphaChar" value="#form.letter#">
			<cfinvokeargument name="alphaCharPos" value="#local.alphaCharPos#">
			<cfinvokeargument name="clientId" value="#form.client#">
			<cfinvokeargument name="verifyOnce" value="#local.verifyOnce#">
			<cfinvokeargument name="verifyOnceMsg" value="#form.verify_once_message#">
			<cfinvokeargument name="includeSerial" value="#local.includeSerial#">
			<cfinvokeargument name="logId" value="#form.logId#">
			<cfinvokeargument name="userId" value="#session.user_id#">
			<cfinvokeargument name="verification_url" value="#form.verification_url#">
		</cfinvoke>
			
	<cfelse>
	
		<cfinvoke component="cfc/PasswordService" method="generatePasswords">
			<cfinvokeargument name="numPasswords" value="#form.numPasswords#">
			<cfinvokeargument name="clientId" value="#form.client#">
			<cfinvokeargument name="verifyOnce" value="#local.verifyOnce#">
			<cfinvokeargument name="verifyOnceMsg" value="#form.verify_once_message#">
			<cfinvokeargument name="includeSerial" value="#local.includeSerial#">
			<cfinvokeargument name="logId" value="#form.logId#">
			<cfinvokeargument name="userId" value="#session.user_id#">
			<cfinvokeargument name="verification_url" value="#form.verification_url#">
		</cfinvoke>
	
	</cfif>
	<cflocation addtoken="no" url="labels-generate.cfm">
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>