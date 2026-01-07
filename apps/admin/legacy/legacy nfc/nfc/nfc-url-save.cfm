<!---<cfdump var="#form#">--->
<cftry>

	<cfif IsValid("URL",form.redirectUrl) EQ false>
		<cfheader statuscode="400">
	</cfif>
	
	<cfquery name="updateUrl" datasource="#application.datasource#">
	UPDATE `#application.schema#`.`tag`
	SET	`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#">,
	<cfif IsValid('URL',form.redirectUrl)>
		`product_page` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.redirectUrl#">,
	<cfelse>
		`product_page` = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
	</cfif>
	<cfif IsValid('URL',form.videoUrl)>
		`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.videoUrl#">
	<cfelse>
		`video_url` = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
	</cfif>
	WHERE `seq_num` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tagNum#">
	</cfquery>	

    <cfif StructKeyExists(form,"logoImg") AND Len(form.logoImg) GT 0>
        <cffile action="upload" filefield="logoImg" destination="C:\home\scanacart.com\wwwroot\assets\img\logo\" nameconflict="MAKEUNIQUE"  />
        <cfset local.img_path = 'assets/img/logo/' & cffile.serverfile>
    <cfelseif StructKeyExists(form,'useGenericLogo')>
        <cfset local.img_path = 'assets/img/logo/yourlogohere.png'>
	<cfelse>
	    <cfset local.img_path = ''>
    </cfif>	

	<cfquery name="updateClient" datasource="#application.datasource#">
	UPDATE #application.schema#.client
    SET <cfif Len(local.img_path)>
			logo_path = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.img_path#">,
		</cfif>
	    update_dt = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	WHERE client_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.client#">
	</cfquery>	

<cfcatch type="any">
	<cfheader statuscode="500">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>