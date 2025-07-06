# gauge-go-sample

This repository sample tests using [Gauge](https://github.com/getgauge/gauge) and Go. 

## Overview

This project uses:
- Gauge as the BDD (Behavior Driven Development) testing framework
- Go as the programming language

## Prerequisites

- Go 1.24.1 or later
- Gauge framework

## Project Structure

```
.
├── env/             # Environment configurations
├── specs/           # Gauge test files
├── stepimpl/        # Step implementation files (Go)
└── reports/         # Test execution reports
```

## Setup Instructions

1. Install Go dependencies:

```bash
$ make tidy
```

2. Install Gauge:

- For macOS:

```bash
$ brew install gauge
# or
$ curl -Ssl https://downloads.gauge.org/stable | sh
```

- For other platforms, visit: https://docs.gauge.org/getting_started/installing-gauge.html

3. Setup Go for Gauge:

```bash
$ gauge install go html-report screenshot
$ gauge --version
Gauge version: 1.6.18
Commit Hash: d6e10a4

Plugins
-------
go (0.4.0)
html-report (4.3.2)
screenshot (0.3.2)
```

## Running Tests

To run all tests:

```bash
$ make test
```

To run the tests with the specified tags (e.g. successful):

```bash
$ make test tags=successful
$ make test tags="single word"
```

To validate tests syntax:

```bash
$ make validate
```

## Running Tests with Docker

You can also run the tests using Docker, which provides a consistent environment for testing. Here's how to use Docker:

1. Build the Docker image:

```bash
$ make docker-build
```

2. Validate the tests syntax within Docker:

```bash
$ make docker-validate
```

3. Run all tests within Docker:

```bash
$ make docker-test
```

## Generating Reports

Test reports are automatically generated in the `reports` directory after test execution. To view the latest report:
```bash
$ open reports/html-report/index.html
```

## Writing Test Cases

Test cases are written in Gauge's specification format using `.spec` files in the `specs` directory. Here's how to write test cases:

### Basic Structure

1. **Specification Title**: Start with a `#` followed by the title
2. **Context**: Add any necessary context or setup information
3. **Scenarios**: Write test scenarios using `##` for each scenario
4. **Steps**: Write test steps using `*` for each step

Example:

```markdown
# Specification Heading

* Vowels in English language are "aeiou".

## Vowel counts in single word

tags: single word

* The word "gauge" has "3" vowels.
```

To validate gauge specs syntax:

```bash
$ make validate
```

### Step Implementation

Each step in the specification needs to be implemented in Go code under the `stepimpl` directory. The implementation should match the step text exactly.

Example step implementation:

```go
var _ = gauge.Step("The word <word> has <expectedCount> vowels.", func(word string, expected string) {
	actualCount := countVowels(word)
	expectedCount, err := strconv.Atoi(expected)
	if err != nil {
		testsuit.T.Fail(fmt.Errorf("Failed to parse string %s to integer", expected))
	}
	if actualCount != expectedCount {
		testsuit.T.Fail(fmt.Errorf("got: %d, want: %d", actualCount, expectedCount))
	}
})
```

This step implementation can be invoked as shown below in a Gauge spec:

```markdown
* The word "gauge" has "3" vowels.
```
