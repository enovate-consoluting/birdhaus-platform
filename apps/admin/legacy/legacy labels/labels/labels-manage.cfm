<cfset includePath = "../">

<!--- Create functions component object --->
<cfset functionsObj = createObject('component','functions') >
<cfset getLabelPassDetail = functionsObj.getLabelPassDetailFunc()>

<!DOCTYPE html>
<html dir="ltr" lang="en">
    <cfinclude template="#includePath#includes/header/header.cfm">
    <body>
        <div id="mainLayout">
            <cfinclude template="#includePath#includes/navigation/left_nav.cfm">
            <div onclick="removeMenu()" class="sideOverlay"></div>
            <cfinclude template="#includePath#includes/header/top_bar.cfm">
            <div class="mainBody">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="pageTitle">
                            <h2><i class="material-icons">assignment</i><span>Manage Labels</span></h2>

                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="../dashboard.cfm">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Manage Labels</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="ManageLabelsTable" class="table table-bordered" style="width:100%;">
                                        <thead>
                                            <tr>
												<th>Detail Id</th>
                                                <th>Client</th>
                                                <th>Note</th>
                                                <th>Entered</th>
                                                <th>Video URL</th>
                                                <th>Verify Once</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="loading-data">
                                            <tr>
                                                <td colspan="5" class="text-center">
                                                    <span>
                                                        <img src="../../img/spinner.gif">Loading...
                                                    </span>
                                                </td>
                                            </tr>
                                        </tbody>
                                        <tbody id="ManageLabelsTableData" style="display: none;">
                                            <cfoutput query="getLabelPassDetail">
                                                <tr>
													<td>#getLabelPassDetail.label_pass_detail_id#</td>
                                                    <td>#getLabelPassDetail.company_name#</td>
                                                    <td>#getLabelPassDetail.label_note#</td>
                                                    <td><span style="display:none;">#DateFormat(getLabelPassDetail.create_dt,'YYYYMMDD')#</span>#DateTimeFormat(getLabelPassDetail.create_dt,'short')#</td>
                                                    <td><cfif getLabelPassDetail.video_url NEQ ""><cfif FindNoCase("https://imagedelivery.net/", getLabelPassDetail.video_url) LT 1>#application.siteUrl#labels/videos/</cfif>#getLabelPassDetail.video_url#</cfif></td>
                                                    <td><cfif getLabelPassDetail.verify_once EQ 'Y'>Yes<cfelse>No</cfif></td>
                                                    <td>
                                                        <div class="action-btn">
                                                            <button type="button" class="iconBox" title="Edit Detail">
                                                                <a onclick="managelabel(#getLabelPassDetail.label_pass_detail_id#)">
                                                                    <i class="material-icons">mode_edit</i>
                                                                </a>
                                                            </button>

                                                            <a href="test-results-assoc.cfm?client_id=#getLabelPassDetail.client_id#&label_id=#getLabelPassDetail.label_pass_detail_id#&label_type=password" class="iconBox result" title="Associate with Test Results">
                                                                <i class="material-icons">call_split</i>
                                                            </a>

                                                            <button type="button" class="iconBox danger" title="Delete">
                                                                <a href="labels-delete.cfm?label_pass_detail_id=#getLabelPassDetail.label_pass_detail_id#">
                                                                    <i class="material-icons">delete</i>
                                                                </a>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </cfoutput>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <cfinclude template="#includePath#includes/footer/footer.cfm">
        </div>
        <cfinclude template="#includePath#includes/footer/js_files.cfm">
    </body>
    <div class="modal fade" id="EditLabelDetailModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
    aria-labelledby="EditLabelDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="EditLabelDetailModalLabel">Edit Labels</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modal_data">

                </div>
            </div>
        </div>
    </div>
</html>

<script>
   $(document).ready(function() {
        $(document).delegate("#video_url","change",function () {
            var file = this.files[0];
            if (!file) return;

            var reader = new FileReader();
            reader.onload = function (evt) {
            $("#previewImage").attr("src", evt.target.result);
            };
            reader.readAsDataURL(file);
        });
    });
</script>
