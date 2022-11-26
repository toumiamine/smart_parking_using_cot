package smart.parking.cot.security.infra.mappers;

import smart.parking.cot.security.UserForbiddenException;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

@Provider
public class UserForbiddenExceptionMapper implements ExceptionMapper<UserForbiddenException> {
    @Override
    public Response toResponse(UserForbiddenException exception) {
        return Response.status(Response.Status.FORBIDDEN).build();
    }
}
