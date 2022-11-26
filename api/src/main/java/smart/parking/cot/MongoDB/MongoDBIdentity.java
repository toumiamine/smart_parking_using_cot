package smart.parking.cot.MongoDB;

import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import smart.parking.cot.Entity.User;
import smart.parking.cot.Repository.UserRepository;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.security.enterprise.credential.CallerOnlyCredential;
import javax.security.enterprise.credential.Credential;
import javax.security.enterprise.identitystore.CredentialValidationResult;
import javax.security.enterprise.identitystore.IdentityStore;
import java.util.Optional;

import static javax.security.enterprise.identitystore.CredentialValidationResult.INVALID_RESULT;

@ApplicationScoped
public class MongoDBIdentity implements IdentityStore {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private UserRepository repository;

    @Override
    public int priority() {
        return 10;
    }

    @Override
    public CredentialValidationResult validate(Credential credential) {

        if (credential instanceof CallerOnlyCredential) {
            CallerOnlyCredential callerOnlyCredential = CallerOnlyCredential
                    .class.cast(credential);

            final Optional<User> userOptional = repository.findById(callerOnlyCredential.getCaller());
            if (userOptional.isPresent()) {
                final User user = userOptional.get();
                return new CredentialValidationResult(user.getEmail(), user.getRoles());
            }
        }
        return INVALID_RESULT;
    }

}
