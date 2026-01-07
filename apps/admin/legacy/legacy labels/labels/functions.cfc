<cfcomponent>
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

    <cffunction name="getPassGenFunc" access="public">
        <cfargument name="search" default="">

        <cfquery name="getPassGen" datasource="#application.datasource#">
            SELECT `label_pass_generation`.`label_pass_gen_id`,
                `label_pass_generation`.`label_pass_detail_id`,
                `label_pass_generation`.`client_id`,
                `label_pass_generation`.`num_passwords`,
                `label_pass_generation`.`password_length`,
                `label_pass_generation`.`include_alpha`,
                `label_pass_generation`.`alpha_char`,
                `label_pass_generation`.`alpha_random_ind`,
                `label_pass_generation`.`alpha_position`,
                `label_pass_generation`.`create_dt`,
                `label_pass_generation`.`create_user_id`,
                `label_pass_generation`.`first_serial_num`,
                `label_pass_generation`.`last_serial_num`,
                `label_pass_generation`.`spreadsheet_name`,
                (select `client`.`company_name` from `#application.schema#`.`client` where `client`.`client_id` = `label_pass_generation`.`client_id`) as company_name,
                (SELECT count(1) FROM `#application.schema#`.`label_pass_generation` lpg WHERE lpg.owner_label_pass_gen_id = `label_pass_generation`.`label_pass_gen_id`) num_sub_spreadsheets
            FROM `#application.schema#`.`label_pass_generation`
                <cfif arguments.search NEQ "">
                ,`#application.schema#`.`label_password`
                WHERE `label_pass_generation`.`label_pass_detail_id` = `label_password`.`label_pass_detail_id` and
                    `label_password`.`password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(arguments.search))#">
                <cfelse>
                WHERE `label_pass_generation`.`owner_label_pass_gen_id` is null
                </cfif>
            ORDER BY `label_pass_generation`.`create_dt` DESC
        </cfquery>
        <cfreturn getPassGen>
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

    <cffunction name="getLabelPassDetailFunc" access="public">
        <cfargument name="label_pass_detail_id" default="">
        <cfargument name="client_id" default="">

        <cfif arguments.label_pass_detail_id NEQ "" AND arguments.client_id NEQ "">
            <cfquery name="getLabelPassDetail" datasource="#application.datasource#">
                SELECT `label_password_detail`.`label_pass_detail_id`,
                    `label_password_detail`.`client_id`,
                    `label_password_detail`.`create_dt`,
                    `label_password_detail`.`video_url`,
                    `label_password_detail`.`create_user_id`,
                    `label_password_detail`.`update_dt`,
                    `label_password_detail`.`update_user_id`,
                    `label_password_detail`.`verify_once`,
                    `label_password_detail`.`verify_once_msg`,
                    `label_password_detail`.`label_validation_msg`,
                    `label_password_detail`.`label_note`,
                    `client`.`company_name`
                FROM `#application.schema#`.`label_password_detail`,
                    `#application.schema#`.`client`
                WHERE `label_password_detail`.`active` = 'Y' and
                    `client`.`client_id` = `label_password_detail`.`client_id` and
                    `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_pass_detail_id#"> and
                    `client`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.client_id#">
                ORDER BY `label_password_detail`.`create_dt`
            </cfquery>
        <cfelseif arguments.label_pass_detail_id NEQ "">
            <cfquery name="getLabelPassDetail" datasource="#application.datasource#">
                SELECT `label_password_detail`.`label_pass_detail_id`,
                    `label_password_detail`.`client_id`,
                    `label_password_detail`.`create_dt`,
                    `label_password_detail`.`video_url`,
                    `label_password_detail`.`create_user_id`,
                    `label_password_detail`.`update_dt`,
                    `label_password_detail`.`update_user_id`,
                    `label_password_detail`.`verify_once`,
                    `label_password_detail`.`verify_once_msg`,
                    `label_password_detail`.`label_validation_msg`,
                    `label_password_detail`.`label_note`,
                    `client`.`company_name`
                FROM `#application.schema#`.`label_password_detail`,
                    `#application.schema#`.`client`
                WHERE `label_password_detail`.`active` = 'Y' and
                    `client`.`client_id` = `label_password_detail`.`client_id` and
                    `label_password_detail`.`label_pass_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_pass_detail_id#">
            </cfquery>
        <cfelse>
            <cfquery name="getLabelPassDetail" datasource="#application.datasource#">
                SELECT `label_password_detail`.`label_pass_detail_id`,
                    `label_password_detail`.`client_id`,
                    `label_password_detail`.`create_dt`,
                    `label_password_detail`.`video_url`,
                    `label_password_detail`.`create_user_id`,
                    `label_password_detail`.`update_dt`,
                    `label_password_detail`.`update_user_id`,
                    `label_password_detail`.`verify_once`,
                    `label_password_detail`.`verify_once_msg`,
                    `label_password_detail`.`label_validation_msg`,
                    `label_password_detail`.`label_note`,
                    `client`.`company_name`
                FROM `#application.schema#`.`label_password_detail`,
                    `#application.schema#`.`client`
                WHERE `label_password_detail`.`active` = 'Y' and
                    `client`.`client_id` = `label_password_detail`.`client_id`
                ORDER BY `label_password_detail`.`create_dt`
            </cfquery>
        </cfif>
        <cfreturn getLabelPassDetail>
    </cffunction>

    <cffunction name="getLabelValidationsFunc" access="public">
        <cfargument name="code" default="">

        <cfquery name="getLabelValidations" datasource="#application.datasource#">
            SELECT `label_validation`.`validation_id`,
                `label_validation`.`range_id`,
                `label_validation`.`create_dt`,
                `label_validation`.`IP_addr`,
                `label_validation`.`validation_code`,
                `label_validation`.`activity_id`,
                `label_validation`.`activity_loc_id`,
                `label_validation`.`reset`,
                `label_range`.`verify_once`,
                `client`.`company_name`
            FROM `#application.schema#`.`label_validation`,
                `#application.schema#`.`label_range`,
                `#application.schema#`.`client`
            WHERE `label_validation`.`validation_code` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.code)#"> and
                `label_validation`.`range_id` = `label_range`.`range_id` and
                `client`.`client_id` = `label_range`.`client_id`
            ORDER BY `label_validation`.`validation_id` DESC
        </cfquery>
        <cfreturn getLabelValidations>
    </cffunction>

    <cffunction name="getPasswordDetailFunc" access="public">
        <cfargument name="code" default="">

        <cfquery name="getPasswordDetail" datasource="#application.datasource#">
            SELECT `label_password_detail`.`label_pass_detail_id`,
                `label_password_detail`.`client_id`,
                `label_password_detail`.`create_dt`,
                `label_password_detail`.`create_user_id`,
                `label_password_detail`.`update_dt`,
                `label_password_detail`.`update_user_id`,
                `label_password_detail`.`active`,
                `label_password_detail`.`verify_once`,
                `label_password_detail`.`verify_once_msg`,
                `label_password_detail`.`label_validation_msg`,
                `label_password_detail`.`label_note`,
                `client`.`company_name`,
                `label_password`.`verify_once_override`
            FROM `#application.schema#`.`label_password_detail`,
                `#application.schema#`.`label_password`,
                `#application.schema#`.`client`
            WHERE `label_password_detail`.`label_pass_detail_id` = `label_password`.`label_pass_detail_id` and
                `label_password_detail`.`client_id` = `client`.`client_id` and
                `label_password`.`password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.code)#">
		</cfquery>
        <cfreturn getPasswordDetail>
    </cffunction>

    <cffunction name="getPasswordValidationsFunc" access="public">
        <cfargument name="code" default="">

		<cfquery name="getPasswordValidations" datasource="#application.datasource#">
            SELECT `label_password_detail`.`label_pass_detail_id`,
                `label_password_detail`.`client_id`,
                `label_password_detail`.`create_dt`,
                `label_password_detail`.`create_user_id`,
                `label_password_detail`.`update_dt`,
                `label_password_detail`.`update_user_id`,
                `label_password_detail`.`active`,
                `label_password_detail`.`verify_once`,
                `label_password_detail`.`verify_once_msg`,
                `label_password_detail`.`label_validation_msg`,
                `label_password_detail`.`label_note`,
                `label_password_validation`.`label_pass_val_id`,
                `label_password_validation`.`IP_addr`,
                `label_password_validation`.`password`,
                `client`.`company_name`,
                `label_password`.`verify_once_override`
            FROM `#application.schema#`.`label_password_detail`,
                `#application.schema#`.`label_password_validation`,
                `#application.schema#`.`label_password`,
                `#application.schema#`.`client`
            WHERE `label_password`.`password` =  `label_password_validation`.`password` and
                <!---`label_password_detail`.`label_pass_detail_id` = `label_password`.`label_pass_detail_id` and--->
                `label_password_validation`.`label_pass_detail_id` = `label_password_detail`.`label_pass_detail_id` and
                `label_password_detail`.`client_id` = `client`.`client_id` and
                `label_password_validation`.`password` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(UCase(arguments.code))#">
            ORDER BY `label_password_validation`.`label_pass_val_id` DESC
		</cfquery>
        <cfreturn getPasswordValidations>
    </cffunction>

    <cffunction name="getLabelRangeFunc" access="public">
        <cfargument name="label_id" default="">
        <cfargument name="client_id" default="">

		<cfquery name="getLabelRange" datasource="#application.datasource#">
            SELECT `label_range`.`range_id`,
                `label_range`.`range_start`,
                `label_range`.`range_end`,
                `label_range`.`range_alpha`,
                `label_range`.`doc_name`,
                `label_range`.`create_dt`,
                `label_range`.`create_user_id`,
                `label_range`.`update_dt`,
                `label_range`.`update_user_id`,
                `label_range`.`verify_once`,
                `label_range`.`range_start_display`,
                `label_range`.`range_end_display`,
                `label_range`.`label_note`,
                `label_range`.`client_id`,
                `client`.`company_name`
            FROM `#application.schema#`.`label_range`,
                `#application.schema#`.`client`
            WHERE `client`.`client_id` = `label_range`.`client_id` and
                `label_range`.`range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_id#"> and
                `client`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.client_id#">
        </cfquery>
        <cfreturn getLabelRange>
    </cffunction>

    <cffunction name="getAssociationsFunc" access="public">
        <cfargument name="label_id" default="">
        <cfargument name="client_id" default="">
        <cfargument name="pass" default="">

        <cfif pass EQ 1>
            <cfquery name="getAssociations" datasource="#application.datasource#">
                SELECT `lab_test_label_assoc`.`assoc_id`,
                    `lab_test_label_assoc`.`client_id`,
                    `lab_test_label_assoc`.`lab_test_id`,
                    `lab_test_label_assoc`.`create_dt`,
                    `lab_test_label_assoc`.`create_user_id`,
                    `label_password_detail`.`label_note`,
                    `lab_test_result`.`name`
                FROM `#application.schema#`.`lab_test_label_assoc`,
                    `#application.schema#`.`label_password_detail`,
                    `#application.schema#`.`lab_test_result`
                WHERE `lab_test_label_assoc`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.client_id#"> and
                    `lab_test_label_assoc`.`password_detail_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_id#"> and
                    `label_password_detail`.`label_pass_detail_id` = `lab_test_label_assoc`.`password_detail_id` and
                    `lab_test_result`.`lab_test_id` = `lab_test_label_assoc`.`lab_test_id` and
                    `lab_test_result`.`active` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
                ORDER BY `lab_test_result`.`name`
            </cfquery>
        <cfelse>
            <cfquery name="getAssociations" datasource="#application.datasource#">
                SELECT `lab_test_label_assoc`.`assoc_id`,
                    `lab_test_label_assoc`.`client_id`,
                    `lab_test_label_assoc`.`lab_test_id`,
                    `lab_test_label_assoc`.`create_dt`,
                    `lab_test_label_assoc`.`create_user_id`,
                    `label_range`.`label_note`,
                    `lab_test_result`.`name`
                FROM `#application.schema#`.`lab_test_label_assoc`,
                    `#application.schema#`.`label_range`,
                    `#application.schema#`.`lab_test_result`
                WHERE `lab_test_label_assoc`.`client_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.client_id#"> and
                    `lab_test_label_assoc`.`range_id` = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.label_id#"> and
                    `label_range`.`range_id` = `lab_test_label_assoc`.`range_id` and
                    `lab_test_result`.`lab_test_id` = `lab_test_label_assoc`.`lab_test_id` and
                    `lab_test_result`.`active` = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y">
                ORDER BY `lab_test_result`.`name`
            </cfquery>
        </cfif>
        <cfreturn getAssociations>
    </cffunction>
</cfcomponent>