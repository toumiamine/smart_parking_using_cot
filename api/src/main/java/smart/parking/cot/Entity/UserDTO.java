package smart.parking.cot.Entity;

import jakarta.nosql.mapping.Id;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Set;

public class UserDTO {
    @Id
    private String email;

    @NotBlank
    private String full_name;

    @NotBlank
    private String password;
    @NotNull
    @Size(min = 8, max = 8, message = "Invalid Phone number")
    private String phonenumber;

    private String registration_date;

    private String last_active;
    
    private Set<String> roles;

    public String getEmail() {
        return email;
    }

    public String getPhonenumber() {
        return phonenumber;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    public void setRegistration_date(String registration_date) {
        this.registration_date = registration_date;
    }
    public String getFull_name() {
        return full_name;
    }
    public String getRegistration_date() {
        return registration_date;
    }

    public String getLast_active() {
        return last_active;
    }

    public String getPassword() {
        return password;
    }

    public void setLast_active(String last_active) {
        this.last_active = last_active;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Set<String> getRoles() {
        return roles;
    }

    public void setRoles(Set<String> roles) {
        this.roles = roles;
    }

    @Override
    public String toString() {
        return "UserDTO{" +
                "email='" + email + '\'' +
                ", password='" + password + '\'' +
                "phonenumber='" + phonenumber + '\'' +
                '}';
    }
}
