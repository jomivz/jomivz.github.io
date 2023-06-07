---
layout: post
title: Build .NET projects
category: dev
parent: cheatsheets
modified_date: 2023-06-03
permalink: /dev/dotnet
---

<!-- vscode-markdown-toc -->
* [get-version](#get-version)
* [install](#install)
* [build](#build)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='get-version'></a>get-version

Check the core version:
```
# V1 current version is 4.8
cd C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework
msbuild.exe -version

# V2 current version is 4.8
cd hklm:
ls SOFTWARE\Microsoft\NET Framework Setup\NDP\v4
```

## <a name='install'></a>install

Install EoL version 4.5
```
choco install netfx-4.5.1-devpack
```

## <a name='build'></a>build
