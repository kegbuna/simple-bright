/*
Copyright (c) 2010, Kinetic Data Inc. All rights reserved.
http://www.kineticdata.com
*/
var remedyServerSettingsHelp = "<p class=\"bold\">The Remedy Server Settings determine which Remedy server Kinetic SR will connect with.</p>" +
"<p>Server Name is the name of your Remedy server.  This value must match the information in your license key.  If your license key was generated using the fully qualified name, you must use the fully qualified name here.</p>" +
"<p>TCP Port defines the TCP Port your Remedy server is listening on.  If your Remedy server is configured to use portmapper, use 0 as the value.</p>" +
"<p>RPC Port defines the RPC Port your Remedy server is listening on.  Remedy uses 0 by default.</p>" +
"<p>Answer Thread RPC Port defines the private RPC Port dedicated to answer submissions.  Uses 0 by default.</p>" +
"<p>API Connection Pool Limit defines the number of simultaneous connections allowed to the Remedy server.  Changing this value requires a restart of the web application.</p>" +
"<p>API Impersonate User allows the default web user to impersonate the user logging into the system.</p>";
var remedyServerAndUserSettingsHelp = remedyServerSettingsHelp +
"<p>Default User is the Remedy User ID the application as a service account.";
var encryptionSettingsHelp = "<p class=\"bold\">The Encryption Settings determine if your web user passwords are stored in the Kinetic SR configuration file in plain text or as an encrypted value.</p>" +
"<p>Encrypt Passwords, if true, web user passwords are stored encrypted.  If false, web user passwords are stored in plain text.</p>" +
"<p>Encryption Seed is the seed string used to encrypt the passwords.  This value is used in the encryption algorithm when generating the encrypted password to make it harder to reverse engineer the encrypted value.</p>";
var webUserSettingsHelp = "<p class=\"bold\">The Web User Settings determine the Remedy User account that Kinetic SR will use to connect to Remedy.  This user account must have a fixed write license, and should be a Remedy Administrator.  If the account cannot be an Administrator, all the following groups are required: KS_CORE, KS_SRV, KS_SRV_Inspector, KS_MSG, and KS_RQT_Inspector.</p>" +
"<p>Web User Id is the Remedy user that will be used by Kinetic SR to connect as the default user account.</p>" +
"<p>Web User Password is the password associated with the Web User account.</p>";
var taskManagerSettingsHelp = "<p class=\"bold\">The task manager is a service that polls the Remedy server to check if any Kinetic Request tasks need to be processed.  The poller service will process all records that match the Record Poller Query.  It polls the remedy server every X number of seconds, as defined by the Record Poller Sleep Delay.</p>" +
"<p>Task Manager Service, if enabled, the record poller will be enabled on this web server.</p>" +
"<p>Query is the Remedy qualification used to select which records require processing.</p>" +
"<p>Sleep Delay is the number of seconds to wait before checking for unprocessed tasks.  The default value is 60 seconds.</p>";
var defaultLoggerSettingsHelp = "<p class=\"bold\">The logger settings allow you to manage logging information.</p>" +
"<p>Log Level controls the level of information being sent to the log file.  Off is lowest (nothing logged), and All is highest.</p>" +
"<p>Max Long Size (Bytes) determines how large log files should be allowed to grow before a new file is started.</p>" +
"<p>Log Output Directory allows logs to be written to a directory other than the default.</p>"+
"<p>Log Properties File allows multiple logger appenders to be configured in addition to the default logger.</p>";
var miscellaneousSettingsHelp = "<p class=\"bold\">These are properties that just do not fit in any other category</p>" +
"<p>Max Chars on Submit defines the maximum characters that can be submitted in an html form.  Default value is 4000, but it may need to be increased if you have some large forms.</p>" +
"<p>Map Fields Count is the number of possible field mappings.  Default is 128.</p>" +
"<p>Max Cache Size.  Default is 200.</p>";
var ssoAdapterSettingsHelp = "<p class=\"bold\">If you are writing your own Single Sign-On Adapter, this is where you tell Kinetic SR what the SSO Java class name and properties file are located</p>" +
"<p>SSO Adapter Class is the java class that executes your custom SSO code to authenticate users.  Please use the full package name.</p>" +
"<p>If your SSO adapter stores properties in a configuration file, Kinetic SR can load that file when it starts.  If your SSO adapter does not use a properties file, leave this value blank.</p>";
var configAdminCredentialsHelp = "<p class=\"bold\">Kinetic SR provides a configuration administrator user to manage the properties file.  This account is NOT a Remedy account.  By default, the user and password is admin/admin, but we highly recommend changing at least the password.</p>" +
"<p>Config Admin User is the name of the configuration admin user account.</p>";
var configAdminCredentialDetailsHelp = "<p class=\"bold\">Kinetic SR provides a configuration administrator user to manage the properties file.  This account is NOT a Remedy account.  By default, the user and password is admin/admin, but we highly recommend changing at least the password.</p>" +
"<p>Username is the name of the admin user.  This value can be changed here.</p>"+
"<p>Current Password is the current password of the configuration administrator user account.</p>"+
"<p>New Password will be the new value of the password.</p>"+
"<p>Confirm New Password requires the new password to entered again, just to make sure it was typed correctly.</p>";

var ids = new Array("remedyServerSettings", "remedyServerAndUserSettings", "encryptionSettings", "webUserSettings", "taskManagerSettings",
    "defaultLoggerSettings", "miscellaneousSettings", "ssoAdapterSettings", "configAdminCredentials", "configAdminCredentialDetails");

var helpMessage = {
    remedyServerSettings: remedyServerSettingsHelp,
    remedyServerAndUserSettings: remedyServerAndUserSettingsHelp,
    encryptionSettings: encryptionSettingsHelp,
    webUserSettings: webUserSettingsHelp,
    taskManagerSettings: taskManagerSettingsHelp,
    defaultLoggerSettings: defaultLoggerSettingsHelp,
    miscellaneousSettings: miscellaneousSettingsHelp,
    ssoAdapterSettings: ssoAdapterSettingsHelp,
    configAdminCredentials: configAdminCredentialsHelp,
    configAdminCredentialDetails: configAdminCredentialDetailsHelp
};

var tooltip = new YAHOO.widget.Tooltip("tooltip", {
    context:ids,
    autodismissdelay:30000
});

tooltip.contextTriggerEvent.subscribe(function(type, args) {
    var context = args[0];
    this.cfg.setProperty("text", helpMessage[context.id]);
});