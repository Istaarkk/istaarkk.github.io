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
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 100,
                    behavior: 'smooth'
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
        const lines = block.textContent.split('\n');
        if (lines[lines.length - 1] === '') lines.pop();
        
        let numberedLines = '';
        lines.forEach((line, index) => {
            numberedLines += `<span class="line-number">${index + 1}</span>${line}\n`;
        });
        
        block.innerHTML = numberedLines;
        block.parentNode.classList.add('line-numbers');
    });

    // Add image caption from alt text
    document.querySelectorAll('.post-content img[alt]').forEach(img => {
        if (img.alt.trim() !== '') {
            const figure = document.createElement('figure');
            const figcaption = document.createElement('figcaption');
            
            img.parentNode.insertBefore(figure, img);
            figure.appendChild(img);
            figure.appendChild(figcaption);
            figcaption.textContent = img.alt;
        }
    });

    // Add heading anchor links
    document.querySelectorAll('.post-content h2, .post-content h3, .post-content h4').forEach(heading => {
        const id = heading.getAttribute('id');
        if (id) {
            const anchor = document.createElement('a');
            anchor.className = 'heading-anchor';
            anchor.setAttribute('href', `#${id}`);
            anchor.innerHTML = '<i class="fas fa-link"></i>';
            heading.appendChild(anchor);
        }
    });
    
    // Handle external links - open in new tab
    document.querySelectorAll('a[href^="http"]').forEach(link => {
        if (!link.hostname.includes(window.location.hostname)) {
            link.setAttribute('target', '_blank');
            link.setAttribute('rel', 'noopener noreferrer');
            
            // Optional: add external link icon
            if (!link.querySelector('.fa-external-link-alt')) {
                const icon = document.createElement('i');
                icon.className = 'fas fa-external-link-alt';
                icon.style.fontSize = '0.8em';
                icon.style.marginLeft = '4px';
                link.appendChild(icon);
            }
        }
    });

    // Highlight active navigation based on current page
    const currentPath = window.location.pathname;
    document.querySelectorAll('.site-nav a').forEach(navLink => {
        const navPath = navLink.getAttribute('href');
        if (navPath === currentPath || (navPath !== '/' && currentPath.startsWith(navPath))) {
            navLink.classList.add('current');
        }
    });

    // Add table of contents for posts if there are headings
    const postContent = document.querySelector('.post-content');
    if (postContent && postContent.querySelectorAll('h2, h3, h4').length > 2) {
        const headings = postContent.querySelectorAll('h2, h3, h4');
        if (headings.length) {
            const toc = document.createElement('div');
            toc.className = 'table-of-contents';
            
            const tocTitle = document.createElement('h4');
            tocTitle.textContent = 'Table of Contents';
            toc.appendChild(tocTitle);
            
            const tocList = document.createElement('ul');
            toc.appendChild(tocList);
            
            headings.forEach(heading => {
                if (heading.id) {
                    const listItem = document.createElement('li');
                    listItem.className = `toc-${heading.tagName.toLowerCase()}`;
                    
                    const tocLink = document.createElement('a');
                    tocLink.href = `#${heading.id}`;
                    tocLink.textContent = heading.textContent.replace(/§$/, '');
                    
                    listItem.appendChild(tocLink);
                    tocList.appendChild(listItem);
                }
            });
            
            const postHeader = document.querySelector('.post-header');
            if (postHeader) {
                postHeader.parentNode.insertBefore(toc, postHeader.nextSibling);
            }
        }
    }
}); 