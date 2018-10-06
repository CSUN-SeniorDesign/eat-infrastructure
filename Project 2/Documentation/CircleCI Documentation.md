# CircleCI
For the build, we are using the machine opposed to a docker container.  The first step is to checkout, then we make a directory where the blog will be placed. Hugo is installed using wget on the latest release. It is also possible to use apt to install snapd, then use snap to install hugo.

Doing it in this way would allow for more future proof code, so updated versions would automatically be downloaded and used, instead of having to change the code each version. The problem with doing it this way, is that we must run atp-get update, which can add around 2-3 minutes to the build time. As a result, we are currently doing the following:

Installing the hugo release using wget on the .deb file. Using apt-get for dpkg, then using dpkg to install the .deb release. After this, we run "hugo new site beats."

Following this step, we move our already checked-out theme into our hugo themes directory, then move our config into the /beats/ directory, to replace the already existing default config.toml.
Then, we move all of our content into /home/circleci/blogtozip/beats/content/

After this step, all of our required materials are in place, then we can run hugo. This will create a public file in the /beats/ directory. Following this, we remove the hugo.deb file we downloaded, then use tar to zip our public directory into a tar.gz. We use the environment variable $CIRCLE_SHA1 to get the commit number. Finally, we upload to s3 with aws s3 cp $CIRCLE_SHA1.tar.gz s3://csuneat-project-2/Uploads/

In order to allow us to determine which version is the staging version, a .txt file is also uploaded from github into s3 using CircleCI. This .txt file holds the file name of the current production version.
