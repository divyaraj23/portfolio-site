/**
 * Modern Portfolio Site - Vanilla JavaScript
 * Apple-like smooth animations and interactions
 * Zero dependencies - Pure ES6+
 */

(function() {
    'use strict';

    // ===========================
    // Configuration
    // ===========================
    const CONFIG = {
        menuDelay: 500,
        scrollOffset: 80,
        observerThreshold: 0.1,
        animationDuration: 600
    };

    // ===========================
    // Utility Functions
    // ===========================
    const $ = (selector, parent = document) => parent.querySelector(selector);
    const $$ = (selector, parent = document) => [...parent.querySelectorAll(selector)];

    const ease = {
        inOutCubic: t => t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2,
        outExpo: t => t === 1 ? 1 : 1 - Math.pow(2, -10 * t)
    };

    // ===========================
    // Page Load Animation
    // ===========================
    class PageLoader {
        constructor() {
            this.body = document.body;
            this.init();
        }

        init() {
            this.body.classList.add('is-loading');

            // Remove loading state with smooth transition
            window.addEventListener('load', () => {
                requestAnimationFrame(() => {
                    setTimeout(() => {
                        this.body.classList.remove('is-loading');
                        this.animateHero();
                    }, 100);
                });
            });
        }

        animateHero() {
            const hero = $('section');
            if (hero) {
                hero.style.opacity = '0';
                hero.style.transform = 'translateY(20px)';

                requestAnimationFrame(() => {
                    hero.style.transition = 'opacity 0.8s ease-out, transform 0.8s ease-out';
                    hero.style.opacity = '1';
                    hero.style.transform = 'translateY(0)';
                });
            }
        }
    }

    // ===========================
    // Smooth Scroll
    // ===========================
    class SmoothScroll {
        constructor() {
            this.init();
        }

        init() {
            $$('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', (e) => {
                    const href = anchor.getAttribute('href');
                    if (href === '#menu') return; // Skip menu toggle

                    e.preventDefault();
                    const target = $(href);

                    if (target) {
                        this.scrollTo(target);
                        // Close menu if open
                        if (document.body.classList.contains('is-menu-visible')) {
                            Menu.instance.close();
                        }
                    }
                });
            });
        }

        scrollTo(target) {
            const header = $('#header');
            const headerHeight = header ? header.offsetHeight : CONFIG.scrollOffset;
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - headerHeight;
            const startPosition = window.pageYOffset;
            const distance = targetPosition - startPosition;
            const duration = CONFIG.animationDuration;
            let start = null;

            const animation = (currentTime) => {
                if (start === null) start = currentTime;
                const timeElapsed = currentTime - start;
                const progress = Math.min(timeElapsed / duration, 1);

                window.scrollTo(0, startPosition + distance * ease.inOutCubic(progress));

                if (timeElapsed < duration) {
                    requestAnimationFrame(animation);
                }
            };

            requestAnimationFrame(animation);
        }
    }

    // ===========================
    // Mobile Menu
    // ===========================
    class Menu {
        static instance = null;

        constructor() {
            if (Menu.instance) return Menu.instance;

            this.menu = $('#menu');
            this.body = document.body;
            this.isVisible = false;
            this.closeButton = null;

            this.init();
            Menu.instance = this;
        }

        init() {
            if (!this.menu) return;

            // Create close button
            this.closeButton = document.createElement('a');
            this.closeButton.href = '#menu';
            this.closeButton.className = 'close';
            this.closeButton.setAttribute('aria-label', 'Close menu');

            // SVG close icon
            this.closeButton.innerHTML = `
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            `;

            this.menu.appendChild(this.closeButton);
            this.body.appendChild(this.menu);

            // Toggle button
            const toggleButton = $('a[href="#menu"]', $('#header'));
            if (toggleButton) {
                // Add hamburger icon
                toggleButton.innerHTML = `
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                    <span>Menu</span>
                `;

                toggleButton.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.toggle();
                });
            }

            // Close button
            this.closeButton.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.close();
            });

            // Click outside to close
            document.addEventListener('click', (e) => {
                if (this.isVisible && !this.menu.contains(e.target) && !e.target.closest('a[href="#menu"]')) {
                    this.close();
                }
            });

            // Menu links
            $$('a', this.menu).forEach(link => {
                if (link !== this.closeButton) {
                    link.addEventListener('click', () => {
                        setTimeout(() => this.close(), CONFIG.menuDelay);
                    });
                }
            });

            // Escape key to close
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && this.isVisible) {
                    this.close();
                }
            });

            // Touch swipe to close
            this.initSwipeGesture();
        }

        toggle() {
            this.isVisible ? this.close() : this.open();
        }

        open() {
            this.isVisible = true;
            this.body.classList.add('is-menu-visible');

            // Prevent scroll
            const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;
            this.body.style.overflow = 'hidden';
            this.body.style.paddingRight = `${scrollbarWidth}px`;

            // Animate menu items
            requestAnimationFrame(() => {
                $$('li', this.menu).forEach((item, index) => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateX(20px)';

                    setTimeout(() => {
                        item.style.transition = 'opacity 0.4s ease-out, transform 0.4s ease-out';
                        item.style.opacity = '1';
                        item.style.transform = 'translateX(0)';
                    }, index * 50);
                });
            });
        }

        close() {
            this.isVisible = false;
            this.body.classList.remove('is-menu-visible');

            // Restore scroll
            this.body.style.overflow = '';
            this.body.style.paddingRight = '';
        }

        initSwipeGesture() {
            let touchStartX = 0;
            let touchEndX = 0;

            this.menu.addEventListener('touchstart', (e) => {
                touchStartX = e.changedTouches[0].screenX;
            }, { passive: true });

            this.menu.addEventListener('touchend', (e) => {
                touchEndX = e.changedTouches[0].screenX;
                if (touchEndX > touchStartX + 50) {
                    this.close();
                }
            }, { passive: true });
        }
    }

    // ===========================
    // Scroll Reveal Animation
    // ===========================
    class ScrollReveal {
        constructor() {
            this.observer = null;
            this.init();
        }

        init() {
            if (!('IntersectionObserver' in window)) return;

            this.observer = new IntersectionObserver(
                (entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('revealed');
                            this.observer.unobserve(entry.target);
                        }
                    });
                },
                {
                    threshold: CONFIG.observerThreshold,
                    rootMargin: '0px 0px -50px 0px'
                }
            );

            // Observe elements
            const elements = $$('.group, section > div, footer > div');
            elements.forEach(el => {
                el.classList.add('reveal');
                this.observer.observe(el);
            });
        }
    }

    // ===========================
    // Parallax Effect
    // ===========================
    class ParallaxScroll {
        constructor() {
            this.elements = [];
            this.ticking = false;
            this.init();
        }

        init() {
            // Select parallax elements
            const hero = $('section.relative.min-h-screen');
            if (hero) {
                this.elements.push({
                    element: hero.querySelector('.absolute.inset-0'),
                    speed: 0.5
                });
            }

            if (this.elements.length > 0) {
                window.addEventListener('scroll', () => this.onScroll(), { passive: true });
            }
        }

        onScroll() {
            if (!this.ticking) {
                requestAnimationFrame(() => {
                    this.update();
                    this.ticking = false;
                });
                this.ticking = true;
            }
        }

        update() {
            const scrolled = window.pageYOffset;

            this.elements.forEach(({ element, speed }) => {
                if (element) {
                    const yPos = -(scrolled * speed);
                    element.style.transform = `translateY(${yPos}px)`;
                }
            });
        }
    }

    // ===========================
    // Floating Animation for Cards
    // ===========================
    class FloatingCards {
        constructor() {
            this.init();
        }

        init() {
            $$('.group').forEach((card, index) => {
                // Stagger the animation
                card.style.animationDelay = `${index * 0.1}s`;

                // Add subtle floating effect on hover
                card.addEventListener('mouseenter', () => {
                    card.style.transform = 'translateY(-8px) scale(1.02)';
                });

                card.addEventListener('mouseleave', () => {
                    card.style.transform = '';
                });
            });
        }
    }

    // ===========================
    // Header Scroll Effect
    // ===========================
    class HeaderScroll {
        constructor() {
            this.header = $('#header');
            this.lastScroll = 0;
            this.init();
        }

        init() {
            if (!this.header) return;

            let ticking = false;

            window.addEventListener('scroll', () => {
                if (!ticking) {
                    requestAnimationFrame(() => {
                        this.update();
                        ticking = false;
                    });
                    ticking = true;
                }
            }, { passive: true });
        }

        update() {
            const currentScroll = window.pageYOffset;

            if (currentScroll > 100) {
                this.header.classList.add('scrolled');
            } else {
                this.header.classList.remove('scrolled');
            }

            // Hide/show header on scroll
            if (currentScroll > this.lastScroll && currentScroll > 300) {
                this.header.style.transform = 'translateY(-100%)';
            } else {
                this.header.style.transform = 'translateY(0)';
            }

            this.lastScroll = currentScroll;
        }
    }

    // ===========================
    // Performance Optimization
    // ===========================
    class PerformanceOptimizer {
        constructor() {
            this.init();
        }

        init() {
            // Lazy load images
            if ('loading' in HTMLImageElement.prototype) {
                // Browser supports native lazy loading
                $$('img[loading="lazy"]').forEach(img => {
                    img.loading = 'lazy';
                });
            } else {
                // Fallback for older browsers
                this.lazyLoadImages();
            }
        }

        lazyLoadImages() {
            const imageObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        if (img.dataset.src) {
                            img.src = img.dataset.src;
                            img.removeAttribute('data-src');
                        }
                        imageObserver.unobserve(img);
                    }
                });
            });

            $$('img[data-src]').forEach(img => imageObserver.observe(img));
        }
    }

    // ===========================
    // Initialize Everything
    // ===========================
    function init() {
        // Check if DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeApp);
        } else {
            initializeApp();
        }
    }

    function initializeApp() {
        // Initialize all modules
        new PageLoader();
        new SmoothScroll();
        new Menu();
        new ScrollReveal();
        new ParallaxScroll();
        new FloatingCards();
        new HeaderScroll();
        new PerformanceOptimizer();

        console.log('✨ Portfolio site initialized with modern UX');
    }

    // Start the app
    init();

})();
