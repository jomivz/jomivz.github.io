---
layout: default
title: GIT Quickstart
parent: Development
grand_parent: Cheatsheets  
category: Development
---

<!-- vscode-markdown-toc -->
* 1. [Generate SSH keypair](#GenerateSSHkeypair)
* 2. [Introduction](#Introduction)
* 3. [Configure git settings](#Configuregitsettings)
* 4. [Working with repos](#Workingwithrepos)
* 5. [Ignoring content](#Ignoringcontent)
* 6. [Logging](#Logging)
* 7. [Branches](#Branches)
* 8. [Pushes and Merges](#PushesandMerges)
* 9. [Cleaning repo](#Cleaningrepo)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# {{ page.title }}

##  1. <a name='GenerateSSHkeypair'></a>Generate SSH keypair
---------------------
```
ssh-keygen -t rsa -b 4096 -C "john@smith.fr"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
sudo apt install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
ssh -T git@github.com
```

##  2. <a name='Introduction'></a>Introduction
---------------------
Git is a source control tool created by Linus Torvald.
Simply stated, git manage snapshots, checksums, and metadata to track of changes in files.

Some basics terminology:
- each state is a commit
- the current commit is called the HEAD
- commits are affiliated with repositories and branches
- the HEAD may be moved between commits

##  3. <a name='Configuregitsettings'></a>Configure git settings
---------------------
```
git config --global user.email "john@smith.fr"
git config --global user.name "john"
git config --system core.editor vim
```

Alternatively, assign system-wide configuration in the config files:
- /etc/gitconfig which correspond to --system
- ~/.gitconfig or ~/.config/git/config whci correspond to --global
- .git/config in a directory which correspond to --local 
Note: Files lower in the list override higher files.

Files format:
```
[user]
	name = john smith
	email = john@smith.fr
```

Exclude certain paths:
```
git config --global core.excludesfile <path>
```

##  4. <a name='Workingwithrepos'></a>Working with repos
---------------------

To create a repo, use the command below. It creates a ```.git``` directory in the repository for git metadata:
```
git init
```

To clone an existing repository
```
git clone ssh://user@domain.com/repo.git
```

Making changes, tracking and commiting its like this:
```
touch blob1.txt blob2.txt
git add blob2.txt
git status
      
	Sur la branche master
	Votre branche est à jour avec 'origin/master'.

	Modifications qui seront validées :
	  (utilisez "git reset HEAD <fichier>..." pour désindexer)

		nouveau fichier : blob2.txt

git reset HEAD blob2.txt
git rm -f blob2.txt
git commit -m "some comments here"
git push origin master
```

##  5. <a name='Ignoringcontent'></a>Ignoring content
---------------------

Binaries, compiled files might be not versionned. Disregard those files creating a ```.gitignore``` file:
```
*.o
src/
**.cache/
**.jekyll-cache/
```

##  6. <a name='Logging'></a>Logging
---------------------

```
git log --oneline
```
Look at logs for a particular file
```
git log -- <filename>
git log --oneline <filename>
```

Look at logs in a graphical way
```
git log --graph --decorate
```

##  7. <a name='Branches'></a>Branches 
---------------------

Branches allows to create an effective copy of the master branch with a repository that worked with or without interfering with the master. This declutters the master branch.

Create a branch:
```
git branch foo
```

Begin working in a new branch:
```
git checkout foo
```

Do both at once
```
git checkout -b foo
```

##  8. <a name='PushesandMerges'></a>Pushes and Merges
---------------------

Push one or all branches to the origin:
```
git push origin <branchname>
git push origin --all
```

Merge a branch with HEAD on the master branch:
```
git checkout branch
git merge foo
```

##  9. <a name='Cleaningrepo'></a>Cleaning repo 
---------------------

Steps to remove folder/directory only from git repository and not from the local  :

```
git rm -r --cached FolderName
git commit -m "Removed folder from repository"
git push origin master
```
