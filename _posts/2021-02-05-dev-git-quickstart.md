---
layout: post
title: GIT Cheatsheet
parent: Development
grand_parent: Cheatsheets  
category: Development
modified_date: 2021-11-19
---

<!-- vscode-markdown-toc -->
* [Generate SSH keypair](#GenerateSSHkeypair)
* [Introduction](#Introduction)
* [Configure git settings](#Configuregitsettings)
* [Working with repos](#Workingwithrepos)
* [Ignoring content](#Ignoringcontent)
* [Logging](#Logging)
* [Branches](#Branches)
* [Pushes and Merges](#PushesandMerges)
* [Cleaning repo](#Cleaningrepo)
* [Rollback on files](#Rollbackonfiles)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

First if something missing here, [Atlassian GIT tutorials](https://www.atlassian.com/fr/git/tutorials).

## <a name='GenerateSSHkeypair'></a>Generate SSH keypair
---------------------
```
ssh-keygen -t rsa -b 4096 -C "john@smith.fr"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
sudo apt install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
ssh -T git@github.com
```

## <a name='Introduction'></a>Introduction
---------------------
Git is a source control tool created by Linus Torvald.
Simply stated, git manage snapshots, checksums, and metadata to track of changes in files.

Some basics terminology:
- each state is a commit
- the current commit is called the HEAD
- commits are affiliated with repositories and branches
- the HEAD may be moved between commits

## <a name='Configuregitsettings'></a>Configure git settings
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

## <a name='Workingwithrepos'></a>Working with repos
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

## <a name='Ignoringcontent'></a>Ignoring content
---------------------

Binaries, compiled files might be not versionned. Disregard those files creating a ```.gitignore``` file:
```
*.o
src/
**.cache/
**.jekyll-cache/
```

## <a name='Logging'></a>Logging
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

## <a name='Branches'></a>Branches 
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

## <a name='PushesandMerges'></a>Pushes and Merges
---------------------

Push one or all branches to the origin:
```
git push origin <branchname>
git push origin --all
```

Merge a branch with HEAD on the master branch:
```
git pull
git checkout master
git merge foo
```

## <a name='Cleaningrepo'></a>Cleaning repo 
---------------------

Steps to remove folder/directory only from git repository and not from the local  :

```
git rm -r --cached FolderName
git commit -m "Removed folder from repository"
git push origin master
```

## <a name='Rollbackonfiles'></a>Rollback on files
---------------------

```
#Interesting when file was erased / nothing functioning anymore
git checkout -- file.txt

#Case of loop erasing a folder
for i in `ls`; echo "" > $i; done
git checkout -- *
```
