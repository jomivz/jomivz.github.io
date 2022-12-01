---
layout: post
title: Yet Cyber Cheatsheets
nav_order: 5
has_children: true
permalink: /cheatsheets/
---

## #yet 🖱 #cyber 🔫 #cheatsheets ↩️

<h2>Categories</h2>
<ul>
{% assign categories_list = site.categories %}
  {% if categories_list.first[0] == null %}
    {% for category in categories_list %}
      <li><a href="{{ category | downcase | downcase | url_escape | strip | replace: ' ', '-' }}">{{ category | camelcase }} ({{ site.tags[category].size}})</a></li>
    {% endfor %}
  {% else %}
    {% for category in categories_list %}
      <li><a href="{{ category[0] | downcase | url_escape | strip | replace: ' ', '-' }}">{{ category[0] | camelcase }} ({{ category[1].size }})</a></li>
  {% endfor %}
{% endif %}
{% assign categories_list = nil %}
</ul>

<h2>Full-listing</h2>

<table class="sortable">
<col width="20%">
<col width="80%">
<thead>
<tr>
<th>Last updated</th>
<th>Category</th>
<th>Cheatsheet</th>
</tr>
</thead>
<tbody>
{% assign timeframe = 5184000 %}

{% for post in site.posts %}
	{% if post.title != null %}
<tr>
<td><time datetime="{{ post.modified_date | date_to_xmlschema }}" itemprop="datePublished">{{ post.modified_date | date: "%Y-%m-%d" }}</time></td>
<td>{{ post.category }}</td>
<td><a href="{{ site.url }}{{ post.url }}"> {{ post.title }} </a></td>
	{% endif %}
  </tr>
{% endfor %}
</tbody>

</table>
<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
