service_item "Send an Update" do
  catalog "Lahey IT Services"
  categories "Issue Reporting"
  type "Utility"
  description "Submit a help ticket to the Support Center!"
  display_page "/themes/simple-bright/packages/base/display.jsp"
  display_name "Lahey-Update"
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
      custom_code "keg.startTemplate(); keg.Request.setQuestionsFromParams();"
      bridged_resource "People",
        :qualification => "Raw"
    end
    section  "Requested For Section",
      :removed,
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
          :qualification => "'Person ID' = \"<FLD>Search By Person ID;KSf6a22888257c61bc3c6abd2f2effc8dbc;ANSWER</FLD>\""
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
    section  "User Update",
      :style_class => " form-section "
    text "Provide Details", "<i class=\"fa fa-clipboard section-header-icon\"></i><h2 class=\"section-header-title\">Provide Details</h2>",
      :style_class => " section-header "
    question "Ticket Number", "Ticket Number", :free_text,
      :required,
      :read_only,
      :size => "20",
      :rows => "1",
      :field_map_number => "4"
    question "User Comments", "Type your update here", :free_text,
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
    :display_page => "/themes/simple-bright/packages/base/update-confirmation.jsp" do
  end
  task_tree "User Update",
    :type => "Complete",
    :xml => "<taskTree version=\"\" builder_version=\"\" schema_version=\"1.0\">\n    <name>User Update</name>\n    <author/>\n    <notes/>\n    <lastID>20</lastID>\n    <request>\n        <task name=\"Start\" definition_id=\"system_start_v1\" id=\"start\" x=\"17\" y=\"18\">\n            <version>1</version>\n            <configured>true</configured>\n            <defers>false</defers>\n            <deferrable>false</deferrable>\n            <visible>false</visible>\n            <parameters/>\n            <messages/>\n            <dependents>\n                \n            <task type=\"Complete\" value=\"@answers['Ticket Number'].include? &quot;INC0&quot;\" label=\"Includes Incident Number\">bmc_itsm7_incident_work_info_create_v5_15</task><task type=\"Complete\" label=\"Includes Request ID\" value=\"@answers['Ticket Number'].include? &quot;KSR0&quot;\">col_itsm_generic_find_v1_17</task></dependents>\n        </task>\n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        <task name=\"Request Complete\" definition_id=\"kinetic_request_submission_close_v1\" id=\"kinetic_request_submission_close_v1_8\" x=\"101.72\" y=\"379.85\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter label=\"Validation Status:\" id=\"validation_status\" menu=\"\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\">Complete</parameter>\n        <parameter label=\"Submission Id:\" id=\"submission_id\" menu=\"\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters>\n            <messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      \n        \n      <task name=\"Attach Incident Worklog\" definition_id=\"bmc_itsm7_incident_work_info_create_v5\" id=\"bmc_itsm7_incident_work_info_create_v5_15\" x=\"174.65\" y=\"228.66\">\n      <version>5</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter label=\"Incident Number:\" id=\"incident_number\" menu=\"\" required=\"true\" tooltip=\"The incident number of the Incident to associate the Incident Work Info entry with.\">&lt;%=@answers['Ticket Number']%&gt;</parameter>\n        <parameter label=\"Include Review Request:\" id=\"include_review_request\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to prepend the review request URL to the Notes of the Incident Work Info entry.\">No</parameter>\n        <parameter label=\"Include Question Answers:\" id=\"include_question_answers\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to append the question answer pairs to the Notes of the Incident Work Info entry.\">No</parameter>\n        <parameter label=\"Work Info Type:\" id=\"work_info_type\" menu=\"\" required=\"true\" tooltip=\"Work Info Type.\">Customer Follow-up</parameter>\n\t\t<parameter label=\"Work Info Summary:\" id=\"work_info_summary\" menu=\"\" required=\"true\" tooltip=\"Sets the Summary of the Incident Work Info entry.\">User Update</parameter>\n        <parameter label=\"Work Info Notes:\" id=\"work_info_notes\" menu=\"\" required=\"false\" tooltip=\"Sets the Notes of the Incident Work Info entry.\">&lt;%=@answers['User Comments']%&gt;</parameter>\n        <parameter label=\"Work Info Submit Date:\" id=\"work_info_submit_date\" menu=\"\" required=\"false\" tooltip=\"Sets the Date of the Incident Work Info entry.\"/>\n        <parameter label=\"Attachment Question Menu Label 1:\" id=\"attachment_question_menu_label_1\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\">&lt;% if !@answers['Attachment'].nil? %&gt;Attachment&lt;% end %&gt;</parameter>\n        <parameter label=\"Attachment Question Menu Label 2:\" id=\"attachment_question_menu_label_2\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\"/>\n        <parameter label=\"Attachment Question Menu Label 3:\" id=\"attachment_question_menu_label_3\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\"/>\n        <parameter label=\"Submitter:\" id=\"submitter\" menu=\"\" required=\"false\" tooltip=\"Sets the Submitter of the Incident Work Info entry.\"/>\n\t\t<parameter label=\"Locked:\" id=\"secure_work_log\" menu=\"Yes,No\" required=\"true\" tooltip=\"Sets the Incident Work Info entry Locked status.\">Yes</parameter>\t\t\t\t   \n        <parameter label=\"View Access:\" id=\"view_access\" menu=\"\" required=\"true\" tooltip=\"Sets the Incident Work Info entry to Public or Internal.\">Public</parameter>\n\t\t<parameter label=\"Customer Survey Instance ID:\" id=\"customer_survey_instance_id\" menu=\"\" required=\"true\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\">&lt;%=@dataset['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter label=\"Survey Template Instance ID:\" id=\"survey_template_instance_id\" menu=\"\" required=\"true\" tooltip=\"The survey template instance ID related to the Customer Survey Instance ID.\">&lt;%=@dataset['Survey Instance ID']%&gt;</parameter>\n\t\t<parameter label=\"Default Web Server:\" id=\"default_web_server\" menu=\"\" required=\"true\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\">&lt;%=@appconfig['Default Web Server']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" value=\"\" label=\"\">kinetic_request_submission_close_v1_8</task></dependents>\n    </task><task name=\"Attach WorkOrder Worklog\" definition_id=\"bmc_itsm7_work_order_work_info_create_v2\" id=\"bmc_itsm7_work_order_work_info_create_v2_16\" x=\"710\" y=\"389\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n\t\t<parameter label=\"Work Order ID:\" id=\"work_order_id\" menu=\"\" required=\"true\" tooltip=\"The work order id number of the work order to associate the Work Order Work Info entry with.\">&lt;%=@entryID%&gt;</parameter>\n        <parameter label=\"Include Review Request:\" id=\"include_review_request\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to prepend the review request URL to the Notes of the Work Order Work Info entry.\">No</parameter>\n        <parameter label=\"Include Question Answers:\" id=\"include_question_answers\" menu=\"Yes,No\" required=\"true\" tooltip=\"Option to append the question answer pairs to the Notes of the Work Order Work Info entry.\">No</parameter>\n        <parameter label=\"Work Info Summary:\" id=\"work_info_summary\" menu=\"\" required=\"true\" tooltip=\"Sets the Summary of the Work Order Work Info entry.\">Customer Follow-up</parameter>\n        <parameter label=\"Work Info Notes:\" id=\"work_info_notes\" menu=\"\" required=\"false\" tooltip=\"Sets the Notes of the Work Order Work Info entry.\">&lt;%=@answers['User Comments']%&gt;</parameter>\n        <parameter label=\"Work Info Submit Date:\" id=\"work_info_submit_date\" menu=\"\" required=\"false\" tooltip=\"Sets the Date of the Work Order Work Info entry.\"/>\n        <parameter label=\"Attachment Question Menu Label 1:\" id=\"attachment_question_menu_label_1\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\">&lt;% if !@answers['Attachment'].nil? %&gt;Attachment&lt;% end %&gt;</parameter>\n        <parameter label=\"Attachment Question Menu Label 2:\" id=\"attachment_question_menu_label_2\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\"/>\n        <parameter label=\"Attachment Question Menu Label 3:\" id=\"attachment_question_menu_label_3\" menu=\"\" required=\"false\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\"/>\n        <parameter label=\"Submitter:\" id=\"submitter\" menu=\"\" required=\"false\" tooltip=\"Sets the Submitter of the Work Order Work Info entry.\"/>\n        <parameter label=\"Locked:\" id=\"secure_work_log\" menu=\"Yes,No\" required=\"true\" tooltip=\"Sets the Work Order Work Info entry Locked status.\">Yes</parameter>\t\t\t\t   \n        <parameter label=\"View Access:\" id=\"view_access\" menu=\"Public,Internal\" required=\"true\" tooltip=\"Sets the Work Order Work Info entry to Public or Internal.\">Public</parameter>\t\t\t\t   \n        <parameter label=\"Work Info Source:\" id=\"work_info_source\" menu=\"\" required=\"true\" tooltip=\"Sets the Work Order Work Info Communication Source value.  Options include to Email, Fax, Phone, Voice Mail, Walk In, Pager, System Assignment, Web, and Other.\">Web</parameter>\n        <parameter label=\"Work Info Type:\" id=\"work_info_type\" menu=\"\" required=\"true\" tooltip=\"Sets the Work Order Work Info Type value.  Many options exist for this field.  The most commonly used is 'General Information'\">Customer Follow-up</parameter>\n\t\t<parameter label=\"Source Instance ID:\" id=\"source_instance_id\" menu=\"\" required=\"true\" tooltip=\"The instance id of the submission you want data returned from.  Typically the originating service item in a parent/child scenario.\">&lt;%=@dataset['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter label=\"Source Survey Template ID:\" id=\"survey_template_instance_id\" menu=\"\" required=\"true\" tooltip=\"The instance id of the survey template you want data returned from.\">&lt;%=@dataset['Survey Instance ID']%&gt;</parameter>\n\t\t<parameter label=\"Default Web Server:\" id=\"default_web_server\" menu=\"\" required=\"true\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\">&lt;%=@appconfig['Default Web Server']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_loop_tail_v1_19</task></dependents>\n    </task>\n        <task name=\"Find Matching Work Orders\" id=\"col_itsm_generic_find_v1_17\" definition_id=\"col_itsm_generic_find_v1\" x=\"363\" y=\"50\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter id=\"form\" label=\"Remedy Form:\" required=\"true\" tooltip=\"Remedy Form Name (not display name), eg. People is CTM:People\" menu=\"\">WOI:Work Order</parameter>\n        <parameter id=\"query\" label=\"Query:\" required=\"true\" tooltip=\"The query to search by\" menu=\"\">'SRID' = \"&lt;%=@answers['Ticket Number']%&gt;\"</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_loop_head_v1_18</task></dependents>\n    </task>\n      \n        <task name=\"Begin Loop of matching Work Orders\" id=\"system_loop_head_v1_18\" definition_id=\"system_loop_head_v1\" x=\"698\" y=\"6\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"data_source\" label=\"Data Source:\" required=\"true\" tooltip=\"The source that contains the data to use to create each task in the loop.\" menu=\"\">&lt;%=@results['Find Matching Work Orders']['EntryIdList']%&gt;</parameter>\n        <parameter id=\"loop_path\" label=\"Loop Path:\" required=\"true\" tooltip=\"The XPath statement to indicate what data records to process.\" menu=\"\">//EntryIdList/Entry_Ids</parameter>\n        <parameter id=\"var_name\" label=\"Variable Name:\" required=\"true\" tooltip=\"The local variable name used to represent the data used in loop tasks.\" menu=\"\">entryID</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">bmc_itsm7_work_order_work_info_create_v2_16</task></dependents>\n    </task>\n      \n        <task name=\"End Loop of matching Work Orders\" id=\"system_loop_tail_v1_19\" definition_id=\"system_loop_tail_v1\" x=\"353\" y=\"382\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"type\" label=\"Type:\" menu=\"All,Some,Any\" required=\"true\" tooltip=\"How many loop processes must be completed before continuing?\">All</parameter>\n        <parameter dependsOnId=\"type\" dependsOnValue=\"Some\" id=\"number\" label=\"Number:\" tooltip=\"If some, how many?\" required=\"false\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">col_itsm_generic_find_v1_17</task></dependents>\n    </task>\n      \n        <task name=\"Work Orders can have many:1 cardinality with KSRs, so we loop for any matches, and attach the worklog to them. This will need to be changed eventually.\" id=\"system_noop_v1_20\" definition_id=\"system_noop_v1\" x=\"526\" y=\"97\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters/><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      </request>\n</taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
