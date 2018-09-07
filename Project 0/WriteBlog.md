# How to write a blog post

1. Download GIT for windows: https://git-scm.com/download/win
2. Install. When it's done create a new folder on your desktop.
3. Open the folder, right click inside. Select "Git bash here" on the drop down.
4. In the cli, type "git clone https://github.com/CSUN-SeniorDesign/eat-blog.git" then enter.
5. Open the new eat-blog folder assuming the command runs successfully.
6. Inside, right click, add a new file "weekx-lastname.md" i.e. "week1-kluszczynski.md"
7. If you don't have a markdown editor: <br>
      a. Download Atom here https://atom.io/ <br>
      b. Install. Open atom. <br>
      c. File -> Add project folder -> eat-blog folder. Click select folder. <br>
      d. Open your markdown (.md file) <br>
      e. Once it's open, press ctrl+shift+m. The window will split. <br>
      f. The left side is where you add your markdown, the right side will show a preview. <br>
     g. You can see how to use markdown here: https://guides.github.com/features/mastering-markdown/ <br>
     h. Create your blog post. <br>
     i. Please have a consistent blog style, starting with: <br>     <br>## Name's blog. Week x.
     <br>##### Topic<br>
     bla bla
     <br>##### Topic 2
     <br>etc
     etc.<br><br>
8. When you're done writing your blog post, open your eat-blog folder again, and open git-bash again.
9. 
  a. Run "git branch <lastname>-weekx i.e. kluszczynski-week2" <br>
  b. run "git checkout <branchname>" i.e. git checkout kluszczynski-week2
10. Run the command "git add <markdown filename>" or run "git add ."
11. Run the command "git status." Everything should be green.
12. Run the command "git commit -m "Week <x> blog post for <name> uploaded" "
13. Run the command "git push origin <branchname>."
14. Go onto github, click the "compare & pull request" button.
15. Click "create pull request", then submit
16. Have someone else make a comment on your pull request, then click the "merge and branch" button.
17. Go to the branches, delete the active branch.
