service_item "Approvals" do
  catalog "Lahey IT Services"
  categories ""
  type "Approval"
  description "Approval Template used for reviewing and approving requests."
  display_page "/themes/simple-bright/packages/base/approval.jsp"
  display_name "Lahey-Approval"
  header_content nil
  web_server "http://wvremmidt01g1.laheyheath.org:8090/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority nil
  allow_anonymous true
  page "Initial Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
    section  "Approval"
    question "Approve or Deny", "Approve or Deny", :list,
      :list_box,
      :vertical,
      :required,
      :answer_mapping => "Validation Status",
      :choice_list => "Approval",
      :required_text => "Please Approve or Deny the Request",
      :field_map_number => "1" do
      choice "Approved"
      choice "Denied"
      event "Denial Reason",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value== \"Denied\" " do
        target "Please give a reason for denial",
          :question,
          :insert
      end
      event "Approval",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value != \"Denied\"" do
        target "Please give a reason for denial",
          :question,
          :remove
      end
    end
    question "Please give a reason for denial", "Please give a reason for denial", :free_text,
      :removed,
      :answer_mapping => "Attribute 3",
      :size => "20",
      :rows => "1",
      :field_map_number => "2"
    question "Approver Full Name", "Approver Full Name", :free_text,
      :removed,
      :advance_default,
      :answer_mapping => "Attribute9",
      :default_form => "CTM:People",
      :default_field => "Full Name",
      :default_qual => "'Remedy Login ID' = \"$\\USER$\"",
      :size => "20",
      :rows => "1",
      :field_map_number => "3"
    question "Originating Request", "Originating Request", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "4"
  end
  page "Confirmation",
    :confirmation,
    :vertical_buttons,
    :submit_button_value => "Submit",
    :display_page => "/themes/flat-bootstrap3/packages/base/approval-confirmation.jsp" do
  end
  task_tree "Update Approval",
    :type => "Complete",
    :xml => "<taskTree schema_version=\"1.0\" version=\"\" builder_version=\"3.1.0\"><name>Update Approval</name><author/><notes/><lastID>5</lastID><request><task name=\"Start\" id=\"start\" definition_id=\"system_start_v1\" x=\"40\" y=\"30\"><version>1</version><configured>true</configured><defers>false</defers><deferrable>false</deferrable><visible>false</visible><parameters/><messages/><dependents><task type=\"Complete\" label=\"\" value=\"\">utilities_create_trigger_v1_1</task></dependents></task>\n        <task name=\"Create Approval Trigger\" id=\"utilities_create_trigger_v1_1\" definition_id=\"utilities_create_trigger_v1\" x=\"315.6875\" y=\"123.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>true</visible>\n      <parameters>\n        <parameter required=\"true\" id=\"action_type\" label=\"Action Type\" menu=\"Root,Update,Complete\" tooltip=\"\">Complete</parameter>\n        <parameter required=\"true\" id=\"deferral_token\" label=\"Deferral Token\" tooltip=\"\" menu=\"\">&lt;%=@dataset['Token']%&gt;</parameter>\n        <parameter id=\"deferred_variables\" label=\"Deferred Results\" required=\"false\" tooltip=\"\" menu=\"\">&lt;results&gt;\n     &lt;result name='Validation Status'&gt;\n&lt;%=@answers['Approve or Deny']%&gt;&lt;/result&gt;\n   &lt;/results&gt;</parameter>\n        <parameter id=\"message\" label=\"Message\" required=\"false\" tooltip=\"\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_update_status_v1_2</task></dependents>\n    </task>\n      \n        <task name=\"Update Request Status\" id=\"kinetic_request_submission_update_status_v1_2\" definition_id=\"kinetic_request_submission_update_status_v1\" x=\"587.6875\" y=\"196.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" menu=\"\">&lt;%=@answers['Approve or Deny']%&gt;</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" menu=\"\">&lt;%=@dataset['Originating ID']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_close_v1_3</task></dependents>\n    </task>\n      \n        <task name=\"Close Approval\" id=\"kinetic_request_submission_close_v1_3\" definition_id=\"kinetic_request_submission_close_v1\" x=\"451.6875\" y=\"293.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" menu=\"\">&lt;%=@answers['Approve or Deny']%&gt;</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">bbb_close_all_open_approvals_v1_5</task></dependents>\n    </task>\n      \n        \n      \n        <task name=\"Close Other Open Approvals\" id=\"bbb_close_all_open_approvals_v1_5\" definition_id=\"bbb_close_all_open_approvals_v1\" x=\"549.6875\" y=\"357.703125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" menu=\"\">&lt;%=@answers['Approve or Deny']%&gt;</parameter>\n        <parameter id=\"submission_id\" label=\"Originating Id:\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" menu=\"\">&lt;%=@base['OriginatingID']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      </request></taskTree>",
    :description => "Kinetic Task Process Tree",
    :notes => "A new task process"
end
