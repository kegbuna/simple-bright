service_item "My Personal Details" do
  catalog "Lahey IT Services"
  categories ""
  type "Request"
  description "Update Personal Information"
  display_page "/themes/simple-bright/packages/catalog/profile.jsp"
  display_name "Simple-Profile"
  header_content nil
  web_server "http://kinetic-server/catalog/"
  authentication :default
  data_set "SYSTEM_DEFAULTS"
  visible_to_group "0;"
  management_group "Public"
  submission_group "Public"
  priority "5"
  allow_anonymous true
  page "Initial Page",
    :contents,
    :vertical_buttons,
    :submit_button_value => "Submit" do
    section  "User Information",
      :removed,
      :style_class => " border rounded "
    text "Section Title", "User Information",
      :style_class => " sectionHeader "
    question "Requester First Name", "First Name", :free_text,
      :required,
      :advance_default,
      :editor_label => "Req First Name",
      :answer_mapping => "First Name",
      :default_form => "KS_SAMPLE_People",
      :default_field => "First Name",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :max => "50",
      :required_text => "Requester First Name"
    question "Requester Last Name", "Last Name", :free_text,
      :required,
      :advance_default,
      :editor_label => "Req Last Name",
      :answer_mapping => "Last Name",
      :default_form => "KS_SAMPLE_People",
      :default_field => "Last Name",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :max => "100",
      :required_text => "Requester Last Name"
    question "Requester Email Address", "Email", :email,
      :required,
      :advance_default,
      :editor_label => "Req Email Address",
      :answer_mapping => "Contact Info Value",
      :default_form => "KS_SAMPLE_People",
      :default_field => "Email",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :required_text => "Requester Email",
      :pattern_label => "Standard Email Address",
      :pattern => "^[\\w-\\.]+\\@[\\w\\.-]+\\.[a-zA-Z]{2,4}$",
      :validation_text => "Requester Email Address (Standard Email Address)",
      :style_class => " email ",
      :field_map_number => "1"
    question "Address", "Address", :free_text,
      :advance_default,
      :default_form => "KS_SAMPLE_People",
      :default_field => "AddrLine1",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :field_map_number => "2"
    question "City", "City", :free_text,
      :advance_default,
      :default_form => "KS_SAMPLE_People",
      :default_field => "City",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :field_map_number => "3"
    question "State", "State", :free_text,
      :advance_default,
      :default_form => "KS_SAMPLE_People",
      :default_field => "State/Prov",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :field_map_number => "4"
    question "Zip", "Zip", :free_text,
      :advance_default,
      :default_form => "KS_SAMPLE_People",
      :default_field => "Postal Code",
      :default_qual => "'AR Login'=$\\USER$",
      :size => "20",
      :rows => "1",
      :field_map_number => "5"
  end
  page "Confirmation Page",
    :confirmation,
    :vertical_buttons,
    :submit_button_value => "Submit",
    :display_page => "/themes/flat-bootstrap3/packages/base/confirmation.jsp" do
    section  "Details"
  end
end
