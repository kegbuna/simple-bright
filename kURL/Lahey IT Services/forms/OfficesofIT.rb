service_item "Offices of IT" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Dynamic about page which allows for editing content"
  display_page "/themes/simple-bright/packages/catalog/offices.jsp"
  display_name "Simple-Offices"
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
  page "Offices of IT",
    :contents,
    :vertical_buttons,
    :submit_button_value => "Submit" do
    section  "About" do
      style "min-height: 500px;"
    end
  end
end
