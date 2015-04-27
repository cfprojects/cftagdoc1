<cfcomponent name="Application" displayname="Application" hint="CFTag Doc" output="false">

	<cfscript>
		this.name = "CFTag Doc";
		this.sessionManagement = true;
		this.sessionTimeout = createTimeSpan(0,0,20,0);
	</cfscript>
	
	<!---:: application start ::--->
	<cffunction name="onApplicationStart" displayname="On Application Start" hint="Runs when application initializes" access="public" output="false" returntype="boolean">
		<cfset application.templatesDir = "templates/" />	
		<cfset application.seedDir = expandPath('../../customtags/') />
		<cfset application.tagParser = createObject("component","components.TagParser").init(application.seedDir) />
		
		<cfset application.packages = structNew() />
		<cfset application.tags = structNew() />
		<cfset application.tagParser.processTags(application.tagParser.getSeedDir(), "", application.packages, application.tags) />
		
		<cfreturn true>
	</cffunction>
	
	<!---:: session start ::--->
	<cffunction name="onSessionStart" displayname="On Session Start" hint="Runs when session initializes" access="public" output="false" returntype="void">
		
		
		<cfreturn>
	</cffunction>
	
	<cffunction name="onRequestStart" displayname="On Request Start" hint="Runs when request initializes" access="public" output="false" returntype="boolean">
		<cfsetting showdebugoutput="false">
		<cfscript>
			if (structKeyExists(url, 'flush')){
				onApplicationStart();
				onSessionStart();
			}
		</cfscript>
		
		<cfreturn true>
	</cffunction>
	
</cfcomponent>