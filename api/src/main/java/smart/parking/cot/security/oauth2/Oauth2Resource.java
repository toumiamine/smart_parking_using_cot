package smart.parking.cot.security.oauth2;

import smart.parking.cot.security.oauth2.Oauth2Request;
import smart.parking.cot.security.oauth2.Oauth2Response;
import smart.parking.cot.security.oauth2.Oauth2Service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.BeanParam;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import java.util.Map;

@ApplicationScoped
@Path("oauth2")
public class Oauth2Resource {
    @Inject
    private Oauth2Service service;

    @POST
    @Path("login")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, Object> token(@Valid Oauth2Request request) {
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
