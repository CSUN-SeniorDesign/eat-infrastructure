# How to deploy a new blog post
##### Installation of Hugo

1. Create a new folder under C:\ and name it "Hugo" and create a folder inside the Hugo folder called "bin".
2. Navigate over to https://github.com/gohugoio/hugo/releases to download the latest release of Hugo. I run windows so I picked hugo_0.48_Windows-64bit.zip
3. Unpack hugo_0.48_Windows-64bit.zip to your bin folder under C:\Hugo\bin.
4. Open your cmd and navigate to your hugo folder.
       cd C:\Hugo
5. When inside the Hugo folder, type "hugo version" and it should return a message similar to this: <br>

        C:\Hugo>hugo version
        Hugo Static Site Generator v0.48 windows/amd64 BuildDate: 2018-08-29T06:35:13Z

6. Hugo should now be installed and it is time to download the latest version of our project.
https://drive.google.com/open?id=1wFu8gD9bwHWJW-d0jTI2YddG5XBj5Hq3
7. Unpack fa480.rar into your Hugo folder.
8. Open your cmd again and navigate into your project folder.
       cd C:\Hugo\fa480

##### Add files and recompile project after changes
9. All of our blog post (.md) files will be added to the C:\Hugo\fa480\content folder.
10. Once new files have been added we can recompile our project to save the new changes. We can do this by typing "hugo" inside the project folder.

        C:\Hugo\fa480>hugo
        Building sites …
                           | EN
        +------------------+----+
          Pages            | 12
          Paginator pages  |  0
          Non-page files   |  0
          Static files     | 25
          Processed images |  0
          Aliases          |  1
          Sitemaps         |  1
          Cleaned          |  0

        Total in 88 ms

11. Project is now ready to be uploaded to the server.

##### Test hugo locally
12. type "hugo server" to test our project locally at http://localhost:1313/.
        C:\Hugo\fa480>hugo server
        Building sites …
                           | EN
        +------------------+----+
          Pages            | 12
          Paginator pages  |  0
          Non-page files   |  0
          Static files     | 25
          Processed images |  0
          Aliases          |  1
          Sitemaps         |  1
          Cleaned          |  0

        Total in 41 ms
        Watching for changes in C:\Hugo\fa480\{content,data,layouts,static,themes}
        Watching for config changes in C:\Hugo\fa480\config.toml
        Serving pages from memory
        Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
        Web Server is available at //localhost:1313/ (bind address 127.0.0.1)
        Press Ctrl+C to stop

##### How to upload from your machine onto our site
1. Open git bash <right click, git bash here> wherever your key file is (pem not ppk file)
2. Run 'scp -r -i 'name of keyfile.pem' ../Desktop/zipfilename.zip ubuntu@fa480.club:~/'<br>
  a. Assuming your zip file is located on your desktop
3. Go onto the aws ssh terminal,<br>
  a. Run Cd /~<br>
  b. Run Sudo Mv blog.zip /var/www/blog<br>
  c. Run Cd /var/www/blog (this is also cloned to /var/www/html for now)<br>
  d. Run Sudo Unzip blog.zip
