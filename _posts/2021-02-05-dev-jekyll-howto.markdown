---
layout: post
title: Running github pages locally with JEKYLL
parent: Development
category: Development
grand_parent: Cheatsheets  
permalink: /docs/development/git/
nav_order: 4
modified_date: 2021-11-19
---

<!-- vscode-markdown-toc -->
* [Installation](#Installation)
* [Testing](#Testing)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

OLD: Gems to install change a lot from a version to another. Prefer to use the [jekyll docker image](https://hub.docker.com/r/jekyll/jekyll/). 
See how to install on Kali [here](http://www.jmvwork.xyz/sysadmin/2021/10/26/sys-cli-docker.html)

Github Pages run with Jekyll. This markdown explains how tp install and run/test it.
This is a way of editing is interesting when:
- changing the main pages
- adding features

To edit the markdowns, a classic flow of git pull/push should be enough.

## <a name='Installation'></a>Installation

Check [sofwares required](https://jekyllrb.com/docs/installation/) for installation on the Jekyll offical website.

Here are the required packages installed, last tested on 2021/01/25 :
```
sudo dnf install ruby ruby-devel openssl-devel redhat-rpm-config @development-tools
```

To install Jekyll locally, copy/paste the following commands:

```bash
gem install jekyll bundler \
sudo yum install g++ \
gem install rake \
gem install listen -v 3.4.0 \
gem install jekyll-feed -v 0.13.0 \
gem install jekyll-seo-tag -v 2.6.1 \
gem install minima -v 2.5.1 \
gem install concurrent-ruby -v 1.1.7 \
gem install rexml -v 3.2.4
```

```bash
gem install just-the-docs
```

## <a name='Testing'></a>Testing

Run a localhost webserver with the following command:

```bash
bundle exec jekyll serve --watch
```
For shared directory in a VM or container, run
```bash
bundle exec jekyll serve --watch --force
```

