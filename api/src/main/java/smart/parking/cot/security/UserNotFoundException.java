package smart.parking.cot.security;

public class UserNotFoundException extends RuntimeException {

    public UserNotFoundException(String id) {
        super("User does not found with email: " + id);
    }
}
