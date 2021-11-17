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

<h2>Last Updates</h2>

<table>
<col width="20%">
<col width="80%">
<tr>
<th>Last updated</th>
<th>Page</th>
</tr>

{% assign timeframe = 5184000 %}
{% assign count = 0 %}

{% for post in pages_list %}
  {% assign post_in_seconds = post.last-modified | date: "%s" | plus: 0 %}
  {% assign recent_posts = "now" | date: "%s" | minus: timeframe  %}

  {% if post_in_seconds > recent_posts %}
  {% assign count = count | plus:1 %}

<tr>
<td>{{post.last-modified | date: "%b %d, %Y" }}</td>
<td><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a> </td>
</tr>
{% if count == 15 %}{% break %}{% endif %}
{% endif %}
{% endfor %}
</table>

{% comment %}
details about the script logic above: https://idratherbewriting.com/blog/adding-last-modified-timestamps-to-documentation/
{% endcomment %}