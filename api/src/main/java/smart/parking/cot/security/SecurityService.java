package smart.parking.cot.security;

import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import smart.parking.cot.Entity.Role;
import smart.parking.cot.Entity.RoleDTO;
import smart.parking.cot.Entity.User;
import smart.parking.cot.Entity.UserDTO;
import smart.parking.cot.Repository.UserRepository;
import smart.parking.cot.Repository.UserTokenRepository;
import smart.parking.cot.security.oauth2.Oauth2Request;
import smart.parking.cot.security.oauth2.UserToken;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Event;
import jakarta.inject.Inject;
import jakarta.security.enterprise.SecurityContext;
import jakarta.security.enterprise.identitystore.Pbkdf2PasswordHash;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@ApplicationScoped
public class SecurityService {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private UserRepository repository;

    @Inject
    private UserTokenRepository token_repository;

    @Inject
    private Pbkdf2PasswordHash passwordHash;

    @Inject
    private Validator validator;

    @Inject
    private SecurityContext securityContext;



    @Inject
    private Event<RemoveToken> removeTokenEvent;


    public void create(UserDTO userDTO) {
        if (repository.existsById(userDTO.getEmail())) {
            throw new UserAlreadyExistException("There is an user with this id: " + userDTO.getEmail());
        } else {
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            User user = User.builder()
                    .withFullname(userDTO.getFull_name())
                    .withRegistration_date(dtf.format(now))
                    .withLast_active(dtf.format(now))
                    .withPasswordHash(passwordHash)
                    .withPassword(userDTO.getPassword())
                    .withEmail(userDTO.getEmail())
                    .withPhonenumber(userDTO.getPhonenumber())
                    .withRoles(getRole())
                    .build();
            repository.save(user);
        }
    }

    public void delete(String id) {
        repository.deleteById(id);
    }

    public void updatePassword(String id, UserDTO dto) {

        final Principal principal = securityContext.getCallerPrincipal();
        if (isForbidden(id, securityContext, principal)) {
            throw new UserForbiddenException();
        }

        final User user = repository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        user.updatePassword(dto.getPassword(), passwordHash);
        repository.save(user);
    }


    public void addRole(String id, RoleDTO dto) {
        final User user = repository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));

        user.add(dto.getRoles());
        repository.save(user);

    }


    public void removeRole(String id, RoleDTO dto) {
        final User user = repository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
        user.remove(dto.getRoles());
        repository.save(user);
    }

    public UserDTO getUser() {
        final User user = getLoggedUser();
        UserDTO dto = toDTO(user);
        return dto;
    }

    public List<UserDTO> getUsers() {
        return repository.findAll()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }
    public int numberUsers(){
        return getUsers().size();
    }



    public User findBy(String username, String password) {
        final User user = repository.findById(username)
                .orElseThrow(() -> new UserNotAuthorizedException());

        if (passwordHash.verify(password.toCharArray(), user.getPassword())) {
            return user;
        }
        throw new UserNotAuthorizedException();

    }

    public User findBy(String username) {
        return repository.findById(username)
                .orElseThrow(() -> new UserNotAuthorizedException());
    }

    public void removeUser(String userId) {
        final User user = repository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(userId));
        repository.deleteById(user.getEmail());

    }

    public void removeToken(String token) {
        final User loggedUser = getLoggedUser();
        RemoveToken removeToken = new RemoveToken(loggedUser, token);
        removeTokenEvent.fire(removeToken);
    }

    private User getLoggedUser() {
        final Principal principal = securityContext.getCallerPrincipal();
        if (principal == null) {
            throw new UserNotAuthorizedException();
        }
        return repository.findById(principal.getName())
                .orElseThrow(() -> new UserNotFoundException(principal.getName()));
    }

    private UserDTO toDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setEmail(user.getEmail());
        dto.setPhonenumber(user.getPhonenumber());
        dto.setLast_active(user.getLast_active());
        dto.setFull_name(user.getFull_name());
        dto.setRegistration_date(user.getRegistration_date());
        dto.setRoles(user.getRoles());
        return dto;
    }

    private Set<Role> getRole() {
        if (repository.count() == 0) {
            return Collections.singleton(Role.ADMIN);
        } else {
            return Collections.singleton(Role.USER);
        }
    }

    private boolean isForbidden(String id, SecurityContext context, Principal principal) {
        return !(context.isCallerInRole(Role.ADMIN.name()) || id.equals(principal.getName()));
    }


}
