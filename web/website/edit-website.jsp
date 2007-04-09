<%@ include file="/taglibs.jsp" %><%@ include file="/theme/header.jsp" %>

<roller:StatusMessage/>

<h1><fmt:message key="websiteSettings.title" /></h1>
<html:form action="/editor/website" method="post">
    <html:hidden property="method" value="update"/></input>

    <html:hidden property="id"/></input>
    <html:hidden property="weblogDayPageId" />
    <html:hidden property="locale"/></input>
    <html:hidden property="timezone"/></input>
    <html:hidden property="editorTheme"/></input>
    <html:hidden property="isEnabled"/></input>

<table>

    <tr>
        <td class="propname" width="30%"><fmt:message key="websiteSettings.websiteTitle" />
        <td><html:text property="name" size="60"/></input></td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.websiteDescription" /></td>
        <td><html:textarea property="description" rows="3" cols="40"/></td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.homePage" /></td>
        <td>
            <html:select property="defaultPageId" size="1">
                <html:options collection="pages"
                    property="id" labelProperty="name" />
            </html:select>
        </td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.editor" /></td>
        <td>
            <html:select property="editorPage" size="1">
                <html:options name="editorPagesList" />
            </html:select></p>
       </td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.defaultCategory" /></td>
        <td>
            <html:select property="defaultCategoryId" size="1">
                <html:options collection="categories"
                    property="id" labelProperty="path" />
            </html:select>
        </td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.allowComments" /></td>
        <td><html:checkbox property="allowComments" /></input></td>
    </tr>
<%
boolean emailComments = RollerRuntimeConfig.getBooleanProperty("users.comments.emailnotify");
if (emailComments) { %>
    <tr>
        <td class="propname"><fmt:message key="websiteSettings.emailComments" /></td>
        <td><html:checkbox property="emailComments" onclick="toggleNextRow(this)" /></input></td>
    </tr>

    <tr <c:if test="${!websiteFormEx.emailComments}">style="display: none"</c:if>>
        <td class="propname"><fmt:message key="websiteSettings.emailFromAddress" /></td>
        <td><html:text size="50" property="emailFromAddress" /></input></td>
    </tr>

    <tr>
        <td><h2><fmt:message key="websiteSettings.formatting" /></h2></td>
        <td></td>
    </tr>
<% } %>

<% if (org.roller.presentation.velocity.ContextLoader.hasPlugins()) { %>
    <tr>
        <td class="propname">Default Entry Formatters <br />(applied in the listed order)</td>
        <td>
        <logic:iterate id="plugin" type="org.roller.presentation.velocity.PagePlugin"
            collection="<%= org.roller.presentation.velocity.ContextLoader.getPagePlugins() %>">
            <html:multibox property="defaultPluginsArray"
                title="<%= plugin.getName() %>" value="<%= plugin.getName() %>" /></input>
            <label for="<%= plugin.getName() %>"><%= plugin.getName() %></label>
            <a href="javascript:void(0);" onmouseout="return nd();"
            onmouseover="return overlib('<%= plugin.getDescription() %>', STICKY, MOUSEOFF, TIMEOUT, 3000);">?</a>
            <br />
        </logic:iterate>
        </td>
    </tr>
<% } else { %>
    <html:hidden property="defaultPlugins" />
<% } %>

    <tr>
        <td><h2><fmt:message key="websiteSettings.bloggerApi" /></h2></td>
        <td></td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.enableBloggerApi" /></td>
        <td><html:checkbox property="enableBloggerApi" /></input></td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.bloggerApiCategory" /></td>
        <td>
            <html:select property="bloggerCategoryId" size="1">
                <html:options collection="bloggerCategories"
                    property="id" labelProperty="path" />
            </html:select>
        </td>
    </tr>

    <tr>
        <td><h2><fmt:message key="websiteSettings.spamPrevention" /></h2></td>
        <td></td>
    </tr>

    <tr>
        <td class="propname"><fmt:message key="websiteSettings.ignoreUrls" /></td>
        <td><html:textarea property="ignoreWords" rows="7" cols="60"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="buttonBox" colspan="2">
            <input type="submit" value='<fmt:message key="websiteSettings.button.update" />' />
        </td>
    </tr>
</table>

</html:form>

<%@ include file="/theme/footer.jsp" %>
