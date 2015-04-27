<!---  
<cfscript>
	variables.seedDir = expandPath('../../');
	session.siteMap = createObject("component", "Sitemap").init(variables.seedDir, "windows");
</cfscript> 
		
		
<cfset variables.seedDir = expandPath('../../customtags/uielement/') />
<cfset variables.tagParser = createObject("component","components.TagParser").init(variables.seedDir) />

<cfset variables.qryDir = variables.tagParser.getDirectory(variables.tagParser.getSeedDir()) />

<cfdump var="#variables.seedDir#" />

<cfdump var="#variables.qryDir#" />

<cfset variables.currentTag = "#variables.qryDir.directory[2]#\#variables.qryDir.name[2]#" />


<cfdump var="#variables.currentTag#" />

<cffile action="read" file="#variables.currentTag#" variable="tagContents">


<br />Get Params
<cfset aParams = variables.tagParser.getAttributes(variables.tagContents) />

<cfdump var="#aParams#" />


<cfset stTag = structNew() />
<cfset stTag.params = structNew() />

<cfloop from="1" to="#arrayLen(aParams)#" index="i">
	<cfset stParams = structNew()>
	<cfset structAppend(stParams,variables.tagParser.getTagAttributes(aParams[i].tagblock,'cfparam'),true)>
	<cfset stTag.params[stParams.name] = stParams />
</cfloop>

<cfdump var="#stTag#" />
 --->

<cfoutput>
<html>
<head>
	<title>CFTag Doc</title>
</head>
<!--- 
<cfdump var="#application#">
<cfabort> --->
<!--- <cfparam name="url.startRoot" default="" type="string">
<cfparam name="url.startPackage" default="" type="string">
<cfparam name="url.startComponent" default="" type="string"> --->


<frameset cols="210,*" border="2" bordercolor="##aaaaaa" framespacing="0" >
	<frame src="#application.templatesDir#leftbar.cfm" name="leftbar"></frame>
	<frameset bordercolor="##aaaaaa" border="0" rows="80,*">
		<frame scrolling="no" frameborder="0" name="titlebar" src="#application.templatesDir#titleBar.cfm" />
			<frame src="#application.templatesDir#default.cfm" name="content" />
	</frameset>	
</frameset>
</cfoutput>
