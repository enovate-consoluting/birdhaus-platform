<cfcomponent>
    <cffunction name="getSpoolData" access="public">
        <cfquery name="getSpoolData" datasource="#application.datasource#">
            SELECT s.spool_id, s.num_tags, s.create_dt, s.active, c.company_name
                FROM #application.schema#.spool s
                LEFT OUTER JOIN  #application.schema#.client c ON s.client_id = c.client_id
        </cfquery>
        <cfreturn getSpoolData>
    </cffunction>

    <cffunction name="getLabelGenDetailFunc" access="public">
        <cfquery name="getLabelGenDetail" datasource="#application.datasource#">
            SELECT `label_pass_generation`.`label_pass_gen_id`,
                `label_pass_generation`.`label_pass_detail_id`,
                `label_pass_generation`.`client_id`,
                `label_password_detail`.`label_pass_detail_id`,
                `label_password_detail`.`verify_once`,
                `label_password_detail`.`verify_once_msg`,
                `label_password_detail`.`label_validation_msg`,
                `label_password_detail`.`label_note`,
                `label_password_detail`.`exclude_from_stats`
            FROM `#application.schema#`.`label_pass_generation`,
                `#application.schema#`.`label_password_detail`
            WHERE `label_password_detail`.`label_pass_detail_id` = `label_pass_generation`.`label_pass_detail_id`
        </cfquery>
        <cfreturn getLabelGenDetail>
    </cffunction>

    <cffunction name="getNfcGenFunc" access="public">

        <cfquery name="getNfcGen" datasource="#application.datasource#">
            SELECT `nfc_generation`.`nfc_gen_id`,
                `nfc_generation`.`first_spool_id`,
                `nfc_generation`.`last_spool_id`,
                `nfc_generation`.`client_id`,
                `nfc_generation`.`num_tags`,
                `nfc_generation`.`create_dt`,
                `nfc_generation`.`create_user_id`,
                `nfc_generation`.`spreadsheet_name`,
				`nfc_generation`.`nfcs_per_spool`,
				`nfc_generation`.`note`,
                (select `client`.`company_name` from `#application.schema#`.`client` where `client`.`client_id` = `nfc_generation`.`client_id`) as company_name
            FROM `#application.schema#`.`nfc_generation`
            ORDER BY `nfc_generation`.`create_dt` DESC
        </cfquery>
        <cfreturn getNfcGen>
    </cffunction>
    
    <cffunction name="getClientsFunc" access="public">
        <cfargument name="page" default="">

        <cfquery name="getClients" datasource="#application.datasource#">
            SELECT `client`.`client_id`,
                `client`.`company_name`
            FROM `#application.schema#`.`client`
            WHERE `client`.`status` = 'Approved'
                <cfif page NEQ "labels-add">
                    and `client`.`company_name` != 'M80'
                </cfif>
            ORDER BY 2
        </cfquery>
        <cfreturn getClients>
    </cffunction>   

	<cffunction name="getApprovedClients" access="public" returntype="query">
        <cfquery name="approvedClients" datasource="#application.datasource#">
            SELECT DISTINCT c.client_id, c.status, c.company_name
            FROM #application.schema#.client c 
            WHERE c.status = 'Approved' and
                  exists (select 'x' from #application.schema#.tag t where t.client_id = c.client_id)
			ORDER BY c.company_name
        </cfquery>
        <cfreturn approvedClients>
    </cffunction>

<cffunction name="getSpecificTrackingData" access="public" returntype="any"  returnformat="JSON">
        <cfargument name="client_name" type="string" required="false" default="">
        <cfargument name="scan_count" default="5">
        <cfargument name="status" default="">
        <cfquery name="getSpecificTrackingData" datasource="#application.datasource#">
            SELECT 
                t.seq_num, 
                t.tag_id, 
                t.product_page, 
                t.client_id, 
                t.spool_id, 
                c.company_name,
                t.live,
                COUNT(l.tap_loc_id) AS scanCount
            FROM 
                #application.schema#.tag t
            JOIN 
                #application.schema#.client c ON t.client_id = c.client_id 
            JOIN
                #application.schema#.tap_location l ON t.tag_id = l.tag_id
            WHERE 1=1
            <cfif arguments.client_name NEQ "">
                AND c.company_name = <cfqueryparam value="#arguments.client_name#" cfsqltype="cf_sql_varchar">
            </cfif>
            <cfif arguments.status NEQ "">
                AND t.live = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_bit">
            </cfif>
            GROUP BY 
                t.seq_num, 
                t.tag_id, 
                t.video_url, 
                t.client_id, 
                t.spool_id, 
                c.company_name,
                t.live
				<cfif arguments.scan_count NEQ "">
					HAVING COUNT(l.tap_loc_id) > <cfqueryparam value="#arguments.scan_count#" cfsqltype="cf_sql_integer">
				</cfif>
            ORDER BY 
                COUNT(l.tap_loc_id) DESC
        </cfquery>
        <cfreturn getSpecificTrackingData>
    </cffunction>
</cfcomponent>