---
layout: post
title: Yet Cyber Cheatsheets
nav_order: 5
category: cheatsheets
has_children: true
---

<h3>Play and Detect cheatsheets</h3>
<ul>
{% assign categories_list = site.categories %}
  {% if categories_list.first[0] == null %}
    {% for category in categories_list limit: 7 %}
      {% assign cate = category[0] | downcase | downcase | url_escape | strip | split: "-" %}
      <li><a href="{{ cate[1] }}">{{ category | camelcase }} ({{ site.tags[category].size}})</a></li>
    {% endfor %}
  {% else %}
    {% for category in categories_list  limit: 7 %}
      {% assign cate = category[0] | downcase | downcase | url_escape | strip | split: "-" %}
      <li><a href="{{ cate[1] }}">{{ cate[1] | camelcase }} ({{ category[1].size }})</a></li>
    {% endfor %}
</ul>

<h3>Other cheatsheets categories</h3>
<ul>
    {% for category in categories_list offset:7 continue %}
      {% assign cate = category[0] | downcase | downcase | url_escape | strip | split: "-" %}
      <li><a href="{{ cate[1] }}">{{ cate[1] | camelcase }} ({{ category[1].size }})</a></li>
    {% endfor %}

{% endif %}
{% assign categories_list = nil %}
</ul>


<h3>Cheatsheets full-listing</h3>

<table class="sortable">
<col width="20%">
<col width="80%">
<thead>
<tr>
<th>Last updated</th>
<th>Cheatsheet</th>
<th>Category</th>
</tr>
</thead>
<tbody>
{% assign timeframe = 5184000 %}

{% for post in site.posts %}
	{% if post.title != null %}
<tr>
<td><time datetime="{{ post.modified_date | date_to_xmlschema }}" itemprop="datePublished">{{ post.modified_date | date: "%Y-%m-%d" }}</time></td>
<td><a href="{{ site.url }}{{ post.url }}"> {{ post.title }} </a></td>
<td>{{ post.category }}</td>
	{% endif %}
  </tr>
{% endfor %}
</tbody>

</table>
<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
