<cfcomponent>
	<cfset variables.seedDir = "" />
	
	
	<cffunction name="init" access="public" returntype="TagParser" output="false" hint="The init method currently does nothing.">
		<cfargument name="seedDir" type="string" required="true">
			
		<cfset setSeedDir(arguments.seedDir) / >		
			
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="processTags" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="packageKey" type="string" required="true">
		<cfargument name="packages" type="struct" required="true">
		<cfargument name="tags" type="struct" required="true">
		<cfset var qryDir = "" />
		<cfset var packageID = "" />
		<cfset var fileID = "" />
		<!--- get files --->
		<cfset qryDir = application.tagParser.getDirectory(arguments.path) />
		
		
		
		<cfloop query="qryDir">
			
			<cfif qryDir.type EQ "DIR" AND qryDir.attributes NEQ "H">
			<!--- if it's a directory, add to structure and call process tags with path --->
			<cfif len(arguments.packageKey)>
				<cfset package = "#packageKey#.#name#" />
			<cfelse>
				<cfset package = name />		
			</cfif>
			
			<cfset packageID = createUUID() />
			<cfset arguments.packages[packageID] = structNew() />
			<cfset arguments.packages[packageID].path = directory & "\" & name />
			<cfset arguments.packages[packageID].name = package />
			
			<cfset processTags(directory & "\" & name, package,arguments.packages, arguments.tags) />
			<cfelseif qryDir.type EQ "FILE" AND qryDir.attributes NEQ "H" AND right(qryDir.name,4) EQ ".cfm">
			<!--- if it's a file, do nothing --->
				<cfset fileID = createUUID() />
				<cfset arguments.tags[fileID] = structNew() />
				<cfset arguments.tags[fileID].path = directory & "\" & name />
				<cfset arguments.tags[fileID].package = arguments.packageKey />
				<cfset arguments.tags[fileID].params = structNew() />
				<cfset arguments.tags[fileID].name = name />
				
				<cfset tag = structNew() />
				<cfset tag = parseFile(directory & "\" & name) />
				<cfset arguments.tags[fileID].params = tag.params />
				<cfset arguments.tags[fileID].comment = tag.comment />
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="parseFile" access="public" returntype="struct" output="false">
		<cfargument name="filePath" type="string" required="true">
		<cfset var aParams = arrayNew(1) />
		<cfset var stTag = structNew() />
		<cfset stTag.params = structNew() />
		
		<cffile action="read" file="#arguments.filePath#" variable="tagContents">
		
		<cfset aParams = getAttributes(tagContents) />
		
		<cfloop from="1" to="#arrayLen(aParams)#" index="i">
			<cfset stParams = structNew()>
			<cfset structAppend(stParams,getTagAttributes(aParams[i].tagblock,'cfparam'),true)>
			<cfset stTag.params[stParams.name] = stParams />
		</cfloop>
		
		<cfset stTag.comment = getComment(tagContents) />
		
		<cfreturn stTag />
	</cffunction>
	
	
	<!--- accessors/mutators --->
	<cffunction name="getComment" access="public" returntype="string" output="false" hint="I build a struct from a passed absolute directory.">
		<cfargument name="tagContents" type="string" required="true">
		
		<cfscript>
			var tmp = "";
			var comment = "";
		</cfscript>

		<cfscript>
			tmp = reFind('(<!\-\-.+?\-\->)|(/\*.+?\*/)', tagContents, 1, "yes");
			if ( tmp.pos[1] ) {
				comment = mid(tagContents, tmp.pos[1], tmp.len[1]);
				comment = replace(comment, "<!---", "");
				comment = replace(comment, "<!--", "");
				comment = replace(comment, "--->", "");
				comment = replace(comment, "-->", "");
				comment = replace(comment, "/*", "");
				comment = replace(comment,"*/","");
			} else {
				comment = "No comment block found.";
			}
		</cfscript>

		<cfreturn comment />
	</cffunction>
	
	
	<cffunction name="getSeedDir" access="public" returntype="string" output="false" hint="accessor">

		<cfreturn variables.seedDir />
	</cffunction>
	<cffunction name="setSeedDir" access="private" returntype="void" output="false" hint="mutator">
		<cfargument name="property" type="string" required="true" />

		<cfset variables.seedDir = arguments.property />
	</cffunction>
	
	<cffunction name="getDirectory" access="public" returntype="query" output="false">
		<cfargument name="dir" type="string" required="true" />
		
		<cfdirectory name="qryDir" directory="#arguments.dir#" action="list" />
		
		<cfreturn qryDir />
	</cffunction>
	
	<cffunction name="findTags" access="private" returntype="array" output="true" hint="The findTags method searches the document for the given startTag and endTag. It returns an array of structures containing the locations in the document of the start and end position of each tag, and the full contents of the tag itself.">
		<cfargument name="document" type="string" required="yes">
		<cfargument name="startTag" type="string" required="yes">
		<cfargument name="endTag" type="string" required="yes">
		
		<!--- Find and remove comments --->
		<cfset var tagLocations = arrayNew(1)>
		<cfset var nestingLevel = 1>
		<cfset var searchMode = "start">
		<cfset var position = 1>
		<cfset var i = 0>
		<cfset var j = 0>
		<cfset var tagBegin = 0>
		<cfset var tagEnd = 0>
		<cfset var tagBlock = "">
		<cfset var tmpPosition = 0>
		<cfset var nestCount = 0>
		<cfset var padding = "">
		<cfset var lastReturn = "">
		<cfset var lastSpace = "">
		
		<cfloop from="1" to="#len(document)#" index="i">
			
			<cfif searchMode is "start">
			
				<cfset tagBegin = findNoCase(startTag,document,position)>
				
				<cfif tagBegin>
					<cfset position = tagBegin + len(startTag)>
					<cfset searchMode = "end">
					<!--- <cfoutput>Start Tag found at character #tagBegin#<br></cfoutput> --->
				<cfelse>
					<cfbreak>
				</cfif>
			
			<cfelse>	
			
				<cfset tagEnd = find(endTag,document,position)>
				
				<cfif tagEnd>
					<cfset tagEnd = tagEnd + len(endTag)>
					<cfset position = tagEnd>
					<!--- <cfoutput>End Tag found at character #tagEnd#<br></cfoutput> --->
				<cfelse>
					<cfbreak>
				</cfif>
				
				<cfset tagBlock = mid(document,tagBegin,tagEnd-tagBegin)>
				
				<cfset tmpPosition = 1>
				<cfset nestCount = 0>
				<cfloop from="1" to="#len(tagBlock)#" index="j">
					<cfif findNoCase(startTag,tagBlock,tmpPosition)>
						<cfset tmpPosition = findNoCase(startTag,tagBlock,tmpPosition) + len(startTag)>
						<cfset nestCount = nestCount + 1>
					<cfelse>
						<cfbreak>
					</cfif>
					<!--- <cfoutput>TmpPosition: #tmpPosition#(#htmlEditFormat(mid(tagBlock,tmpPosition,len(tagBlock)))#)<br></cfoutput> --->
				</cfloop>
				
				<!--- <cfoutput>count - #nestCount# :: Level - #nestingLevel#<br></cfoutput> --->
				<cfif nestCount EQ nestingLevel>
					
					<cfset lastSpace = reFindNoCase('[#chr(32)##chr(9)#][^#chr(32)##chr(9)#]+$',tagBlock)>
					<cfset lastReturn = reFindNoCase('[#chr(10)##chr(13)#][^#chr(10)##chr(13)#]+$',tagBlock)>
					
					<cfset padding = "">
					
					<cfif lastReturn AND lastSpace AND lastReturn LT lastSpace>
						<cfset padding = mid(tagBlock,lastReturn+1,lastSpace-lastReturn)>
					</cfif>
				
					
					<cfset stTag = structNew()>
					<cfset stTag.start = tagBegin>
					<cfset stTag.end = tagEnd>
					<cfset stTag.tagBlock = padding & tagBlock>
					<cfset arrayAppend(tagLocations,stTag)>
					<cfset searchMode = "start">
				<cfelse>
					<cfset nestingLevel = nestingLevel + 1>
				</cfif>
				
			</cfif>
			
		</cfloop>
		<cfreturn tagLocations>
	</cffunction>
	
	<cffunction name="getAttributes" access="public" returntype="array" output="false" hint="Calls the findTags method to retrieve all cfarguments tags in the given document. This method should be passed the body of a cffunction tag as the document argument.">
		<cfargument name="document" type="string" required="true">
		<cfreturn findTags(document,"<cf"&"param ",">")>
		
	</cffunction>
	
	<cffunction name="getTagAttributes" access="public" returntype="struct" output="false" hint="Parses the attributes out of the given document for the first occurrence of the tag specified and returns a structure containing name value pairs for the tag attributes.">
		<cfargument name="document" type="string" required="true">
		<cfargument name="tagname" type="string" required="true">
		
		<cfset var startTag = "">
		<cfset var stAttributes = structNew()>
		<cfset var aTmp = reFindNoCase('<#arguments.tagname#[^>]*>',document,1,true)>
		<cfset var i = 1>
		<cfset var position = 1>
		<cfset var regex = '[[:space:]][^=]+="[^"]*"' >
		
		<cfif NOT aTmp.pos[1]>
			<cfreturn stAttributes>
		</cfif>
		
		<cfset startTag = mid(document,aTmp.pos[1],aTmp.len[1])>

		<cfloop from="1" to="#len(startTag)#" index="i">
			<cfif reFindNoCase(regex,startTag,position)>
				<cfset aTmp = reFindNoCase(regex,startTag,position,true)>
				<cfset attribute = trim(mid(startTag,aTmp.pos[1],aTmp.len[1]))>
				<cfset stAttributes[listFirst(attribute,'=')] = mid(listLast(attribute,'='),2,len(listLast(attribute,'='))-2)>
				<cfset position = aTmp.pos[1] + aTmp.len[1]>
			</cfif>
		</cfloop>
		
		<cfset stAttributes.fullTag = startTag>

		<cfreturn stAttributes>
		
		
	</cffunction>
	
</cfcomponent>