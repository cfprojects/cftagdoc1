<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Package List - API Documentation</title>
<base target="components">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">

</head>
<body class="classFrameContent">
<br>
<a href="tags.cfm" target="tags">All Packages</a>

<!--- <cfset packages = structNew() />
<cfset application.tagParser.processTags(application.tagParser.getSeedDir(), "", packages) />

 --->
<p>
<strong>Packages</strong><br>
<cfoutput>
	<a href="tags.cfm?package=." target="tags"><em>default package</em></a><br />	
	
	
<cfset packageArray = structKeyArray(application.packages) />
<cfset arraySort(packageArray, "textnocase", "asc") />
<cfset numPackages = arrayLen(packageArray) />

<cfloop from="1" to="#numPackages#" index="idx">
	<a href="tags.cfm?package=#urlEncodedFormat(application.packages[packageArray[idx]].name)#" target="tags">#application.packages[packageArray[idx]].name#</a><br />
</cfloop>	
</cfoutput>

</body>
</html>