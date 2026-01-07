<cfif NOT StructKeyExists(URL,"label_pass_detail_id")>
	<cflocation url="labels-manage.cfm" addtoken="no">
	<cfabort>
</cfif>
<cfset includePath = "../">

<!--- Create functions component object --->
<cfset functionsObj = createObject('component','functions') >
<cfset getLabelPassDetail = functionsObj.getLabelPassDetailFunc(URL.label_pass_detail_id)>

<!DOCTYPE html>
<html dir="ltr" lang="en">
    <cfinclude template="#includePath#includes/header/header.cfm">
<body>
    <div class="preloader">
        <div class="lds-ripple">
            <div class="lds-pos"></div>
            <div class="lds-pos"></div>
        </div>
    </div>

    <div id="mainLayout">
        <cfinclude template="#includePath#includes/navigation/left_nav.cfm">
        <cfinclude template="#includePath#includes/header/top_bar.cfm">
        <div class="mainBody">
            <div class="row">
                <div class="col-lg-12">
                    <div class="pageTitle">
                        <h2><i class="material-icons">assignment</i><span>Manage Labels</span></h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/admin/dashboard.cfm">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Manage Labels</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header">
                            <h6>Delete Label</h6>
                        </div>
                        <div class="card-body">
                            <form name="labels-delete-form" action="labels-delete-save.cfm" enctype="multipart/form-data" method="post">
                                <cfoutput>
                                    <div class="card-body">
                                        <h5 class="card-title">Are you sure you want to delete this set of labels?</h5>
                                        <div class="table-responsive">
                                            <table class="text-muted mb-0 no-wrap">
                                                <tbody>
                                                    <tr>
                                                        <td class="border-0" width="120px"><b>Client:</b></td>
                                                        <td class="border-0">#getLabelPassDetail.company_name#</td>
                                                    </tr>	
                                                    <tr>
                                                        <td class="border-0"><b>Note:</b></td>
                                                        <td class="txt-oflo">#getLabelPassDetail.label_note#</td>
                                                    </tr>																					
                                                </tbody>
                                            </table>
                                        </div>						
                                        <div class="form-actions mt-5">
                                            <button type="submit" class="ThemeBtn btnDanger">Delete</button>
                                            <a href="labels-manage.cfm"><button type="button" class="ThemeBtn-outline">Cancel</button></a>
                                        </div>								
                                    </div>
                                    <input type="hidden" name="label_pass_detail_id" value="#URL.label_pass_detail_id#">
                                </cfoutput>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <cfinclude template="#includePath#includes/footer/footer.cfm">
    </div>
    <cfinclude template="#includePath#/includes/footer/js_files.cfm">
</body>

</html>