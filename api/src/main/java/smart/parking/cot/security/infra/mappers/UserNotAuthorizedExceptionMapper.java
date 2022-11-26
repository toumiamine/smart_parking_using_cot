package smart.parking.cot.security.infra.mappers;

import smart.parking.cot.security.UserNotAuthorizedException;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

@Provider
public class UserNotAuthorizedExceptionMapper implements ExceptionMapper<UserNotAuthorizedException> {

    @Override
    public Response toResponse(UserNotAuthorizedException exception) {
        return Response.status(Response.Status.UNAUTHORIZED)
                .entity(new ErrorMessage(exception.getMessages()))
                .build();
    }
}
