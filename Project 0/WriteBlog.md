# How to write a blog.

#### Initial setup, first time use only.
  1. Download GIT for windows : https://git-scm.com/download/win

  2. Install. When it's done create a new folder on your desktop.

  3. Open the new folder, right click inside. Select "Git bash here" on the drop down.

#### For future weeks.
  4. a. After week 1, ignore #1-3. Go into the eat-blog folder on your desktop instead, open git bash by right clicking and selecting "git bash here".

  5. In the cli, type "git clone https://github.com/CSUN-SeniorDesign/eat-blog.git" then enter.

  6. Open the new eat-blog folder assuming the command runs successfully.

  7. Open the folder for this week's blogs. Inside, right click, add a new file "weekx-lastname.md" i.e. "week1-kluszczynski.md".

#### Obtaining a markdown editor.
  8. If you don't have a markdown editor:

    a. Download Atom here https://atom.io/

    b. Install. Open atom.

    c. File -) Add project folder -) eat-blog folder. Click select folder.

    d. Open your markdown (.md file).

    e. Once it's open, press ctrl+shift+m. The window will split.

    f. The left side is where you add your markdown, the right side will show a preview.

    You can see how to use markdown here: https://guides.github.com/features/mastering-markdown/

#### Writing your blog
Create your blog post. Please have a consistent blog style, starting with:
## Name's blog. Week x.
##### Topic
Description
##### Topic 2
Description.

---------------------

9. When you're done writing your blog post, open your eat-blog folder again, and open git-bash again.

#### Creating a new branch.
10. Run "git branch (lastname)-weekx i.e. kluszczynski-week2" This creates a new branch.

11. Run "git checkout (branchname)" i.e. git checkout kluszczynski-week2.

#### Adding your file to the branch.
12. Run the command "git add (markdown filename)" or run "git add ."

13. Run the command "git status." Everything should be green.

#### Committing and pushing your branch.
14. Run the command "git commit -m "Week (x) blog post for (name) uploaded" ".

15. Run the command "git push origin (branchname)."

#### Finishing on GitHub with a pull request
16. Go onto github, click the "compare & pull request" button.

17. Click "create pull request", then submit.

18. Have someone else make a comment on your pull request, then click the "merge pull request" button.

19. Go to the branches, delete the active branch.

20. To push the blog to the server, see the "How to upload from your machine onto our site" section of "DeployBlog.md".
