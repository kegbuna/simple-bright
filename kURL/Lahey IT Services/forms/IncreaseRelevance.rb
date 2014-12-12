service_item "Increase Relevance" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "A portal to the Knowledge Management system."
  display_page "/themes/simple-bright/packages/rkm/interface/callbacks/incrementRelevance.jsp"
  display_name "incrementRelevance"
  header_content nil
  web_server "http://kinetic-server/catalog/"
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
  end
end
