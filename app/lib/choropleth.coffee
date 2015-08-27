module.exports = class Choropleth
  constructor: (options) ->
    # required
    @topology = options.topology
    @levels = options.levels
    @level = options.level
    @selection = options.selection
    @parent = options.parent

    # required if the default values aren't correct
    @idAttr = options.idAttr ? 'id'
    @nameAttr = options.nameAttr ? 'name'
    @metricAttr = options.metricAttr ? 'value'

    # optional
    @numColors = options?.numColors ? 9
    @colorScheme = options?.colorScheme ? 'Reds'
    @projection = options?.projection ? d3.geo.albersUsa()
    @margin = options?.margin ? top: -30, left: 0, bottom: 0, right: 0
    @heightRatio = options?.heightRatio ? 0.45

    # calculated
    @objects = @topology.objects
    @colors = colorbrewer[@colorScheme][@numColors]

  init: (options) =>
    # required
    @data = options.data
    @names = options.names

    # calculated
    @extent = d3.extent(@data, (d) => d[@metricAttr])
    @color = d3.scale.quantize().domain(@extent).range(@colors)
    @metricById = _.object([m[@idAttr], +m[@metricAttr]] for m in @data)
    @nameById = _.object([m[@idAttr], m[@nameAttr]] for m in @names)

  getColors: => @colors
  getPercent: => 100 / @numColors
  createPath: => d3.geo.path().projection(@projection)
  tooltipShow: (d) =>
    name = @nameById[d[@idAttr]]
    metric = @metricById[d[@idAttr]]

    $("##{d[@idAttr]}").tooltip(
      title: "<h5>#{name}: #{metric}</h5>"
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
    for level, levelAttr of @levels
      d3.selectAll("#{@selection} g.#{level} path").attr('d', @path)

  removeChart: => @d3selection.remove()

  makeChart: (width=null) =>
    @d3selection = d3.select(@selection)
    @params = width: width
    @resize()
    @path = @createPath @projection

    for level, levelAttr of @levels
      region = topojson.feature(@topology, @objects[levelAttr])

      @d3selection.append('g')
        .attr('class', level)
        .selectAll('path')
        .data(region.features)
        .enter()
        .append('path')
        .attr('id', (d) => d[@idAttr])
        .attr('d', @path)

    d3.selectAll("#{@selection} g.#{@level} path")
      .attr('fill', (d) => @color @metricById[d[@idAttr]])
      .on('mouseover', @tooltipShow).on('mouseout', @tooltipHide)

    d3.select(window).on('resize', _.debounce @resize, 10)

  # add a 'debounce' so that no resizing at all happens until the user is
  # done resizing
