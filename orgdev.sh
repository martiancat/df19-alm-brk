# assign variables
gitusername=dfalmteam
devsb=DevSB1
uat=UATFull

# Import auto pilot
source ./autopilot.sh

# Cleanup
rm -rf ./dfdemo
rm -rf ./dfdemo_working
hub delete -y $gitusername/dfdemo > /dev/null 2>&1
#node ./testing.js

# Demo script

# Create project and initialize Git and create remote repository
dprintf "##### Start by creating a working directory and new project #####"
dprintf "mkdir dfdemo"
dprintf "cd dfdemo"
git init > /dev/null 2>&1
dprintf "sfdx force:project:create -n myproject"
dprintf "cd myproject"
dprintf "##### Open VS Code to see project contents #####"
dprintf "code ."
# Set up git repo
git add . > /dev/null 2>&1
git commit -m 'commit project' > /dev/null 2>&1
git remote add origin https://github.com/$gitusername/dfdemo.git > /dev/null 2>&1
hub create > /dev/null 2>&1
git push -u origin master > /dev/null 2>&1
git push origin -d feature1 > /dev/null 2>&1
git push origin -d uat > /dev/null 2>&1
git checkout -b uat > /dev/null 2>&1
git push origin uat > /dev/null 2>&1
# Do development in Sandbox and pull changes and push them to source control repo
dprintf "##### Sync the sandbox with the local project #####"
dprintf "sfdx force:source:pull -u $devsb" 
dprintf "###### Now we will make a change in the Sandbox by adding a new custom field to the Contact standard object ######"
dprintf "sfdx force:org:open -u $devsb"
dprintf "##### And now we will pull the recent changes to the local project #####"
dprintf "sfdx force:source:pull -u $devsb"
dprintf "###### Now we will create and checkout a new feature branch for our changes ######"
dprintf "git branch feature1"
dprintf "git checkout feature1"
dprintf "###### And add and commit the changes to the feature branch ######"
dprintf "git add ."
dprintf "git commit -m 'My first feature commit'"
dprintf "###### Now we will push the changes to the remote repository feature branch ######"
dprintf "git push -u origin feature1"
dprintf "###### Now we will create a Pull Request ######"
dprintf "hub pull-request -b uat -h feature1"
dprintf "###### Now we will go into GitHub and review and merge the Pull Request ######"
dprintf "###### Now we will pull the changes from the repo to deploy them to UAT ######"
dprintf "mkdir ../../dfdemo_working"
dprintf "cd ../../dfdemo_working"
dprintf "git clone https://github.com/$gitusername/dfdemo"
dprintf "cd dfdemo/myproject"
dprintf "git pull origin uat"
dprintf "##### And deploy the changes to our UAT sandbox #####"
dprintf "sfdx force:source:deploy -p force-app/ -u $uat -w 10"
dprintf "###### Now we will go into the UAT sandbox to do final verification ######"
dprintf "sfdx force:org:open -u $uat"
dprintf "##### When we are ready to release to production we would repeat the steps to create a Pull Request to merge the changes into master ######"
dprintf "hub pull-request -b master -h uat"
