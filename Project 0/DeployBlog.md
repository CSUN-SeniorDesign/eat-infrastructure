# How to deploy a new blog post
##### Installation of Hugo

1. Create a new folder under C:\ and name it "Hugo" and create a folder inside the Hugo folder called "bin".
2. Navigate over to https://github.com/gohugoio/hugo/releases to download the latest release of Hugo. I run windows so I picked hugo_0.48_Windows-64bit.zip
3. Unpack hugo_0.48_Windows-64bit.zip to your bin folder under C:\Hugo\bin.
4. Open your cmd and navigate to your hugo folder.
       cd C:\Hugo
5. When inside the Hugo folder, type "hugo version" and it should return a message similar to this:

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

##### How to upload from your machine onto our site.
1. After all blogs have been finished for the week, add them to the hugo site directory for blogs.
2. After that, open your cmd (not git bash) and run "hugo" inside the hugo site folder. It should generate a public folder.
3. Zip the **contents** of the public folder with a .zip extension. Don't zip the folder itself or you'll make more work for yourself.
4. Open git bash (right click, git bash here) wherever your key file is (pem not ppk file).
5. Run "scp -r -i 'name of keyfile.pem' ../Desktop/zipfilename.zip ubuntu@fa480.club:~/" in git bash. (Assuming your zip file of the public file is located on your desktop).
6. Go onto the aws ssh terminal.

##### Finishing from the AWS Terminal.
1. Run "cd ~/". You should be able to see the zip file you copied if you run "ls".
2. Run "cd /var/www/blog". This takes you to the blog directory.
3. Run "sudo rm -rf \*". **This will delete the site at blog.fa480.club.**
4. Run "cd /var/www/html." This takes you to the main site directory.
5. Run "sudo rm -rf \*". **This will delete the site at fa480.club.**
6. Run "cd ~/" again . You should be able to see the zip file again.
7. Run "sudo mv blog.zip /var/www/blog". This moves the zip file to the blog folder. Navigate to the blog folder again with "cd /var/www/blog."
8. Run "sudo unzip blog.zip". This will unzip the contents of the public folder.
9. Run "sudo mv blog.zip /var/www/html". This will move the blog.zip to the html site, where it needs to be copied (until we have a different homepage). Navigate to the html folder again with "cd /var/www/html."
10. Run "sudo unzip blog.zip" again.
11. Run "sudo rm blog.zip" to delete the zip file.
