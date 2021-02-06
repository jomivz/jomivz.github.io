---
layout: default
title: Sysadmin
category: Sysadmin
parent: Cheatsheets
nav_order: 1
permalink: /cheatsheets/sysadmin
---

<h1>{{ page.title }} cheatsheets</h1>
<h2>{{ page.description }}</h2>

  <ul>
    {% for post in site.categories[page.category] %}
      {% if post.title != null %}
        <li><a href="{{ site.url }}{{ post.url }}"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date: "%Y-%m-%d" }} - {{ post.title }} </time></a></li>
      {% endif %}
    {% endfor %}
  </ul>
