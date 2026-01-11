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
        'heading': ['Montserrat', 'sans-serif'],
        'body': ['Open Sans', 'sans-serif'],
        'script': ['Pacifico', 'cursive']
      }
    }
  },
  plugins: [],
}
