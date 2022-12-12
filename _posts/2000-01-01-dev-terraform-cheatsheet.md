---
layout: post
title: Terraform with DigitalOcean
category: Development
parent: Development
grand_parent: Cheatsheets  
modified_date: 2022-12-12
permalink: /:categories/:title/
---

<!-- vscode-markdown-toc -->
* [Ressources](#Ressources)
* [Command lines](#Commandlines)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


## <a name='Ressources'></a>Ressources

| 📚 **Top Sites** 									| 🎞️ **Top Video Channels** |
|---------------------------------------------------|------------------------|
| [DO resources](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) | 🔴 [simple coding](https://www.youtube.com/watch?v=u_zl7XHiF-g&list=PL9evZl_m5wqsc7C38L9grx-djts2bqT_b) |
| [terry-the-terraformer](https://github.com/ezra-buckingham/terry-the-terraformer) | |

## <a name='Commandlines'></a>Command lines

```
# watch logs building a droplet
tail -f /var/log/cloud-init-output.log
```