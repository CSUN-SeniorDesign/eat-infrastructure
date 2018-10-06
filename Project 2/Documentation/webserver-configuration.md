# Web server configuration documentation

#### Understanding request headers
1. Open any web browser and press ```F12```
2. Go to the Network tab
3. Click on any object in the left hand column under name
4. Look at the section titled Response Headers
5. Additional headers may be supplied with every request in the response

#### Adding additional headers with Apache 2.4 and Ubuntu 14.04 64-bit
1. On your ubuntu system, open the /etc/apache2/apache2.conf
2. Add this line to the end of the file: ```RequestHeader add name value```
3. Replace the "name" and "value" with the name of the response header and
   the value of the reponse header.
4. Repeat step 3 for any many new response headers you want.  
5. Make sure the module for headers is enabled in apache2 by using
   the command ```sudo a2enmod headers```
6. Restart the apache2 server when changes are complete

#### Setting up variables in Apache manually
1. In /etc/apache2/envvars add ```export servername='ubuntu'``` to the end of the file
2. In the same file add ```export serverip='192.168.0.1'```
3. In /etc/apache2/apache.conf add ```PassEnv servername```
4. In the same file add ```PassEnv serverip```
5. In the same file add ```Header set X-Hostname %{servername}e```
6. In the same file add ```Header set X-Private-IP %{serverip}e```  
  6a. If you haven't already make sure you've run ```sudo a2enmod headers```
7. Then restart apache with ```sudo service apache2 restart```

#### Setting up variables in Apache automatically
1. curl icanhazip.com | sudo tee /etc/apache2/serverip
2. ```sudo echo "export servername= `</etc/hostname`" | sudo tee -a /etc/apache2/envvars```
3. ```sudo echo "export serverip=`</etc/apache2/serverip`" | sudo tee -a /etc/apache2/envvars```

##### Note: in order to set the hostname globally run this command:
```sudo echo "ServerName `</etc/hostname`" | sudo tee /etc/apache2/conf-available/servername.conf```
and ```sudo a2enconf servername``` then restart ```sudo service apache2 reload```
