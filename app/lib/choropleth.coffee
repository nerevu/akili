module.exports = class Choropleth
  constructor: (options) ->
    # required
    @topology = options.topology
    @selection = options.selection
    @parent = options.parent
    @data = options.data
    @names = options.names

    # required if the default values aren't correct
    @idAttr = options.idAttr ? 'id'
    @nameAttr = options.nameAttr ? 'name'
    @metricAttr = options.metricAttr ? 'value'

    # optional
    @numColors = options?.numColors ? 9
    @colorScheme = options?.colorScheme ? 'Reds'
    @projection = options?.projection ? d3.geo.mercator()

  init: =>
    @colors = colorbrewer[@colorScheme][@numColors]
    @extent = d3.extent(@data, (d) => d[@metricAttr])
    @color = d3.scale.quantize().domain(@extent).range(@colors)
    @nameById = _.object([m[@idAttr], m[@nameAttr]] for m in @names)
    @metricByName = _.object([m[@nameAttr], +m[@metricAttr]] for m in @data)

  createPath: (projection) -> d3.geo.path().projection(projection)
  getWidth: => $(@parent).width()
  getHeight: (width) => width * @heightRatio

  tooltipShow: (d) =>
    name = @nameById[d[@idAttr]] or 'N/A'
    metric = @metricByName[name] or 0
    formatter = d3.format(",.2f")

    $("##{d[@idAttr]}").tooltip(
      title: "<h5>#{name}: #{formatter(metric)}</h5>"
      html: true
      container: @parent
      placement: 'auto'
    ).tooltip('show')

  tooltipHide: => $(@).tooltip('hide')

  calcProjection: (projection, width) =>
    # http://stackoverflow.com/a/14691788/408556
    path = @createPath projection
    b = path.bounds(@topology)
    bwidth = Math.abs(b[1][0] - b[0][0])
    bheight = Math.abs(b[1][1] - b[0][1])
    ratio = bheight / bwidth
    s = .9 / (bwidth / width)
    height = width * ratio

    result =
      scale: s
      x: (width - s * (b[1][0] + b[0][0])) / 2
      y: (height - s * (b[1][1] + b[0][1])) / 2
      height: height

    result

  resize: =>
    r = @calcProjection @projection.scale(1).translate([0, 0]), @getWidth()
    projection = @projection.scale(r.scale).translate([r.x, r.y])
    path = @createPath projection
    $(@selection)[0].setAttribute 'height', r.height
    d3.select(@selection).selectAll('g path').attr('d', path)

  makeChart: =>
    d3selection = d3.select(@selection)
    width = @getWidth()
    r = @calcProjection @projection.scale(1).translate([0, 0]), width
    projection = @projection.scale(r.scale).translate([r.x, r.y])
    path = @createPath projection

    d3selection.append('g')
      .attr('class', 'region')
      .selectAll('path')
      .data(@topology.features)
      .enter()
      .append('path')
      .attr(@idAttr, (d) => d[@idAttr])
      .attr('d', path)

    d3.selectAll("#{@selection} g path")
      .attr('fill', (d) =>
        name = @nameById[d[@idAttr]]
        (@color @metricByName[name]) or '#ccc'
      )
      .on('mouseover', @tooltipShow).on('mouseout', @tooltipHide)

    $(@selection)[0].setAttribute 'height', r.height
    d3.select(window).on('resize', _.debounce @resize, 50)
