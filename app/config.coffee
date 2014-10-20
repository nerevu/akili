site_name = 'HHS Disparity'

config =
  author:
    name: 'Team Akili'
    url: ''
    email: 'team-akili@googlegroups.com'

  site:
    title: site_name
    description: 'An HTML5 application built with Brunch and Chaplin.'
    url: 'https://github.com/paulmillr/brunch-with-chaplin'
    id: 'com.akili.hhs_risk_factor_disparities'
    type: 'website'
    version: '0.1.0'
    keywords: """
      brunch, chaplin, nodejs, backbonejs, bower, html5, single page app
      """

    # Web pages
    main:
      page: 'home'
      href: '/'
      title: 'App'

    pages: null

  default:
    factor: 'unemployment'
    level: 'county'

  google:
    analytics_tracking_id: ''
    adwords_id: '479-081-1830'
    displayads_id: ''
    app_name: site_name
    app_id: ''
    plus_id: ''

  facebook:
    app_id: ''

module.exports = config
