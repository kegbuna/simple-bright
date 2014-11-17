/* KEYSTONE SERVLET BASE CLASS -------------------------------------------------------------
   Author: Ryan Ahern
   Date: June 1, 2012
   
   This class is meant to be the base class for all Keystone Servlets. All common
   functionality is placed into this class and is accessible from each Keystone servlet.
-------------------------------------------------------------------------------------------- */
import java.io.*;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.bmc.arsys.api.*;

import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;


public class KeystoneServletBase extends HttpServlet {
	// Constants ----------------------------------------------------------------------------------
    private String SERVLET_NAME    				= "[KeystoneServletBase]";
    private String CONFIG_FILE_PATH 			= "config/kineticConfig.json";
	private String ARS_HOSTNAME;
	private String API_AUTH_USER;
	private String API_AUTH_PASS;
	private String API_AUTH_COMPANY; /* Temp to be used for a qual */
	private int    ARS_PORT           			= 0;
	private String ARS_FORM_NAME				= "";
	private DateFormat DATE_FORMAT 				= new SimpleDateFormat("MM/dd/yyyy hh:mm a");
    private JSONObject CONFIG_MAP  		        = new JSONObject();
    private JSONObject PARAM_MAP   		        = new JSONObject();
    protected Map<Integer,String> STATUS_MAP 	= new HashMap<Integer,String>();
    protected Map<Integer,String> URGENCY_MAP 	= new HashMap<Integer,String>();
    protected Map<Integer,String> IMPACT_MAP 	= new HashMap<Integer,String>();
    
	public KeystoneServletBase() {
		super();
	}
	
	/**
	 * Builds all maps that convert AR System data to human-readable formatting.
	 */
	public void BuildMaps() { 
	    /* Need a better way to configure this */
	    STATUS_MAP.put(0, "New");
	    STATUS_MAP.put(1, "Assigned");
	    STATUS_MAP.put(2, "In Progress");
	    STATUS_MAP.put(3, "Pending");
	    STATUS_MAP.put(4, "Resolved");
	    STATUS_MAP.put(5, "Closed");
	    STATUS_MAP.put(6, "Cancelled");
	    
	    URGENCY_MAP.put(1000, "1-Critical");
	    URGENCY_MAP.put(2000, "2-High");
	    URGENCY_MAP.put(3000, "3-Medium");
	    URGENCY_MAP.put(4000, "4-Low");
	    
	    IMPACT_MAP.put(1000, "1-Extensive/Widespread");
	    IMPACT_MAP.put(2000, "2-Significant/Large");
	    IMPACT_MAP.put(3000, "3-Moderate/Limited");
	    IMPACT_MAP.put(4000, "4-Minor/Localized");
    }
	
	protected void ClearParamMap() {
		PARAM_MAP = new JSONObject();
	}
	
	protected String ConvertTimestamp( Value val ) {
        Timestamp ts = (Timestamp)val.getValue();
        Date sub_date_s = ts.toDate();
        return DATE_FORMAT.format(sub_date_s);
    }
	
    /**
     * Forward all requests over to doPost().
     * NOTE: doPost() must be overridden in the derived class.
     */
    protected void doGet( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doPost( request, response );
	}
    
    protected String GetConfig( String name ) {
        try
        {
            String value = (String)CONFIG_MAP.get( name );
            if ( value != null )
            {
                return value;
            }
        }
        catch (JSONException e)
        {
           e.printStackTrace();
        }

        return "";
    }

    protected JSONObject getConfigObject()
    {
        return new JSONObject(CONFIG_MAP, JSONObject.getNames(CONFIG_MAP));
    }
    
    protected String GetForm() {
    	return ARS_FORM_NAME;
    }

    protected JSONObject getParametersObject()
    {
        return new JSONObject(PARAM_MAP, JSONObject.getNames(PARAM_MAP));
    }
    protected String GetParameter( String name )
    {
        String value;
        try
        {
            value = (String)PARAM_MAP.get( name );
            if ( value != null )
            {
                return value;
            }
        }
        catch (JSONException e)
        {
            e.printStackTrace();
        }
        return "NONE";
    }
    
    /*protected Iterator GetParameterIterator() {
        return PARAM_MAP.entrySet().iterator();
    } */
    
    protected int GetParameterMapSize() {
    	return PARAM_MAP.length();
    }
    
	/** 
     *  Parse the Configuration json file
     */
    protected void GetProperties() {
        try{
            File configFile = new File(getServletContext().getRealPath(CONFIG_FILE_PATH));
            BufferedReader config = new BufferedReader(new FileReader(configFile));

            String configString = "";
            String readLine;

            while ((readLine = config.readLine()) != null)
            {
                configString += readLine;
            }
            System.out.println(configString);
            CONFIG_MAP = new org.json.JSONObject(configString);
            CONFIG_MAP.put("Path", getServletContext().getRealPath(CONFIG_FILE_PATH));
        }
        catch ( Exception e ) {
            e.printStackTrace();
        }
    }
	
    protected String GetServletName() {
        return SERVLET_NAME;
    }
    
    protected void ParseParameters( HttpServletRequest request ) {
        Enumeration paramNames = request.getParameterNames();

	    while ( paramNames.hasMoreElements() ) {
	        String paramName = (String)paramNames.nextElement();

	        /* Get the param value */
	        String paramValue = request.getParameter( paramName );
	        try
            {
                PARAM_MAP.put( paramName, paramValue );
            }
            catch (JSONException e)
            {
                e.printStackTrace();
            }
	    }
    }
    
    protected void PrintError( HttpServletResponse response, String error ) {
    	try {
	    	PrintWriter pw = response.getWriter();
	    	response.setContentType( "application/json" );
	        pw.println( "{\"Error\":\"" + error + "\"}" );
	        pw.close();
    	}
    	catch ( IOException e ) {
    		e.printStackTrace();
    	}
    }
    
    protected void SetForm( String form ) {
    	ARS_FORM_NAME = form;
    }
    
    protected void SetServletName( String name ) {
        SERVLET_NAME = "[" + name + "]";
    }
}