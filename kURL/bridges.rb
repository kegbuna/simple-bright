model {
  name "Broadcasts"
  status "Active"
  attribute {
    name "Broadcast Message"
  }
  attribute {
    name "BroadcastSubject"
  }
  attribute {
    name "End Date"
  }
  attribute {
    name "Start Date"
  }
  qualification {
    name "Available Broadcasts"
    result_type "Multiple"
  }
}
model {
  name "Tickets"
  status "Active"
  attribute {
    name "Description"
  }
  attribute {
    name "Detailed Description"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Submit Date"
  }
  attribute {
    name "Ticket ID"
  }
  qualification {
    name "All Incidents"
    result_type "Multiple"
  }
  qualification {
    name "by ID"
    result_type "Single"
    parameter {
      name "Ticket ID"
    }
  }
}
model {
  name "Service Requests"
  status "Active"
  attribute {
    name "CustomerSurveyID"
  }
  attribute {
    name "Root ID"
  }
  attribute {
    name "Survey_Template_Name"
  }
  attribute {
    name "Task Status"
  }
  attribute {
    name "Task_Type"
  }
  attribute {
    name "TaskName"
  }
  attribute {
    name "Type"
  }
  qualification {
    name "by User"
    result_type "Multiple"
    parameter {
      name "User"
    }
  }
}
model {
  name "Service Items"
  status "Active"
  attribute {
    name "Anonymous URL"
  }
  attribute {
    name "Category"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Survey Description"
  }
  attribute {
    name "Survey Template Name"
  }
  attribute {
    name "Type"
  }
  qualification {
    name "by Name"
    result_type "Multiple"
  }
}
model {
  name "Service Item Category"
  status "Active"
  attribute {
    name "Category"
  }
  attribute {
    name "CategoryDescription"
  }
  attribute {
    name "IconHTML"
  }
  attribute {
    name "Number of Items"
  }
  attribute {
    name "Service Catalog"
  }
  qualification {
    name "by Catalog"
    result_type "Multiple"
    parameter {
      name "Catalog"
    }
  }
}
model {
  name "Image Now Workflow Groups"
  status "Active"
  attribute {
    name "Group"
  }
  qualification {
    name "By Category"
    result_type "Multiple"
    parameter {
      name "Category"
    }
  }
}
model {
  name "Change"
  status "Active"
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "Priority"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Token"
  }
  qualification {
    name "By Id"
    result_type "Single"
    parameter {
      name "Id"
    }
  }
}
model {
  name "Change Work Info"
  status "Active"
  attribute {
    name "Attachment1"
  }
  attribute {
    name "Attachment2"
  }
  attribute {
    name "Attachment3"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "SubmitDate"
  }
  attribute {
    name "Submitter"
  }
  qualification {
    name "By Change Id"
    result_type "Multiple"
    parameter {
      name "Change Id"
    }
  }
}
model {
  name "JDA Levels"
  status "Active"
  attribute {
    name "Label"
  }
  attribute {
    name "Value"
  }
  qualification {
    name "By Concept"
    result_type "Multiple"
    parameter {
      name "Concept"
    }
  }
}
model {
  name "OutQs"
  status "Active"
  attribute {
    name "Label"
  }
  attribute {
    name "Value"
  }
  qualification {
    name "By Network"
    result_type "Multiple"
    parameter {
      name "Network"
    }
  }
}
model {
  name "Concepts"
  status "Active"
  attribute {
    name "Concept"
  }
  qualification {
    name "Enabled"
    result_type "Multiple"
  }
}
model {
  name "Sites"
  status "Active"
  attribute {
    name "Site Name"
  }
  qualification {
    name "Enabled"
    result_type "Multiple"
  }
}
model {
  name "WorkOrder"
  status "Active"
  attribute {
    name "Assigned Group"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Token"
  }
  qualification {
    name "By Id"
    result_type "Single"
    parameter {
      name "Id"
    }
  }
}
model {
  name "WorkOrder Work Info"
  status "Active"
  attribute {
    name "Attachment1"
  }
  attribute {
    name "Attachment2"
  }
  attribute {
    name "Attachment3"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "SubmitDate"
  }
  attribute {
    name "Submitter"
  }
  qualification {
    name "By WorkOrder Id"
    result_type "Multiple"
    parameter {
      name "Work Order Id"
    }
  }
}
model {
  name "Incident"
  status "Active"
  attribute {
    name "Assigned Group"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "Priority"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Token"
  }
  qualification {
    name "By Id"
    result_type "Single"
    parameter {
      name "Id"
    }
  }
}
model {
  name "Incident Work Info"
  status "Active"
  attribute {
    name "Attachment1"
  }
  attribute {
    name "Attachment2"
  }
  attribute {
    name "Attachment3"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Notes"
  }
  attribute {
    name "SubmitDate"
  }
  attribute {
    name "Submitter"
  }
  attribute {
    name "Summary"
  }
  qualification {
    name "By Incident Id"
    result_type "Multiple"
    parameter {
      name "Incident Id"
    }
  }
}
model {
  name "People"
  status "Active"
  attribute {
    name "Email Address"
  }
  attribute {
    name "First Name"
  }
  attribute {
    name "Full Name"
  }
  attribute {
    name "Last Name"
  }
  attribute {
    name "Login ID"
  }
  attribute {
    name "Person ID"
  }
  attribute {
    name "Phone Number"
  }
  attribute {
    name "Site"
  }
  qualification {
    name "Raw"
    result_type "Multiple"
    parameter {
      name "qualification"
    }
  }
  qualification {
    name "Ops Team"
    result_type "Multiple"
  }
  qualification {
    name "Manager and Above"
    result_type "Multiple"
  }
  qualification {
    name "Director and Above"
    result_type "Multiple"
  }
  qualification {
    name "VP and Above"
    result_type "Multiple"
  }
}
model {
  name "Kinetic Elements"
  status "Active"
  attribute {
    name "Page Name"
  }
  qualification {
    name "Raw"
    result_type "Multiple"
    parameter {
      name "qualification"
    }
  }
}
model {
  name "Helper"
  status "Active"
  attribute {
    name "Display"
  }
  attribute {
    name "Display2"
  }
  attribute {
    name "Type"
  }
  attribute {
    name "Value"
  }
  attribute {
    name "Value2"
  }
  qualification {
    name "System Profile Departments"
    result_type "Multiple"
  }
  qualification {
    name "Report An Incident Type"
    result_type "Multiple"
  }
  qualification {
    name "Report An Incident Products"
    result_type "Multiple"
    parameter {
      name "Type"
    }
  }
}
model {
  name "Products"
  status "Active"
  attribute {
    name "Categorization 1"
  }
  attribute {
    name "Categorization 2"
  }
  attribute {
    name "Categorization 3"
  }
  attribute {
    name "Product Name"
  }
  qualification {
    name "All Products"
    result_type "Multiple"
  }
}
model_mapping {
  name "Broadcast"
  model_name "Broadcasts"
  bridge_name "ARS Bridge Localhost"
  structure "CFG:Broadcast"
  status "Active"
  attribute_mapping {
    attribute_name "Broadcast Message"
    field_mapping "<%=field[\"Broadcast Message\"]%>"
  }
  attribute_mapping {
    attribute_name "BroadcastSubject"
    field_mapping "<%=field[\"BroadcastSubject\"]%>"
  }
  attribute_mapping {
    attribute_name "End Date"
    field_mapping "<%=field[\"Broadcast End Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Start Date"
    field_mapping "<%=field[\"Broadcast Start Date\"]%>"
  }
  qualification_mapping {
    qualification_name "Available Broadcasts"
    query "'Status' = \"Enabled\" AND 'View Access' = \"Public\" AND 'Broadcast Start Date' < $\\TIMESTAMP$ AND ('Broadcast End Date' = $\\NULL$ OR 'Broadcast End Date' > $\\TIMESTAMP$)"
  }
}
model_mapping {
  name "Change"
  model_name "Change"
  bridge_name "Remedy"
  structure "CHG:Infrastructure Change"
  status "Active"
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Infrastructure Change ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Priority"
    field_mapping "<%=field[\"Priority\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Change Request Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status Reason\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Token"
    field_mapping "<%=field[\"SRID\"]%>"
  }
  qualification_mapping {
    qualification_name "By Id"
    query "'Infrastructure Change ID' = \"<%=parameter[\"Id\"]%>\""
  }
}
model_mapping {
  name "Change Work Info"
  model_name "Change Work Info"
  bridge_name "Remedy"
  structure "CHG:WorkLog"
  status "Active"
  attribute_mapping {
    attribute_name "Attachment1"
    field_mapping "<%=field[\"z2AF Work Log01\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment2"
    field_mapping "<%=field[\"z2AF Work Log02\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment3"
    field_mapping "<%=field[\"z2AF Work Log03\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Infrastructure Change ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Description\"]%>"
  }
  attribute_mapping {
    attribute_name "SubmitDate"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Submitter"
    field_mapping "<%=field[\"Submitter\"]%>"
  }
  qualification_mapping {
    qualification_name "By Change Id"
    query "'Infrastructure Change ID' = \"<%=parameter[\"Change Id\"]%>\""
  }
}
model_mapping {
  name "Companies"
  model_name "Concepts"
  bridge_name "Remedy"
  structure "COM:Company"
  status "Active"
  attribute_mapping {
    attribute_name "Concept"
    field_mapping "<%=field[\"Company\"]%>"
  }
  qualification_mapping {
    qualification_name "Enabled"
    query "'Status' = \"Enabled\" AND 'Company Type' = \"Operating Company\" OR 'Company Type' = \"Customer\""
  }
}
model_mapping {
  name "Helper Remedy"
  model_name "Helper"
  bridge_name "Remedy"
  structure "KS_SRV_Helper"
  status "Active"
  attribute_mapping {
    attribute_name "Display"
    field_mapping "<%=field[\"Character Field3\"]%>"
  }
  attribute_mapping {
    attribute_name "Display2"
    field_mapping "<%=field[\"Character Field5\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Character Field1\"]%>"
  }
  attribute_mapping {
    attribute_name "Value"
    field_mapping "<%=field[\"Character Field2\"]%>"
  }
  attribute_mapping {
    attribute_name "Value2"
    field_mapping "<%=field[\"Character Field4\"]%>"
  }
  qualification_mapping {
    qualification_name "Report An Incident Products"
    query "'Character Field1' = \"Report An Incident Choices\" AND 'Character Field2' = \"<%=parameter[\"Type\"]%>\""
  }
  qualification_mapping {
    qualification_name "Report An Incident Type"
    query "'Character Field1' = \"Report An Incident Choices\""
  }
  qualification_mapping {
    qualification_name "System Profile Departments"
    query "'Character Field1' = \"System Profile Departments\""
  }
}
model_mapping {
  name "Groups"
  model_name "Image Now Workflow Groups"
  bridge_name "Remedy"
  structure "SYS:Menu Items"
  status "Active"
  attribute_mapping {
    attribute_name "Group"
    field_mapping "<%=field[\"Menu Value 2\"]%>"
  }
  qualification_mapping {
    qualification_name "By Category"
    query "'Menu Type' = \"Image Now Workflow Groups\" AND 'Menu Value 1' = \"<%=parameter[\"Category\"]%>\""
  }
}
model_mapping {
  name "Remedy"
  model_name "Incident"
  bridge_name "Remedy"
  structure "HPD:Help Desk"
  status "Active"
  attribute_mapping {
    attribute_name "Assigned Group"
    field_mapping "<%=field[\"Assigned Group\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Incident Number\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Decription\"]%>"
  }
  attribute_mapping {
    attribute_name "Priority"
    field_mapping "<%=field[\"Priority\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status_Reason\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Token"
    field_mapping "<%=field[\"SRMSAOIGuid\"]%>"
  }
  qualification_mapping {
    qualification_name "By Id"
    query "'Incident Number' = \"<%=parameter[\"Id\"]%>\""
  }
}
model_mapping {
  name "Remedy IWI"
  model_name "Incident Work Info"
  bridge_name "Remedy"
  structure "HPD:WorkLog"
  status "Active"
  attribute_mapping {
    attribute_name "Attachment1"
    field_mapping "<%=field[\"z2AF Work Log01\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment2"
    field_mapping "<%=field[\"z2AF Work Log02\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment3"
    field_mapping "<%=field[\"z2AF Work Log03\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Work Log ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Description\"]%>"
  }
  attribute_mapping {
    attribute_name "SubmitDate"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Submitter"
    field_mapping "<%=field[\"Submitter\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  qualification_mapping {
    qualification_name "By Incident Id"
    query "'Incident Number' = \"<%=parameter[\"Incident Id\"]%>\" AND 'View Access' = \"Public\""
  }
}
model_mapping {
  name "Sys Menu Items"
  model_name "JDA Levels"
  bridge_name "Remedy"
  structure "SYS:Menu Items"
  status "Active"
  attribute_mapping {
    attribute_name "Label"
    field_mapping "<%=field[\"Menu Label 2\"]%>"
  }
  attribute_mapping {
    attribute_name "Value"
    field_mapping "<%=field[\"Menu Value 2\"]%>"
  }
  qualification_mapping {
    qualification_name "By Concept"
    query "'Menu Type' = \"JDA Levels\" AND 'Menu Value 1' = \"<%=parameter[\"Concept\"]%>\""
  }
}
model_mapping {
  name "Kinetic Elements"
  model_name "Kinetic Elements"
  bridge_name "Remedy"
  structure "KS_SRV_ContentsElementHTML"
  status "Active"
  qualification_mapping {
    qualification_name "Raw"
    query "<%=parameter[\"qualification\"]%>"
  }
}
model_mapping {
  name "Menu Items"
  model_name "OutQs"
  bridge_name "Remedy"
  structure "SYS:Menu Items"
  status "Active"
  attribute_mapping {
    attribute_name "Label"
    field_mapping "<%=field[\"Menu Label 2\"]%>"
  }
  attribute_mapping {
    attribute_name "Value"
    field_mapping "<%=field[\"Menu Value 2\"]%>"
  }
  qualification_mapping {
    qualification_name "By Network"
    query "'Menu Type' = \"OutQs\" AND 'Menu Value 1' = \"<%=parameter[\"Network\"]%>\""
  }
}
model_mapping {
  name "Remedy People"
  model_name "People"
  bridge_name "Remedy"
  structure "CTM:People"
  status "Active"
  attribute_mapping {
    attribute_name "Email Address"
    field_mapping "<%=field[\"Internet E-mail\"]%>"
  }
  attribute_mapping {
    attribute_name "First Name"
    field_mapping "<%=field[\"First Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Full Name"
    field_mapping "<%=field[\"Full Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Last Name"
    field_mapping "<%=field[\"Last Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Login ID"
    field_mapping "<%=field[\"Remedy Login ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Person ID"
    field_mapping "<%=field[\"Person ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Phone Number"
    field_mapping "<%=field[\"Phone Number Business\"]%>"
  }
  attribute_mapping {
    attribute_name "Site"
    field_mapping "<%=field[\"Site\"]%>"
  }
  qualification_mapping {
    qualification_name "Director and Above"
    query "'Profile Status' = \"Enabled\""
  }
  qualification_mapping {
    qualification_name "Manager and Above"
    query "'Profile Status' = \"Enabled\""
  }
  qualification_mapping {
    qualification_name "Ops Team"
    query "'Profile Status' = \"Enabled\""
  }
  qualification_mapping {
    qualification_name "Raw"
    query "<%=parameter[\"qualification\"]%>"
  }
  qualification_mapping {
    qualification_name "VP and Above"
    query "'Profile Status' = \"Enabled\""
  }
}
model_mapping {
  name "Remedy Products"
  model_name "Products"
  bridge_name "Remedy"
  structure "PCT:Product Catalog"
  status "Active"
  attribute_mapping {
    attribute_name "Product Name"
    field_mapping "<%=field[\"Product Name\"]%>"
  }
  qualification_mapping {
    qualification_name "All Products"
    query "'Product Name' LIKE \"%\""
  }
}
model_mapping {
  name "Category"
  model_name "Service Item Category"
  bridge_name "ARS Bridge Localhost"
  structure "KS_RQT_ServiceItemCategory"
  status "Active"
  attribute_mapping {
    attribute_name "Category"
    field_mapping "<%=field[\"Category\"]%>"
  }
  attribute_mapping {
    attribute_name "CategoryDescription"
    field_mapping "<%=field[\"CategoryDescription\"]%>"
  }
  attribute_mapping {
    attribute_name "IconHTML"
    field_mapping "<%=field[\"IconHTML\"]%>"
  }
  attribute_mapping {
    attribute_name "Number of Items"
    field_mapping "<%=field[\"Number_of_Items\"]%>"
  }
  attribute_mapping {
    attribute_name "Service Catalog"
    field_mapping "<%=field[\"ServiceCatalog\"]%>"
  }
  qualification_mapping {
    qualification_name "by Catalog"
    query "'ServiceCatalog' = \"Bed Bath & Beyond\""
  }
}
model_mapping {
  name "Service Items"
  model_name "Service Items"
  bridge_name "ARS Bridge Localhost"
  structure "KS_SRV_SurveyTemplate"
  status "Active"
  attribute_mapping {
    attribute_name "Anonymous URL"
    field_mapping "<%=field[\"Anonymous_URL\"]%>"
  }
  attribute_mapping {
    attribute_name "Category"
    field_mapping "<%=field[\"Category\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Survey Description"
    field_mapping "<%=field[\"Survey_Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Survey Template Name"
    field_mapping "<%=field[\"Survey_Template_Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Type\"]%>"
  }
  qualification_mapping {
    qualification_name "by Name"
    query "1=1"
  }
}
model_mapping {
  name "Service Requests"
  model_name "Service Requests"
  bridge_name "ARS Bridge Localhost"
  structure "KS_RQT_CustomerSurvey_Task_join"
  status "Active"
}
model_mapping {
  name "Site form"
  model_name "Sites"
  bridge_name "Remedy"
  structure "SIT:Site"
  status "Active"
  attribute_mapping {
    attribute_name "Site Name"
    field_mapping "<%=field[\"Site\"]%>"
  }
  qualification_mapping {
    qualification_name "Enabled"
    query "'Status' = \"Enabled\""
  }
}
model_mapping {
  name "Incidents"
  model_name "Tickets"
  bridge_name "ARS Bridge Localhost"
  structure "HPD:Help Desk"
  status "Active"
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Detailed Description"
    field_mapping "<%=field[\"Detailed Decription\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Submit Date"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Ticket ID"
    field_mapping "<%=field[\"Incident Number\"]%>"
  }
  qualification_mapping {
    qualification_name "All Incidents"
    query "1=1"
  }
  qualification_mapping {
    qualification_name "by ID"
    query "'Incident Number' = \"<%=parameter[\"Ticket ID\"]%>\""
  }
}
model_mapping {
  name "WorkOrder"
  model_name "WorkOrder"
  bridge_name "Remedy"
  structure "WOI:WorkOrder"
  status "Active"
  attribute_mapping {
    attribute_name "Assigned Group"
    field_mapping "<%=field[\"ASGRP\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Work Order ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status Reason\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Summary\"]%>"
  }
  attribute_mapping {
    attribute_name "Token"
    field_mapping "<%=field[\"SRMSAOIGuid\"]%>"
  }
  qualification_mapping {
    qualification_name "By Id"
    query "'Work Order ID' = \"<%=parameter[\"Id\"]%>\""
  }
}
model_mapping {
  name "Work Order Work Info"
  model_name "WorkOrder Work Info"
  bridge_name "Remedy"
  structure "WOI:WorkInfo"
  status "Active"
  attribute_mapping {
    attribute_name "Attachment1"
    field_mapping "<%=field[\"z2AF Work Log01\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment2"
    field_mapping "<%=field[\"z2AF Work Log02\"]%>"
  }
  attribute_mapping {
    attribute_name "Attachment3"
    field_mapping "<%=field[\"z2AF Work Log03\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Work Log ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Notes"
    field_mapping "<%=field[\"Detailed Description\"]%>"
  }
  attribute_mapping {
    attribute_name "SubmitDate"
    field_mapping "<%=field[\"Work Log Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Submitter"
    field_mapping "<%=field[\"Work Log Submitter\"]%>"
  }
  qualification_mapping {
    qualification_name "By WorkOrder Id"
    query "\"<%=parameter[\"Work Order Id\"]%>\" = 'Work Order ID' AND 'View Access' = \"Public\""
  }
}
bridge {
  name "ARS Bridge Localhost"
  bridge_url "http://10.1.20.137:8092/kineticArsBridge/api/1.0/"
  status "Active"
}
bridge {
  name "Remedy"
  bridge_url "http://localhost/kineticArsBridge/api/1.0/"
  status "Active"
}
