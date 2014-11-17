<%@page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate, max-age=0"); //HTTP 1.1
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
response.setHeader("Pragma","no-cache");
%>
<%-- Format a list of KS_SRV_SurveyTemplateAttrInstance_join entries in an ordered list including link to the template --%>
<% java.util.List resultsList=(java.util.List)request.getAttribute("resultsList");
if(resultsList != null){

     int min = 0; // we will build this up in the hash building
     int max = 0; // we should have more than 0 tags
     java.util.Hashtable hash = new java.util.Hashtable();
     java.util.Iterator iter = resultsList.iterator();

     while(iter.hasNext()){
        com.kd.arsHelpers.SimpleEntry entry=(com.kd.arsHelpers.SimpleEntry)iter.next();
	java.util.StringTokenizer st = new java.util.StringTokenizer(entry.getEntryFieldValue("710000073"), " ");
		   while(st.hasMoreTokens()){
		   	 String s=st.nextToken();
			 if (hash.containsKey(s)) {
				hash.put(s, (Integer)hash.get(s) + 1);
				min = (Integer)hash.get(s); // build up min - so we have a decent init value
			 } else {
			 	hash.put(s, new Integer(1));
			 }
		   }
     }

     java.util.Enumeration en = hash.keys();

     // get max min
	while(en.hasMoreElements()){
           String key = (String)en.nextElement();
	   if ((Integer)hash.get(key) < min) {
		   min = (Integer)hash.get(key);
	   }

	   if ((Integer)hash.get(key) > max) {
		max = (Integer)hash.get(key);
	   }

	}

	// print out the list
	en = hash.keys();
	java.util.ArrayList array = new java.util.ArrayList();


	while (en.hasMoreElements()){
		array.add(en.nextElement().toString());
	}

	Object[] sorted = array.toArray();
	java.util.Arrays.sort(sorted);

	// 5 classes: smallest, smaller, normal, bigger biggest
	// max 15, min 5
	float div = (new Integer(max-min).floatValue() / 5);

	java.lang.String fontSize = "tagNormal";

	for(int i = 0; i < sorted.length; i++) {
		String key = (String)sorted[i];

		if((Integer)hash.get(key) >= new Integer(max).floatValue()-1*div) {
			fontSize = "tagBiggest";
		} else

		if((Integer)hash.get(key) >= new Integer(max).floatValue()-2*div) {
			fontSize = "tagBigger";
		} else

		if((Integer)hash.get(key) >= new Integer(max).floatValue()-3*div) {
			fontSize = "tagNormal";
		} else

		if((Integer)hash.get(key) >= new Integer(max).floatValue()-4*div) {
			fontSize = "tagSmaller";
		} else

		if((Integer)hash.get(key) >= new Integer(max).floatValue()-5*div) {
			fontSize = "tagSmallest";
		}

%>
	<span class=<%=fontSize%> onclick="doItemsForTag(this.innerHTML)"
	onmouseover="this.style.backgroundColor='#3886e6';"
	onmouseout="this.style.backgroundColor='';"
	><%=key%></span>
	<% } %>
<%} else{%>
<p>No results found</p>
<%} %>


