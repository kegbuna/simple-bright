service_item "Category" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Catalog Portal Page"
  display_page "/themes/simple-bright/packages/catalog/category.jsp"
  display_name "Lahey-Category"
  header_content nil
  web_server "http://wvremmidt01g1.laheyheath.org:8090/catalog/"
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
