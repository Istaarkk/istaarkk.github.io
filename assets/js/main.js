// Main JS functionality for the site
document.addEventListener('DOMContentLoaded', function() {
    // Initialize syntax highlighting
    if (typeof hljs !== 'undefined') {
        document.querySelectorAll('pre code').forEach((el) => {
            hljs.highlightElement(el);
        });
    }

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Responsive menu toggle for mobile
    const menuToggle = document.getElementById('menu-toggle');
    const siteNav = document.querySelector('.site-nav');
    
    if (menuToggle && siteNav) {
        menuToggle.addEventListener('click', function() {
            siteNav.classList.toggle('active');
            this.classList.toggle('active');
        });
    }

    // Handle dark/light mode toggle if present
    const themeToggle = document.getElementById('theme-toggle');
    
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            document.body.classList.toggle('dark-theme');
            
            // Save preference
            if (document.body.classList.contains('dark-theme')) {
                localStorage.setItem('theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                localStorage.setItem('theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
        });
        
        // Check for saved theme preference
        const savedTheme = localStorage.getItem('theme');
        
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-theme');
            themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
        } else {
            themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
        }
    }

    // Add 'on-scroll' class to header when scrolled
    const header = document.querySelector('header');
    
    if (header) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                header.classList.add('on-scroll');
            } else {
                header.classList.remove('on-scroll');
            }
        });
    }
    
    // Animate elements when they come into view
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.post-card, .category-box');
        
        elements.forEach(element => {
            const position = element.getBoundingClientRect();
            
            // If element is in viewport
            if(position.top >= 0 && position.bottom <= window.innerHeight) {
                element.classList.add('visible');
            }
        });
    };
    
    // Initial check on load
    animateOnScroll();
    
    // Check on scroll
    window.addEventListener('scroll', animateOnScroll);

    // Add line numbers to code blocks
    document.querySelectorAll('pre code').forEach((block) => {
        const lines = block.innerHTML.split('\n');
        let numberedLines = '';
        
        lines.forEach((line, index) => {
            if (index < lines.length - 1 || lines[lines.length - 1].trim() !== '') {
                numberedLines += `<span class="line-number">${index + 1}</span>${line}\n`;
            }
        });
        
        block.innerHTML = numberedLines;
        block.classList.add('line-numbers');
    });

    // Add caption to images that have alt text
    document.querySelectorAll('.article-content img[alt]').forEach((img) => {
        const alt = img.getAttribute('alt');
        if (alt && alt.trim() !== '') {
            const figure = document.createElement('figure');
            const figcaption = document.createElement('figcaption');
            
            img.parentNode.insertBefore(figure, img);
            figure.appendChild(img);
            figcaption.textContent = alt;
            figure.appendChild(figcaption);
        }
    });

    // Add heading links for easy reference
    document.querySelectorAll('.article-content h2, .article-content h3, .article-content h4, .article-content h5, .article-content h6').forEach((heading) => {
        if (heading.id) {
            const link = document.createElement('a');
            link.href = `#${heading.id}`;
            link.classList.add('heading-link');
            link.innerHTML = '<i class="fas fa-link"></i>';
            heading.appendChild(link);
        }
    });
    
    // Add 'target="_blank"' to external links
    document.querySelectorAll('a[href^="http"]').forEach((link) => {
        if (!link.hostname.includes(window.location.hostname)) {
            link.setAttribute('target', '_blank');
            link.setAttribute('rel', 'noopener noreferrer');
        }
    });

    // Add table of contents if there's a placeholder
    const tocPlaceholder = document.getElementById('toc');
    if (tocPlaceholder) {
        const headings = document.querySelectorAll('.article-content h2, .article-content h3');
        if (headings.length > 2) {
            const toc = document.createElement('ul');
            toc.classList.add('table-of-contents');
            
            headings.forEach((heading) => {
                if (heading.id) {
                    const listItem = document.createElement('li');
                    const link = document.createElement('a');
                    link.href = `#${heading.id}`;
                    link.textContent = heading.textContent.replace(/¶/g, '').trim();
                    listItem.appendChild(link);
                    
                    if (heading.tagName === 'H3') {
                        listItem.classList.add('toc-indent');
                    }
                    
                    toc.appendChild(listItem);
                }
            });
            
            tocPlaceholder.appendChild(toc);
        } else {
            tocPlaceholder.style.display = 'none';
        }
    }
}); 