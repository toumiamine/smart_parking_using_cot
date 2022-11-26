package smart.parking.cot.security;

import smart.parking.cot.Entity.User;

public class RemoveUser {

    private final User user;

    public RemoveUser(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }
}
