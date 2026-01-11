/**
 * Ultra-Modern Portfolio - Advanced JavaScript
 * Features: Dark Mode, Skill Bars, Counters, Scroll Reveal, Smooth Navigation
 * Zero Dependencies - Pure Vanilla JS
 */

(function() {
    'use strict';

    // ===========================
    // Utility Functions
    // ===========================
    const $ = (selector, parent = document) => parent.querySelector(selector);
    const $$ = (selector, parent = document) => [...parent.querySelectorAll(selector)];

    const ease = {
        inOutCubic: t => t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2,
        outQuart: t => 1 - Math.pow(1 - t, 4),
        outExpo: t => t === 1 ? 1 : 1 - Math.pow(2, -10 * t)
    };

    // ===========================
    // Dark Mode
    // ===========================
    class DarkMode {
        constructor() {
            this.html = document.documentElement;
            this.toggleButton = $('#darkModeToggle');
            this.init();
        }

        init() {
            // Check saved preference or system preference
            const savedMode = localStorage.getItem('darkMode');
            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

            if (savedMode === 'dark' || (!savedMode && prefersDark)) {
                this.enable();
            }

            // Toggle button event
            if (this.toggleButton) {
                this.toggleButton.addEventListener('click', () => this.toggle());
            }

            // Listen for system preference changes
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (!localStorage.getItem('darkMode')) {
                    e.matches ? this.enable() : this.disable();
                }
            });
        }

        toggle() {
            this.html.classList.contains('dark') ? this.disable() : this.enable();
        }

        enable() {
            this.html.classList.add('dark');
            localStorage.setItem('darkMode', 'dark');
        }

        disable() {
            this.html.classList.remove('dark');
            localStorage.setItem('darkMode', 'light');
        }
    }

    // ===========================
    // Mobile Menu
    // ===========================
    class MobileMenu {
        constructor() {
            this.menu = $('#mobileMenu');
            this.overlay = $('#menuOverlay');
            this.toggleButton = $('#menuToggle');
            this.closeButton = $('#menuClose');
            this.menuLinks = $$('#mobileMenu a');
            this.isOpen = false;
            this.init();
        }

        init() {
            if (!this.menu) return;

            // Toggle button
            if (this.toggleButton) {
                this.toggleButton.addEventListener('click', () => this.toggle());
            }

            // Close button
            if (this.closeButton) {
                this.closeButton.addEventListener('click', () => this.close());
            }

            // Overlay click
            if (this.overlay) {
                this.overlay.addEventListener('click', () => this.close());
            }

            // Menu links
            this.menuLinks.forEach(link => {
                link.addEventListener('click', () => this.close());
            });

            // Escape key
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && this.isOpen) {
                    this.close();
                }
            });
        }

        toggle() {
            this.isOpen ? this.close() : this.open();
        }

        open() {
            this.isOpen = true;
            this.menu.classList.remove('translate-x-full');
            this.overlay.classList.remove('opacity-0', 'pointer-events-none');
            document.body.style.overflow = 'hidden';
        }

        close() {
            this.isOpen = false;
            this.menu.classList.add('translate-x-full');
            this.overlay.classList.add('opacity-0', 'pointer-events-none');
            document.body.style.overflow = '';
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
                    if (!href || href === '#') return;

                    const target = $(href);
                    if (target) {
                        e.preventDefault();
                        this.scrollTo(target);
                    }
                });
            });
        }

        scrollTo(target) {
            const header = $('#header');
            const headerHeight = header ? header.offsetHeight : 80;
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - headerHeight;
            const startPosition = window.pageYOffset;
            const distance = targetPosition - startPosition;
            const duration = 800;
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
    // Scroll Reveal
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
                            // Trigger skill bar animation if it's a skill bar
                            if (entry.target.classList.contains('skill-bar')) {
                                this.animateSkillBar(entry.target);
                            }
                            // Trigger counter animation if it has data-counter
                            if (entry.target.hasAttribute('data-counter')) {
                                this.animateCounter(entry.target);
                            }
                            this.observer.unobserve(entry.target);
                        }
                    });
                },
                {
                    threshold: 0.1,
                    rootMargin: '0px 0px -50px 0px'
                }
            );

            // Observe reveal elements
            $$('.reveal').forEach(el => {
                this.observer.observe(el);
            });

            // Observe skill bars
            $$('.skill-bar').forEach(el => {
                this.observer.observe(el);
            });

            // Observe counters
            $$('[data-counter]').forEach(el => {
                this.observer.observe(el);
            });
        }

        animateSkillBar(element) {
            const skillLevel = parseInt(element.getAttribute('data-skill') || 0);
            const fillElement = element.querySelector('.skill-fill');
            const percentElement = element.querySelector('.skill-percent');

            if (!fillElement || !percentElement) return;

            let currentPercent = 0;
            const duration = 1500;
            const increment = skillLevel / (duration / 16);

            const animate = () => {
                currentPercent += increment;
                if (currentPercent >= skillLevel) {
                    currentPercent = skillLevel;
                    fillElement.style.width = `${skillLevel}%`;
                    percentElement.textContent = `${skillLevel}%`;
                } else {
                    fillElement.style.width = `${currentPercent}%`;
                    percentElement.textContent = `${Math.floor(currentPercent)}%`;
                    requestAnimationFrame(animate);
                }
            };

            setTimeout(() => animate(), 100);
        }

        animateCounter(element) {
            const target = parseInt(element.getAttribute('data-counter'));
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;

            const animate = () => {
                current += increment;
                if (current >= target) {
                    element.textContent = target + (element.textContent.includes('+') ? '+' : '');
                } else {
                    element.textContent = Math.floor(current);
                    requestAnimationFrame(animate);
                }
            };

            setTimeout(() => animate(), 200);
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

            // Add shadow on scroll
            if (currentScroll > 50) {
                this.header.classList.add('backdrop-blur', 'bg-white/80', 'dark:bg-slate-900/80', 'shadow-md');
            } else {
                this.header.classList.remove('backdrop-blur', 'bg-white/80', 'dark:bg-slate-900/80', 'shadow-md');
            }

            this.lastScroll = currentScroll;
        }
    }

    // ===========================
    // Page Transitions
    // ===========================
    class PageTransitions {
        constructor() {
            this.init();
        }

        init() {
            // Add entrance animation
            document.body.classList.add('page-loaded');

            // Smooth transitions for internal navigation
            $$('a:not([target="_blank"])').forEach(link => {
                link.addEventListener('click', (e) => {
                    const href = link.getAttribute('href');
                    if (href && !href.startsWith('#') && !href.startsWith('mailto:') && !href.startsWith('tel:')) {
                        e.preventDefault();
                        document.body.classList.add('page-exit');
                        setTimeout(() => {
                            window.location.href = href;
                        }, 300);
                    }
                });
            });
        }
    }

    // ===========================
    // Parallax Background
    // ===========================
    class ParallaxBackground {
        constructor() {
            this.elements = [];
            this.ticking = false;
            this.init();
        }

        init() {
            // Find parallax elements
            const hero = $('#hero');
            if (hero) {
                const blobs = $$('.animate-blob', hero);
                blobs.forEach((blob, index) => {
                    this.elements.push({
                        element: blob,
                        speed: 0.1 + (index * 0.05)
                    });
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
                const yPos = -(scrolled * speed);
                element.style.transform = `translate(${element.style.transform.match(/translate\(([^,]+)/)?.[1] || '0'}, ${yPos}px)`;
            });
        }
    }

    // ===========================
    // Performance Observer
    // ===========================
    class PerformanceMonitor {
        constructor() {
            this.init();
        }

        init() {
            // Lazy load images
            if ('loading' in HTMLImageElement.prototype) {
                $$('img[loading="lazy"]').forEach(img => {
                    img.loading = 'lazy';
                });
            }

            // Log performance metrics in development
            if (window.location.hostname === 'localhost') {
                window.addEventListener('load', () => {
                    setTimeout(() => {
                        const perfData = window.performance.timing;
                        const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
                        console.log(`⚡ Page loaded in ${pageLoadTime}ms`);
                    }, 0);
                });
            }
        }
    }

    // ===========================
    // Floating Cards
    // ===========================
    class FloatingCards {
        constructor() {
            this.init();
        }

        init() {
            $$('.group').forEach((card) => {
                card.addEventListener('mouseenter', function() {
                    this.style.transition = 'transform 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
                });

                card.addEventListener('mouseleave', function() {
                    this.style.transition = 'transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
                });
            });
        }
    }

    // ===========================
    // Easter Egg - Konami Code
    // ===========================
    class KonamiCode {
        constructor() {
            this.pattern = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'b', 'a'];
            this.current = 0;
            this.init();
        }

        init() {
            document.addEventListener('keydown', (e) => {
                if (e.key === this.pattern[this.current]) {
                    this.current++;
                    if (this.current === this.pattern.length) {
                        this.activate();
                        this.current = 0;
                    }
                } else {
                    this.current = 0;
                }
            });
        }

        activate() {
            // Add fun confetti or animation
            console.log('🎉 Konami Code activated!');
            document.body.style.animation = 'rainbow 2s linear infinite';
            setTimeout(() => {
                document.body.style.animation = '';
            }, 3000);
        }
    }

    // ===========================
    // Initialize Everything
    // ===========================
    function init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeApp);
        } else {
            initializeApp();
        }
    }

    function initializeApp() {
        // Initialize all modules
        new DarkMode();
        new MobileMenu();
        new SmoothScroll();
        new ScrollReveal();
        new HeaderScroll();
        new PageTransitions();
        new ParallaxBackground();
        new FloatingCards();
        new PerformanceMonitor();
        new KonamiCode();

        console.log('🚀 Ultra-modern portfolio initialized!');
        console.log('💡 Features: Dark Mode, Skill Bars, Animated Counters, Scroll Reveal');
        console.log('⚡ Zero dependencies | Pure Vanilla JS | 60fps animations');
    }

    // Start the app
    init();

})();
