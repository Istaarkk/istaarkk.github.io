---
layout: page
title: Categories
permalink: /categories/
---

# Categories

Browse through all the cybersecurity topics by category:

{% for category in site.categories %}
  <h2 id="{{ category[0] }}">{{ category[0] | capitalize }}</h2>
  <ul>
    {% for post in category[1] %}
      <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
{% endfor %} 