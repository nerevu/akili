site_name = 'Choropleth Visualizer'

config =
  author:
    name: 'Nerevu Group, LLC'
    handle: 'nerevu'
    url: '//www.nerevu.com'
    email: 'reubano@gmail.com'

  site:
    title: site_name
    description: 'An HTML5 data viz application built with Brunch and Chaplin.'
    url: '//showcase.akili.nerevu.com'
    id: 'com.akili.vizapp'
    type: 'webapp'
    source: '//github.com/nerevu/akili'
    data: '//github.com/nerevu/akili/tree/master/app/data'
    keywords: """
      brunch, chaplin, nodejs, backbonejs, bower, html5, single page app
      """

    # Web pages
    home:
      title: site_name

  default:
    factor_attr: 'factor'
    factor: 'healthcare'
    factors: ['unemployment', 'healthcare']
    level: 'county'
    levels:
      state: 'states'
      county: 'counties'

    id_attr: 'id'
    name_attr: 'name'
    metric_attr: 'rate'

  google:
    analytics:
      id: $PROCESS_ENV_GOOGLE_ANALYTICS_TRACKING_ID ? null
      site_number: 3
    adwords_id: $PROCESS_ENV_GOOGLE_ADWORDS_ID ? null
    displayads_id: $PROCESS_ENV_GOOGLE_DISPLAYADS_ID ? null
    app_name: site_name
    app_id: ''
    plus_id: $PROCESS_ENV_GOOGLE_PLUS_ID ? null

  facebook:
    app_id: ''

module.exports = config
