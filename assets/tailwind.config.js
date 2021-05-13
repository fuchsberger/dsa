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
  theme: {},
  variants: {},
  plugins: [ require('@tailwindcss/forms') ]
};
