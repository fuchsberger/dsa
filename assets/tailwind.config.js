const colors = require('tailwindcss/colors')

module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.coolGray,
      red: colors.red,
      green: colors.green,
      blue: colors.blue,
      indigo: colors.indigo
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/forms')
  ]
};
