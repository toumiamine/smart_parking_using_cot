package smart.parking.cot.security.oauth2;

import smart.parking.cot.Repository.UserTokenRepository;
import smart.parking.cot.security.RemoveToken;
import smart.parking.cot.Entity.User;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;

@ApplicationScoped
class Oauth2Observes {


    @Inject
    private UserTokenRepository repository;

    public void observe(@Observes RemoveToken removeToken) {
        final User user = removeToken.getUser();
        final String token = removeToken.getToken();
        UserToken userToken = repository.findById(user.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User was not found: " + user.getEmail()));
        userToken.remove(token);
        repository.save(userToken);
    }

}
