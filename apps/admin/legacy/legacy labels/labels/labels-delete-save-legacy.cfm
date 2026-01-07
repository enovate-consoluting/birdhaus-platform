<cfif NOT StructKeyExists(form,"rangeId")>
	<cflocation addtoken="no" url="labels-manage-legacy.cfm">
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
<cfquery name="deleteProductDetail" datasource="#application.datasource#">
UPDATE `#application.schema#`.`label_range`
SET `label_range`.`active` = 'N'
WHERE `label_range`.`range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rangeId#">
</cfquery>

<cflocation addtoken="no" url="labels-manage-legacy.cfm">