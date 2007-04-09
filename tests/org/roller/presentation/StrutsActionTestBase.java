package org.roller.presentation;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.roller.RollerTestBase;
import org.roller.presentation.filters.PersistenceSessionFilter;
import org.roller.presentation.filters.RequestFilter;

import com.mockrunner.mock.web.ActionMockObjectFactory;
import com.mockrunner.mock.web.MockHttpServletRequest;
import com.mockrunner.mock.web.MockServletContext;
import com.mockrunner.mock.web.WebMockObjectFactory;
import com.mockrunner.servlet.ServletTestModule;
import com.mockrunner.struts.ActionTestModule;
import com.mockrunner.struts.MapMessageResources;

/** 
 * Base for Struts Action testing. 
 * @author Dave Johnson
 */
public class StrutsActionTestBase extends RollerTestBase
{     
    private ActionMockObjectFactory mockFactory;
    protected MockRollerContext rollerContext;
    protected ActionTestModule strutsModule;
    protected ServletTestModule servletModule;

    public void setUp() throws Exception
    {
        super.setUp();       
        getMockFactory().refresh();
        strutsModule = new ActionTestModule(getStrutsMockFactory()); 
        servletModule = new ServletTestModule(getStrutsMockFactory());
        
        MapMessageResources resources = new MapMessageResources();
        resources.putMessages("WEB-INF/classes/ApplicationResources.properties");
        strutsModule.setResources(resources);
        
        MockServletContext ctx = getMockFactory().getMockServletContext();
        ctx.setRealPath("/", "");
        rollerContext = new MockRollerContext();
        rollerContext.init(ctx);
    }
    protected void authenticateUser(String username, String role)
    {
        MockHttpServletRequest mockRequest = getMockFactory().getMockRequest();
        mockRequest.setRemoteUser(username);
        mockRequest.setUserPrincipal(new MockPrincipal(username));
        mockRequest.setUserInRole(role, true);
    }
    
    protected void doFilters()
    {
        servletModule.createFilter(PersistenceSessionFilter.class);
        servletModule.createFilter(RequestFilter.class);
        servletModule.setDoChain(true);
        servletModule.doFilter();        
        getMockFactory().addRequestWrapper(new HttpServletRequestWrapper(
            (HttpServletRequest)servletModule.getFilteredRequest()));
    }
    protected ActionMockObjectFactory getStrutsMockFactory()
    {
        return (ActionMockObjectFactory)getMockFactory();
    }
    protected WebMockObjectFactory getMockFactory()
    {
        if (mockFactory == null) 
        {
            mockFactory = new ActionMockObjectFactory();
        }
        return mockFactory;
    }
}