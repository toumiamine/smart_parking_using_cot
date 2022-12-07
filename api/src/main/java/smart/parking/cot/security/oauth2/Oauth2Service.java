package smart.parking.cot.security.oauth2;

import smart.parking.cot.Repository.UserRepository;
import smart.parking.cot.Repository.UserTokenRepository;
import smart.parking.cot.security.SecurityService;
import smart.parking.cot.Entity.User;
import smart.parking.cot.security.UserNotAuthorizedException;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@ApplicationScoped
public class Oauth2Service {
    static final int EXPIRE_IN = 3600;
    static final Duration EXPIRES = Duration.ofSeconds(EXPIRE_IN);
    @Inject
    private SecurityService securityService;
    @Inject
    private UserTokenRepository repository;

    @Inject
    private UserRepository user_repository;
    @Inject
    private Validator validator;
    public Map<String, Object> token(Oauth2Request request) {

        final Set<ConstraintViolation<Oauth2Request>> violations = validator.validate(request, Oauth2Request
                .GenerateToken.class);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }

        final User user = securityService.findBy(request.getEmail(), request.getPassword());
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        LocalDateTime now = LocalDateTime.now();
        user.setLast_active(dtf.format(now));
        user_repository.save(user);
        final UserToken userToken = repository.findById(request.getEmail()).orElse(new UserToken(user.getEmail()));

        final Token token = Token.generate();

        final String jwt = UserJWT.createToken(user, token, EXPIRES);

        AccessToken accessToken = new AccessToken(jwt, token.get(), EXPIRES);
        RefreshToken refreshToken = new RefreshToken(Token.generate(), accessToken);
        userToken.add(refreshToken);
        repository.save(userToken);
        HashMap<String, Object> map = new HashMap<>();
        map.put("accessToken", accessToken.getToken());
        map.put("refreshToken", refreshToken.getToken());
        map.put("phone_number", user.getPhonenumber());
        map.put("role", user.getRoles());
        map.put("fullname", user.getFull_name());
        map.put("registration_date", user.getRegistration_date());
        map.put("last_active", user.getLast_active());
        return map;
       // return Oauth2Response.of(accessToken, refreshToken, EXPIRE_IN);
    }

    public Map<String, Object> refreshToken(Oauth2Request request) {
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
        HashMap<String, Object> map = new HashMap<>();
        map.put("accessToken", accessToken.getToken());
        map.put("refreshToken", refreshToken.getToken());
        return map;
    }

}
