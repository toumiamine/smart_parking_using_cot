package smart.parking.cot.security.oauth2;

import smart.parking.cot.Repository.UserTokenRepository;
import smart.parking.cot.security.RemoveToken;
import smart.parking.cot.security.RemoveUser;
import smart.parking.cot.Entity.User;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import javax.inject.Inject;

@ApplicationScoped
class Oauth2Observes {


    @Inject
    private UserTokenRepository repository;

    public void observe(@Observes RemoveUser removeUser) {
        final User user = removeUser.getUser();
        repository.deleteById(user.getEmail());
    }

    public void observe(@Observes RemoveToken removeToken) {
        final User user = removeToken.getUser();
        final String token = removeToken.getToken();
        UserToken userToken = repository.findById(user.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User was not found: " + user.getEmail()));
        userToken.remove(token);
        repository.save(userToken);
    }

}
