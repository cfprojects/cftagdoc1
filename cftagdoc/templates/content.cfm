<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Package List - API Documentation</title>
<base target="content">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">

</head>
<body>

<cfparam name="url.tag" type="string" default="">


<cfoutput>
<div class="MainContent">
	<table cellspacing="0" cellpadding="0" class="classHeaderTable">
	<tr>
		<td class="classHeaderTableLabel">Package</td><td><cfif application.tags[url.tag].package NEQ "">#application.tags[url.tag].package#<cfelse><em>default package</em></cfif></td>
	</tr>
	<tr>
		<td class="classHeaderTableLabel">Tag Name</td><td class="classSignature">#application.tags[url.tag].name#</td>
	</tr>
	<tr>
		<td class="classHeaderTableLabel">Inheritance</td><td class="classSignature"></td>
	</tr>
	</table>
	<hr />
	<table cellspacing="0" cellpadding="0" class="classHeaderTable">
	<tr>
		<td class="classHeaderTableLabel">Tag Description</td><td class="classSignature"></td>
	</tr>
	</table>
	<code><pre>#htmlEditFormat(application.tags[url.tag].comment)#</pre></code>	
		
	<hr />
	
	<div class="summarySection">
	<div class="summaryTableTitle">Params summary</div>
	<table id="summaryTableProperty" class="summaryTable " cellpadding="3" cellspacing="0" >
		<tr>
			<th></th><th colspan="2">Parameters</th>
		</tr>
		
		<!--- <cfdump var="#application.tags[url.tag].params#">
		 --->
		<cfset paramArray = structKeyArray(application.tags[url.tag].params) />
		<cfset arraySort(paramArray, "textnocase", "asc") />
		<cfset numParams = arrayLen(paramArray) />
		<cfset paramCount = 0 />
		
		<cfloop from="1" to="#numParams#" index="idx">
		<cfset keyList = structKeyList(application.tags[url.tag].params[paramArray[idx]]) />
		<tr class="">
			<td class="summaryTablePaddingCol">&nbsp;</td>
			<td><div class="summarySignature"><code><strong>#replaceNoCase(paramArray[idx],"attributes.","","one")#</strong></code></div>
			<div class="summaryTableDescription" style="padding: 5px">
				<code>
				Type: <em><cfif listFindNoCase(keyList,"type")>#application.tags[url.tag].params[paramArray[idx]].type#<cfelse>any</cfif></em><br />
				Required: <em><cfif listFindNocase(keyList,"default")>no<cfelse><span style="color:red;">yes</span></cfif></em><br />
				Default: <em><cfif listFindNoCase(keyList,"default")>#application.tags[url.tag].params[paramArray[idx]].default#</cfif></em></code>
			</div>	
			</td>
		</tr>
		</cfloop>
	</table>
	</div>
</div>
</cfoutput>
</body>
</html>