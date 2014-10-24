makeChart = (data, selection, changed=false, resize=false) ->
  retLab = (data) -> data.label
  retVal = (data) -> data.value
  formatMinutes = (d) ->
    time = d3.time.format("%I:%M %p")(new Date 2013, 0, 1, 0, d)
    if time.substr(0,1) is '0' then time.substr(1) else time

  minTime = 0
  maxTime = 24
  chartRange = [minTime * 60, maxTime * 60]
  color = if changed then '#FFD658' else 'steelblue'
  console.log 'making ' + selection

  chart = nv.models.multiBarHorizontalChart()
    .x(retLab)
    .y(retVal)
    .forceY(chartRange)
    .yDomain(chartRange)
    .margin({top: 0, right: 110, bottom: 30, left: 80})
    .showValues(false)
    .tooltips(true)
    .stacked(true)
    .showLegend(false)
    .barColor([d3.rgb(color)])
    .transitionDuration(100)
    .showControls(false)

  chart.yAxis
    .scale(chart.y)
    .tickFormat(formatMinutes)

  chart.multibar.yScale().clamp true

  d3.select(selection)
    .datum(data)
    .call(chart)

  nv.utils.windowResize(chart.update) if resize
  chart.dispatch.on 'stateChange', -> console.log 'stateChange'
  chart

module.exports = makeChart
