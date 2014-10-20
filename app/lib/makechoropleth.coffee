mediator = require 'mediator'

makeChoropleth = (options) ->
  topology = mediator.topology.get 'topology'
  objects = topology.objects

  width = 960
  height = 600

  color = d3.scale.quantize()
    .domain(d3.extent(options.data, (d) -> d.rate))
    .range(colorbrewer.Reds[9])

  selection = d3.select(options.selection)
    .attr("width", width)
    .attr("height", height)

  rateById = _.object([row.id, +row.rate] for row in options.data)
  path = d3.geo.path()

  ready = ->
    if options.level is 'county'
      selection.append("g")
        .attr("class", "county")
        .selectAll("path")
        .data(topojson.feature(topology, objects.counties).features)
        .enter()
        .append("path")
        .attr("id", (d) -> d.id)
        .attr("d", path)

    selection.append("g")
      .attr("class", "state")
      .selectAll("path")
      .data(topojson.feature(topology, objects.states).features)
      .enter()
      .append("path")
      .attr("id", (d) -> d.id)
      .attr("d", path)

    d3.selectAll("#{options.selection} g.#{options.level} path")
      .attr("fill", (d) -> color(rateById[d.id]))

  _.defer ready

module.exports = makeChoropleth
