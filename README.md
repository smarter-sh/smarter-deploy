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
- publicly accessible [online documentation](https://docs.smarter.sh/) and self onboarding resources
- open source UI components for jump starting projects

**Smarter** is a yaml manifest-based approach to managing the disparate resources that are required for creating and managing AI resources that integrate to other enterprise resources like REST Api's and Sql databases. And it gives prompt engineering teams an intuitive workbench approach to designing, prototyping, testing, deploying and managing powerful AI resources for common corporate use cases including agentic workflows, customer facing chat solutions, and more.

**Smarter** provides seamless integration and interoperation between LLMs from DeepSeek, Google AI, Meta AI and OpenAI. It is LLM provider-agnostic, and provides seamless integrations to a continuously evolving list of value added services for security management, prompt content moderation, audit, cost accounting, and workflow management. **Smarter** is cloud native and runs locally, on Kubernetes, on-site in your data center or in the cloud.

## Prerequisites and Minimum System Requirements

Before you begin, make sure you have:

- 40Gib of available drive space
- for Mac: Version 12 (Monterey), Apple Silicon (M1 or newer) or Intel CPU with support for virtualization
- for Windows: Windows 10 64-bit, 64-bit processor with Second Level Address Tranlation (SLAT), 8Gib of RAM, Windows Subsystem for Linux 2 if running Windows Home Editions.
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running (includes Docker Compose)
- Basic familiarity with using the terminal/command prompt
- (Optional) A Git client if you want to clone this repository

### Docker Desktop

You should run the following checks in a terminal window to ensure that you have the Docker command-line tools installed and running in addition to Docker Desktop itself.

```console
docker --version
docker-compose --version
```

If you get results from both of these then you're good to go. If not, then you'll need to do some trouble shooting first. In my case I had to go to the Advanced settings of Docker Desktop, and fiddle with the radio button that toggles between the default 'system' installation of the CLI tools, and the 'User' alternative option. Toggling back and forth, and clicking the 'Apply' button each time eventually got it working for me. Moreover, I had some old versions of Docker cli tools from years past which I had to delete, as these also were wreaking havoc in my development environment. Another check (for macOS), while we're on this topic, is to check the contents of `/usr/local/bin` to see if both docker and docker-compose are present. If not, then you definitely have work to do.

#### Docker Resource Requirements

- memory: 4Gib
- Swap: 4Gib
- cpu: 2
- disk storage: 40Gib


## Quickstart: Run Smarter Locally with Docker

This guide will help you deploy Smarter on your local machine using Docker Desktop. You can get up and running in about 10 minutes!

### 1. Install Docker Desktop

If you haven't already, download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/). This will also install Docker Compose.

### 2. Clone the repository

```console
git clone https://github.com/smarter-sh/smarter-deploy.git
cd smarter-deploy
```

### 3. Prepare Your Environment File

Smarter requires a [.env](./.env.example) file with your credentials and configuration. You can scaffold a template using the following command:

```console
make                # creates a .env file in the root of the repo
```


**Important:**

- Open the newly created [.env](./.env.example) file and add your credentials (API keys, passwords, etc.) as needed. The application will not run without this step.
- Note that [.env](./.env.example) contains copious inline documentation that you can refer to for specific configuration and technical guidance.

### 4. Initialize the Application

This step does the following:

- pulls the Docker containers (takes around 5 minutes)
- sets up the MySql database tables (takes around 3 minutes)
- seeds the platform with test data: (takes around 2 minutes)

**START DOCKER DESKTOP**

```console
make init
```

### 5. Start the Application

Run the following command to start all Docker containers and launch the web server:

```console
make run
```

- The web console will be available at: [http://127.0.0.1:9357/](http://127.0.0.1:9357/) or [http://localhost:9357](http://localhost:9357)
- If you see a login screen, your deployment is working!

### 6. Log In

Go to [http://localhost:9357/login/](http://localhost:9357/login/) and log in with:

- **Username:** `admin@smarter.sh`
- **Password:** `smarter`

> **Note:** These are default credentials for local testing. You should change them for any production or public-facing deployment.

### 7. Download the Smarter Command-Line Interface

You'll need to download, install and configure the cli in order to manage AI resources. Get the cli here, at [smarter.sh/cli](https://smarter.sh/cli).

## Configuration

The Smarter platform defaults should be sufficient for running locally for "tire kicking" and
hacking purposes.

To configure for deployment to AWS, use the `.env` to modify any settings value.

- Smarter settings (see [smarter/smarter/common/conf.py](https://github.com/smarter-sh/smarter/blob/main/smarter/smarter/common/conf.py#L377)) should be prefixed with `SMARTER_`.

- Django settings, including those of 3rd party Django packages included in settings.INSTALLED_APPS should be prefixed with `DJANGO_`. Django settings that exist in [smarter/smarter/settings/base.py](https://github.com/smarter-sh/smarter/blob/main/smarter/smarter/settings/base.py)
will be cast to the same data types. For any other Django settings that you add to `.env`, 
Smarter will attempt to analyze the value and cast it to one of: int, float, datetime, list, dict, or str.

> Values that you include in `.env` will override both Smarter as well as Django default settings.

## Troubleshooting & FAQ

**Docker not running?**

- Make sure Docker Desktop is open and running before you use any `make` commands.

**Port already in use?**

- If you get an error about port 9357, make sure nothing else is running on that port, or change the port in your [.env](./.env.example) and Docker configuration.

**.env file issues?**

- Double-check that your [.env](./.env.example) file exists in the project root and contains all required variables.

**Still stuck?**

- Verify that `OPENAI_API_KEY` has been set in your .env file in the root of the repository.
- Try running `docker compose ps` to see the status of your containers.
- Check the Docker Desktop dashboard for error logs.
- Ask for help: [Lawrence McDaniel](https://lawrencemcdaniel.com/contact)

---

## What to Expect

- After running `make run`, you should see the Smarter web console at [http://127.0.0.1:9357/](http://127.0.0.1:9357/).
- The login page should load without errors.
- If you encounter issues, see the troubleshooting section above.

---

## Optional Kubernetes Deployment

See [Kubernetes Deployment Instructions](./docs/KUBERNETES.md).

## Documentation

See [docs/](./docs/)

## Contributing

Please see the [CONTRIBUTING](./.github/CONTRIBUTING.md) page, the [project documentation](./docs/) and these tutorials:
