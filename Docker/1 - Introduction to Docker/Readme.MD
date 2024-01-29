
# UNDERSTAND AND SETUP DOCKER

- Difficulty : Easy (⭐)
- Time : 2 Hours(⏲️)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#Prerequisites)
- [Installation](#installation)
- [Commands](#commands)
- [Challenges](#challenges)


## Introduction

Docker is a powerful tool that facilitates the development and deployment of software applications in a consistent and reproducible manner. It addresses the challenge of varying development environments across different machines, ensuring that applications run seamlessly regardless of the underlying system.

Docker can be employed to encapsulate an application along with its dependencies, libraries, and runtime environment into a standardized unit known as a container. This container becomes a self-sufficient entity that can be easily shared and executed on any machine with Docker installed.

Some of the features of docker are:

- **Development Environment Isolation**:
Docker enables the isolation of the development environment, ensuring that the application runs consistently across different systems. This is achieved by packaging the application and its dependencies into a Docker container.

- **Dockerfile**:
The Dockerfile serves as a blueprint for building a Docker image. It specifies the base image, sets up the necessary environment, copies the application code, and configures any required settings. This file essentially defines the steps to create a reproducible and portable container.

- **GitHub Repository Integration**:
The Docker configuration, including the Dockerfile, can be stored in the same GitHub repository as the application code. This ensures version control and a streamlined collaboration process.

- **Continuous Integration (CI)**:
Integration with CI/CD (Continuous Integration/Continuous Deployment) pipelines is a common practice. CI tools, such as Jenkins or GitHub Actions, can be configured to automatically build and test the Docker container whenever changes are pushed to the GitHub repository.

- **Docker Image Registry**:
The built Docker image can be pushed to a container registry (like Docker Hub) or a private repository. This allows for easy distribution of the containerized application to other developers or deployment environments.

- **Versioning and Collaboration**:
Docker images can be versioned, providing a structured approach to collaboration. Developers can pull specific versions of the Docker image, ensuring consistency in testing and deployment across different stages of the development lifecycle.

- **Deployment**:
The Docker container, containing both the application code and its dependencies, can be deployed on any machine with Docker support. This streamlines the deployment process, reducing the chances of environment-related issues.


## Prerequisites
- **Operating System**: Ensure you are running a Windows version that supports Docker. Docker for Windows requires Windows 10 Pro or Enterprise (64-bit) with Hyper-V support.
- **Hyper-V**: Enable Hyper-V on your machine. You can do this through the "Turn Windows features on or off" menu in the Control Panel.
- **Virtualization**: Make sure that virtualization is enabled in your machine's BIOS settings.
## Installation

### Windows
Official installation instructions can be found [here](https://docs.docker.com/engine/install/)

1. **Download Docker Desktop**:
Go to the Docker Desktop for Windows page and download the Docker Desktop installer.

2. **Install Docker Desktop**:
Run the installer you downloaded in the previous step. Follow the on-screen instructions to install Docker Desktop on your Windows machine. This may require a system restart.

3. **Enable Hyper-V and Containers Windows Features**:
Docker Desktop will prompt you to enable Hyper-V and Containers features during the installation. Allow Docker Desktop to make the necessary changes to your system.

4. **Run Docker Desktop**:
After installation is complete, launch Docker Desktop from the Start menu.

5. **Check Docker Version**:
Open a Command Prompt or PowerShell window and type the following command to verify that Docker is installed successfully:
```
docker --version
```
6. **Run a Test Container**:
Open a Command Prompt or PowerShell window and run a simple test container to ensure everything is working. For example, run the following command to pull and run the "hello-world" container:
```
docker run hello-world
```
Docker will download the "hello-world" image and run a container, and you should see a message indicating that your Docker installation is working correctly.

Congratulations! You have successfully set up Docker on your Windows machine.

## Basic Commands

1. Pulling and Setting Up a Basic Container (e.g., Node):

```
# Pull the Node.js image from Docker Hub
docker pull node

# Create and start a container named "my-node-container" from the Node.js image
docker run --name my-node-container -d node
```
2. Checking if the Container is Running:

```
# List all running containers
docker ps

# To see all containers, including those not currently running, add the `-a` option
docker ps -a
```

3. Running Interactive Node Terminal in the Container:

```
# Start an interactive terminal session inside the running container
docker exec -it my-node-container bash

# Now you are inside the container, and you can run Node.js commands or check its version
node --version
```

4. Delete the Created Container:

```
# Stop the running container
docker stop my-node-container

# Remove the container
docker rm my-node-container
```

## Challenges

Complete the following tasks for some hands on practice.

1. Pull and setup a docker container of the image 'node'.
2. Check if the container was sucessfully created or not.
3. Run a interactive node terminal. 
4. Check the version of NODE running inside the container.
5. Delete all the created containers.
