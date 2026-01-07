<cfset local.myFile = 'C:\Users\cbarrington\Desktop\temp\data.xls'>

<cfif NOT FileExists(local.myFile)>
	<cfoutput>#local.myFile#</cfoutput> does not exist
	<cfabort>
</cfif>

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
		  
		  <cfdump var="#mySpreadsheet#">
		  
	  <cfcatch type="any">
	  	<cfdump var="#cfcatch#">
	  </cfcatch>
	  </cftry>
<cfelse>
	File is not a spreadsheet
</cfif>

