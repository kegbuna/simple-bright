<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%@page import="org.apache.log4j.Logger"%>
<%
    String fwdQry = (String)request.getAttribute("javax.servlet.forward.query_string");
    String fwdUri = (String)request.getAttribute("javax.servlet.forward.request_uri");
    Integer errorCode = (Integer)request.getAttribute("javax.servlet.error.status_code");
    String errorMsg = (String)request.getAttribute("javax.servlet.error.message");
    Exception errorEx = (Exception)request.getAttribute("javax.servlet.error.exception");

    Logger logger = Logger.getLogger("com.kineticdata");
    String loggerID = "ERROR_PAGE_" + errorCode.toString() + ": ";

    // explain why this page was rendered
    if (logger.isDebugEnabled()) {
        // log what request was made
        StringBuffer buf = new StringBuffer("Error encountered while processing request from: ");
        buf.append(fwdUri);
        buf.append("?");
        buf.append(fwdQry);
        logger.debug(loggerID + buf.toString());

        // log the reason
        buf = new StringBuffer();
        if (errorCode.intValue() == 404) {
            buf.append("The following page was not found on this web server: ");
        }
        buf.append(errorMsg);
        if (errorEx != null) {
            buf.append("\n").append(errorEx.toString());
            StackTraceElement[] stackTraceElements = errorEx.getStackTrace();
            for (int i=0; i < stackTraceElements.length; i++) {
                buf.append("\n").append(stackTraceElements[i].toString());
            }
        }
        logger.debug(loggerID + buf.toString());
    }
    else {
        Object error = request.getAttribute("javax.servlet.error.exception");
        if (error != null) {
            logger.error(loggerID + "The following server error was encountered: ", (Exception)error);
        }
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="shortcut icon" href="<%=request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
<title>Page cannot be found</title>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<div align="center">
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">There was
    an error on the page you were attempting to reach or the page could not be
    found.</font></b> <br/>
  </p>
  <p><br/>
    <br/>
    <a href="http://www.kineticdata.com"><img src="<%=request.getContextPath()%>/resources/poweredByKS.gif" alt="Powered by Kinetic"/></a>
  </p>
  </div>
</body>
</html>
