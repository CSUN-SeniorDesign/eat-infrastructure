# Scripts
There were two primary scripts for this project. One for uploading the .txt file to s3, and one to fetch the .txt file and .tar.gz from s3.

# Beats Uploader
The BEATS Uploader is a tool used to update the ProductionSite.txt file. 
It works by:
 - pulling down the eat-blog repo, 
 - getting the latest commit SHA from the cloned repo.
 - updating the ProductionSite.txt file with the new cloned repo (or allowing a user to enter their own choise of SHA).
 - making a git branch, checkout, adding the new .txt file, comitting and pushing.
 - From there, the user must go on the github to create a pull request for their new .txt file. 

# S3-Fetch
S3-Fetch is used by the servers as a cronjob to fetch from s3.
 - First, the ProductionSite.txt is fetched for the production enviornment as "NewProductionSite.txt". 
 - If this file is the same as the already stored ProductionSite.txt, the NewProductionSite.txt replaces ProductionSite.txt, and nothing else happens.
 - If the file is different, it will fetch the .tar.gz stated in the ProductionSite file, unzip it and move it into /var/www/html.
 - On the staging side, there is a ProductionSite.txt which states the current most recent version.
 - The cronjob will check this .txt file against the most recent .tar.gz on s3. If the commit numbers in both are the same, nothing happens. Otherwise, the new version is pulled down, and palced in /var/www/staging.
 - In either case, if a site is replaced, apache and the server are restarted.

