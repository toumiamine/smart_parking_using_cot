package smart.parking.cot.Ressources;

import jakarta.annotation.security.DenyAll;
import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.RequestScoped;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;

@Path("")
@RequestScoped
public class HelloWorldResource {

    public static void main(String[] args){

        System.out.println("Hello, World!");

    }
    @GET
    @PermitAll
    @Produces("text/plain")
    public String doGet() {
        return "hello from everyone";
    }

    @Path("admin")
    @GET
    @RolesAllowed("ADMIN")
    @Produces("text/plain")
    public String admin() {
        return "hello from admin";
    }

    @Path("user")
    @GET
    @RolesAllowed({"MANAGER","USER"})
    @Produces("text/plain")
    public String user() {
        return "hello from user";
    }
}
