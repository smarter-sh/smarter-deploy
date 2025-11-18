# Smarter Deploy

[![Docker Hub](https://img.shields.io/docker/pulls/mcdaniel0073/smarter?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/mcdaniel0073/smarter)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/project-smarter)](https://artifacthub.io/packages/search?repo=project-smarter)
[![License: GNU AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![hack.d Lawrence McDaniel](https://img.shields.io/badge/hack.d-Lawrence%20McDaniel-orange.svg)](https://lawrencemcdaniel.com)

**Smarter is a platform for managing and orchestrating AI resources.** This repository contains deployment tools
to help you get the Smarter platform running locally using Docker.

Features:

- declarative manifest based resource management
- command-line interface for Windows, macOS, Linux and Docker
- rest api
- web console / prompt engineer workbench
- extensible: PyPi, NPM, VS Code Extension and more
- publicly accessible online documentation and self onboarding resources
- open source UI components for jump starting projects

**Smarter** is a yaml manifest-based approach to managing the disparate resources that are required for creating and managing AI resources that integrate to other enterprise resources like REST Api's and Sql databases. And it gives prompt engineering teams an intuitive workbench approach to designing, prototyping, testing, deploying and managing powerful AI resources for common corporate use cases including agentic workflows, customer facing chat solutions, and more.

**Smarter** provides seamless integration and interoperation between LLMs from DeepSeek, Google AI, Meta AI and OpenAI. It is LLM provider-agnostic, and provides seamless integrations to a continuously evolving list of value added services for security management, prompt content moderation, audit, cost accounting, and workflow management. **Smarter** is cloud native and runs locally, on Kubernetes, on-site in your data center or in the cloud.

## Prerequisites

Before you begin, make sure you have:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running (includes Docker Compose)
- Basic familiarity with using the terminal/command prompt
- (Optional) A Git client if you want to clone this repository

## Quickstart: Run Smarter Locally with Docker

This guide will help you deploy Smarter on your local machine using Docker Desktop. You can get up and running in about 10 minutes!

### 1. Install Docker Desktop

If you haven't already, download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/). This will also install Docker Compose.

### 2. Prepare Your Environment File

Smarter requires a `.env` file with your credentials and configuration. You can scaffold a template using the following command:

```console
make                # creates a .env file in the root of the repo
```

**Important:**
- Open the newly created `.env` file and add your credentials (API keys, passwords, etc.) as needed. The application will not run without this step.

### 3. Initialize and Build the Application

This step sets up the Python environment, builds the Docker container, and seeds the platform with test data:

```console
make init
```

### 4. Start the Application

Run the following command to start all Docker containers and launch the web server:

```console
make run
```

- The web console will be available at: [http://127.0.0.1:8000/](http://127.0.0.1:8000/) or [http://localhost:8000](http://localhost:8000)
- If you see a login screen, your deployment is working!

### 5. Log In

Go to [http://localhost:8000/admin/login/](http://localhost:8000/admin/login/) and log in with:

- **Username:** `admin`
- **Password:** `smarter`

> **Note:** These are default credentials for local testing. Change them for any production or public deployment.

---

## Troubleshooting & FAQ

**Docker not running?**
- Make sure Docker Desktop is open and running before you use any `make` commands.

**Port already in use?**
- If you get an error about port 8000, make sure nothing else is running on that port, or change the port in your `.env` and Docker configuration.

**.env file issues?**
- Double-check that your `.env` file exists in the project root and contains all required variables.

**Still stuck?**
- Try running `docker compose ps` to see the status of your containers.
- Check the Docker Desktop dashboard for error logs.
- Ask for help: [Lawrence McDaniel](https://lawrencemcdaniel.com/contact)

---

## What to Expect

- After running `make run`, you should see the Smarter web console at [http://127.0.0.1:8000/](http://127.0.0.1:8000/).
- The login page should load without errors.
- If you encounter issues, see the troubleshooting section above.

---

## Optional Kubernetes Deployment

See [Kubernetes Deployment Instructions](./docs/KUBERNETES.md).

## Documentation

See [docs/](./docs/)

## Contributing

Please see the [CONTRIBUTING](./.github/CONTRIBUTING.md) page, the [project documentation](./docs/) and these tutorials:
