
    <cffunction name="getClients" access="remote" returntype="array">
        <cfargument name="searchValue" type="string" required="true">

        <!-- Query to get matching clients -->
        <cfquery name="getClients" datasource="#application.datasource#">
            SELECT client_id, company_name
            FROM clients
            WHERE company_name LIKE <cfqueryparam value="%#arguments.searchValue#%" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!-- Build an array of results -->
        <cfset var clientsArray = []>
        <cfloop query="getClients">
            <cfset structInsert(clientsArray, {
                client_id = getClients.client_id,
                company_name = getClients.company_name
            })>
        </cfloop>

        <!-- Return the JSON encoded result -->
        <cfreturn clientsArray>
    </cffunction>

</cfcomponent>
