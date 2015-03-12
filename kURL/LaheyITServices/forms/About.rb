service_item "About" do
  catalog "Lahey IT Services"
  categories ""
  type "Portal"
  description "Dynamic about page which allows for editing content"
  display_page "/themes/simple-bright/packages/catalog/about.jsp"
  display_name "Lahey-About"
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
  page "About Page",
    :contents,
    :horizontal_buttons,
    :submit_button_value => "Submit" do
    section  "About",
      :removed do
      style "min-height: 500px;"
    end
    text "Title", "<header>\n<h2>\nBed Bath and Beyond's IT Services\n</h2>\n<hr class=\"soften\">\n</header>"
    text "Information", "<div class=\"hoja\">Bed Bath</div>"
  end
end
