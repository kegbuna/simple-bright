service_item "Epic Reporting" do
  catalog "Lahey IT Services"
  type "Template"
  description "Make a request for new access or reporting for a clinical application."
  display_page "/themes/simple-bright/packages/base/display.jsp"
  display_name "Lahey-EpicReporting"
  header_content nil
  web_server "http://wvremmidt01g1.laheyhealth.org:8090/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority nil
  allow_anonymous true
  task_engine "Kinetic Task 2/3"
  attribute "Review JSP", "themes/simple-bright/packages/base/review.jsp"
  page "Initial Page",
    :contents,
    :vertical_buttons,
    :submit_button_value => "Submit" do
    event "enable people search",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code "keg.startTemplate();"
      bridged_resource "People",
        :qualification => "Raw"
    end
    section  "Requested For Section",
      :style_class => " border rounded "
    text "Requested For Header", "<i class=\"fa fa-group section-header-icon\"></i><h2 class=\"section-header-title\">User Information</h2>",
      :style_class => " section-header "
    text "Contact Information", "<div id=\"submitterBox\" class=\"person-info\">\n<div class=\"person-info-title\">Submitter</div>\n<div class=\"person-info-box\"></div>\n</div>\n<div id=\"customerBox\" class=\"person-info\">\n<div class=\"person-info-title\">Customer <i id =\"changeCustomer\" class=\"person-info-change\"></i></div>\n<div class=\"person-info-box\"></div>\n</div>",
      :style_class => " contact-info "
    question "Search By Person ID", "Person ID", :free_text,
      :removed,
      :transient,
      :size => "40",
      :rows => "1",
      :style_class => " fleft "
    text "Search Buttons", "<div class=\"fleft\" id=\"searchButtons\">\n  <input type=\"button\" value=\"Search\" id=\"b_searchReqFor\" class=\"templateButton\" > \n  <input type=\"button\" value=\"Clear\" id=\"b_clearReqFor\" class=\"templateButton\" > \n  <img id=\"ajax_searchReqFor\" src=\"themes/flyout/common/resources/images/spinner.gif\" alt=\"searching...\" style=\"display:none;\" />\n</div>\n<div class=\"clearfix\"></div>",
      :removed,
      :style_class => " fleft " do
      event "Person Lookup",
        :set_fields_external,
        :click,
        :fire_if => "1==1" do
        data_request "CTM:People",
          :sort_fields => "Last Name",
          :max_entries => "100",
          :sort_order => "Ascending",
          :qualification => "'Person ID' = \"<FLD>Search By Person ID;KSc7313fa97ddee11a8a3725c12f4d6b5d30;ANSWER</FLD>\""
        field_map "ReqFor_First Name", "<FLD>First Name</FLD> ",
          :visible_in_table => "Yes",
          :table_label => "First Name"
        field_map "ReqFor_Last Name", "<FLD>Last Name</FLD> ",
          :visible_in_table => "Yes",
          :table_label => "Last Name"
        field_map "ReqFor_Login ID", "<FLD>Remedy Login ID</FLD> ",
          :fire_change_immediately,
          :visible_in_table => "Yes",
          :table_label => "Login ID"
        field_map "ReqFor_Phone", "<FLD>Phone Number Business</FLD> ",
          :visible_in_table => "No"
        field_map "ReqFor_Email", "<FLD>Internet E-mail</FLD> ",
          :visible_in_table => "Yes",
          :table_label => "Email"
        field_map "ReqFor_Org", "<FLD>Organization</FLD> ",
          :visible_in_table => "No"
        field_map "ReqFor_Dept", "<FLD>Department</FLD> ",
          :visible_in_table => "No"
        field_map "ReqFor_VIP", "<FLD>VIP</FLD> ",
          :visible_in_table => "No"
      end
    end
    section  "Submitter",
      :removed
    text "Submitter Header", "Submitter Information",
      :style_class => " primaryColorHeader "
    question "Requester First Name", "Requester First Name", :free_text,
      :required,
      :advance_default,
      :editor_label => "Req First Name",
      :answer_mapping => "First Name",
      :default_form => "CTM:People",
      :default_field => "First Name",
      :default_qual => "$\\USER$= 'Remedy Login ID'",
      :size => "20",
      :rows => "1",
      :required_text => "Requester First Name",
      :field_map_number => "12"
    question "Requester Last Name", "Requester Last Name", :free_text,
      :required,
      :advance_default,
      :editor_label => "Req Last Name",
      :answer_mapping => "Last Name",
      :default_form => "CTM:People",
      :default_field => "Last Name",
      :default_qual => "$\\USER$= 'Remedy Login ID'",
      :size => "20",
      :rows => "1",
      :required_text => "Requester Last Name",
      :field_map_number => "17"
    question "Requester People Number", "Requester People Number", :free_text,
      :advance_default,
      :editor_label => "Req People #",
      :default_form => "CTM:People",
      :default_field => "Person ID",
      :default_qual => "$\\USER$= 'Remedy Login ID'",
      :size => "20",
      :rows => "1",
      :max => "20",
      :field_map_number => "18"
    question "Requester Email Address", "Requester Email", :email,
      :required,
      :advance_default,
      :editor_label => "Req Email Address",
      :default_form => "CTM:People",
      :default_field => "Internet E-mail",
      :default_qual => "$\\USER$= 'Remedy Login ID'",
      :size => "20",
      :required_text => "Requester Email",
      :pattern_label => "Standard Email Address",
      :pattern => "^[\\w-\\.]+\\@[\\w\\.-]+\\.[a-zA-Z]{2,4}$",
      :validation_text => "Requester Email Address (Standard Email Address)",
      :field_map_number => "19"
    question "Requester Phone Number", "Requester Phone Number", :free_text,
      :advance_default,
      :editor_label => "Req Phone Number",
      :default_form => "CTM:People",
      :default_field => "Phone Number Business",
      :default_qual => "'Remedy Login ID' = $\\USER$",
      :size => "20",
      :rows => "1",
      :field_map_number => "115"
    question "Requester Login ID", "Requester Login ID", :free_text,
      :advance_default,
      :editor_label => "Req Login ID",
      :default_form => "CTM:People",
      :default_field => "Remedy Login ID",
      :default_qual => "$\\USER$= 'Remedy Login ID'",
      :size => "20",
      :rows => "1",
      :field_map_number => "20"
    section  "Requested For Details Section",
      :removed,
      :style_class => " border rounded "
    question "Requested For Login ID", "Requested For Login ID", :free_text,
      :required,
      :editor_label => "ReqFor_Login ID",
      :size => "40",
      :rows => "1",
      :field_map_number => "11"
    question "Requested For First Name", "First Name", :free_text,
      :editor_label => "ReqFor_First Name",
      :size => "40",
      :rows => "1",
      :field_map_number => "13"
    question "Requested For Last Name", "Last Name", :free_text,
      :editor_label => "ReqFor_Last Name",
      :size => "40",
      :rows => "1",
      :field_map_number => "14"
    question "Requested For Email", "Email Address", :free_text,
      :editor_label => "ReqFor_Email",
      :size => "40",
      :rows => "1",
      :field_map_number => "15"
    question "Requested For Phone Number", "Phone Number", :free_text,
      :editor_label => "ReqFor_Phone",
      :size => "40",
      :rows => "1",
      :field_map_number => "16"
    question "ReqFor_Org", "Office", :free_text,
      :size => "40",
      :rows => "1",
      :field_map_number => "28"
    question "ReqFor_Dept", "Branch", :free_text,
      :size => "40",
      :rows => "1",
      :field_map_number => "21"
    question "ReqFor_VIP", "VIP", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "22"
    section  "Epic Reporting Request",
      :style_class => " form-section "
    text "Request Information", "<i class=\"fa fa-clipboard section-header-icon\"></i><h2 class=\"section-header-title\">Request Details</h2>",
      :style_class => " section-header "
    question "Report Request Type", "What type of assistance do you need?", :list,
      :list_box,
      :vertical,
      :required,
      :choice_list => "ReportReqTypes",
      :style_class => " qTrigger ",
      :field_map_number => "3" do
      choice "Access", "Request Access to an Epic Report(s) for yourself or others."
      choice "Development", "Request Development of a New Epic Report"
      choice "Modification", "Request Modification to an Existing Epic Report"
      choice "Other", "Other Epic Reporting Request"
    end
    question "Primary Application", "Which Epic application is primarily related to your request?", :dynamic_list,
      :field_map_number => "2" do
      bridged_dynamic_list "Products",
        :qualification => "By Prod Cats",
        :label_attribute => "Product Name",
        :value_attribute => "Product Name" do
        parameter "Cat1", " "
        parameter "Cat2", " "
        parameter "Cat3", " "
      end
    end
    question "Attachment", "Attach a file", :attachment,
      :size => "20",
      :file_size_limit => "1024",
      :upload_label => "Add",
      :clear_label => "Clear",
      :field_map_number => "6"
    text "Request Access", "<h3 class=\"question-header-title\">Request access to an Epic report(s) for yourself or others.</h3><p class=\"question-header-text\">Access requests are granted with a valid MR1 account and sign-off from the owner of the requested report(s). In an effort to keep Lahey reporting sustainable, access is granted to all reports that share the same permissions group as opposed to the specified reports.</p>",
      :style_class => " question-header Access qHide "
    question "Access Users", "Who are the user(s) that access is requested for? Please provide MR1 account names or email addresses of each requested user. Absence of this information will delay the request.", :free_text,
      :size => "20",
      :rows => "4",
      :style_class => " Access qHide req PeopleList ",
      :field_map_number => "1"
    question "Access Reports", "Which reports are being requested? If there a user that you wish the requested users to mimic for additional report access, who would that be? Please provide MR1 account names or email addresses. Absence of this information will delay the request.", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Access qHide req ",
      :field_map_number => "4"
    question "Access Details", "Are there any other details?", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Access qHide ",
      :field_map_number => "5"
    text "Request Modification", "<h3 class=\"question-header-title\">Request Modification to Existing Report</h3><p class=\"question-header-text\">Report modification requests are submitted for approval by governance. Please provide as much information as possible to aid the approval and prioritization of your request.</p>",
      :style_class => " question-header Modification qHide "
    question "Modification Report Name", "Please provide the exact display name of the report as it appears in Hyperspace.", :free_text,
      :size => "20",
      :rows => "1",
      :style_class => " Modification qHide req ",
      :field_map_number => "7"
    question "Modification Business Case", "Please describe the business case or rather impact this reporting will have on the organization and/or our patients?", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Modification qHide req ",
      :field_map_number => "8"
    question "Modification Change Description", "Please describe the requested change(s) with as much detail and specifics as possible?", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Modification qHide req ",
      :field_map_number => "9"
    text "Request Development", "<h3 class=\"question-header-title\">Request Development of a New Epic Report</h3><p class=\"question-header-text\">New report requests are submitted for approval by governance. Please provide as much information as possible to aid the approval and prioritization of your request.</p>",
      :style_class => " question-header Development qHide "
    question "Development Draft Title", "Please enter a draft title for this report", :free_text,
      :size => "20",
      :rows => "1",
      :style_class => " Development qHide req ",
      :field_map_number => "10"
    question "Development Description", "Please describe your request with as much detail and specifics as possible", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Development qHide req ",
      :field_map_number => "23"
    question "Development Business Case", "Please describe the business case or rather impact this reporting will have on the organization and/or our patients?", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Development qHide req ",
      :field_map_number => "24"
    question "Development Statements", "Select all statements that relate to this request: ", :list,
      :check_box,
      :vertical,
      :choice_list => "DevStatements",
      :style_class => " Development qHide req ",
      :field_map_number => "25" do
      choice "This request impacts patient safety, regulatory requirements, or significant budget items."
      choice "Absent this reporting, there is no known workaround that will satisfy the need."
    end
    question "Development Sites/Departments", "What are the intended sites and departments that will use this report?", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Development qHide req ",
      :field_map_number => "26"
    question "Development Reporting Approach", "Which reporting approach is appropriate for your need?", :list,
      :radio_button,
      :vertical,
      :choice_list => "ReportApproaches",
      :style_class => " Development qHide req ",
      :field_map_number => "27" do
      choice "Reporting Workbench", "Reporting Workbench (Near real time data but limited to a 31 day span. An example might be all discharges last April for a given nursing unit.)"
      choice "Clarity Report", "Clarity Report (Virtually unlimited time span of data but data is stale by one day. Typical these are managerial reports looking at trends.)"
      choice "Automated Extract", "Automated Extract (A scheduled extract to be transmitted to a third party or internal computer system)"
      choice "I don't know."
    end
    text "Request Other", "<h3 class=\"question-header-title\">Other Epic Reporting Request</h3>",
      :style_class => " question-header Other qHide "
    question "Other Description", "Please describe your request with as much detail and specifics as possible", :free_text,
      :size => "30",
      :rows => "4",
      :style_class => " Other qHide req ",
      :field_map_number => "29"
    question "Sponsor", "Who is the sponsor of this request (director or higher)? Upon submission, this user will be assigned to approve the request.", :dynamic_list,
      :style_class => " Modification Access Development qHide req ",
      :field_map_number => "30" do
      bridged_dynamic_list "People",
        :qualification => "All Enabled",
        :label_attribute => "Full Name",
        :value_attribute => "Login ID"
    end
    section  "Admin",
      :removed
    question "Validation Status", "Validation Status", :free_text,
      :answer_mapping => "Validation Status",
      :default_answer => "Submitted",
      :size => "20",
      :rows => "1",
      :field_map_number => "31"
    question "Incident Number", "Incident Number", :free_text,
      :required,
      :read_only,
      :answer_mapping => "Originating ID-Display",
      :size => "20",
      :rows => "1",
      :field_map_number => "32"
  end
  page "Confirmation",
    :confirmation,
    :vertical_buttons,
    :submit_button_value => "Submit",
    :display_page => "/themes/simple-bright/packages/base/confirmation.jsp" do
  end
  task_tree "Submit Epic Reporting",
    :type => "Complete",
    :xml => "<taskTree builder_version=\"\" schema_version=\"1.0\" version=\"\">\n    <name>Submit Epic Reporting</name>\n    <author/>\n    <notes/>\n    <lastID>15</lastID>\n    <request>\n        <task definition_id=\"system_start_v1\" id=\"start\" name=\"Start\" x=\"17\" y=\"18\">\n            <version>1</version>\n            <configured>true</configured>\n            <defers>false</defers>\n            <deferrable>false</deferrable>\n            <visible>false</visible>\n            <parameters/>\n            <messages/>\n            <dependents>\n                \n            <task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_format_answers_html_v3_13</task></dependents>\n        </task>\n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        <task definition_id=\"kinetic_request_submission_update_status_v1\" id=\"kinetic_request_submission_update_status_v1_7\" name=\"Update Status In Progress\" x=\"98\" y=\"277\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">In Progress</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        <task definition_id=\"kinetic_request_submission_close_v1\" id=\"kinetic_request_submission_close_v1_8\" name=\"Request Complete\" x=\"399.6875\" y=\"300.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">Complete</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        \n      \n        \n      \n        \n      \n        \n      \n        <task name=\"Format Answers\" id=\"kinetic_request_submission_format_answers_html_v3_13\" definition_id=\"kinetic_request_submission_format_answers_html_v3\" x=\"159.6875\" y=\"53.703125\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"start\" label=\"Starting Question:\" required=\"false\" tooltip=\"The menu label of the first question that should be formatted.  If this is left blank, the first question on the service item will be used.\" menu=\"\">Report Request Type</parameter>\n        <parameter id=\"end\" label=\"Ending Question:\" required=\"false\" tooltip=\"The menu label of the last question that should be formatted.  If this is left blank, the last question on the service item will be used.\" menu=\"\">Validation Status</parameter>\n        <parameter id=\"include\" label=\"Included Questions:\" required=\"false\" tooltip=\"A comma separated list of question menu labels that should be explicitely included in the question list.  Questions included in this list will be included even if they do not exist between the starting and ending questions.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" menu=\"\"/>\n        <parameter id=\"exclude\" label=\"Excluded Questions:\" required=\"false\" tooltip=\"A comma separated list of question menu labels that should be explicitely excluded in the question list.  Questions included in this list will be excluded even if they exist between the starting and ending questions or are included in the 'Included Question' parameter.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" menu=\"\">Validation Status</parameter>\n\t\t<parameter id=\"csrvId\" label=\"Survey/Request Instance ID:\" required=\"true\" tooltip=\"Instance ID of the survey/request to retrieve answers for\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter id=\"h_table_structure\" label=\"Heading table structure:\" required=\"false\" tooltip=\"header table structure\" menu=\"\"/>\n\t\t<parameter id=\"q_table_wrapper_open\" label=\"Question table tag open:\" required=\"false\" tooltip=\"opening table tag and styling\" menu=\"\">&lt;table&gt;</parameter>\n\t\t<parameter id=\"q_tbody_wrapper_open\" label=\"Question table tbody tag open:\" required=\"false\" tooltip=\"opening table tag and styling\" menu=\"\">&lt;tbody&gt;</parameter>\n\t\t<parameter id=\"q_tr_wrapper_open\" label=\"Question table tr tag open:\" required=\"false\" tooltip=\"opening tr tag and styling\" menu=\"\">&lt;tr&gt;</parameter>\n\t\t<parameter id=\"q_td_qlabel_wrapper_open\" label=\"Question table label td tag open:\" required=\"false\" tooltip=\"opening question label td tag and styling\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter id=\"q_td_qlabel_wrapper_close\" label=\"Question table label td tag close:\" required=\"false\" tooltip=\"closing question label td tag\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter id=\"q_td_qanswer_wrapper_open\" label=\"Question table answer td tag open:\" required=\"false\" tooltip=\"opening question answer td tag and styling\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter id=\"q_td_qanswer_wrapper_close\" label=\"Question table answer td tag close:\" required=\"false\" tooltip=\"closing question answer td tag\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter id=\"q_tr_wrapper_close\" label=\"Question table tr tag close:\" required=\"false\" tooltip=\"closing tr tag\" menu=\"\">&lt;/tr&gt;</parameter>\n\t\t<parameter id=\"q_tbody_wrapper_close\" label=\"Question table tbody tag close:\" required=\"false\" tooltip=\"closing body tag\" menu=\"\">&lt;/tbody&gt;</parameter>\n\t\t<parameter id=\"q_table_wrapper_close\" label=\"Question table tag close:\" required=\"false\" tooltip=\"closing table tag\" menu=\"\">&lt;/table&gt;</parameter>\n\t\t\t\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">bbb_itsm7_incident_templated_create_id_v1_14</task></dependents>\n    </task>\n      \n        <task name=\"Epic Reporting Incident\" id=\"bbb_itsm7_incident_templated_create_id_v1_14\" definition_id=\"bbb_itsm7_incident_templated_create_id_v1\" x=\"310\" y=\"130\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>true</defers>\n      <deferrable>true</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter id=\"incident_template_name\" label=\"Incident Template Name:\" required=\"true\" tooltip=\"The name of the incident template to submit with.\" menu=\"\">Epic Reporting</parameter>\n        <parameter id=\"requester_first_name\" label=\"Requester First Name:\" required=\"true\" tooltip=\"The value placed in the First Name field on the Incident form.\" menu=\"\">&lt;%=@answers['ReqFor_First Name']%&gt;</parameter>\n        <parameter id=\"requester_last_name\" label=\"Requester Last Name:\" required=\"true\" tooltip=\"The value placed in the Last Name field on the Incident form.\" menu=\"\">&lt;%=@answers['ReqFor_Last Name']%&gt;</parameter>\n       <parameter id=\"submitter_login_id\" label=\"Submitter Login Id:\" required=\"true\" tooltip=\"The value placed in the Submitter field on the Incident form.\" menu=\"\">&lt;%=@answers['Req Login ID']%&gt;</parameter>\n\t<parameter id=\"summary\" label=\"Summary:\" required=\"false\" tooltip=\"The value placed in the Summary field on the Incident form.\" menu=\"\">Epic Reporting &lt;%=@answers['Report Request Type']%&gt; Request</parameter>\n\t<parameter id=\"notes\" label=\"Notes:\" required=\"false\" tooltip=\"The value placed in the Notes field on the Incident form.\" menu=\"\">See request details below:\n\n&lt;%=@results['Format Answers']['textresult']%&gt;</parameter>\n\t<parameter id=\"service_type\" label=\"Service Type:\" required=\"false\" tooltip=\"The Service Type (eg. User Service Request or User Service Restoration) value placed in the Notes field on the Incident form.\" menu=\"\"/>\n\t<parameter id=\"impact\" label=\"Impact:\" required=\"false\" tooltip=\"Should be exactly equal to the text visible in Remedy for this field.\" menu=\"\"/>\n\t<parameter id=\"urgency\" label=\"Urgency:\" required=\"false\" tooltip=\"Should be exactly equal to the text visible in Remedy for this field.\" menu=\"\"/>\n\t<parameter id=\"surveyid\" label=\"Survey ID (KSR #):\" required=\"true\" tooltip=\"The value placed in the SRID field on the Incident form.\" menu=\"\">&lt;%=@dataset['Originating ID-Display']%&gt;</parameter>\n    <parameter id=\"srinstanceid\" label=\"Survey Instance ID:\" required=\"true\" tooltip=\"The value placed in the SRInstanceID field on the Incident form.\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    <parameter id=\"incident_id\" label=\"Incident ID:\" required=\"true\" tooltip=\"The Incident Number to push\" menu=\"\">&lt;%=@answers['Incident Number']%&gt;</parameter>\n\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Create\" label=\"\" value=\"\">kinetic_request_submission_update_status_v1_7</task><task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_close_v1_8</task><task type=\"Complete\" label=\"If Attachment\" value=\"!@answers['Attachment'].nil?\">bmc_itsm7_incident_work_info_create_v5_15</task></dependents>\n    </task>\n      \n        <task name=\"Add attachment worklog\" id=\"bmc_itsm7_incident_work_info_create_v5_15\" definition_id=\"bmc_itsm7_incident_work_info_create_v5\" x=\"578\" y=\"107\">\n      <version>5</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter id=\"incident_number\" label=\"Incident Number:\" required=\"true\" tooltip=\"The incident number of the Incident to associate the Incident Work Info entry with.\" menu=\"\">&lt;%=@answers['Incident Number']%&gt;</parameter>\n        <parameter id=\"include_review_request\" label=\"Include Review Request:\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to prepend the review request URL to the Notes of the Incident Work Info entry.\">No</parameter>\n        <parameter id=\"include_question_answers\" label=\"Include Question Answers:\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to append the question answer pairs to the Notes of the Incident Work Info entry.\">No</parameter>\n        <parameter id=\"work_info_type\" label=\"Work Info Type:\" required=\"true\" tooltip=\"Work Info Type.\" menu=\"\">General Information</parameter>\n\t\t<parameter id=\"work_info_summary\" label=\"Work Info Summary:\" required=\"true\" tooltip=\"Sets the Summary of the Incident Work Info entry.\" menu=\"\">User attachment</parameter>\n        <parameter id=\"work_info_notes\" label=\"Work Info Notes:\" required=\"false\" tooltip=\"Sets the Notes of the Incident Work Info entry.\" menu=\"\">User attachment</parameter>\n        <parameter id=\"work_info_submit_date\" label=\"Work Info Submit Date:\" required=\"false\" tooltip=\"Sets the Date of the Incident Work Info entry.\" menu=\"\"/>\n        <parameter id=\"attachment_question_menu_label_1\" label=\"Attachment Question Menu Label 1:\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\">Attachment</parameter>\n        <parameter id=\"attachment_question_menu_label_2\" label=\"Attachment Question Menu Label 2:\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\"/>\n        <parameter id=\"attachment_question_menu_label_3\" label=\"Attachment Question Menu Label 3:\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\"/>\n        <parameter id=\"submitter\" label=\"Submitter:\" required=\"false\" tooltip=\"Sets the Submitter of the Incident Work Info entry.\" menu=\"\"/>\n\t\t<parameter id=\"secure_work_log\" label=\"Locked:\" menu=\"Yes,No\" required=\"true\" tooltip=\"Sets the Incident Work Info entry Locked status.\">Yes</parameter>\t\t\t\t   \n        <parameter id=\"view_access\" label=\"View Access:\" required=\"true\" tooltip=\"Sets the Incident Work Info entry to Public or Internal.\" menu=\"\">Public</parameter>\n\t\t<parameter id=\"customer_survey_instance_id\" label=\"Customer Survey Instance ID:\" required=\"true\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter id=\"survey_template_instance_id\" label=\"Survey Template Instance ID:\" required=\"true\" tooltip=\"The survey template instance ID related to the Customer Survey Instance ID.\" menu=\"\">&lt;%=@dataset['Survey Instance ID']%&gt;</parameter>\n\t\t<parameter id=\"default_web_server\" label=\"Default Web Server:\" required=\"true\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\" menu=\"\">&lt;%=@appconfig['Default Web Server']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      </request>\n</taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
