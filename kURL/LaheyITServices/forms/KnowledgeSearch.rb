service_item "Knowledge Search" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Catalog Search"
  display_page "/themes/simple-bright/packages/catalog/interface/callbacks/knowledgeSearch.jsp"
  display_name "Lahey-KS"
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
