FROM ubuntu:14.04.5

# First cd into the folder this docker image is in.
# Then build this dockerfile image by running: docker build --rm=true -t fa480.club-base .
# Tell the image that it's noninteractive so there wont be any waiting for prompts.
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Installing minimum software to get the website running.
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y curl
RUN apt-get install -y dpkg
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y wget
RUN apt-get install -y rcconf && update-rc.d -f apache2 remove && update-rc.d -f apache2 defaults
