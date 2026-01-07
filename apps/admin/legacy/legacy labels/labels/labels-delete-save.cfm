<cfif NOT StructKeyExists(form,"label_pass_detail_id")>
	<cflocation addtoken="no" url="labels-manage.cfm">
	<cfabort>
</cfif>
	
<!--- remove from file system --->
<!---<cfif FileExists('#application.productsFolder#\#form.productId#\#getProductImage.image_name#')>
	<cffile action="delete"
			file="#application.productsFolder#\#form.productId#\#getProductImage.image_name#">
</cfif>

<cfif FileExists('#application.productsFolder#\#form.productId#\#getProductImage.image_thumbnail#')>
	<cffile action="delete"
			file="#application.productsFolder#\#form.productId#\#getProductImage.image_thumbnail#">
</cfif>--->


<!--- remove from product_category_assoc --->
<cfquery name="deleteLabelPassDetail" datasource="#application.datasource#">
UPDATE `#application.schema#`.`label_password_detail`
SET `label_password_detail`.`active` = 'N'
WHERE `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.label_pass_detail_id#">
</cfquery>

<cflocation addtoken="no" url="labels-manage.cfm">