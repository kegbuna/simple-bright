service_item "Submission Activity" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Submission Activity Page"
  display_page "/themes/simple-bright/packages/submissions/submissionActivity.jsp"
  display_name "Simple-SubmissionsActivity"
  header_content nil
  web_server "http://kinetic-server/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority "5"
  allow_anonymous true
  page "Initial Page",
    :contents,
    :vertical_buttons,
    :submit_button_value => "Submit" do
    event "expose Bridge",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "Change",
        :qualification => "By Id"
    end
    event "expose WorkOrder",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "WorkOrder",
        :qualification => "By Id"
    end
    event "expose CHG Work Info",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "Change Work Info",
        :qualification => "By Change Id"
    end
    event "expose WorkOrder Work Info",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "WorkOrder Work Info",
        :qualification => "By WorkOrder Id"
    end
    event "Expose Incident Worklogs",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "Incident Work Info",
        :qualification => "By Incident Id"
    end
    event "expose Incident Model",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "1==1" do
      custom_code nil
      bridged_resource "Incident",
        :qualification => "By Id"
    end
    question "Worklog Text", "Worklog Text", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "1"
    question "Work Log Id", "Work Log Id", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "2"
    question "Worklog Form", "Worklog Form", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "3"
  end
  task_tree "Worklog Submission",
    :type => "Complete",
    :xml => "<taskTree schema_version=\"1.0\" version=\"\" builder_version=\"3.1.0\"><name>Worklog Submission</name><author/><notes/><lastID>1</lastID><request><task name=\"Start\" id=\"start\" definition_id=\"system_start_v1\" x=\"10\" y=\"10\"><version>1</version><configured>true</configured><defers>false</defers><deferrable>false</deferrable><visible>false</visible><parameters/><messages/><dependents><task type=\"Complete\" label=\"\" value=\"&lt;%= !@answers['Worklog Text'].nil? &amp;&amp; !@answers['Work Log Id'].nil? %&gt;\">bmc_itsm7_work_order_work_info_create_v2_1</task></dependents></task>\n        <task name=\"Create Work Log\" id=\"bmc_itsm7_work_order_work_info_create_v2_1\" definition_id=\"bmc_itsm7_work_order_work_info_create_v2\" x=\"229.6875\" y=\"50.703125\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n\t\t<parameter id=\"work_order_id\" required=\"true\" label=\"Work Order ID:\" tooltip=\"The work order id number of the work order to associate the Work Order Work Info entry with.\" menu=\"\">&lt;%=@answers['Work Log Id']%&gt;</parameter>\n        <parameter id=\"include_review_request\" required=\"true\" label=\"Include Review Request:\" tooltip=\"Option to prepend the review request URL to the Notes of the Work Order Work Info entry.\" menu=\"Yes,No\">Yes</parameter>\n        <parameter id=\"include_question_answers\" required=\"true\" label=\"Include Question Answers:\" tooltip=\"Option to append the question answer pairs to the Notes of the Work Order Work Info entry.\" menu=\"Yes,No\">Yes</parameter>\n        <parameter id=\"work_info_summary\" required=\"true\" label=\"Work Info Summary:\" tooltip=\"Sets the Summary of the Work Order Work Info entry.\" menu=\"\">Web submission</parameter>\n        <parameter id=\"work_info_notes\" required=\"false\" label=\"Work Info Notes:\" tooltip=\"Sets the Notes of the Work Order Work Info entry.\" menu=\"\">&lt;%=@answers['Worklog Text']%&gt;</parameter>\n        <parameter id=\"work_info_submit_date\" required=\"false\" label=\"Work Info Submit Date:\" tooltip=\"Sets the Date of the Work Order Work Info entry.\" menu=\"\"/>\n        <parameter id=\"attachment_question_menu_label_1\" required=\"false\" label=\"Attachment Question Menu Label 1:\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\"/>\n        <parameter id=\"attachment_question_menu_label_2\" required=\"false\" label=\"Attachment Question Menu Label 2:\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\"/>\n        <parameter id=\"attachment_question_menu_label_3\" required=\"false\" label=\"Attachment Question Menu Label 3:\" tooltip=\"The menu label of an attachment question to retrieve an attachment from.\" menu=\"\"/>\n        <parameter id=\"submitter\" required=\"false\" label=\"Submitter:\" tooltip=\"Sets the Submitter of the Work Order Work Info entry.\" menu=\"\"/>\n        <parameter id=\"secure_work_log\" required=\"true\" label=\"Locked:\" tooltip=\"Sets the Work Order Work Info entry Locked status.\" menu=\"Yes,No\">Yes</parameter>\t\t\t\t   \n        <parameter id=\"view_access\" required=\"true\" label=\"View Access:\" tooltip=\"Sets the Work Order Work Info entry to Public or Internal.\" menu=\"Public,Internal\">Public</parameter>\t\t\t\t   \n        <parameter id=\"work_info_source\" required=\"true\" label=\"Work Info Source:\" tooltip=\"Sets the Work Order Work Info Communication Source value.  Options include to Email, Fax, Phone, Voice Mail, Walk In, Pager, System Assignment, Web, and Other.\" menu=\"\">Web</parameter>\n        <parameter id=\"work_info_type\" required=\"true\" label=\"Work Info Type:\" tooltip=\"Sets the Work Order Work Info Type value.  Many options exist for this field.  The most commonly used is 'General Information'\" menu=\"\">General Information</parameter>\n\t\t<parameter id=\"source_instance_id\" required=\"true\" label=\"Source Instance ID:\" tooltip=\"The instance id of the submission you want data returned from.  Typically the originating service item in a parent/child scenario.\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n\t\t<parameter id=\"survey_template_instance_id\" required=\"true\" label=\"Source Survey Template ID:\" tooltip=\"The instance id of the survey template you want data returned from.\" menu=\"\">&lt;%=@dataset['Survey Instance ID']%&gt;</parameter>\n\t\t<parameter id=\"default_web_server\" required=\"true\" label=\"Default Web Server:\" tooltip=\"Instance ID of the submission that should be used to retrieve answers.\" menu=\"\">&lt;%=@appconfig['Default Web Server']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      </request></taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
