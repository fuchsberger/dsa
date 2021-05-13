// const colors = require('tailwindcss/colors')

module.exports = {
  mode: 'jit',
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {
    fontFamily: {
      'sans': 'Inter var,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;'
    }
  },
  variants: {},
  plugins: [ require('@tailwindcss/forms') ]
};
