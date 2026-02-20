# Developer Documentation

This document is for developers who want to set up, build, and work on the Inception project.

## 1. Environment Setup

Follow these steps to set up the development environment from scratch.

### Prerequisites

Ensure you have the following tools installed on your system:
-   Docker Engine
-   Docker Compose
-   `make`
-   `sudo` or root access

### Step 1: Configure Hostname

The NGINX service is configured to respond to a specific domain name. You must map this domain to your local machine's loopback address.

Add the following line to your `/etc/hosts` file:
```
127.0.0.1 mmaksimo.42.fr
```

### Step 2: Create Data Directories

The project uses bind mounts to persist data on the host machine. The `Makefile` is configured to use a specific path.

-   The default path is `/home/mmaksimo/data`. If this is not suitable for your machine, you must edit the `DATA_PATH` variable in the `Makefile`.
-   Run the `setup` command to create the required directories:
    ```bash
    make setup
    ```
    This will create `/home/mmaksimo/data/wordpress` and `/home/mmaksimo/data/mariadb`.

### Step 3: Configure Secrets

All secrets (passwords, API keys, etc.) are managed via an environment file.

1.  Navigate to the `srcs/` directory.
2.  Create a file named `.env`.
3.  Populate it with the required variables. Use the example below as a template.

**`srcs/.env` Example:**
```env
# Domain Name
DOMAIN_NAME=mmaksimo.42.fr

# MariaDB Credentials
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=changeme
MYSQL_ROOT_PASSWORD=changeme_root

# WordPress Admin Credentials
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=adminpass
WP_ADMIN_EMAIL=admin@example.com

# WordPress Secondary User
WP_USER=user
WP_USER_PASSWORD=userpass
WP_USER_EMAIL=user@example.com
```

## 2. Building and Launching

The `Makefile` provides convenient targets for managing the project's lifecycle.

-   **Build and Start**: To build the Docker images and launch the container stack, run:
    ```bash
    make
    ```
    This is equivalent to `make all` or `make up`.

-   **Force Rebuild**: To perform a clean build, which involves removing all existing containers, volumes, and data before starting again, run:
    ```bash
    make re
    ```
    **Warning**: This command is destructive and will delete your database and WordPress files.

-   **Direct Docker Compose**: You can also use Docker Compose directly if you need more control:
    ```bash
    docker compose -f ./srcs/docker-compose.yml up --build -d
    ```

## 3. Makefile Commands

The following commands are available to manage the project:

| Command         | Description                                                                                             |
|-----------------|---------------------------------------------------------------------------------------------------------|
| `make all`      | Default command. Builds images and starts all services. Alias for `up`.                                 |
| `make setup`    | Creates the data directories on the host machine.                                                       |
| `make up`       | Builds images if they don't exist and starts all services in detached mode.                             |
| `make down`     | Stops and removes all containers and the project network.                                               |
| `make start`    | Starts previously stopped containers without rebuilding.                                                |
| `make stop`     | Stops running containers without removing them.                                                         |
| `make clean`    | Runs `down` and then prunes unused Docker images and networks. Does **not** remove volumes or host data. |
| `make fclean`   | **DESTRUCTIVE**. Runs `down`, prunes everything (including volumes), and deletes all data in the host data directories. |
| `make re`       | **DESTRUCTIVE**. Runs `fclean` and then `all`. A complete reset.                                        |
| `make logs`     | Tails the logs from all running services.                                                               |

## 4. Data Persistence

-   **Mechanism**: The project uses **bind mounts** for data persistence. This links a directory on your host machine directly into a container.
-   **Location**: All persistent data is stored under the path defined by the `DATA_PATH` variable in the `Makefile` (default: `/home/mmaksimo/data`).
-   **Lifecycle**: This data persists even when containers are removed with `make down`. It is only deleted when you run `make fclean` or `make re`.

## 5. Debugging

-   **View Logs**: The first step in debugging is to check the service logs: `make logs`.
-   **Access a Container**: To get an interactive shell inside a running container (e.g., `wordpress`), use `docker exec -it <container_name_or_id> sh`.