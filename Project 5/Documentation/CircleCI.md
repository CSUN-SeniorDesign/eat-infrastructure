# CircleCI and Deploying Blogs
CircleCI has been updated to deploy to S3 only when there is a commit to the master branch.

First we make a new directory
```
# Making blog upload directory
sudo mkdir ~/blogupload
```

Then, we install hugo and dpkg. Note that the wget will need to change for future versions of hugo, and it is possible to use apt-get to install hugo, but takes longer to build.

```
# Getting required packages.
sudo wget https://github.com/gohugoio/hugo/releases/download/v0.49/hugo_0.49_Linux-64bit.deb
sudo apt-get install dpkg

# Installing hugo
sudo dpkg -i hugo_0.49_Linux-64bit.deb
```

After this, we set up the blog site similar to previous projects, moving the posts into a post directory, and the theme into a theme directory.
```
# Setting up site
cd ~/blogupload
sudo hugo new site beats
sudo mv -v ~/project/arabica ~/blogupload/beats/themes
sudo mv ~/project/config.toml ~/blogupload/beats/config.toml
sudo mkdir ~/blogupload/beats/content/post
sudo mv -v ~/project/* ~/blogupload/beats/content/post
```

Next, we remove the .deb file so it isn't uploaded, then build the site.
```
# Removing deb
sudo rm ~/blogupload/beats/content/post/hugo_0.49_Linux-64bit.deb

# Building site
cd ~/blogupload/beats
sudo hugo
```

Finally, we upload to S3.
```
# Upload files to S3
sudo pip install awscli        
aws s3 cp ~/blogupload/beats/public/ s3://fa480.club/ --recursive
```

## Deploying a blog
The blog can be written using markdown, similar to previous assignments. We are now adding a tag on the top of the weekly blogs so the title appears on the website.  It looks similar to this:

```
+++
title = "Tyler's Blog. Week 10."
description = "Project 5"
tags = [
    "Blog", "beats", "Tyler", "CIT 480",
]
date = "2018-10-31"
categories = [
    "Blog",
]
menu = "main"
+++
```

When the blog is done, add it to the corresponding folder, then when it gets pushed to master after approval of a pull request, it will automatically be uploaded to the site.
