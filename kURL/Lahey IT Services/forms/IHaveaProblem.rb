service_item "I Have a Problem" do
  catalog "Lahey IT Services"
  categories "Security Requests"
  type "Template"
  description "Submit a help ticket to the Support Center!"
  display_page "/themes/simple-bright/packages/base/display.jsp"
  display_name "Lahey-ReportIncident"
  header_content nil
  web_server "http://wvremmidt01g1.laheyheath.org:8090/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority nil
  allow_anonymous true
  attribute "Review JSP", "themes/flat-bootstrap3/packages/base/review.jsp"
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
          :qualification => "'Person ID' = \"<FLD>Search By Person ID;KS4cfea9fdf0f8fde44ca73ffa64b937b26;ANSWER</FLD>\""
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
      :horizontal,
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
  end
  page "Confirmation",
    :confirmation,
    :vertical_buttons,
    :submit_button_value => "Submit",
    :display_page => "/themes/flat-bootstrap3/packages/base/confirmation.jsp" do
  end
  task_tree "Info Sec General Request",
    :type => "Complete",
    :xml => "<taskTree builder_version=\"3.1.0\" schema_version=\"1.0\" version=\"\">\n    <name>Info Sec General Request</name>\n    <author/>\n    <notes/>\n    <lastID>13</lastID>\n    <request>\n        <task definition_id=\"system_start_v1\" id=\"start\" name=\"Start\" x=\"17\" y=\"18\">\n            <version>1</version>\n            <configured>true</configured>\n            <defers>false</defers>\n            <deferrable>false</deferrable>\n            <visible>false</visible>\n            <parameters/>\n            <messages/>\n            <dependents>\n                \n            <task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_format_answers_html_v3_13</task></dependents>\n        </task>\n        <task definition_id=\"bmc_srm_templated_work_order_create_v3\" id=\"bmc_srm_templated_work_order_create_v3_1\" name=\"Work Order\" x=\"494\" y=\"229.703125\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>true</defers>\n      <deferrable>true</deferrable>\n      <visible>true</visible>\n      <parameters>\n\t\t<parameter id=\"work_order_template\" label=\"Work Order Template:\" menu=\"\" required=\"true\" tooltip=\"Name of the work order template to be used.\">InfoSec General Request</parameter>\n\t\t<parameter id=\"work_order_summary\" label=\"Work Order Summary:\" menu=\"\" required=\"false\" tooltip=\"The value placed in the Summary field on the Work Order form. Leave empty to use the Summary defined in the WO Template.\">General Security Request for &lt;%=@answers['ReqFor_First Name']%&gt; &lt;%=@answers['ReqFor_Last Name']%&gt;</parameter>\n\t\t<parameter id=\"work_order_notes\" label=\"Work Order Notes:\" menu=\"\" required=\"false\" tooltip=\"The value placed in the Notes field on the Work Order form. Leave empty to use the Notes defined in the WO Template.\">See request details below:\nDate Required: &lt;%=@answers['Date Required']%&gt;\nProject ID: &lt;%=@answers['Project ID']%&gt;\nBusiness Reason: &lt;%=@answers['Reason for Request']%&gt;\nDetails: \n&lt;%=@answers['Request Details']%&gt;</parameter>\n\t\t<parameter id=\"requester_login_id\" label=\"Requester Login Id:\" menu=\"\" required=\"true\" tooltip=\"Login Id of the person making the request. This will be used to retrive the Person ID and place it in the Customer People ID field.\">&lt;%=@answers['ReqFor_Login ID']%&gt;</parameter>\n\t\t<parameter id=\"submitter_login_id\" label=\"Submitter Login Id:\" menu=\"\" required=\"true\" tooltip=\"Login Id of the person submitting the request. This will be used to retrive the Person ID and place it in the Requested By People ID field.\">&lt;%=@answers['Req Login ID']%&gt;</parameter>\n\t\t<parameter id=\"surveyid\" label=\"Survey ID (KSR #):\" menu=\"\" required=\"true\" tooltip=\"The value placed in the SRID field on the Work Order form.\">&lt;%=@dataset['Originating ID-Display']%&gt;</parameter>\n        <parameter id=\"srinstanceid\" label=\"Survey Instance ID:\" menu=\"\" required=\"true\" tooltip=\"The value placed in the SRInstanceID field on the Work Order form.\">&lt;%=@source['Id']%&gt;</parameter>\n\t\t<parameter id=\"wo_detail_field_value_1\" label=\"Detail Field 1 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 1 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_2\" label=\"Detail Field 2 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 2 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_3\" label=\"Detail Field 3 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 3 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_4\" label=\"Detail Field 4 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 4 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_5\" label=\"Detail Field 5 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 5 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_6\" label=\"Detail Field 6 Value (Datetime):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 6 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_7\" label=\"Detail Field 7 Value (Datetime):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 7 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_8\" label=\"Detail Field 8 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 8 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_9\" label=\"Detail Field 9 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 9 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_10\" label=\"Detail Field 10 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 10 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_11\" label=\"Detail Field 11 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 11 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_12\" label=\"Detail Field 12 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 12 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_13\" label=\"Detail Field 13 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 13 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_14\" label=\"Detail Field 14 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 14 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_15\" label=\"Detail Field 15 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 15 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_16\" label=\"Detail Field 16 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 16 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_17\" label=\"Detail Field 17 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 17 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_18\" label=\"Detail Field 18 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 18 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_19\" label=\"Detail Field 19 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 19 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_20\" label=\"Detail Field 20 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 20 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_21\" label=\"Detail Field 21 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 21 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_22\" label=\"Detail Field 22 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 22 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_23\" label=\"Detail Field 23 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 23 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_24\" label=\"Detail Field 24 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 24 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_25\" label=\"Detail Field 25 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 25 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_26\" label=\"Detail Field 26 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 26 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_27\" label=\"Detail Field 27 Value (Integer):\" menu=\"\" required=\"false\" tooltip=\"Value for Field 27 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_28\" label=\"Detail Field 28 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 28 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_29\" label=\"Detail Field 29 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 29 as sepcified in the WO Template Detail tab.\"/>\n\t\t<parameter id=\"wo_detail_field_value_30\" label=\"Detail Field 30 Value:\" menu=\"\" required=\"false\" tooltip=\"Value for Field 30 as sepcified in the WO Template Detail tab.\"/>\n\t</parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents>\n                <task label=\"\" type=\"Create\" value=\"\">kinetic_request_submission_update_status_v1_7</task>\n                <task label=\"\" type=\"Complete\" value=\"\">kinetic_request_submission_close_v1_8</task>\n            \n            </dependents>\n    </task>\n      \n        \n      \n        \n      \n        \n      \n        <task definition_id=\"kinetic_request_email_message_create_v2\" id=\"kinetic_request_email_message_create_v2_5\" name=\"Notify User Request Denied\" x=\"200.6875\" y=\"355.703125\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"to\" label=\"To:\" menu=\"\" required=\"true\" tooltip=\"The email address of the target recipient.\">&lt;%=@answers['Req Email Address']%&gt;</parameter>\n        <parameter id=\"message_template_name\" label=\"Message Template Name:\" menu=\"\" required=\"true\" tooltip=\"The name of the message template that will be used to generate the email message.\">Request Denied</parameter>\n        <parameter id=\"originating_id\" label=\"Originating Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of an originating Kinetic Request submission.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        <task definition_id=\"kinetic_request_submission_close_v1\" id=\"kinetic_request_submission_close_v1_6\" name=\"Close Request\" x=\"101.6875\" y=\"186.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">&lt;%=@results['Approval']['Approver Status']%&gt;</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents>\n                <task label=\"\" type=\"Complete\" value=\"\">kinetic_request_email_message_create_v2_5</task>\n            </dependents>\n    </task>\n      \n        <task definition_id=\"kinetic_request_submission_update_status_v1\" id=\"kinetic_request_submission_update_status_v1_7\" name=\"Update Status In Progress\" x=\"303.6875\" y=\"300.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">In Progress</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        <task definition_id=\"kinetic_request_submission_close_v1\" id=\"kinetic_request_submission_close_v1_8\" name=\"Request Complete\" x=\"399.6875\" y=\"300.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">Complete</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        \n      \n        \n      \n        \n      \n        <task name=\"Approval\" id=\"tree_create_user_approval_v1_12\" definition_id=\"tree_create_user_approval_v1\" x=\"345.6875\" y=\"81.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>true</defers>\n      <deferrable>true</deferrable>\n      <visible>false</visible>\n      <parameters>\n            <parameter id=\"Approver\" label=\"Approver\" required=\"true\" tooltip=\"Approver user ID\" menu=\"\">&lt;%=@answers['Approving Manager']%&gt;</parameter>\n            <parameter id=\"Submission ID\" label=\"Submission ID\" required=\"true\" tooltip=\"\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n            <parameter id=\"Deferral Token\" label=\"Deferral Token\" required=\"true\" tooltip=\"\" menu=\"\">&lt;%=@dataset['Token']%&gt;</parameter>\n            <parameter id=\"Approval Title\" label=\"Approval Title\" required=\"false\" tooltip=\"\" menu=\"\">General Manager Approval</parameter>\n            <parameter id=\"Questions HTML\" label=\"Questions HTML\" required=\"false\" tooltip=\"\" menu=\"\">&lt;%=@results['Format Answers']['result']%&gt;</parameter>\n        </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"Approved\" value=\"&lt;%=@results['Approval']['Approver Status'].gsub(&quot;\\n&quot;,'') == &quot;Approved&quot; %&gt;\">bmc_srm_templated_work_order_create_v3_1</task><task type=\"Complete\" label=\"Denied\" value=\"&lt;%=@results['Approval']['Approver Status'].gsub(&quot;\\n&quot;,'') == &quot;Denied&quot; %&gt;\">kinetic_request_submission_close_v1_6</task></dependents>\n    </task>\n      \n        <task name=\"Format Answers\" id=\"kinetic_request_submission_format_answers_html_v3_13\" definition_id=\"kinetic_request_submission_format_answers_html_v3\" x=\"159.6875\" y=\"53.703125\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"start\" label=\"Starting Question:\" required=\"false\" tooltip=\"The menu label of the first question that should be formatted.  If this is left blank, the first question on the service item will be used.\" menu=\"\"/>\n        <parameter id=\"end\" label=\"Ending Question:\" required=\"false\" tooltip=\"The menu label of the last question that should be formatted.  If this is left blank, the last question on the service item will be used.\" menu=\"\"/>\n        <parameter id=\"include\" label=\"Included Questions:\" required=\"false\" tooltip=\"A comma separated list of question menu labels that should be explicitely included in the question list.  Questions included in this list will be included even if they do not exist between the starting and ending questions.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" menu=\"\"/>\n        <parameter id=\"exclude\" label=\"Excluded Questions:\" required=\"false\" tooltip=\"A comma separated list of question menu labels that should be explicitely excluded in the question list.  Questions included in this list will be excluded even if they exist between the starting and ending questions or are included in the 'Included Question' parameter.  Whitespace matters; ensure there are no spaces after a comma separating the menu labels (unless the question menu label includes a preceding space).\" menu=\"\"/>\n\t\t<parameter id=\"csrvId\" label=\"Survey/Request Instance ID:\" required=\"true\" tooltip=\"Instance ID of the survey/request to retrieve answers for\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter id=\"h_table_structure\" label=\"Heading table structure:\" required=\"false\" tooltip=\"header table structure\" menu=\"\"/>\n\t\t<parameter id=\"q_table_wrapper_open\" label=\"Question table tag open:\" required=\"false\" tooltip=\"opening table tag and styling\" menu=\"\">&lt;table&gt;</parameter>\n\t\t<parameter id=\"q_tbody_wrapper_open\" label=\"Question table tbody tag open:\" required=\"false\" tooltip=\"opening table tag and styling\" menu=\"\">&lt;tbody&gt;</parameter>\n\t\t<parameter id=\"q_tr_wrapper_open\" label=\"Question table tr tag open:\" required=\"false\" tooltip=\"opening tr tag and styling\" menu=\"\">&lt;tr&gt;</parameter>\n\t\t<parameter id=\"q_td_qlabel_wrapper_open\" label=\"Question table label td tag open:\" required=\"false\" tooltip=\"opening question label td tag and styling\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter id=\"q_td_qlabel_wrapper_close\" label=\"Question table label td tag close:\" required=\"false\" tooltip=\"closing question label td tag\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter id=\"q_td_qanswer_wrapper_open\" label=\"Question table answer td tag open:\" required=\"false\" tooltip=\"opening question answer td tag and styling\" menu=\"\">&lt;td&gt;</parameter>\n\t\t<parameter id=\"q_td_qanswer_wrapper_close\" label=\"Question table answer td tag close:\" required=\"false\" tooltip=\"closing question answer td tag\" menu=\"\">&lt;/td&gt;</parameter>\n\t\t<parameter id=\"q_tr_wrapper_close\" label=\"Question table tr tag close:\" required=\"false\" tooltip=\"closing tr tag\" menu=\"\">&lt;/tr&gt;</parameter>\n\t\t<parameter id=\"q_tbody_wrapper_close\" label=\"Question table tbody tag close:\" required=\"false\" tooltip=\"closing body tag\" menu=\"\">&lt;/tbody&gt;</parameter>\n\t\t<parameter id=\"q_table_wrapper_close\" label=\"Question table tag close:\" required=\"false\" tooltip=\"closing table tag\" menu=\"\">&lt;/table&gt;</parameter>\n\t\t\t\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">tree_create_user_approval_v1_12</task></dependents>\n    </task>\n      </request>\n</taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
