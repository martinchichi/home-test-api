# Home Test API

API test automation project developed with [Karate](https://www.karatelabs.io/), Java, Maven, JUnit, and Testcontainers.

The project covers the inventory API scenarios requested in the take-home challenge.

## Technologies

* Java 21
* Maven 3.9+
* Karate 2.1.0
* JUnit 6
* Testcontainers 2.0.5
* Docker

## Prerequisites

Before running the project, make sure the following tools are installed:

```bash
java -version
mvn -version
docker --version
```

Docker Desktop, or another compatible Docker runtime, must be running.

The project uses Testcontainers to start an isolated instance of the following API image automatically:

```text
automaticbytes/demo-app
```

It is not necessary to start the API container manually when using the default test command.

## Project Structure

```text
home-test-api
├── pom.xml
├── README.md
└── src
    └── test
        └── java
            ├── karate-config.js
            └── inventory
                ├── InventoryTest.java
                ├── add-inventory.feature
                ├── filter-inventory.feature
                ├── get-inventory.feature
                └── data
                    └── inventory-items.json
```

## Test Scenarios

The automated suite covers the following scenarios:

### Get all menu items

Endpoint:

```http
GET /api/inventory
```

Validations:

* Response status is `200`.
* The response contains at least nine inventory items.
* Every inventory item contains:

  * `id`
  * `name`
  * `price`
  * `image`

### Filter inventory item by ID

Endpoint:

```http
GET /api/inventory/filter?id=3
```

Validations:

* Response status is `200`.
* The response matches the expected information for `Baked Rolls x 8`.

### Add an item using a non-existent ID

Endpoint:

```http
POST /api/inventory/add
```

Request body:

```json
{
  "id": "10",
  "name": "Hawaiian",
  "image": "hawaiian.png",
  "price": "$14"
}
```

Validations:

* Response status is `200`.
* Response body is `OK`.

### Add an item using an existing ID

The same item is submitted again.

Validations:

* Response status is `400`.
* Response body is `Bad Request`.

### Add an item with missing information

A request is submitted without the `id` field.

Validations:

* Response status is `400`.
* Response body is `Not all requirements are met`.

### Validate the recently added item

Endpoint:

```http
GET /api/inventory
```

Validations:

* Response status is `200`.
* The Hawaiian item is present in the inventory.
* The item contains the expected `id`, `name`, `image`, and `price`.

## Running the Tests

Clone the repository:

```bash
git clone git@github.com:martinchichi/home-test-api.git
```

Enter the project directory:

```bash
cd home-test-api
```

Run the complete test suite:

```bash
mvn clean test
```

During the execution, Testcontainers will:

1. Start a clean instance of `automaticbytes/demo-app`.
2. Wait until the inventory API is available.
3. Configure the dynamic API URL for Karate.
4. Execute the complete test suite.
5. Stop and remove the container after the tests finish.

Expected result:

```text
Tests run: 6, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

## Repeatable Execution

The suite can be executed multiple times without manual data cleanup:

```bash
mvn clean test
mvn clean test
```

A new API container is created for every execution. Therefore, the inventory always starts from a clean state and the item with ID `10` can be added consistently.

## Running Against a Different Environment

The test logic does not contain environment-specific URLs.

To execute the suite against another API environment, provide its base URL through a Maven system property:

```bash
mvn clean test \
  "-Dkarate.env=qa" \
  "-DbaseUrl=https://your-real-qa-environment.com/api"
```

Replace the example URL with the URL of an existing environment.

When `baseUrl` is provided explicitly, the tests use that environment and do not start the local Testcontainers API.

The default configuration is defined in:

```text
src/test/java/karate-config.js
```

## Test Data

Test data is stored separately from the Gherkin scenarios:

```text
src/test/java/inventory/data/inventory-items.json
```

This allows expected inventory items and request payloads to be modified or extended without changing the test logic.

Example:

```json
{
  "bakedRolls": {
    "id": "3",
    "name": "Baked Rolls x 8",
    "image": "roll.png",
    "price": "$10"
  },
  "hawaiian": {
    "id": "10",
    "name": "Hawaiian",
    "image": "hawaiian.png",
    "price": "$14"
  }
}
```

## Test Reports

After running the tests, the Karate HTML report is generated under:

```text
target/karate-reports/karate-summary.html
```

On Windows with Git Bash, it can be opened with:

```bash
start target/karate-reports/karate-summary.html
```

## Manual API Execution

The API can also be started manually for exploratory testing.

Pull the Docker image:

```bash
docker pull automaticbytes/demo-app
```

Start the container:

```bash
docker run --name demo-app -d -p 3100:3100 automaticbytes/demo-app
```

Verify the API:

```bash
curl "http://localhost:3100/api/inventory"
```

Run the tests against the manually started API:

```bash
mvn clean test "-DbaseUrl=http://localhost:3100/api"
```

Stop and remove the manual container:

```bash
docker rm -f demo-app
```

## Design Decisions

### Feature organization

The scenarios are grouped by inventory operation:

* `get-inventory.feature`
* `filter-inventory.feature`
* `add-inventory.feature`

This keeps related scenarios together without creating one file for every individual test case.

### Environment configuration

The base URL is resolved by `karate-config.js` and can be overridden through `-DbaseUrl`. No environment-specific URL is hardcoded in the feature files.

### External test data

Request payloads and expected responses are stored in a JSON file to improve maintainability and extensibility.

### Test isolation

Testcontainers provides a disposable API instance for each test execution. This prevents failures caused by data created during previous executions and removes the need for manual cleanup.

## Author

Martin Cicinelli
