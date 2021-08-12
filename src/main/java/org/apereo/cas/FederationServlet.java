package org.apereo.cas;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.cxf.fediz.core.Claim;
import org.apache.cxf.fediz.core.ClaimCollection;
import org.apache.cxf.fediz.core.FedizPrincipal;
import org.apache.cxf.fediz.core.SecurityTokenThreadLocal;
import org.w3c.dom.Element;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.security.Principal;
import java.util.Arrays;
import java.util.List;

public class FederationServlet extends HttpServlet {
    private static final long serialVersionUID = -9019993850246851112L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html>");
        out.println("<head><title>WS Federation Example</title></head>");
        out.println("<body>");
        out.println("Request url: " + request.getRequestURL());
        out.println("<p>");

        out.println("<br><b>User</b><p>");
        Principal p = request.getUserPrincipal();
        if (p != null) {
            out.println("Principal: <span id='principalId'>" + p.getName() + "</span><p>");
        }

        out.println("<br><b>Roles</b><p>");
        List<String> roleListToCheck = Arrays.asList("Admin", "Manager", "User", "Authenticated");
        for (String item : roleListToCheck) {
            out.println("Has role '" + item + "': " + (request.isUserInRole(item) ? "<b>yes</b>" : "no") + "<p>");
        }

        if (p instanceof FedizPrincipal) {
            FedizPrincipal fp = (FedizPrincipal) p;
            out.println("<br><b><span id='claims'>Claims</span></b>");
            ClaimCollection claims = fp.getClaims();
            out.println("<ul id='listOfClaims'>");
            int count = 0;
            for (Claim c : claims) {
                out.println("<li id='claim" + count + "'>" + c.getClaimType().toString().trim() + ":" + c.getValue() + "</li>");
                count++;
            }
            out.println("</ul>");
        } else {
            out.println("Principal is not instance of FedizPrincipal: " + p);
        }

        Element el = SecurityTokenThreadLocal.getToken();
        if (el != null) {
            out.println("<p>Bootstrap token...<p>");
            try {
                Transformer transformer = TransformerFactory.newInstance().newTransformer();
                transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
                StringWriter token = new StringWriter();
                transformer.transform(new DOMSource(el), new StreamResult(token));
                out.print("<pre id='assertion'>");
                out.println(StringEscapeUtils.escapeXml11(token.toString()));
                out.print("</pre>");
            } catch (Exception ex) {
                out.println("Failed to transform cached element to string: " + ex.toString());
                ex.printStackTrace();
            }
        } else {
            out.println("<p>Bootstrap token not cached in thread local storage");
        }
        out.println("</body>");
        out.println("</html>");
    }
}
