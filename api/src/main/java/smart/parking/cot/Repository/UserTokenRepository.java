package smart.parking.cot.Repository;

import jakarta.nosql.mapping.Param;
import jakarta.nosql.mapping.Query;
import jakarta.nosql.mapping.Repository;
import smart.parking.cot.security.oauth2.UserToken;

import javax.enterprise.context.ApplicationScoped;
import java.util.Optional;

@ApplicationScoped
public interface UserTokenRepository extends Repository<UserToken, String> {


    @Query("select * from UserToken where tokens.token = @refreshToken")
    Optional<UserToken> findByRefreshToken(@Param("refreshToken") String token);

    @Query("select * from UserToken where tokens.accessToken.token = @accessToken")
    Optional<UserToken> findByAccessToken(@Param("accessToken") String token);
}
