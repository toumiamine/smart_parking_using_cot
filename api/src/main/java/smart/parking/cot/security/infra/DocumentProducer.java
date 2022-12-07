package smart.parking.cot.security.infra;

import jakarta.nosql.document.DocumentCollectionManager;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Disposes;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Inject;

@ApplicationScoped
public class DocumentProducer {


    @Inject
    @ConfigProperty(name = "document")
    private DocumentCollectionManager manager;

    @Produces
    public DocumentCollectionManager getManager() {
        return manager;
    }

    public void destroy(@Disposes DocumentCollectionManager manager) {
        manager.close();
    }
}
