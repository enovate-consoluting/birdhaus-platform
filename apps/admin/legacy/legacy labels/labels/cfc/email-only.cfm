<cftry>

	<!--- sent 1/11/22 --->
	<!---
	Gold Coast Clear_220000_10028366_10248365
	Gold Coast Clear_220000_10248366_10468365
	Gold Coast Clear_220000_10468366_10688365
	--->

	<!---<cfinvoke component="PasswordService" method="emailSpreadsheet" returnvariable="emailSpreadsheetResult">
		<cfinvokeargument name="quantity" value="220000">
		<cfinvokeargument name="fileName" value="Gold Coast Clear_220000_10468366_10688365">
		<cfinvokeargument name="clientName" value="Gold Coast Clear">
	</cfinvoke>--->	
	
	<cfoutput>#emailSpreadsheetResult#</cfoutput>
<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>