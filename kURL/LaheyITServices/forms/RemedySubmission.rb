service_item "Remedy Submission" do
  catalog "Lahey IT Services"
  categories ""
  type "System Generated"
  description nil
  display_page "/themes/simple-bright/packages/base/display.jsp"
  display_name nil
  header_content nil
  web_server "http://kinetic-server:8090/catalog/"
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority nil
  allow_anonymous true
  task_engine "Kinetic Task 2/3"
  page "Initial Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
  end
end
