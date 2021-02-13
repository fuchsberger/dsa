module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex'
  ],
  theme: {},
  variants: {},
  plugins: [
    require('@tailwindcss/forms')
  ]
};
