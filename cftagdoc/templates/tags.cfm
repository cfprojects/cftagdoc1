<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>All Classes - API Documentation</title>
<base target="content">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">
</head>
<body class="classFrameContent">
	
	<cfparam name="url.package" type="string" default="" />
	
	<!--- <cfdump var="#url#"> --->
	<cfoutput>
	<cfif url.package EQ "">
		<strong>All Packages</strong><br /><br />
	<cfelseif url.package EQ ".">
		<strong>default package</strong><br /><br />
	<cfelse>
		<strong>#url.package#</strong><br /><br />
	</cfif>
	
	<strong>Tags</strong><br>
	
	
	<cfset tagArray = structKeyArray(application.tags) />
	<cfset arraySort(tagArray, "textnocase", "asc") />
	<cfset numTags = arrayLen(tagArray) />
	<cfset tagCount = 0 />
	
	<cfloop from="1" to="#numTags#" index="idx">
		<cfif url.package EQ "" OR url.package EQ application.tags[tagArray[idx]].package OR (url.package EQ "." AND application.tags[tagArray[idx]].package EQ "")>
			<a href="content.cfm?tag=#urlEncodedFormat(tagArray[idx])#" target="content">#application.tags[tagArray[idx]].name#</a><br />
			<cfset tagCount = tagCount + 1 />
		</cfif>
	</cfloop>
	<cfif tagCount EQ 0>
		No tags for this package
	</cfif>
	</cfoutput>
</body>
</html>