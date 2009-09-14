<%--
  Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  The ASF licenses this file to You
  under the Apache License, Version 2.0 (the "License"); you may not
  use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.  For additional information regarding
  copyright in this work, please see the NOTICE file in the top level
  directory of this distribution.
--%>
<%@ include file="/WEB-INF/jsps/taglibs-struts2.jsp" %>
<link rel="stylesheet" type="text/css" href="<s:url value='/roller-ui/styles/yui/reset-fonts-grids.css'/>" />
<link rel="stylesheet" type="text/css" href="<s:url value='/roller-ui/styles/yui/container.css'/>" />
<link rel="stylesheet" type="text/css" href="<s:url value='/roller-ui/styles/yui/menu.css'/>" />

<script type="text/javascript" src="<s:url value='/roller-ui/scripts/yui/yahoo-dom-event.js'/>"></script>
<script type="text/javascript" src="<s:url value='/roller-ui/scripts/yui/container_core-min.js'/>"></script>
<script type="text/javascript" src="<s:url value='/roller-ui/scripts/yui/menu-min.js'/>"></script>

<style type="text/css">
    body {
        margin:0;
        padding:0;
        text-align:left;
    }
    h1   {
        font-size:20px;
        font-weight:bold;
    }
    .yui-overlay {
        position:fixed;
        background: #ffffff;
        z-index: 112;
        color:#000000;
        border: 4px solid #525252;
        text-align:left;
        top: 50%;
        left: 50%;
    }
</style>
<script type="text/javascript">
    YAHOO.util.Event.onContentReady("myMenu", function () {
        var oClones = this;

        function findMediaFileIdForLineItem(lineItemNode) {
            var findMediaFileIdNode = function(node) {
                return (node.id == 'mediafileidentity');
            }
            var temp_elements = YAHOO.util.Dom.getElementsBy(findMediaFileIdNode,"input",lineItemNode);
            return temp_elements[0].value;
        }

        function deleteMedia(p_oLI) {
            var lineItemNode = YAHOO.util.Dom.getAncestorByTagName(p_oLI, "LI");
            var hidden_mediaFileId_value = findMediaFileIdForLineItem(lineItemNode);
            document.mediaFileSearchForm.mediaFileId.value=hidden_mediaFileId_value;
            document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!delete" />';
            document.mediaFileSearchForm.submit();
        }

        function createPost(p_oLI) {
            var lineItemNode = YAHOO.util.Dom.getAncestorByTagName(p_oLI, "LI");
            var hidden_mediaFileId_value = findMediaFileIdForLineItem(lineItemNode);
            document.mediaFileSearchForm.mediaFileId.value = hidden_mediaFileId_value;
            document.mediaFileSearchForm.action = '<s:url action="entryAddWithMediaFile"></s:url>';
            document.mediaFileSearchForm.submit();
        }

        function includeMedia(p_oLI) {
            var lineItemNode = YAHOO.util.Dom.getAncestorByTagName(p_oLI, "LI");
            var hidden_mediaFileId_value = findMediaFileIdForLineItem(lineItemNode);
            document.mediaFileSearchForm.mediaFileId.value=hidden_mediaFileId_value;
            document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!includeInGallery" />';
            document.mediaFileSearchForm.submit();
        }

        function onEweContextMenuClick(p_sType, p_aArgs) {

            var oItem = p_aArgs[1],
            oTarget = this.contextEventTarget,
            oLI;

            if (oItem) {
                oLI = oTarget.className == "contextMenu" ?
                    oTarget : YAHOO.util.Dom.getAncestorByClassName(oTarget, "contextMenu");
                switch (oItem.index) {

                    case 0:// delete
                        deleteMedia(oLI);
                        break;
                    case 1:// create post
                        createPost(oLI);
                        break;
                    case 2:// include in gallery
                        includeMedia(oLI);
                        break;
                }
            }
        }

        /*
              Array of text labels for the MenuItem instances to be
              added to the ContextMenu instanc.
         */

        var aMenuItems = ["Delete", "Create Post", "Include in Gallery" ];

        /*
              Instantiate a ContextMenu:  The first argument passed to the constructor
              is the id for the Menu element to be created, the second is an
              object literal of configuration properties.
         */

        var oEweContextMenu = new YAHOO.widget.ContextMenu(
        "ewecontextmenu",
        {
            trigger: oClones.getElementsByClassName("contextMenu"),
            itemdata: aMenuItems,
            lazyload: true
        }
    );

        // "render" event handler for the ewe context menu

        function onContextMenuRender(p_sType, p_aArgs) {

            //  Add a "click" event handler to the ewe context menu

            this.subscribe("click", onEweContextMenuClick);

        }

        // Add a "render" event handler to the ewe context menu

        oEweContextMenu.subscribe("render", onContextMenuRender);


    });

    YAHOO.example = function() {
        var $D = YAHOO.util.Dom;
        var $E = YAHOO.util.Event;
        return {
            init : function() {
                var overlay_img = new YAHOO.widget.Overlay("overlay_img", { fixedcenter:true,
                    visible:false,
                    width:"577px",height:"550px"
                });
                overlay_img.render();
                var overlay = document.createElement('div');
                overlay.id = 'overlay';
                // Assign 100% height and width
                overlay.style.width = '100%';
                overlay.style.height = '100%';
                document.getElementsByTagName('body')[0].appendChild(overlay);
                overlay.style.display = 'none';
            }
        };
    }();

    YAHOO.util.Event.addListener(window, "load", YAHOO.example.init);
</script>

<%-- JavaScript for media file search page--%>
<script type="text/javascript">
    <!--

    function onDelete(id)
    {
        document.mediaFileSearchForm.mediaFileId.value=id;
        document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!delete" />';
        document.mediaFileSearchForm.submit();
    }

    function onIncludeInGallery(id)
    {
        document.mediaFileSearchForm.mediaFileId.value=id;
        document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!includeInGallery" />';
        document.mediaFileSearchForm.submit();
    }


    function onDeleteSelected()
    {
        if ( confirm("<s:text name='mediaFile.delete.confirm' />") ) {
            document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!deleteSelected" />';
            document.mediaFileSearchForm.submit();
        }
    }

    function onMoveSelected()
    {
        if ( confirm("<s:text name='mediaFile.move.confirm' />") ) {
            document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!moveSelected" />';
            document.mediaFileSearchForm.submit();
        }
    }

    function onClickInsert(id, url, text, isImage)
    {
        var filePointer;
        if (isImage) {
            document.mediaFileSearchForm.mediaFileId.value=id;
            document.mediaFileSearchForm.action='<s:url action="mediaFileImageDim" />';
            document.mediaFileSearchForm.submit();
        }
        else {
            var filePointer = "<a href='" + url + "'>" + text + "</a>";
            parent.onClose(filePointer);
        }
    }

    function onCreateDirectory()
    {
        document.mediaFileSearchForm.action='<s:url action="mediaFileSearch!createDirByPath" />';
        document.mediaFileSearchForm.submit();
    }
    function onNext()
    {
        document.mediaFileSearchForm["bean.pageNum"].value = parseInt(document.mediaFileSearchForm["bean.pageNum"].value) +  1;
        document.mediaFileSearchForm.submit();
    }
    function onPrevious()
    {
        document.mediaFileSearchForm["bean.pageNum"].value = parseInt(document.mediaFileSearchForm["bean.pageNum"].value) -  1;
        document.mediaFileSearchForm.submit();
    }
    function onClose()
    {
        document.getElementById('overlay').style.display = 'none';
        document.getElementById('overlay_img').style.visibility = 'hidden';
    }
    function onClickEdit(mediaFileId)
    {
        var browser=navigator.appName;
        document.getElementById("overlay_img").style.visibility = "visible";
        document.getElementById('overlay').style.display = 'block';

        var frame = document.createElement('iframe');
        frame.setAttribute("id","myframe");
        frame.setAttribute("frameborder","no");
        frame.setAttribute("scrolling","auto");
        frame.setAttribute('src','<s:url action="mediaFileEdit"><s:param name="weblog" value="%{actionWeblog.handle}" /></s:url>&mediaFileId='+mediaFileId );
        frame.style.width="100%";
        frame.style.height="100%";
        if (browser=="Microsoft Internet Explorer") {
            document.getElementById("overlay_img").style.top= "40px";
            document.getElementById("overlay_img").style.left= "170px";
            document.getElementById("overlay_img").style.height= "500px";
        }
        document.getElementById("overlay_img").innerHTML = '<div ><a href="#" class="container-close" onclick="onClose()"></a></div>';
        document.getElementById("overlay_img").appendChild(frame);
    }
    -->
</script>

<p class="subtitle">
    Search uploaded files
</p>

<s:form id="mediaFileSearchForm" name="mediaFileSearchForm" action="mediaFileSearch!search" onsubmit="editorCleanup()">
    <s:hidden name="weblog" />
    <input type="hidden" name="mediaFileId" value="" />
    <table class="mediaFileSearchTable" cellpadding="0" cellspacing="3" width="100%">
        <tr>
            <td>
                <label for="name">Name</label>
            </td>
            <td>
                <s:textfield name="bean.name" size="40" maxlength="255" />
            </td>
            <td>
                <label for="type">File Type</label>
            </td>
            <td>
                <s:select name="bean.type" list="fileTypes" />
            </td>
        </tr>
        <tr>
            <td>
                <label for="size">Size</label>
            </td>
            <td width="80%">
                <s:select name="bean.sizeFilterType" list="sizeFilterTypes" listKey="key" listValue="value" />
                <s:textfield name="bean.size" size="3" maxlength="10" />
                <s:select name="bean.sizeUnit" list="sizeUnits" listKey="key" listValue="value" />
            </td>
            <td width="10%">
                <label for="tags">Tags</label>
            </td>
            <td>
                <s:textfield name="bean.tags" size="20" maxlength="50" />
            </td>
        </tr>
        <tr>
            <td>
                <input style="margin:5px 0px;" type="submit" name="search" value="Search" />
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <div id="overlay_img" style="visibility:hidden">
    </div>

    <div class="control">
        <span style="padding-left:20px">Sort by:</span>
        <s:select name="bean.sortOption" list="sortOptions" listKey="key" listValue="value" />
        <s:if test="!pager.justOnePage">
            <span style="padding-left:300px">
                <s:if test="pager.hasPrevious()"><a href="#" onclick="onPrevious()">&lt;Previous</a></s:if>
                <s:if test="pager.hasNext()"><a href="#" onclick="onNext()">Next&gt;</a></s:if>
                <span>
                </s:if>
                </div>

                <s:hidden name="bean.pageNum" />

                <%-- ================================================================== --%>
                <%-- Title, category, dates and other metadata --%>

                <ul id = "myMenu" style="margin-top:10px">

                    <s:iterator id="mediaFile" value="pager.items">
                        <li class="align-images">
                            <div style="border:1px solid #000000;width:120px;height:100px;margin:5px;">
                                <s:if test="#mediaFile.imageFile">
                                    <s:url id="mediaFileURL" value="/roller-ui/rendering/media-resources/%{#mediaFile.id}"></s:url>
                                </s:if>
                                <s:else>
                                    <s:url id="mediaFileURL" value="/images/page.png"></s:url>
                                </s:else>
                                <img border="0" src='<s:property value="%{mediaFileURL}" />' <s:if test="#mediaFile.imageFile">width="120px" height="100px" </s:if> <s:else>style="padding:40px 50px;"</s:else>/>
                            </div><br/>

                            <div style="clear:left;width:130px;margin-left:5px;font-size:11px;"><label><s:property value="#mediaFile.name" /></label><br />
                                <label style="color:blue"><s:property value="#mediaFile.directory.path" /></label>
                                <div style="padding-top:5px;">   <!--  one -->
                                    <input style="float:left;" type="checkbox" name="selectedMediaFiles" value="<s:property value="#mediaFile.id"/>"/>
                                    <INPUT TYPE="hidden" id="mediafileidentity" value="<s:property value='#mediaFile.id'/>">
                                    <s:if test="overlayMode">
                                        <div style="float:right;">
                                            <a  href="#" onclick="onClickInsert('<s:property value="#mediaFile.id" />', '<s:url value="/roller-ui/rendering/media-resources/%{#mediaFile.id}" />', '<s:property value="#mediaFile.name" />', <s:property value="#mediaFile.imageFile" />)">Insert</a>
                                        </div>
                                    </s:if>
                                    <s:else>
                                        <div style="float:right;">
                                            <a  href="#" id="<s:property value='#mediaFile.id'/>" onclick="onClickEdit(this.id)">Edit</a>

                                            <a  class="contextMenu" href="#">More...</a>
                                        </div>
                                    </s:else>
                                </div>  <!-- one -->
                            </div>
                        </li>
                    </s:iterator>
                </ul>


                <br/>
                <s:if test="!overlayMode">
                    <div style="width: 100%; clear:both; padding-top:2em">
                        <label>New Directory:</label>
                        <input type="text" name="newDirectoryPath" size="30" />
                        <input type="button" value="Create" onclick="onCreateDirectory()" />
                    </div>
                </s:if>

                </div>


                <br/>
                <div class="control">
                    <s:if test="!overlayMode">
                        <input type="button" style="padding-left:20px" value="Delete Selected" onclick="onDeleteSelected()" />
                        <input type="button" style="padding-left:20px" value="Move Selected" onclick="onMoveSelected()" />
                        <span style="padding-left:20px">
                            <s:select name="selectedDirectory" list="allDirectories" listKey="id" listValue="path" />
                        </span>
                    </s:if>
                </div>
            </s:form>

