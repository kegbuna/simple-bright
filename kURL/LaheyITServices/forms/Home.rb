service_item "Home" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "This is the home page"
  display_page "/themes/simple-bright/packages/catalog/home.jsp"
  display_name "Lahey-Home"
  header_content nil
  web_server "http://kinetic-server:8090/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority "5"
  allow_anonymous true
  form_type :launcher
  task_engine "Kinetic Task 2/3"
  page "Initial Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
  end
end
