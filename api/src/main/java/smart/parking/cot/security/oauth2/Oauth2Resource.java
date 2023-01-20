package smart.parking.cot.security.oauth2;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.HttpHeaders;
import smart.parking.cot.Entity.User;
import smart.parking.cot.security.oauth2.Oauth2Request;
import smart.parking.cot.security.oauth2.Oauth2Response;
import smart.parking.cot.security.oauth2.Oauth2Service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.core.MediaType;

import java.text.ParseException;
import java.util.Base64;
import java.util.Map;
import jakarta.ws.rs.core.Response;

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
                throw new UnsupportedOperationException("There is no support to another type");
        }
    }



}
