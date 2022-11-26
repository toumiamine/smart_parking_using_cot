package smart.parking.cot.Repository;

import jakarta.nosql.mapping.Repository;
import smart.parking.cot.Entity.User;

import javax.enterprise.context.ApplicationScoped;
import java.util.stream.Stream;

@ApplicationScoped
public interface UserRepository extends Repository<User, String> {

    User findByNameAndPassword(String name, String password);

    Stream<User> findAll();
}
