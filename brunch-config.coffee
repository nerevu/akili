exports.config =
  # See https://brunch.io/docs/config for docs.
  watcher: usePolling: true
  notifications: false

  plugins:
    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        indentation:
          value: 2
          level: "error"

  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app.css'

    templates:
      joinTo: 'javascripts/app.js'

  npm:
    globals:
      _cp: 'console-polyfill'

    styles:
      'normalize.css': ['normalize.css']
