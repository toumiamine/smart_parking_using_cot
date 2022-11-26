package smart.parking.cot.Entity;

import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;

import javax.security.enterprise.identitystore.Pbkdf2PasswordHash;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import static java.util.Objects.requireNonNull;
import static java.util.stream.Collectors.toUnmodifiableSet;

@Entity
public class User {
    @Id
    private String email;
    @Column
    private String password;

    @Column
    private String phonenumber;

    @Column
    private Set<Role> roles;

    User() {
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public Set<String> getRoles() {
        if (roles == null) {
            return Collections.emptySet();
        }
        return roles.stream().map(Role::get)
                .collect(toUnmodifiableSet());
    }

    public void add(Set<Role> roles) {
        if (this.roles == null) {
            this.roles = new HashSet<>();
        }
        this.roles.addAll(roles);
    }

    public void remove(Set<Role> roles) {
        if (this.roles == null) {
            this.roles = new HashSet<>();
        }
        this.roles.removeAll(roles);
    }

    public void updatePassword(String password, Pbkdf2PasswordHash passwordHash) {
        this.password = passwordHash.generate(password.toCharArray());
    }

    public boolean isAdmin() {
        return getRoles().stream().anyMatch(Role.ADMIN::equals);
    }

    @Override
    public String toString() {
        return "User{" +
                "user='" + email + '\'' +
                ", password='" + password + '\'' +
                ", roles=" + roles +
                '}';
    }

    public static UserBuilder builder() {
        return new UserBuilder();
    }



    public static class UserBuilder {

        private String email;

        private String password;
        private String phonenumber;
        private Set<Role> roles;

        private Pbkdf2PasswordHash passwordHash;

        private UserBuilder() {
        }

        public UserBuilder withEmail(String email) {
            this.email = email;
            return this;
        }

        public UserBuilder withPhonenumber(String phonenumber) {
            this.phonenumber = phonenumber;
            return this;
        }

        public UserBuilder withPassword(String password) {
            this.password = password;
            return this;
        }

        public UserBuilder withRoles(Set<Role> roles) {
            this.roles = roles;
            return this;
        }

        public UserBuilder withPasswordHash(Pbkdf2PasswordHash passwordHash) {
            this.passwordHash = passwordHash;
            return this;
        }

        public User build() {
            requireNonNull(phonenumber);
            requireNonNull(email, "email is required");
            requireNonNull(password, "password is required");
            requireNonNull(roles, "roles is required");
            requireNonNull(passwordHash, "passwordHash is required");

            User user = new User();
            user.roles = roles;
            user.email = email;
            user.phonenumber = phonenumber;
            user.password = passwordHash.generate(password.toCharArray());
            return user;
        }
    }

}
