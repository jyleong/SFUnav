# README #

This README contains information for contributors and new users who will use the repository

### Version Submissions ###
* Version 3 Branch Name: [Master](https://bitbucket.org/20151cmpt_275/2015-1-cmpt_275_team_13/branch/master)

### Version 3 Startup Crash/Warnings Issue ###
* There is a known bug in a 3rd party toolkit that causes the map to ocassionally crash when using the emulator in Xcode. This does not happen on a physical device.
*  Warnings generated in the Images.xcassets and Storyboard are caused by the absence of scaled images for all resolution and auto layout issues. Changing the compiler flags or project build settings will ignore the warnings.
* Auto layout issues are ignored because we use slightly bigger buttons to allow for easier usage.

### Running the code ###
* Current Deployment Target: iOS: 8.1
* Suggested X-Code version to avoid issues: X-Code 6.1.1

### What is this repository for? ###
* This is the parent repo for SFUNav by Team NoMacs

### How do I get set up? ###
* Decide if your task requires a branch or a fork
* If you are using a branch, create a branch with a name that follows the syntax : <name>_<branch source>_branch
   e.g.: arjun_master_branch
* Clone the repository onto your mac using: git clone <url>
   the entire command can be available by clicking on the clone button under actions on the left side bar
* To navigate into your branch, use: git fetch && git checkout <branch name>
* To leave this branch and access other branches, you have to commit.
* For further details use the tutorials and documentation provided at [Bitbucket Documentation](https://confluence.atlassian.com/display/BITBUCKET/Bitbucket+Documentation+Home)

### IMPORTANT NOTES ###
* #### DO NOT MAKE CHANGES TO THE MASTER BRANCH WITHOUT BEING SURE THAT YOUR CODE WORKS ####
* INCASE OF A MERGE CONFLICT, CONTACT THE PERSON WHO'S CODE IT IS CONFLICTING WITH AND THEN RESOLVE THE ISSUE

### Doubts/Who do I talk to? ###

* Arjun Rathee and James Leong
