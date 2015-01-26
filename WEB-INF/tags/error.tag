<%@attribute name="title" required="true"
%><%@attribute name="bodyClass" required="true"
%><%@attribute name="content" required="true"
%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
        <title>${title}</title>
    </head>
    <body bgcolor="#FFFFFF" class="${bodyClass}" text="#000000">
        <div align="center">
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">${content}</font></b><br/></p>
            <p>
                <br/>
                <br/>
                <a href="http://www.kineticdata.com">
                    <img src="<%=request.getContextPath()%>/resources/poweredByKS.gif" alt="Powered by Kinetic"/>
                </a>
            </p>
        </div>
    </body>
</html>
