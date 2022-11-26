package smart.parking.cot.security.oauth2;

import smart.parking.cot.security.oauth2.Oauth2Request;
import smart.parking.cot.security.oauth2.Oauth2Response;
import smart.parking.cot.security.oauth2.Oauth2Service;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.validation.Valid;
import javax.ws.rs.BeanParam;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@ApplicationScoped
@Path("oauth2")
public class Oauth2Resource {
    @Inject
    private Oauth2Service service;

    @POST
    @Path("login")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    public Oauth2Response token(@BeanParam @Valid Oauth2Request request) {
        switch (request.getGrandType() ) {
            case PASSWORD:
                return service.token(request);
            case REFRESH_TOKEN:
                return service.refreshToken(request);
            default:
                throw new UnsupportedOperationException("There is not support to another type");
        }
    }
}
