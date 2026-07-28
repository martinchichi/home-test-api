package inventory;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DynamicNode;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

import java.time.Duration;

class InventoryTest {

    private static final String BASE_URL_PROPERTY = "baseUrl";
    private static final int API_PORT = 3100;

    private static final GenericContainer<?> API_CONTAINER =
            new GenericContainer<>(
                    DockerImageName.parse("automaticbytes/demo-app")
            )
                    .withExposedPorts(API_PORT)
                    .waitingFor(
                            Wait.forHttp("/api/inventory")
                                    .forStatusCode(200)
                    )
                    .withStartupTimeout(Duration.ofSeconds(90));

    private static boolean containerStartedByTests;

    @BeforeAll
    static void startApiIfNeeded() {
        String configuredBaseUrl =
                System.getProperty(BASE_URL_PROPERTY);

        if (configuredBaseUrl != null
                && !configuredBaseUrl.isBlank()) {
            return;
        }

        API_CONTAINER.start();

        String containerBaseUrl = String.format(
                "http://%s:%d/api",
                API_CONTAINER.getHost(),
                API_CONTAINER.getMappedPort(API_PORT)
        );

        System.setProperty(
                BASE_URL_PROPERTY,
                containerBaseUrl
        );

        containerStartedByTests = true;
    }

    @AfterAll
    static void stopApiIfManagedByTests() {
        if (!containerStartedByTests) {
            return;
        }

        try {
            API_CONTAINER.stop();
        } finally {
            System.clearProperty(BASE_URL_PROPERTY);
            containerStartedByTests = false;
        }
    }

    @Karate.Test
    Iterable<DynamicNode> testInventory() {
        return Karate.run("classpath:inventory");
    }
}