# Only a development image. It is NOT an application runtime image.
ARG DEVCONTAINER_GO_IMAGE=mcr.microsoft.com/devcontainers/go:1.26-bookworm
FROM ${DEVCONTAINER_GO_IMAGE}

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client jq make \
    && rm -rf /var/lib/apt/lists/*

# Keep the local linter version aligned with the application's GitHub Actions workflow.
ARG GOLANGCI_LINT_VERSION=v2.15.0
RUN GOBIN=/usr/local/bin go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}

USER vscode
