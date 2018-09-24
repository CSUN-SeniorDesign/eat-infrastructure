##### Setup a new site with Hugo

1. To install hugo:
sudo apt-get update
sudo apt-get install hugo

2. Verify your installation:
which hugo

(Should return /usr/local/bin/Hugo)

3. Create a new site:
hugo new site beats

4. Navigate to new site:
cd ~/beats

5. Pick a theme (https://themes.gohugo.io/) and find the git link. I picked the theme "dream" just to test.
cd themes
git clone https://github.com/g1eny0ung/hugo-theme-dream.git dream

6. We now need to copy the sample posts the theme uses, this will be replaced with our blog posts.
sudo cp -R ~/beats/themes/dream/exampleSite/content ~/beats/content

7. Navigate back to your beats folder.
cd ~/beats
nano config.toml

Add the line: theme = "hugo-theme-dream"

8. run "hugo server"

9. Your site should be up and running at http://localhost:1313

10. Run "hugo" to compile the website before uploading to apache folder.
