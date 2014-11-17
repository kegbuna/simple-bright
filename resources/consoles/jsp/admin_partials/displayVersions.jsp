<%--
 Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
 http://www.kineticdata.com
--%>
<%@page contentType="text/html; charset=UTF-8"%>
<% String overrideContext = request.getParameter("override"); %>
<div id="libraries">
	<div class="wrapper">
		<div class="window">
			<table>
				<tr>
					<th>Library</th>
					<th>Version</th>
					<th>Jar File Name</th>
				</tr>
				<% String curClass = "light"; %>
                
                <%
                try {
                    com.kd.kineticSurvey.beans.JarInfo jarInfo = new com.kd.kineticSurvey.beans.JarInfo();
                    if (overrideContext!=null) {
                        jarInfo.setContext(overrideContext);
                    }
                    for (int i = 1; i < jarInfo.getJarCount()+1; i++) {
                    %>
                        <tr class="<%= curClass %>">
                            <td><%= jarInfo.getJarKey(i) %></td>
                            <td><%= jarInfo.getJarVersion(i) %></td>
                            <td><%= jarInfo.getJarName(i) %></td>
                        </tr>
                    <% if (curClass.equals("light")) { curClass = "dark"; } else { curClass = "light"; } %>
                    <%}%>
                <% } catch (Throwable t) { %>
                        <tr class="<%= curClass %>">
                            <td>AR JNI API Not Found</td>
                            <td></td>
                            <td></td>
                        </tr>
                <%}%>
			</table>
		</div>
	</div>
</div>