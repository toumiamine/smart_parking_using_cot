package smart.parking.cot.security.infra;

import jakarta.annotation.security.DeclareRoles;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

@ApplicationPath("")
@ApplicationScoped
@DeclareRoles({"ADMIN", "USER"})  // all roles that are used by the app
public class ApplicationConfig extends Application {




}
