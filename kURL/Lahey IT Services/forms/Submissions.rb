service_item "Submissions" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Submissions"
  display_page "/themes/simple-bright/packages/submissions/submissionsDataTable.jsp"
  display_name "Simple-Submissions"
  header_content nil
  web_server "http://kinetic-server/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority "5"
  allow_anonymous true
  form_type :launcher
  page "Initial Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
  end
end
