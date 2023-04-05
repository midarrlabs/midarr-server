module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
