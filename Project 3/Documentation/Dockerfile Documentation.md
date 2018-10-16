#### Setting up Docker
1. Update the package list
  ```
  sudo apt-get update
  ```

2. Install the packages that allow docker to use aufs storage
  ```
  sudo apt-get -y install linux-image-extra-$(uname -r)

  sudo apt-get -y install linux-image-extra-virtual
  ```

3. Install packages to allow apt to use a repository over HTTPS
  ```
  sudo apt-get -y install apt-transport-https
  sudo apt-get -y install ca-certificates
  sudo apt-get -y install curl
  sudo apt-get -y install software-properties-common
  ```

4. Add Docker’s official GPG key
  ```
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  ```

5. Add the stable repository
  ```
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  ```

6. Update the package list
  ```
  sudo apt-get update
  ```

7. Install the latest version of Docker
  ```
  sudo apt-get -y install docker-ce
  ```

8. Verify that docker has been installed
  ```
  sudo docker run hello-world
  ```

9. Removing the need to sudo all docker commands
  ```
  sudo usermod -a -G docker $USER
  ```

10. Reboot the system or log out to apply the change from step 9.

##### Creating a Dockerfile
1. First start by creating a new directory for the Dockerfile.

2. Use an editor to create the Dockerfile
  ```
  nano Dockerfile
  ```

3. Start the Dockerfile with the ```FROM``` command that uses an operating system as a base.
  ```
  FROM ubuntu
  ```

4. Use the ```RUN``` command to run the linux command to download and install software
  ```
  RUN apt-get -y install apache2
  RUN ./home/datadog.sh
  ```

5. Use the ```COPY``` command to move files form the host machine
  ```
  COPY datadog.sh /home/datadog.sh
  ```

##### Getting the IP address of the container
1. First run the docker and keep it running
  ```
  docker run -t -d production-site
  ```
2. Then Run the ```exec``` command to get the IP address
  ```
  docker exec [image-id from step 1] cat /etc/hosts
  ```
3. The very bottom result will give you the ip address to put into your internet browser to test
  the apache2 website.

#### Managing images and containers
1. To create a docker image
  ```
  docker build -f image-name -t tagid [path/from/root/to/image]

  docker build /path/to/Dockerfile -t image-name
  docker build - < /path/to/Dockerfile -t image-name
  ```

  example:

  ```
  docker build -t docker-test -t 1.0 ~/Desktop/docker-test

  docker build --rm=true -t production-site .
  ```

2. Exporting the created docker image
  ```
  docker save [imagename] > [path/to/save/to]/imagename.tar
  ```

  example:

  ```
  docker save docker-test > ~/Desktop/docker-test/docker-test.tar
  ```

3. Remove a docker image by using the command
  ```
  docker rmi [imageid]
  ```

  As long as a couple unique characters from the image id is used, the
  command will find the entire id and remove it for you.

4. Running a shell in a docker image
  ```
  docker run -it [image-name]:[version]
  ```

  example:
  ```
  docker run -it ubuntu:14.04.5
  ```

5. Stopping all docker containers
  ```
  docker stop $(docker ps -aq)
  ```

6. Removing all docker containers
  ```
  docker rm $(docker ps -aq)
  ```

7. Removing all docker images
  ```
  docker rmi $(docker images -q)
  ```
