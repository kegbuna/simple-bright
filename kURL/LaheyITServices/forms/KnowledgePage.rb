service_item "Knowledge Page" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "A portal to the Knowledge Management system."
  display_page "/themes/simple-bright/packages/catalog/knowledge.jsp"
  display_name "Lahey-KnowledgePage"
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
  page "Initial Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
  end
end
