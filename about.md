---
layout: page
title: About
permalink: /about/
---

<div class="about-container">
  <div class="about-intro">
    <div class="about-avatar">
      <img src="/assets/images/avatar.png" alt="Istark - Cybersecurity Researcher">
    </div>
    <div class="about-text">
      <h2>Istark</h2>
      <p class="about-tagline">Chercheur en Cybersécurité & Analyste de Sécurité</p>
      
      <div class="about-social">
        <a href="https://github.com/Istaarkk" target="_blank" rel="noopener"><i class="fab fa-github"></i></a>
        <a href="https://twitter.com/istaarkk" target="_blank" rel="noopener"><i class="fab fa-twitter"></i></a>
        <a href="https://www.linkedin.com/in/istaarkk/" target="_blank" rel="noopener"><i class="fab fa-linkedin"></i></a>
      </div>
    </div>
  </div>
  
  <div class="about-section">
    <h3>À Propos de Ce Site</h3>
    <p>Bienvenue sur mon laboratoire de cybersécurité. Ce site est dédié au partage de mes recherches, analyses et expériences dans divers domaines de la sécurité informatique.</p>
    
    <p>Vous y trouverez des articles techniques sur la sécurité web, l'exploitation binaire, le reverse engineering, les communications réseau, et bien d'autres sujets liés à la cybersécurité.</p>
  </div>
  
  <div class="about-section">
    <h3>Expertise & Compétences</h3>
    
    <div class="skills-container">
      <div class="skill-category">
        <h4>Web Security</h4>
        <ul>
          <li>Audit d'applications web</li>
          <li>OWASP Top 10</li>
          <li>Analyse de vulnérabilités</li>
          <li>Pentesting</li>
        </ul>
      </div>
      
      <div class="skill-category">
        <h4>Binary Exploitation</h4>
        <ul>
          <li>Analyse de vulnérabilités binaires</li>
          <li>Exploitation de la mémoire</li>
          <li>Reverse engineering</li>
          <li>Développement d'exploits</li>
        </ul>
      </div>
      
      <div class="skill-category">
        <h4>Network Security</h4>
        <ul>
          <li>Analyse de protocoles</li>
          <li>Sécurité des communications</li>
          <li>Détection d'intrusion</li>
          <li>Monitoring réseau</li>
        </ul>
      </div>
    </div>
  </div>
  
  <div class="about-section">
    <h3>Contact</h3>
    <p>Pour toute question, collaboration ou échange professionnel, n'hésitez pas à me contacter via les réseaux sociaux ci-dessus ou par email à l'adresse suivante: <a href="mailto:contact@istarklab.com">contact@istarklab.com</a></p>
  </div>
</div>

<style>
  .about-container {
    display: flex;
    flex-direction: column;
    gap: 40px;
  }
  
  .about-intro {
    display: flex;
    align-items: center;
    gap: 30px;
    margin-bottom: 20px;
  }
  
  .about-avatar {
    flex-shrink: 0;
  }
  
  .about-avatar img {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid var(--accent-color);
  }
  
  .about-text {
    flex-grow: 1;
  }
  
  .about-text h2 {
    margin-top: 0;
    margin-bottom: 10px;
    font-size: 2rem;
  }
  
  .about-tagline {
    font-size: 1.1rem;
    color: var(--light-text);
    margin-bottom: 15px;
  }
  
  .about-social {
    display: flex;
    gap: 15px;
  }
  
  .about-social a {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: var(--light-background);
    color: var(--accent-color);
    font-size: 1.2rem;
    transition: all 0.2s;
  }
  
  .about-social a:hover {
    background-color: var(--accent-color);
    color: white;
    transform: translateY(-3px);
  }
  
  .about-section {
    margin-bottom: 20px;
  }
  
  .about-section h3 {
    position: relative;
    margin-bottom: 20px;
    padding-bottom: 10px;
    display: inline-block;
  }
  
  .about-section h3:after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 40px;
    height: 3px;
    background-color: var(--accent-color);
  }
  
  .skills-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
    margin-top: 20px;
  }
  
  .skill-category {
    background-color: var(--light-background);
    border-radius: 8px;
    padding: 20px;
    box-shadow: var(--card-shadow);
  }
  
  .skill-category h4 {
    margin-top: 0;
    margin-bottom: 15px;
    color: var(--accent-color);
  }
  
  .skill-category ul {
    list-style-type: none;
    padding-left: 0;
    margin-bottom: 0;
  }
  
  .skill-category ul li {
    margin-bottom: 8px;
    position: relative;
    padding-left: 20px;
  }
  
  .skill-category ul li:before {
    content: '→';
    position: absolute;
    left: 0;
    color: var(--accent-color);
  }
  
  @media (max-width: 768px) {
    .about-intro {
      flex-direction: column;
      text-align: center;
    }
    
    .about-social {
      justify-content: center;
    }
    
    .about-section h3:after {
      left: 50%;
      transform: translateX(-50%);
    }
    
    .about-section h3 {
      display: block;
      text-align: center;
    }
  }
</style>

*This site is built with [Jekyll](https://jekyllrb.com/) and hosted on GitHub Pages.* 