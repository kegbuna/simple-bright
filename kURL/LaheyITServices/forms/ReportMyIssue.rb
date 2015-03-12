service_item "Report My Issue" do
  catalog "Lahey IT Services"
  categories "Issue Reporting"
  type "Template"
  description "Submit a help ticket to the Support Center!"
  display_page "/themes/simple-bright/packages/base/display.jsp"
  display_name "Lahey-ReportIncident"
  header_content nil
  web_server "http://kinetic-server:8090/catalog/"
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
      custom_code "keg.startTemplate(); keg.Request.retrieveINC();"
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
          :qualification => "'Person ID' = \"<FLD>Search By Person ID;KSe1702b74d5e7a8354854af2471ddd7e536;ANSWER</FLD>\""
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
    section  "Incident Request",
      :style_class => " form-section "
    text "Incident INformation", "<i class=\"fa fa-clipboard section-header-icon\"></i><h2 class=\"section-header-title\">Problem Details</h2>",
      :style_class => " section-header "
    question "Locations", "Where are you located?", :dynamic_list,
      :field_map_number => "2" do
      bridged_dynamic_list "Sites",
        :qualification => "Enabled",
        :label_attribute => "Site Name",
        :value_attribute => "Site Name"
    end
    question "What kind of problem?", "What kind of problem?", :list,
      :list_box,
      :vertical,
      :removed,
      :choice_list => "deals",
      :field_map_number => "3" do
      choice "Minor", "Not a Big Deal"
      choice "Major", "Big Deal"
      choice "Critical", "HUGE DEAL!"
    end
    question "Request Details", "Please describe the issue you're experiencing.", :free_text,
      :required,
      :size => "30",
      :rows => "4",
      :field_map_number => "1"
    question "Attachment", "Attach any relevant files", :attachment,
      :size => "20",
      :file_size_limit => "1024",
      :upload_label => "Add",
      :clear_label => "Clear",
      :field_map_number => "6"
    section  "Admin",
      :removed
    question "Incident Number", "Incident Number", :free_text,
      :required,
      :read_only,
      :answer_mapping => "Originating ID-Display",
      :size => "20",
      :rows => "1",
      :field_map_number => "4"
    question "Validation Status", "Validation Status", :free_text,
      :answer_mapping => "Validation Status",
      :default_answer => "Submitted",
      :size => "20",
      :rows => "1",
      :field_map_number => "5"
  end
  page "Confirmation",
    :confirmation,
    :vertical_buttons,
    :display_page => "/themes/simple-bright/packages/base/confirmation.jsp" do
  end
  task_tree "Submit Incident",
    :type => "Complete",
    :xml => "<taskTree version=\"\" schema_version=\"1.0\" builder_version=\"\">\n    <name>Submit Incident</name>\n    <author />\n    <notes />\n    <lastID>15</lastID>\n    <request>\n        <task name=\"Start\" y=\"18\" x=\"17\" id=\"start\" definition_id=\"system_start_v1\">\n            <version>1</version>\n            <configured>true</configured>\n            <defers>false</defers>\n            <deferrable>false</deferrable>\n            <visible>false</visible>\n            <parameters />\n            <messages />\n            <dependents>\n                \n            <task type=\"Complete\" value=\"\" label=\"\">kinetic_request_submission_format_answers_html_v3_13</task></dependents>\n        </task>\n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        <task name=\"Update Status In Progress\" y=\"358\" x=\"556\" id=\"kinetic_request_submission_update_status_v1_7\" definition_id=\"kinetic_request_submission_update_status_v1\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter label=\"Validation Status:\" id=\"validation_status\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" required=\"true\" menu=\"\">In Progress</parameter>\n        <parameter label=\"Submission Id:\" id=\"submission_id\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" required=\"true\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\" />\n        <message type=\"Update\" />\n        <message type=\"Complete\" />\n      </messages>\n      <dependents />\n    </task>\n      \n        <task name=\"Request Complete\" y=\"308.92\" x=\"718.79\" id=\"kinetic_request_submission_close_v1_8\" definition_id=\"kinetic_request_submission_close_v1\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter label=\"Validation Status:\" id=\"validation_status\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" required=\"true\" menu=\"\">Complete</parameter>\n        <parameter label=\"Submission Id:\" id=\"submission_id\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" required=\"true\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\" />\n        <message type=\"Update\" />\n        <message type=\"Complete\" />\n      </messages>\n      <dependents />\n    </task>\n      \n        \n      \n        \n      \n        \n      \n        \n      \n        <task name=\"Format Answers\" y=\"22\" x=\"308\" id=\"kinetic_request_submission_format_answers_html_v3_13\" definition_id=\"kinetic_request_submission_format_answers_html_v3\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter label=\"Starting Question:\" id=\"start\" tooltip=\"The menu label of the first question that should be formatted.  If this is left blank, the first question on the service item will be used.\" required=\"false\" menu=\"\">Locations</parameter>\n        <parameter label=\"Ending Question:\" id=\"end\" tooltip=\"The menu label of the last question that should be formatted.  If this is left blank, the last question on the service item will be used.\" required=\"false\" menu=\"\">Request Details</parameter>\n        <parameter label=\"Included Questions:\" id=\"include\" tooltip=\"A comma separated list of question menu labels that should be explicitely included in the question list.  Questions included in this list will be included even if they do not exist between the starting and ending questions.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" required=\"false\" menu=\"\" />\n        <parameter label=\"Excluded Questions:\" id=\"exclude\" tooltip=\"A comma separated list of question menu labels that should be explicitely excluded in the question list.  Questions included in this list will be excluded even if they exist between the starting and ending questions or are included in the 'Included Question' parameter.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" required=\"false\" menu=\"\" />\n\t\t<parameter label=\"Survey/Request Instance ID:\" id=\"csrvId\" tooltip=\"Instance ID of the survey/request to retrieve answers for\" required=\"true\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter label=\"Heading table structure:\" id=\"h_table_structure\" tooltip=\"header table structure\" required=\"false\" menu=\"\" />\n\t\t<parameter label=\"Question table tag open:\" id=\"q_table_wrapper_open\" tooltip=\"opening table tag and styling\" required=\"false\" menu=\"\">&lt;table&gt;</parameter>\n\t\t<parameter label=\"Question table tbody tag open:\" id=\"q_tbody_wrapper_open\" tooltip=\"opening table tag and styling\" required=\"false\" menu=\"\">&lt;tbody&gt;</parameter>\n\t\t<parameter label=\"Question table tr tag open:\" id=\"q_tr_wrapper_open\" tooltip=\"opening tr tag and styling\" required=\"false\" menu=\"\">&lt;tr&gt;</parameter>\n\t\t<parameter label=\"Question table label td tag open:\" id=\"q_td_qlabel_wrapper_open\" tooltip=\"opening question label td tag and styling\" required=\"false\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter label=\"Question table label td tag close:\" id=\"q_td_qlabel_wrapper_close\" tooltip=\"closing question label td tag\" required=\"false\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter label=\"Question table answer td tag open:\" id=\"q_td_qanswer_wrapper_open\" tooltip=\"opening question answer td tag and styling\" required=\"false\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter label=\"Question table answer td tag close:\" id=\"q_td_qanswer_wrapper_close\" tooltip=\"closing question answer td tag\" required=\"false\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter label=\"Question table tr tag close:\" id=\"q_tr_wrapper_close\" tooltip=\"closing tr tag\" required=\"false\" menu=\"\">&lt;/tr&gt;</parameter>\n\t\t<parameter label=\"Question table tbody tag close:\" id=\"q_tbody_wrapper_close\" tooltip=\"closing body tag\" required=\"false\" menu=\"\">&lt;/tbody&gt;</parameter>\n\t\t<parameter label=\"Question table tag close:\" id=\"q_table_wrapper_close\" tooltip=\"closing table tag\" required=\"false\" menu=\"\">&lt;/table&gt;</parameter>\n\t\t\t\n    </parameters><messages>\n        <message type=\"Create\" />\n        <message type=\"Update\" />\n        <message type=\"Complete\" />\n      </messages>\n      <dependents><task type=\"Complete\" value=\"\" label=\"\">bbb_itsm7_incident_templated_create_id_v1_14</task></dependents>\n    </task>\n      \n        <task name=\"Create Incident\" y=\"141\" x=\"414\" id=\"bbb_itsm7_incident_templated_create_id_v1_14\" definition_id=\"bbb_itsm7_incident_templated_create_id_v1\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>true</defers>\n      <deferrable>true</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter label=\"Incident Template Name:\" id=\"incident_template_name\" tooltip=\"The name of the incident template to submit with.\" required=\"true\" menu=\"\">Web Submitted Incident</parameter>\n        <parameter label=\"Requester First Name:\" id=\"requester_first_name\" tooltip=\"The value placed in the First Name field on the Incident form.\" required=\"true\" menu=\"\">&lt;%=@answers['ReqFor_First Name']%&gt;</parameter>\n        <parameter label=\"Requester Last Name:\" id=\"requester_last_name\" tooltip=\"The value placed in the Last Name field on the Incident form.\" required=\"true\" menu=\"\">&lt;%=@answers['ReqFor_Last Name']%&gt;</parameter>\n       <parameter label=\"Submitter Login Id:\" id=\"submitter_login_id\" tooltip=\"The value placed in the Submitter field on the Incident form.\" required=\"true\" menu=\"\">&lt;%=@answers['Req Login ID']%&gt;</parameter>\n\t<parameter label=\"Summary:\" id=\"summary\" tooltip=\"The value placed in the Summary field on the Incident form.\" required=\"false\" menu=\"\" />\n\t<parameter label=\"Notes:\" id=\"notes\" tooltip=\"The value placed in the Notes field on the Incident form.\" required=\"false\" menu=\"\">Details below:\n\n&lt;%=@results['Format Answers']['textresult']%&gt;</parameter>\n\t<parameter label=\"Service Type:\" id=\"service_type\" tooltip=\"The Service Type (eg. User Service Request or User Service Restoration) value placed in the Notes field on the Incident form.\" required=\"false\" menu=\"\" />\n\t<parameter label=\"Impact:\" id=\"impact\" tooltip=\"Should be exactly equal to the text visible in Remedy for this field.\" required=\"false\" menu=\"\" />\n\t<parameter label=\"Urgency:\" id=\"urgency\" tooltip=\"Should be exactly equal to the text visible in Remedy for this field.\" required=\"false\" menu=\"\" />\n\t<parameter label=\"Survey ID (KSR #):\" id=\"surveyid\" tooltip=\"The value placed in the SRID field on the Incident form.\" required=\"true\" menu=\"\">&lt;%=@dataset['Originating ID-Display']%&gt;</parameter>\n    <parameter label=\"Survey Instance ID:\" id=\"srinstanceid\" tooltip=\"The value placed in the SRInstanceID field on the Incident form.\" required=\"true\" menu=\"\">&lt;%=@source['Id']%&gt;</parameter>\n    <parameter label=\"Incident ID:\" id=\"incident_id\" tooltip=\"The Incident Number to push\" required=\"true\" menu=\"\">&lt;%=@answers['Incident Number']%&gt;</parameter>\n\n    </parameters><messages>\n        <message type=\"Create\" />\n        <message type=\"Update\" />\n        <message type=\"Complete\" />\n      </messages>\n      <dependents><task type=\"Complete\" value=\"\" label=\"\">kinetic_request_submission_close_v1_8</task><task type=\"Create\" value=\"\" label=\"\">kinetic_request_submission_update_status_v1_7</task><task type=\"Create\" value=\"&lt;%= !@answers['Attachment'].nil? %&gt;\" label=\"File Attached\">bmc_itsm7_incident_work_info_create_v5_15</task></dependents>\n    </task>\n      <task name=\"Attach Worklog\" y=\"295.19\" x=\"240.52\" id=\"bmc_itsm7_incident_work_info_create_v5_15\" definition_id=\"bmc_itsm7_incident_work_info_create_v5\">\n      <version>5</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter label=\"Incident Number:\" id=\"incident_number\" tooltip=\"The incident number of the Incident to associate the Incident Work Info entry with.\" required=\"true\" menu=\"\">&lt;%=@results['Create Incident']['Incident Number']%&gt;</parameter>\n        <parameter label=\"Include Review Request:\" id=\"include_review_request\" tooltip=\"Option to prepend the review request URL to the Notes of the Incident Work Info entry.\" required=\"true\" menu=\"Yes,No\">No</parameter>\n        <parameter label=\"Include Question Answers:\" id=\"include_question_answers\" tooltip=\"Option to append the question answer pairs to the Notes of the Incident Work Info entry.\" required=\"true\" menu=\"Yes,No\">No</parameter>\n        <parameter label=\"Work Info Type:\" id=\"work_info_type\" tooltip=\"Work Info Type.\" required=\"true\" menu=\"\">Customer Follow-up</parameter>\n\t\t<parameter label=\"Work Info Summary:\" id=\"work_info_summary\" tooltip=\"Sets the Summary of the Incident Work Info entry.\" required=\"true\" menu=\"\">Customer attached files</parameter>\n        <parameter label=\"Work Info Notes:\" id=\"work_info_notes\" tooltip=\"Sets the Notes of the Incident Work Info entry.\" required=\"false\" menu=\"\">This file was attached by the customer</parameter>\n        <parameter label=\"Work Info Submit Date:\" id=\"work_info_submit_date\" tooltip=\"Sets the Date of the Incident Work Info entry.\" required=\"false\" menu=\"\" />\n        <parameter label=\"Attachment Question Menu Label 1:\" id=\"attachment_question_menu_label_1\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" required=\"false\" menu=\"\">Attachment</parameter>\n        <parameter label=\"Attachment Question Menu Label 2:\" id=\"attachment_question_menu_label_2\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" required=\"false\" menu=\"\" />\n        <parameter label=\"Attachment Question Menu Label 3:\" id=\"attachment_question_menu_label_3\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" required=\"false\" menu=\"\" />\n        <parameter label=\"Submitter:\" id=\"submitter\" tooltip=\"Sets the Submitter of the Incident Work Info entry.\" required=\"false\" menu=\"\" />\n\t\t<parameter label=\"Locked:\" id=\"secure_work_log\" tooltip=\"Sets the Incident Work Info entry Locked status.\" required=\"true\" menu=\"Yes,No\">Yes</parameter>\t\t\t\t   \n        <parameter label=\"View Access:\" id=\"view_access\" tooltip=\"Sets the Incident Work Info entry to Public or Internal.\" required=\"true\" menu=\"\">Public</parameter>\n\t\t<parameter label=\"Customer Survey Instance ID:\" id=\"customer_survey_instance_id\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\" required=\"true\" menu=\"\">&lt;%=@dataset['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter label=\"Survey Template Instance ID:\" id=\"survey_template_instance_id\" tooltip=\"The survey template instance ID related to the Customer Survey Instance ID.\" required=\"true\" menu=\"\">&lt;%=@dataset['Survey Instance ID']%&gt;</parameter>\n\t\t<parameter label=\"Default Web Server:\" id=\"default_web_server\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\" required=\"true\" menu=\"\">&lt;%=@appconfig['Default Web Server']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\" />\n        <message type=\"Update\" />\n        <message type=\"Complete\" />\n      </messages>\n      <dependents />\n    </task></request>\n</taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
