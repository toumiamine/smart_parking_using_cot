package smart.parking.cot.security.infra.mappers;

import smart.parking.cot.security.UserNotFoundException;

import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import java.util.List;

@Provider
public class UserNotFoundExceptionMapper implements ExceptionMapper<UserNotFoundException> {

    @Override
    public Response toResponse(UserNotFoundException exception) {
        return Response.status(Response.Status.NOT_FOUND)
                .entity(new ErrorMessage(List.of(exception.getMessage())))
                .type(MediaType.APPLICATION_JSON).build();
    }
}
