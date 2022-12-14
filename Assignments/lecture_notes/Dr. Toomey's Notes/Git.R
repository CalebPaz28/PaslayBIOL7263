Version control with git
Matthew Toomey
8/10/2022
Git and Github
In this lesson we will setup and use git to track changes and recover earlier states in a project. We will link our local git project to github to create a long-lasting and sharable record of the project.

Terminology
git - a software system to track changes locally on your computer. Usually used to track text-based files like computer code.
github - a free, public website where you can host git tracked projects.
repository - (repo) - a collection of project files tracked together with git
commit (noun) - a snapshot of the tracked project at a specific point in time
commit (verb) - the act of capturing a snapshot of your project with git
push - copying changes from local project up to github
pull - copying changes from github to your local project
Setting up a new Github repository
Log into your github account
Select the repositories tab and click the “new” button
Name the repository
fill in a short description
add a readme file
and select a license (I use MIT)
all other options, accept the defaults
create!
  Start a linked project on your local computer
select “new project” from the file menu
select “version controlled”
select “git”
you will be asked for the repository URL
through your browser, go to the github repository you just created
click the “clone” button
copy the repository url and paste into Rstudio
If this is your first time linking to github through Rstudio, you will need to provide log in details for your github account (see Installation Instructions).
Make a webpage for your repository
select “new file” > “R markdown” from the file menu
Provide a title for your page
Save this file as “index”
Click the “knit” button at the top of the markdown editor window
Commit the changes to project and push to Github
click over to the terminal
if you are on a windows PC set the options so that the terminal opens with git bash
run the following commands
git status
git add -A
git commit -am 'initial commit'
git push
Host your “index” on Github pages
return to your repository of Github
open the “Settings and go to”Pages"
scroll to “Source” and change from “None” to “master branch”
Refresh page and you should see a message informing you of the web address for your page.
For example mine is https://mbtoomey.github.io/Biol_7263/
Git workflow
All of these commands are implemented in the terminal

Check the status of your project and make sure you are up-to-date with the remote repository
git status- provides details of the current project status
git pull - pulls down any changes from the github repository – Note that you can work on the same project on different computers, as long as you are careful to push and pull changes throught your github repository.
Do some work and commit it to the timeline
Do your actual work and make changes to files through Rstudio, text editors, or other specific software
git status - git will report that the files differ from the repository
git add -A - stage the changes
git commit -am 'informative comment'
this will commit and log the changes you have made in git
comments should:
start with an active verb
all lower case
no punctuation
You can then add these changes to your Github repository
git push
Reviewing the commits in your repro
git log - full list with details of each commit
git log --oneline - a concise list of the commits
git log -2 - shows the last two commits
you can vary the parameter to see more or less
git log -1 -p HEAD - see details of all the changes in the last commit
Amending a commit
For small changes

make changes
stage the changes
git commit --amend -C Head
This will amend the changes you have made to the last commit
Change the git message

git commit --amend -m '<revised message>'
revises message on last commit
Delete a commit

git reset --hard HEAD^
^ indicates a single step backward
this will get rid of all changes in the last commit
be careful, this can’t be undone
Recover a file from an earlier commit

first find it in your commits
git log --oneline -- <file name>
only shows commits where your file was modified
git checkout <hashcode of last commit where file was present> -- <file name>
Branching

git branch
shows all branches and currently active branch
git branch <name of new branch>
adds a new branch
git checkout <name of new branch>
switches to the new branch
git merge --log <name of branch to be merged into current>
first switch to branch you want to merge into
merges working branch back into main with commit comments
git branch -d <name>
deletes branches that have been merged to master
git branch -D <name>
deletes branches without merging
good if you do not want to keep changes