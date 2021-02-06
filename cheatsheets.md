---
layout: default
title: Cheatsheets
nav_order: 2
has_children: true
permalink: /cheatsheets
---

<h2>Cheatsheets' categories</h2>
<ul>
{% assign categories_list = site.categories %}
  {% if categories_list.first[0] == null %}
    {% for category in categories_list %}
      <li><a href="#{{ category | downcase | downcase | url_escape | strip | replace: ' ', '-' }}">{{ category | camelcase }} ({{ site.tags[category].size}})</a></li>
    {% endfor %}
  {% else %}
    {% for category in categories_list %}
      <li><a href="#{{ category[0] | downcase | url_escape | strip | replace: ' ', '-' }}">{{ category[0] | camelcase }} ({{ category[1].size }})</a></li>
  {% endfor %}
{% endif %}
{% assign categories_list = nil %}
</ul>

<h2>Cheatsheets full-listing</h2>
{% for category in site.categories %}
  <h3 id="{{ category[0] | downcase | url_escape | strip | replace: ' ', '-' }}">{{ category[0] | camelcase }}</h3>
  <ul>
    {% assign pages_list = category[1] %}
    {% for post in pages_list %}
      {% if post.title != null %}
      {% if group == null or group == post.group %}
        <li><a href="{{ site.url }}{{ post.url }}"><time datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date: "%Y-%m-%d" }} - {{ post.title }} </time></a></li>
      {% endif %}
      {% endif %}
    {% endfor %}
    {% assign pages_list = nil %}
    {% assign group = nil %}
  </ul>
{% endfor %}
