catalog "Lahey IT Services",
  :description => "BedBath Service Portal",
  :web_server_url => "http://kinetic-server/catalog/",
  :display_page => "/themes/simple-bright/packages/base/display.jsp",
  :assignee_group => "0;",
  :management_group => "Public" do
  category "Hardware Requests",
    :active,
    :sort_order => "1",
    :icon_name => "Hardware Icon",
    :description => "This category groups together all service items that allow you to request IT hardware.  This includes items such as, PCs, laptops, MACs, printers, desk phones and associated peripherals. "
  category "Software Requests",
    :active,
    :sort_order => "3",
    :number_of_items => "0",
    :icon_name => "Software Icon",
    :description => "This category groups together service items that allow you to request desktop software or make miscellaneous software requests.  This does NOT include account access.  Account access request can be found under IT Security or by using the search bar using a keyword. "
  category "Mobility Requests",
    :active,
    :sort_order => "5",
    :icon_name => "poll image",
    :description => "This category groups together service items that pertain to cell phones and smart devices and the software associated with the BYOD program. This includes the Maas360 software which will give you corporate email on your mobile device."
  category "Onboarding",
    :active,
    :sort_order => "4",
    :icon_name => "Kinetic Request Gray Header",
    :description => "Forms needed for NEW associates and consultants to supply them with the necessary IT hardware, software and accounts.  "
  category "Security Requests",
    :active,
    :sort_order => "2",
    :description => "This category is used to acquire accounts or access to various systems.  If you're having trouble locating a specific system, many access types are bundled into the System Profile Request form.  Using the search bar with a keyword will also help to locate the access request form you need."
  category "Infrastructure Requests",
    :active,
    :sort_order => "6",
    :description => "This category groups together service items that allow you to request modifications to infrastructure systems."
  logout_action :go_to_template,
     :template_name => "Home",
     :catalog_name => "Simple"
end
