module.exports = class Choropleth
  constructor: (options) ->
    @numColors = options?.numColors ? 9
    @colorScheme = options?.colorScheme ? 'Reds'
    @topology = options.topology
    @objects = @topology.objects
    @levels = options.shownLevels
    @projection = options?.projection ? d3.geo.albersUsa()
    @margin = options?.margin ? top: -30, left: 0, bottom: 0, right: 0
    @heightRatio = options?.heightRatio ? 0.45
    @colors = colorbrewer[@colorScheme][@numColors]
    @selection = options.selection
    @parent = options.parent

  init: (options) =>
    @data = options.data
    @coloredLevel = options.coloredLevel
    @extent = d3.extent(@data, (d) -> d.rate)
    @color = d3.scale.quantize().domain(@extent).range(@colors)
    @rateById = _.object([row.id, +row.rate] for row in @data)
    @nameById = _.object([row.id, row.name] for row in options.names)

  getColors: => @colors
  getPercent: => 100 / @numColors
  createPath: => d3.geo.path().projection(@projection)
  tooltipShow: (d) =>
    name = @nameById[d.id]
    rate = @rateById[d.id]

    $("##{d.id}").tooltip(
      title: "<h5>#{name}: #{rate}</h5>"
      html: true
      container: @parent
      placement: 'auto'
    ).tooltip('show')

  tooltipHide: => $(@).tooltip('hide')

  dimensions: (width=null) =>
    width = width ? $(@parent).width()
    height = width * @heightRatio

    dimensions =
      width: width - @margin.left - @margin.right
      height: height - @margin.top - @margin.bottom

  pluralize: (word) ->
    num = word.length - 1
    if word[num..] is 'y'
      "#{word[...num]}ies"
    else
      "#{word}s"

  resize: =>
    dimensions = @dimensions @params?.width

    # resize the selection
    @d3selection
      .attr('width', dimensions.width)
      .attr('height', dimensions.height)

    # update the projection
    @projection
      .scale(dimensions.width)
      .translate([dimensions.width / 2, dimensions.height / 2])

    # resize the map
    for level in @params?.levels ? []
      d3.selectAll("#{@selection} g.#{level} path").attr('d', @path)

  removeChart: => @d3selection.remove()

  makeChart: (width=null) =>
    @d3selection = d3.select(@selection)
    @params = width: width
    @resize()
    @path = @createPath @projection

    for level in @levels
      plural = @pluralize level
      region = topojson.feature(@topology, @objects[plural])

      @d3selection.append('g')
        .attr('class', level)
        .selectAll('path')
        .data(region.features)
        .enter()
        .append('path')
        .attr('id', (d) -> d.id)
        .attr('d', @path)

    d3.selectAll("#{@selection} g.#{@coloredLevel} path")
      .attr('fill', (d) => @color @rateById[d.id])
      .on('mouseover', @tooltipShow).on('mouseout', @tooltipHide)

    @params = levels: @levels
    d3.select(window).on('resize', _.debounce @resize, 10)

  # add a 'debounce' so that no resizing at all happens until the user is done resizing
