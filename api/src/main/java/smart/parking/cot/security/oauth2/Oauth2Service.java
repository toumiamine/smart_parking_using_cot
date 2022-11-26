package smart.parking.cot.security.oauth2;

import smart.parking.cot.Repository.UserTokenRepository;
import smart.parking.cot.security.SecurityService;
import smart.parking.cot.Entity.User;
import smart.parking.cot.security.UserNotAuthorizedException;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.validation.Validator;
import java.time.Duration;
import java.util.Set;

@ApplicationScoped
public
class Oauth2Service {
    static final int EXPIRE_IN = 3600;
    static final Duration EXPIRES = Duration.ofSeconds(EXPIRE_IN);
    @Inject
    private SecurityService securityService;
    @Inject
    private UserTokenRepository repository;
    @Inject
    private Validator validator;
    public Oauth2Response token(Oauth2Request request) {

        final Set<ConstraintViolation<Oauth2Request>> violations = validator.validate(request, Oauth2Request
                .GenerateToken.class);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }

        final User user = securityService.findBy(request.getUsername(), request.getPassword());
        final UserToken userToken = repository.findById(request.getUsername()).orElse(new UserToken(user.getEmail()));

        final Token token = Token.generate();

        final String jwt = UserJWT.createToken(user, token, EXPIRES);

        AccessToken accessToken = new AccessToken(jwt, token.get(), EXPIRES);
        RefreshToken refreshToken = new RefreshToken(Token.generate(), accessToken);
        userToken.add(refreshToken);
        repository.save(userToken);
        return Oauth2Response.of(accessToken, refreshToken, EXPIRE_IN);
    }

    public Oauth2Response refreshToken(Oauth2Request request) {
        final Set<ConstraintViolation<Oauth2Request>> violations = validator.validate(request, Oauth2Request
                .RefreshToken.class);

        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }

        final UserToken userToken = repository.findByRefreshToken(request.getRefreshToken())
                .orElseThrow(() -> new UserNotAuthorizedException("Invalid Token"));
        final User user = securityService.findBy(userToken.getEmail());
        final Token token = Token.generate();
        final String jwt = UserJWT.createToken(user, token, EXPIRES);
        AccessToken accessToken = new AccessToken(token.get(), jwt, EXPIRES);
        RefreshToken refreshToken = userToken.update(accessToken, request.getRefreshToken(), repository);

        return Oauth2Response.of(accessToken, refreshToken, EXPIRE_IN);
    }

}
