# Portfolio Site - Divyaraj Singh Sisodia

✨ **Ultra-Modern Portfolio** - Engineering Manager at JumpCloud

A cutting-edge, Apple-like portfolio website featuring zero-dependency vanilla JavaScript, modern CSS animations, and blazing-fast performance.

## 🚀 Quick Deployment Options

### Option 1: Netlify (Recommended - Easiest)

1. **Connect to GitHub**:
   - Go to [netlify.com](https://netlify.com)
   - Sign up/Login with GitHub
   - Click "New site from Git"
   - Connect your GitHub repository

2. **Deploy Settings**:
   - Build command: (leave empty - static site)
   - Publish directory: `.` (root directory)
   - Click "Deploy site"

3. **Custom Domain** (optional):
   - Go to Site settings > Domain management
   - Add your custom domain
   - Configure DNS as instructed

### Option 2: Vercel

1. **Connect Repository**:
   - Go to [vercel.com](https://vercel.com)
   - Sign up/Login with GitHub
   - Click "New Project"
   - Import your GitHub repository

2. **Deploy**:
   - Framework preset: "Other"
   - Root directory: `./`
   - Click "Deploy"

### Option 3: GitHub Pages (Free)

1. **Enable GitHub Pages**:
   - Go to your repository settings
   - Scroll to "Pages" section
   - Source: "Deploy from a branch"
   - Branch: `main` or `gh-pages`
   - Folder: `/ (root)`

2. **Custom Domain** (optional):
   - In repository settings > Pages
   - Add your custom domain
   - Create CNAME file in repository root

## 🛠️ Local Development

```bash
# Clone the repository
git clone https://github.com/divyaraj23/portfolio-site.git
cd portfolio-site

# Install dependencies
npm install

# Build Tailwind CSS
npm run build

# Start development server
npm start

# Visit http://localhost:3000
```

## 📁 Project Structure

```
portfolio-site/
├── index.html              # Main portfolio page
├── src/
│   └── input.css          # Tailwind CSS source
├── assets/
│   ├── css/
│   │   ├── tailwind.css   # Compiled Tailwind CSS
│   │   └── modern.css     # Modern animations & effects
│   └── js/
│       └── modern.js      # Pure vanilla JavaScript (zero dependencies!)
├── images/                # Optimized portfolio images
├── tailwind.config.js     # Tailwind configuration
├── postcss.config.js      # PostCSS configuration
├── netlify.toml           # Netlify deployment config
└── package.json           # Project dependencies
```

## ✨ Features

### 🚀 Performance
- ⚡ **Zero Dependencies** - Pure vanilla JavaScript (no jQuery, no frameworks!)
- 🎯 **Optimized Assets** - Removed 1.6MB+ of unused images
- 🔥 **Modern CSS** - Apple-like animations and micro-interactions
- 📦 **Lightweight** - ~30KB total JavaScript + CSS

### 🎨 Design
- 🍎 **Apple-like UX** - Smooth transitions, glass morphism effects
- 🌊 **Animated Blobs** - Beautiful gradient background animations
- 💫 **Scroll Reveal** - Elements animate into view as you scroll
- 🎭 **Parallax Effects** - Subtle depth and movement
- 🎪 **Floating Cards** - Hover effects with smooth transforms

### 🛠️ Modern Tech
- **Tailwind CSS v4** - Latest utility-first CSS framework
- **Intersection Observer** - Lazy loading and scroll animations
- **ES6+ JavaScript** - Modern syntax with classes and arrow functions
- **CSS Variables** - Design tokens for easy theming
- **Backdrop Filter** - Glassmorphism effects
- **requestAnimationFrame** - Smooth 60fps animations

### 📱 Responsive
- Mobile-first design approach
- Touch gesture support (swipe to close menu)
- Responsive breakpoints for all devices
- Adaptive header with scroll detection

### ♿ Accessibility
- Semantic HTML5 structure
- ARIA labels for interactive elements
- Keyboard navigation support
- Focus-visible states
- Reduced motion support for accessibility

## 🛠️ Technologies Used

- **HTML5** - Semantic markup
- **Tailwind CSS v4.1.18** - Utility-first CSS framework
- **PostCSS** - CSS processing and autoprefixer
- **Vanilla JavaScript (ES6+)** - Zero dependencies!
- **Google Fonts** - Montserrat, Open Sans, Pacifico
- **Netlify** - Fast global CDN deployment

## 📞 Contact

- **Name**: Divyaraj Singh Sisodia
- **Email**: sisodia.divyarajsingh@gmail.com
- **Phone**: +919620800430
- **Location**: Bangalore, India
- **LinkedIn**: [linkedin.com/in/divyarajsinghsisodia](https://www.linkedin.com/in/divyarajsinghsisodia)

---

## 🎯 What's New in v2.0

### Major Improvements
- ✅ **Removed jQuery** - Replaced with 16KB vanilla JavaScript
- ✅ **Removed Skel.js** - Using modern CSS and Intersection Observer
- ✅ **Removed Font Awesome** - Using inline SVG icons
- ✅ **Optimized Images** - Removed 1.6MB+ of unused assets
- ✅ **Modern Animations** - Apple-like smooth transitions
- ✅ **Better Performance** - 70%+ smaller bundle size
- ✅ **Enhanced UX** - Scroll reveal, parallax, floating cards
- ✅ **Accessibility** - Keyboard navigation, ARIA labels, reduced motion

### Performance Metrics
- **Before**: ~250KB JavaScript + 1.6MB images
- **After**: ~46KB total assets (JavaScript + CSS)
- **Improvement**: 97% reduction in asset size!

---

Built with ❤️ using cutting-edge web technologies | v2.0 - 2026