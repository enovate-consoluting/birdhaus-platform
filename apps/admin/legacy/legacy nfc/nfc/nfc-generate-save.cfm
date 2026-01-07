<cftry>
	<cfif NOT StructKeyExists(session,"email")>
		<cfabort>
	</cfif>
	
	<cfsetting requestTimeOut = "3600" />

	<cfset local.active = true>

	<!---<cfif StructKeyExists(form,"direct_to_app")>
		<cfset local.direct_to_app = true>
	<cfelse>
		<cfset local.direct_to_app = false>
	</cfif>--->

	<cfif StructKeyExists(form,"client_url") AND form.client_url EQ "Y">
		<cfset local.client_url = true>
	<cfelse>
		<cfset local.client_url = false>
	</cfif>
	
	<cfif StructKeyExists(form,"show_scan") AND form.show_scan EQ "Y">
		<cfset local.show_scan = true>
	<cfelse>
		<cfset local.show_scan = false>
	</cfif>

	<cfif StructKeyExists(form,"client_url") AND form.client_url EQ "W">
		<cfset local.web_url = true>
		<cfset local.web_url_dropdown = form.web_url_dropdown>
	<cfelse>
		<cfset local.web_url = false>
		<cfset local.web_url_dropdown = "">
	</cfif>	

	<cfif StructKeyExists(form,"bypass_sr")>
		<cfset local.bypass_sr = true>
	<cfelse>
		<cfset local.bypass_sr = false>
	</cfif>
	
	<cfif form.percentage NEQ "">
		<cfset local.percentage = form.percentage>
	<cfelse>
		<cfset local.percentage = 0>
	</cfif>
		
    <cfinvoke component="cfc/NfcService" method="generateNfcs" returnVariable="nfcResult">
        <cfinvokeargument name="numTags" value="#form.num_tags#">
        <cfinvokeargument name="clientId" value="#form.client#">
        <cfinvokeargument name="productPage" value="#form.product_page#">
        <cfinvokeargument name="active" value="#local.active#">
		<!---<cfinvokeargument name="directToApp" value="#local.direct_to_app#">--->
		<cfinvokeargument name="useClientUrl" value="#local.client_url#">
        <cfinvokeargument name="logId" value="#form.logId#">
        <cfinvokeargument name="userId" value="#session.user_id#">
		<cfinvokeargument name="note" value="#form.note#">
		<cfinvokeargument name="bypass_sr" value="#local.bypass_sr#">
		<cfinvokeargument name="tagInactiveMsg" value="#form.tagInactiveMsg#">
		<cfinvokeargument name="perSpool" value="#form.per_spool#">
		<cfinvokeargument name="percentage" value="#local.percentage#">
		<cfinvokeargument name="web_url" value="#local.web_url#">
		<cfinvokeargument name="web_url_dropdown" value="#local.web_url_dropdown#">
		<cfinvokeargument name="show_scan" value="#local.show_scan#">
		<cfinvokeargument name="template_id" value="#form.template_id#">
		<!---<cfinvokeargument name="create_path" value="#local.create_path#">--->
    </cfinvoke>

	<cfif nfcResult EQ 'An error occurred'>
		<cfheader statusCode="500">
	</cfif>
	
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>