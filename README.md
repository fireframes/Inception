*This project has been created as part of the 42 curriculum by mmaksimo.*

# Inception

## Description
This project aims to broaden the knowledge of system administration by using **Docker**. The goal is to virtualize several Docker images, creating a small infrastructure composed of different services within a dedicated network. Unlike simpler containerization tasks, this project requires building images from scratch using **Alpine Linux** and configuring them manually to interact securely and efficiently.

**Services included:**
- **NGINX**: A high-performance web server acting as the entry point, configured with TLS (HTTPS).
- **WordPress**: The popular CMS, running via PHP-FPM.
- **MariaDB**: An open-source relational database management system storing the WordPress data.

## Instructions

### Prerequisites
- Docker Engine
- Docker Compose
- Make
- Root/Sudo privileges

### Installation & Setup

1. **Configure Hostname Resolution**
   The project requires a specific domain name. Add the following line to your `/etc/hosts` file (requires sudo):
   ```bash
   127.0.0.1 mmaksimo.42.fr
   ```

2. **Setup Data Directories**
   Persistence is handled via bind mounts. Ensure the data directories exist on your host machine.
   *Note: Check `docker-compose.yml` to confirm the paths match your user configuration.*
   ```bash
   mkdir -p /home/mmaksimo/data/wordpress
   mkdir -p /home/mmaksimo/data/mariadb
   ```

3. **Environment Variables**
   Ensure the `.env` file is present in `srcs/` containing the required database credentials and domain configuration.

### Execution

The project uses a `Makefile` for easy management:

- **Start the infrastructure**:
  ```bash
  make
  ```
  *Or manually: `docker compose -f ./srcs/docker-compose.yml up -d --build`*

- **Stop the infrastructure**:
  ```bash
  make stop
  ```

- **Rebuild and restart**:
  ```bash
  make re
  ```

Once running, access the site at: `https://mmaksimo.42.fr`

## Project Description & Design Choices

This infrastructure is built using **Docker Compose** to orchestrate multiple containers.

### Design Choices
- **Alpine Linux**: All images (`nginx`, `wordpress`, `mariadb`) are based on Alpine Linux. This was chosen for its minimal footprint and security-oriented design, adhering to the project's requirement to build lightweight custom images.
- **Micro-services Architecture**: Each service runs in its own container, separating concerns (Web Server, App Server, Database).
- **PID 1 Handling**: Entrypoint scripts are designed to exec into the main process (e.g., `mysqld`, `php-fpm`) ensuring they receive system signals correctly.
- **Network Isolation**: All containers communicate inside a custom user-defined bridge network (`inception`), preventing direct external access to the database or PHP-FPM ports.

### Comparisons

#### Virtual Machines vs Docker
| Feature | Virtual Machines | Docker (Containers) |
|---------|------------------|---------------------|
| **Architecture** | Emulates hardware; runs a full Guest OS on top of a Hypervisor. | Virtualizes the OS; shares the Host OS kernel. |
| **Performance** | heavier resource usage; slower boot times. | Lightweight; native performance; instance starts. |
| **Isolation** | Full isolation (hardware level). | Process-level isolation (namespaces & cgroups). |
| **Choice** | **Docker** was chosen for efficiency and rapid deployment of lightweight services suitable for this web stack. |

#### Secrets vs Environment Variables
| Feature | Environment Variables | Secrets |
|---------|-----------------------|---------|
| **Storage** | Stored as plain text in configuration files or memory. | Stored encrypted on disk (swarm mode) or managed files. |
| **Security** | Risk of leakage via `docker inspect` or logs. | More secure; only mounted at runtime to specific containers. |
| **Usage** | **Environment Variables** were used in this project (`.env` file) for simplicity and conformity with the project subject, which requires loading variables for configuration. |

#### Docker Network vs Host Network
| Feature | Host Network | Docker Network (Bridge) |
|---------|--------------|-------------------------|
| **Isolation** | No isolation; container shares host's network stack/IP. | Isolated network namespace; private internal IPs. |
| **Ports** | Conflict if host uses the port. | Ports must be explicitly mapped/exposed. |
| **Choice** | **Docker Network** is used to create a private `inception` network. NGINX is the only entry point (port 443), while MariaDB and WordPress communicate internally without exposing ports to the outside world. |

#### Docker Volumes vs Bind Mounts
| Feature | Docker Volumes | Bind Mounts |
|---------|----------------|-------------|
| **Management** | Managed by Docker (`/var/lib/docker/volumes/`). | Managed by user; specific path on host file system. |
| **Portability** | Easier to back up/migrate via Docker API. | tied to specific host path structure. |
| **Choice** | **Bind Mounts** are used (`/home/mmaksimo/data/...`) as strictly required by the project subject to ensure data persists in a specific location on the student's machine. |

## Resources

### References
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Specification](https://docs.docker.com/compose/)
- [Alpine Linux Package Management](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
- [NGINX Documentation](https://nginx.org/en/docs/)

### AI Usage
AI tools were used in this project to:
- **Clarify Concepts**: Explaining the differences between Docker concepts (Volumes vs Bind Mounts, Network types) to ensure accurate implementation.
- **Debugging**: assisting in troubleshooting shell script syntax (`init.sh`, `wp-setup.sh`) and Dockerfile configurations.
- **Documentation**: Generating this `README.md` and explaining the codebase structure for study purposes.
