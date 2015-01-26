<% 
    String helpType = (String)request.getParameter("helpType");
    if (helpType == null){
        helpType = "SR Manager Consoles";
    }
    String helpUrl = (String)request.getParameter("helpUrl");
    if (helpUrl == null) {
        helpUrl = "http://help.kineticdata.com/ksr52/consoles/";
    }
    String helpTip = (String)request.getParameter("helpTip");
    if (helpTip == null) {
        helpTip = "learn more about the "+helpType+" on Kinetic Community";
    }
    String helpIcon = (String)request.getParameter("helpIcon");
    if (helpIcon == null) {
        helpIcon = "fa-question-circle";
    }
%>

<h8 class='pull-right '>
    <a href="<%= helpUrl %>" target="_blank" data-toggle="tooltip" class="tooltipLink" data-placement="bottom" data-delay="{ show: 5000, hide: 3000}" data-original-title="<%= helpTip %>">
        <i class="fa fa-question-circle fa-lg"></i>
    </a>
</h8>
<script type='text/javascript'>
    $("a.tooltipLink").tooltip({
     'delay': { show: 1000, hide: 1000}
    });
</script>