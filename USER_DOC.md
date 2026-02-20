# User Documentation

This document provides instructions for end-users and administrators on how to manage and use the Inception project stack.

## 1. Provided Services

The project consists of a stack of three main services working together to deliver a fully functional WordPress website:

-   **NGINX**: Acts as the web server and the secure entry point to the application. It handles all incoming web traffic and serves the website over HTTPS.
-   **WordPress**: The Content Management System (CMS) that powers the website. This is where you create and manage pages, posts, and other content. It runs on PHP-FPM for high performance.
-   **MariaDB**: The database service. It stores all of your WordPress data, including posts, user information, and site settings.

These services run in isolated containers but are connected on a private network, ensuring security and separation of concerns.

## 2. Starting and Stopping the Project

A `Makefile` is provided for easy management of the services.

### Starting the Services

To build the service images and start all containers, run:

```bash
make
```

This command will set up the necessary data directories, build the containers if they don't exist, and start them in the background.

### Stopping the Services

You have two options for stopping the services:

-   **`make stop`**: This command stops the running containers but does not remove them. This is useful if you want to quickly pause the services and restart them later with `make start`.

    ```bash
    make stop
    # To restart later:
    make start
    ```

-   **`make down`**: This command stops **and removes** the containers and the network. Your data (WordPress files and database) will be safe as it is stored on your host machine.

    ```bash
    make down
    ```

## 3. Accessing the Website

### Prerequisite: Hostname Configuration

Before you can access the site, you must map the project's domain name to your local machine. Add the following line to your `/etc/hosts` file (this requires `sudo` privileges):

```
127.0.0.1 mmaksimo.42.fr
```

### Website and Admin Panel

-   **Website**: Once the services are running, you can access the website by navigating to `https://mmaksimo.42.fr` in your web browser.
-   **Administration Panel**: To log in to the WordPress dashboard, go to `https://mmaksimo.42.fr/wp-admin`.

## 4. Managing Credentials

All sensitive information, such as database passwords and WordPress admin credentials, is managed in a single file.

-   **Location**: The file is located at `srcs/.env`.
-   **Credentials**: You can find and manage the WordPress admin username and password (`WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`) and other credentials in this file.

**Important**: Treat this file as confidential. Do not share it or commit it to a public version control repository.

## 5. Checking Service Status

To ensure all services are running correctly, you can use the following commands:

-   **List Running Containers**: To see a list of all active Docker containers for this project, run:
    ```bash
    docker ps
    ```
    You should see three containers running: `nginx`, `wordpress`, and `mariadb`.

-   **View Logs**: To view the real-time logs from all services, which is useful for troubleshooting, run:
    ```bash
    make logs
    ```