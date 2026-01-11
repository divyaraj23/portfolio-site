/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./*.html", "./assets/js/**/*.js"],
  theme: {
    extend: {
      colors: {
        primary: '#f6755e',
        secondary: '#25a2c3',
        dark: '#727a82'
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        'mono': ['JetBrains Mono', 'Menlo', 'Monaco', 'monospace'],
        'script': ['Pacifico', 'cursive']
      }
    }
  },
  plugins: [],
}
