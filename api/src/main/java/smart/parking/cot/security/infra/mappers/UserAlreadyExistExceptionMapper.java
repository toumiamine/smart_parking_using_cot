package smart.parking.cot.security.infra.mappers;

import smart.parking.cot.security.UserAlreadyExistException;

import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

@Provider
public class UserAlreadyExistExceptionMapper implements ExceptionMapper<UserAlreadyExistException> {

    @Override
    public Response toResponse(UserAlreadyExistException exception) {
        return Response.status(Response.Status.UNAUTHORIZED)
                .entity(new ErrorMessage(exception.getMessages()))
                .build();
    }
}
