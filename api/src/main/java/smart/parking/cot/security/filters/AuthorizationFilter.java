package smart.parking.cot.security.filters;

import jakarta.annotation.Priority;
import jakarta.annotation.security.DenyAll;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.container.ResourceInfo;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;
import smart.parking.cot.security.UserForbiddenException;
import smart.parking.cot.security.UserNotAuthorizedException;

import java.lang.reflect.Method;

@Provider
@Priority(Priorities.AUTHORIZATION)
public class AuthorizationFilter implements ContainerRequestFilter {
    @Context
    private ResourceInfo resourceInfo;

    @Override
    public void filter(ContainerRequestContext requestContext) {
        Method method = resourceInfo.getResourceMethod();
        if (method.isAnnotationPresent(DenyAll.class)) {
            refuseRequest();
        }

        RolesAllowed rolesAllowed = method.getAnnotation(RolesAllowed.class);
        if (rolesAllowed != null) {
            performAuthorization(rolesAllowed.value(), requestContext);
            return;
        }
        if (method.isAnnotationPresent(PermitAll.class)) {
            return;
        }

        rolesAllowed =
                resourceInfo.getResourceClass().getAnnotation(RolesAllowed.class);
        if (rolesAllowed != null) {
            performAuthorization(rolesAllowed.value(), requestContext);
            return;
        }
        if (resourceInfo.getResourceClass().isAnnotationPresent(DenyAll.class)) {
            refuseRequest();
        }

        // Authorization is not required for non-annotated methods
    }

    private void performAuthorization(String[] rolesAllowed,
                                      ContainerRequestContext requestContext) {

        if (rolesAllowed.length > 0 && !isAuthenticated(requestContext)) {
            refuseRequest();
        }

        for (final String role : rolesAllowed) {
            if (requestContext.getSecurityContext().isUserInRole(role)) {
                return;
            }
        }

        refuseRequest();
    }

    private boolean isAuthenticated(final ContainerRequestContext requestContext) {
        // Return true if the user is authenticated or false otherwise
        return requestContext.getSecurityContext().getUserPrincipal() != null;
    }

    private void refuseRequest() {
        throw new UserNotAuthorizedException("You don't have permissions to perform this action.");
    }
}
