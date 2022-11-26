package smart.parking.cot.Entity;

import java.util.function.Supplier;

public enum Role implements Supplier<String> {

    ADMIN, USER;

    @Override
    public String get() {
        return this.name();
    }
}
