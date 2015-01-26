################################################################################
# RULES
#   The collection of KSL rules that are usable by Kinetic Request.  If access
#   should be denied, the rule should return a String representing the reason
#   for denial.  If access is not being denied, the rule should return +true+.
#   A return value of anything other than +true+ or a String will be treated as
#   an error.
#
#   @catalog [com.kineticdata.ksr.models.Catalog]
#     * (String)       @catalog.name
#     * (String)       @catalog.get_attribute_value(ATTRIBUTE_NAME)
#     * (List<String>) @catalog.get_attribute_values(ATTRIBUTE_NAME)
#   @template [com.kineticdata.ksr.models.Template]
#     * (String)       @template.name
#     * (String)       @template.get_attribute_value(ATTRIBUTE_NAME)
#     * (List<String>) @template.get_attribute_values(ATTRIBUTE_NAME)
#   @user [com.kd.arsHelpers.HelperContext]
#     * (String)       @user.user_name
#     * (true/false)   @user.is_admin_user
#     * (true/false)   @user.user_is_member_of_group
################################################################################

policy "Administrators" do
  if !@user.nil? && @user.is_admin_user
    return true
  else
    return "You must be authenticated as an Administrator."
  end
end

policy "Public" do
  return true
end

policy "Private" do
  return "Nobody is allowed"
end
