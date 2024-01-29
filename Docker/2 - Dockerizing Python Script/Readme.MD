# Dockerize Python Script

- Difficulty : Easy (⭐)
- Time : 0.5 Hours(⏲️)

## Table of Contents
- [Prerequisites](#prerequisites)
- [Introduction](#introduction)
- [Commands](#commands)
- [Tasks](#tasks)

## Prerequisites
Make sure you have docker installed and setup and comeplete the tasks of **Part 1 - Introduction to Docker** [here](https://github.com/ravitejams94/DevOpsProjects/tree/main/Docker/1%20-%20Introduction%20to%20Docker)

## Introduction

Docker containerization is a technology that packages applications and their dependencies into isolated units called containers. These containers ensure consistent and efficient deployment across various environments, minimizing compatibility issues. Containers encapsulate everything needed for an application to run, fostering portability, scalability, and rapid deployment, thereby streamlining development and operations.



In this lesson, we will understand some more docker commands including how to setup a dockerfile. Let's run a simple python script inside docker.

1. **Create a Python Script**:
Create a file named app.py with the following content:

```
print("This is my first Python script running inside a docker container")
print("hello world")
```

2. **Write a Dockerfile**:

A Dockerfile is a text-based configuration file that defines the steps and instructions for building a Docker image. It specifies the base image, sets the working directory, copies application code, and configures runtime settings. Each instruction in the Dockerfile contributes to creating a lightweight, standalone, and executable package, encapsulating the application and its dependencies. Dockerfiles enable the reproducible creation of Docker images, providing a consistent environment for deploying applications across various systems. 

Create a file named Dockerfile in the same directory with the following content:
```
# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the Python script into the container
COPY app.py .

# Specify the command to run the Python script
CMD ["python", "app.py"]
```

- **FROM** - Specifies the base image for the Docker image.
- **WORKDIR** - Sets the working directory inside the container for subsequent instructions.
- **COPY** - Copies files or directories from the host machine to the container. Here we copy app.py script into the WORKDIR
- **CMD** - Provides the default command to run when a container is started from the image.

For a better understanding of all the keywords in Dockerfile, check the official documentation [here](https://docs.docker.com/engine/reference/builder/)

3. ** Build Docker Image**:

Open a terminal in the directory containing the Dockerfile and run the following command to build the Docker image:

```
docker build -t my-python-app .
```
- -t (flag) - Stands for Tag. This image is given the tag of 'my-python-app'

4. **Run the Docker Container**:
After the build completes, you can run a container based on the created image:

```
docker run my-python-app
```

Now, you have successfully built and run a Docker container for a Python "Hello, World!" program. This Docker image can be shared, distributed, and deployed consistently across different systems with Docker installed.



## Tasks

For the task below copy the following script and save it in a file as 'app.py'

1. Using what we learned from Task 2 write a dockerfile with 4 commands
    FROM
    WORKDIR
    COPY
    CMD
2. Build the image.
3. Run the image. 
4. Observe the error. Now run with interactive terminal mode.
5. Stop the container. Start the same container again with attached and interactive shell.
6. How can we start a container that can be removed the moment we stop it?
7. Which command do we use to remove all images which dont have any containers based on it?
8. Create a folder and inside that folder create a text file with some text. Copy that folder into the docker
    either into /app or new random location. Delete the file locally and copy the same folder back into the system.
9. Give a name to the container you are running from python image.
10. Stop and remove the previous container. 
11. Assign a tag to the newly build image. And for this image create a container which has a custom name to it.
