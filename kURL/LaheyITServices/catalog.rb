catalog "Lahey IT Services",
  :description => "BedBath Service Portal",
  :web_server_url => "http://kinetic-server/catalog/",
  :display_page => "/themes/simple-bright/packages/base/display.jsp",
  :assignee_group => "0;",
  :management_group => "Public" do
  category "Applications",
    :active,
    :description => "Use these requests to make requests related to any applications you use."
  logout_action :go_to_template,
     :template_name => "Home",
     :catalog_name => "Lahey IT Services"
end
