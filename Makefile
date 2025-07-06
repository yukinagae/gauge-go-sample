# Run the tests with the specified tags (no tags means run all tests)
.PHONY: test
test:
	gauge run $(if $(tags),--tags "$(tags)",) specs --log-level debug

# Validate the tests syntax
.PHONY: validate
validate:
	gauge validate specs

# Tidy the go.mod file
.PHONY: tidy
tidy:
	go mod tidy

# Docker build
.PHONY: docker-build
docker-build:
	docker build --platform linux/amd64 -t gauge-go-sample:latest .

# Validate the tests syntax within Docker
.PHONY: docker-validate
docker-validate:
	docker run -it --rm \
		--platform linux/amd64 \
		gauge-go-sample:latest make validate

# Run all the tests within Docker
.PHONY: docker-test
docker-test:
	docker run -it --rm \
  --platform linux/amd64 \
  gauge-go-sample:latest gauge run specs --log-level debug
