---
layout: page
title: Categories
permalink: /categories/
---

<div class="taxonomy-container">
  <ul class="taxonomy-list">
    {% assign sorted_categories = site.categories | sort %}
    {% for category in sorted_categories %}
      <li class="taxonomy-item">
        <a href="#{{ category[0] | slugify }}">
          <div class="taxonomy-name">{{ category[0] }}</div>
          <div class="taxonomy-count">{{ category[1].size }} articles</div>
        </a>
      </li>
    {% endfor %}
  </ul>
  
  <div class="taxonomy-sections">
    {% for category in sorted_categories %}
      <section id="{{ category[0] | slugify }}" class="taxonomy-section">
        <h2 class="taxonomy-title">{{ category[0] }}</h2>
        <ul class="post-list">
          {% for post in category[1] %}
            <li class="taxonomy-post">
              <a href="{{ post.url | relative_url }}">
                <span class="post-date">{{ post.date | date: "%d %b %Y" }}</span>
                <span class="post-title">{{ post.title }}</span>
              </a>
            </li>
          {% endfor %}
        </ul>
      </section>
    {% endfor %}
  </div>
</div>

<style>
  .taxonomy-container {
    display: flex;
    flex-direction: column;
    gap: 40px;
  }
  
  .taxonomy-sections {
    display: flex;
    flex-direction: column;
    gap: 40px;
  }
  
  .taxonomy-section {
    margin-bottom: 20px;
    scroll-margin-top: 80px;
  }
  
  .taxonomy-title {
    position: relative;
    margin-bottom: 20px;
    padding-bottom: 10px;
    display: inline-block;
  }
  
  .taxonomy-title:after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 60px;
    height: 4px;
    background-color: var(--accent-color);
  }
  
  .taxonomy-post {
    margin-bottom: 10px;
  }
  
  .taxonomy-post a {
    display: flex;
    align-items: baseline;
    color: var(--text-color);
    padding: 10px 15px;
    border-radius: 4px;
    transition: all 0.2s;
  }
  
  .taxonomy-post a:hover {
    background-color: var(--light-background);
    text-decoration: none;
    transform: translateX(5px);
  }
  
  .post-date {
    min-width: 100px;
    font-size: 0.85rem;
    color: var(--light-text);
  }
  
  @media (max-width: 768px) {
    .taxonomy-post a {
      flex-direction: column;
      align-items: flex-start;
    }
    
    .post-date {
      margin-bottom: 5px;
    }
  }
</style> 