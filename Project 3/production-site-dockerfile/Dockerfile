FROM fa480.club-base

# First cd into the folder this docker image is in.
# Then build this dockerfile image by running: docker build --rm=true -t production-site .
# To run this dockerfile: docker run -dit production-site
# To log into the container the above command makes: docker exec -it [imageid] /bin/bash
# The imageid comes from the run command.
# Do not include the [ ] around the imageid.

# Installing Hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.49/hugo_0.49_Linux-64bit.deb
RUN dpkg -i hugo_0.49_Linux-64bit.deb
RUN pip install awscli --upgrade --user

# Get the website from github
RUN git clone https://github.com/CSUN-SeniorDesign/eat-blog.git

# Pre hugo configuration
RUN hugo new site beats
RUN mv /eat-blog/arabica /beats/themes/arabica
RUN rm -rf /beats/themes/arabica/exampleSite/*
RUN mv /eat-blog/config.toml /beats/config.toml
RUN mkdir /beats/content/post/
RUN mv /eat-blog/* /beats/content/post/

# Pre hugo clean up
RUN rm /beats/content/post/BEATS-Uploader.py
RUN rm /beats/content/post/ProductionSite.txt
RUN rm /beats/content/post/S3-Fetch.py

# Use hugo to create the website
RUN cd /beats && hugo

# Move the website to /var/www/html
RUN mv /beats/public/* /var/www/html
EXPOSE 80/tcp
EXPOSE 443/tcp

# Start apache2 service
RUN sudo service apache2 start

# Change apache2's configuration to include 2 headers
RUN a2enmod headers
#RUN service apache2 restart
RUN curl icanhazip.com | sudo tee /etc/apache2/serverip
RUN echo "export servername=`</etc/hostname`" | sudo tee -a /etc/apache2/envvars
RUN sudo echo "export serverip=`</etc/apache2/serverip`" | sudo tee -a /etc/apache2/envvars
RUN echo "PassEnv servername" >> /etc/apache2/apache2.conf
RUN echo "PassEnv serverip" >> /etc/apache2/apache2.conf
RUN echo "Header set X-Hostname %{servername}e" >> /etc/apache2/apache2.conf
RUN echo "Header set X-Private-IP %{serverip}e" >> /etc/apache2/apache2.conf
#RUN service apache2 restart

# Move the script from the host to the image that installs datadog.
COPY datadog.sh /home/datadog.sh

# Link datadog to the image for monitoring.
#RUN ./home/datadog.sh

CMD service apache2 start && tail -f /dev/null
