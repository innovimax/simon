xquery version "1.0-ml";

module namespace parts="http://marklogic.com/ps/chart-parts";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

declare namespace svg="http://www.w3.org/2000/svg";

declare variable $optimal-major-tick-width as xs:int := 50;

(:
  Generic options available to all parts:

  css-prefix - no default value
  The prefix used for the CSS class.  For example "foobar", will create CSS classes for
  the parts in the chart with "foobar-axis", "foobar-axis-label", "foobar-axis-label-1", etc.


  use-css - false/no
  Do not set styling information in SVG and instead expect styling to come from CSS.
:)


(:
  Generates an X (horizontal) axis with a line and tick marks every so often.
  There are 2 types of tick marks, major and minor.  Major tick marks can have numeric below
  them and minor tick marks do not.  

  Metrics:
  If there are N points, with a width of W, then the ticks are spaced W/N pixels apart.  

  
  label-source - default "ordinal"
  Indicates the source of the ticks. 
    ordinal - use the order of the tick marks to set values 
    data - use the data to set the values (ticks will range from fn:min($data) to fn:max($data))

  label-min - default none
  Set the mininum value for the x axis label
  
  label-max - default none
  Set the minimum value for the x axis label

  minor-tick-size - default 3
  The size for the minor ticks

  major-tick-size - default 5
  The size of the major ticks

  major-ticks-every - none
  Every X tick marks place a major tick, otherwise place a minor tick.

  minor-ticks-every - nonde
  Every X tick marks place a minor tick, otherwise place nothing.

  tick-labels - default yes/true
  Place a numeric label (based on data) at every major tick mark.

  first-label - default yes/true
  Place a label at the first tick mark on the axis.

  last-label - default yes/true
  Place a label at the last X tick mark on the axis.

  minor-tick-width - default 1
  The stroke width for the minor tick

  major-tick-width - default 1
  The stroke width for the major tick

  axis-line-width - default 1
  The stroke width for the axis line

  color - default none
  The color to use for all the X axis elements

  axis-line-color - default none
  The color to use for the axis line (overriding color)

  tick-color - default none
  The color to use for the tick marks (overriding color)

  major-tick-color - default none
  The color to use for the major tick marks (overriding tick-color or color)

  minor-tick-color - default none
  The color to use for the minor tick marks (overriding tick-color or color)

  label-font - default none
  The font to use for labels

  label-size - default none
  The text size of the labels

  label-picture - default none
  The picture used to format the label data

  lebel-color - default none
  The color to use for the labels.

  lengend-font - default none
  The font for the optional legend

  legend-size - default none
  The size of the legend text

  Tested
:)
declare function parts:options-to-map($options as xs:string*) as map:map {
  map:new(
    for $option in $options
    let $parts := fn:tokenize($option, "=")
    return map:entry($parts[1], $parts[2]))
};


(:
  Set the defautl values for the line plot
:)
declare function parts:set-x-axis-defaults($options as map:map) {
  (
    if (fn:not(map:contains($options, "color"))) then map:put($options, "color", "#000000") else (),
    if (fn:not(map:contains($options, "label-source"))) then map:put($options, "label-source", "ordinal") else (),
    if (fn:not(map:contains($options, "minor-tick-size"))) then map:put($options, "minor-tick-size", 3) else (),
    if (fn:not(map:contains($options, "major-tick-size"))) then map:put($options, "major-tick-size", 5) else (),
    if (fn:not(map:contains($options, "tick-labels"))) then map:put($options, "tick-labels", "true") else (),
    if (fn:not(map:contains($options, "first-label"))) then map:put($options, "first-label", "true") else (),
    if (fn:not(map:contains($options, "last-label"))) then map:put($options, "last-label", "true") else (),
    if (fn:not(map:contains($options, "minor-tick-width"))) then map:put($options, "minor-tick-width", 1) else (),
    if (fn:not(map:contains($options, "major-tick-width"))) then map:put($options, "major-tick-width", 1) else (),
    if (fn:not(map:contains($options, "axis-line-width"))) then map:put($options, "axis-line-width", 1) else (),
    $options
  )
};

declare function parts:set-y-axis-defaults($options as map:map) {
  (
    if (fn:not(map:contains($options, "color"))) then map:put($options, "color", "#000000") else (),
    if (fn:not(map:contains($options, "label-source"))) then map:put($options, "label-source", "data") else (),
    if (fn:not(map:contains($options, "minor-tick-size"))) then map:put($options, "minor-tick-size", 3) else (),
    if (fn:not(map:contains($options, "major-tick-size"))) then map:put($options, "major-tick-size", 5) else (),
    if (fn:not(map:contains($options, "tick-labels"))) then map:put($options, "tick-labels", "true") else (),
    if (fn:not(map:contains($options, "first-label"))) then map:put($options, "first-label", "true") else (),
    if (fn:not(map:contains($options, "last-label"))) then map:put($options, "last-label", "true") else (),
    if (fn:not(map:contains($options, "minor-tick-width"))) then map:put($options, "minor-tick-width", 1) else (),
    if (fn:not(map:contains($options, "major-tick-width"))) then map:put($options, "major-tick-width", 1) else (),
    if (fn:not(map:contains($options, "axis-line-width"))) then map:put($options, "axis-line-width", 1) else (),
    $options
  )
};

declare function parts:set-line-plot-defaults($options as map:map) {
  if (fn:not(map:contains($options, "series-colors"))) then map:put($options, "series-colors", (
    "#80A5E4", "#D45D5D", "#F2AE4E", "#D4D13F", "#3EB334", "#371FBF", "#873BE3")) else (),
  if (fn:not(map:contains($options, "line-width"))) then map:put($options, "line-width", 2) else (),
  if (fn:not(map:contains($options, "point-markers"))) then map:put($options, "point-markers", fn:false()) else (),
  if (fn:not(map:contains($options, "point-marker-radius"))) then map:put($options, "point-marker-radius", 5) else (),
  $options
};

(:

  axis-line-width - default 1
  The stroke width for the axis line

  color - default none
  The color to use for all the X axis elements

  axis-line-color - default none
  The color to use for the axis line (overriding color)

  Tested
:)
declare function parts:draw-x-axis-line($width as xs:double, $options as map:map) {
  let $axis-line-color := if (map:contains($options, "axis-line-color")) then map:get($options, "axis-line-color") else ()
  let $global-color := if (map:contains($options, "color")) then map:get($options, "color") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  return
    drawing:line(0, 0, $width, 0, (
      if ($css-prefix) then "class="||$css-prefix||"-"||"x-axis-line" else "class=x-axis-line",
      if (map:get($options, "css-only") eq 'yes' or (map:get($options, 'css-only') eq 'true'))
      then 
        ()
      else 
        (
          if ($axis-line-color) 
            then "stroke="||fn:string($axis-line-color)
            else if ($global-color)
              then "stroke="||fn:string($global-color)
              else (),
          "stroke-width="||fn:string(map:get($options, "axis-line-width"))
        )
    ))
};

declare function parts:draw-y-axis-line($width as xs:double, $height as xs:double, $options as map:map) {
  let $axis-line-color := if (map:contains($options, "axis-line-color")) then map:get($options, "axis-line-color") else ()
  let $global-color := if (map:contains($options, "color")) then map:get($options, "color") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  return
    drawing:line($width, 0, $width, $height, (
      if ($css-prefix) then "class="||$css-prefix||"-"||"y-axis-line" else "class=y-axis-line",
      if (map:get($options, "css-only") eq 'yes' or (map:get($options, 'css-only') eq 'true'))
      then 
        ()
      else 
        (
          if ($axis-line-color) 
            then "stroke="||fn:string($axis-line-color)
            else if ($global-color)
              then "stroke="||fn:string($global-color)
              else (),
          "stroke-width="||fn:string(map:get($options, "axis-line-width"))
        )
    ))
};

(:
  Returns the minimum tick value.  If the label source is ordinal, then it's 1,
  if it's data, it's the minimum data value.  If it's options, then it's whatever
  the defined minimum value is.  If it's options but no minimum is defined, it's 1.

  Tested
:)
declare function parts:get-min-tick-value($label-source, $data, $label-min) {
  if ($label-source eq "ordinal") 
  then
    1
  else if ($label-source eq "data")
  then
    fn:min($data)
  else if (fn:exists($label-min))
  then $label-min
  else 1
};

(:
  Returns the maximum tick value, given the source of the label, the data, and a maximum label
  value passed in through the options.  If the label is ordinal, then the the last tick mark
  is the nth tick.  If the data provides the tickers, then the last ticker is the max of the
  data.  If nothing is set, the default is the count of the data.

  Tested.
:)
declare function parts:get-max-tick-value($label-source, $data, $label-max) {
  if ($label-source eq "ordinal")
    then fn:count($data)
  else if ($label-source eq "data")
    then fn:max($data)
  else if ($label-max)
    then $label-max
  else fn:count($data)
};

(:
  Returns the optimal number of major ticks.  If the optimal visual spacing is 50 pixels, then
  a 300 pixel wide graph should have 6 major ticks.  If the visual spacing is 330 pixels wide, then
  there is some additional space after the last major tick, but no new major tick.  Up intil 
  350 pixels, there is no new major tick.

  Tested.
:)
declare function parts:get-optimal-major-ticks-count($width as xs:double, $optimal-tick-width) as xs:int {
  fn:floor(xs:int($width) div xs:int($optimal-tick-width))
};

(:
  Returns the major ticks every count, i.e. show a major tick every 20 ticks.  If a value is set,
  for the major-ticks-every option, then use that.  Otherwise, the tick spacing should be the
  optimal tick count divided by the number of ticks (the max tick value - the min tick value).  
  Note that min tick value and max tick value is a proxy for tick count. 

  Tested 
:)
declare function parts:get-major-ticks-every($options, $max-tick-value, $min-tick-value, $optimal-major-tick-count) as xs:int {
  if (map:contains($options, "major-ticks-every"))
  then
    xs:int(map:get($options, "major-ticks-every"))
  else
    xs:int(fn:round((xs:int($max-tick-value) - xs:int($min-tick-value)) div $optimal-major-tick-count))
};

(:
  Returns the number of minor ticks between each major tick.  If the option is set for minor ticks,
  then use the configured value.  Otherwise, try to put 5 minor ticks between major ticks.

  Tested
:)
declare function parts:get-minor-ticks-every($options, $max-tick-value, $min-tick-value, $optimal-major-tick-count) as xs:double {
  if (map:contains($options, "minor-ticks-every"))
  then
    xs:int(map:get($options, "minor-ticks-every"))
  else
    let $minor-every := (fn:round( 100 * (($max-tick-value - $min-tick-value) div $optimal-major-tick-count div 5)))
    return fn:max(($minor-every div 100, 1))
};

(:

  Tested
:)
declare function parts:draw-minor-tick($x-offset as xs:double, $options as map:map) {
  let $minor-tick-size as xs:double := map:get($options, "minor-tick-size")
  let $minor-tick-width as xs:double := map:get($options, "minor-tick-width")
  let $color := map:get($options, "color")
  let $tick-color := map:get($options, "tick-color")
  let $minor-tick-color := map:get($options, "minor-tick-color")
  let $final-color := if ($minor-tick-color) then $minor-tick-color 
    else if ($tick-color) then $tick-color
    else if ($color) then $color
    else "#000"
  return
    drawing:line($x-offset, 0, $x-offset, $minor-tick-size, (
      "stroke="||$final-color,
      "stroke-width="||$minor-tick-width
    ))
};

declare function parts:draw-minor-y-tick($width as xs:double, $y-offset as xs:double, $options as map:map) {
  let $minor-tick-size as xs:double := map:get($options, "minor-tick-size")
  let $minor-tick-width as xs:double := map:get($options, "minor-tick-width")
  let $color := map:get($options, "color")
  let $tick-color := map:get($options, "tick-color")
  let $minor-tick-color := map:get($options, "minor-tick-color")
  let $final-color := if ($minor-tick-color) then $minor-tick-color 
    else if ($tick-color) then $tick-color
    else if ($color) then $color
    else "#000"
  return
    drawing:line($width - $minor-tick-size, $y-offset, $width, $y-offset, (
      "stroke="||$final-color,
      "stroke-width="||$minor-tick-width
    ))
};

(:

  major-tick-size - default 5
  The size of the major ticks

  major-tick-width - default 1
  The stroke width for the major tick

  color - default none
  The color to use for all the X axis elements

  tick-color - default none
  The color to use for the tick marks (overriding color)

  major-tick-color - default none
  The color to use for the major tick marks (overriding tick-color or color)

  Tested
:)
declare function parts:draw-major-x-tick($x-offset as xs:double, $options as map:map) {
  let $major-tick-size as xs:double := map:get($options, "major-tick-size")
  let $major-tick-width as xs:double := map:get($options, "major-tick-width")
  let $color := map:get($options, "color")
  let $tick-color := map:get($options, "tick-color")
  let $major-tick-color := map:get($options, "major-tick-color")
  let $final-color := if ($major-tick-color) then $major-tick-color 
    else if ($tick-color) then $tick-color
    else if ($color) then $color
    else "#000"
  return drawing:line($x-offset, 0.0, $x-offset, $major-tick-size, (
      "stroke="||$final-color,
      "stroke-width="||$major-tick-width
    ))
};

declare function parts:draw-major-y-tick($width as xs:double, $y-offset as xs:double, $options as map:map) {
  let $major-tick-size as xs:double := map:get($options, "major-tick-size")
  let $major-tick-width as xs:double := map:get($options, "major-tick-width")
  let $color := map:get($options, "color")
  let $tick-color := map:get($options, "tick-color")
  let $major-tick-color := map:get($options, "major-tick-color")
  let $final-color := if ($major-tick-color) then $major-tick-color 
    else if ($tick-color) then $tick-color
    else if ($color) then $color
    else "#000"
  return drawing:line($width - $major-tick-size, $y-offset, $width, $y-offset, (
      "stroke="||$final-color,
      "stroke-width="||$major-tick-width
    ))
};


(:
  Assumption:  if we're get x-axis labels from data, the data passed in will be the X axis values

  tested
:)
declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $data, $label-min)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $data, $label-max)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($width, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $width div $total-number-of-ticks
  return
    for $idx in 1 to $major-tick-count
    let $tick-count := math:ceil($total-number-of-ticks * ($idx div $major-tick-count))
    let $last-tick-count := math:ceil($total-number-of-ticks * (($idx - 1) div $major-tick-count))
    let $x-offset := $pixels-per-tick * $tick-count
    let $minor-tick-count := fn:round(($tick-count - $last-tick-count - 1) div 5)
    let $minor-ticks := for $minor-idx in 1 to 5
      let $minor-x-offset := $x-offset - $pixels-per-tick * $minor-tick-count * $minor-idx
      return if ($minor-idx ne 5) then parts:draw-minor-tick($minor-x-offset, $options) else ()
    return
      (parts:draw-major-x-tick($x-offset, $options), $minor-ticks)
};


declare function parts:x-axis-ticks($width as xs:double, $height as xs:double, $data, $options as xs:string*) {
  let $option-map := parts:options-to-map($options)
  let $axis-line := parts:draw-x-axis-line($width, $option-map)
  return ()
};

declare function parts:x-axis-labels($width, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $data, $label-min)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $data, $label-max)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($width, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $width div $total-number-of-ticks
  return
    for $idx in 1 to $major-tick-count
    let $tick-offset := fn:round($total-number-of-ticks * ($idx div $major-tick-count))
    let $x-offset := $pixels-per-tick * $tick-offset
    let $label := $min-tick-value + $tick-offset - 1
    let $anchor := if ($idx ne $major-tick-count) then "text-anchor=middle" else "text-anchor=end"
    return
      drawing:text($x-offset, 17, xs:string($label), ($anchor, "font-size=10", "font-weight=100"))
};

declare function parts:draw-y-axis-ticks($width as xs:double, $height as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $data, $label-min)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $data, $label-max)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($height, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $height div $total-number-of-ticks
  return
    for $idx in 1 to $major-tick-count
    let $tick-count := math:ceil($total-number-of-ticks * ($idx div $major-tick-count))
    let $last-tick-count := math:ceil($total-number-of-ticks * (($idx - 1) div $major-tick-count))
    let $y-offset := $height - $pixels-per-tick * $tick-count
    let $minor-tick-count := fn:round(($tick-count - $last-tick-count - 1) div 5)
    let $minor-ticks := for $minor-idx in 1 to 5
      let $minor-y-offset := $y-offset + $pixels-per-tick * $minor-tick-count * $minor-idx
      return if ($minor-idx ne 5) then parts:draw-minor-y-tick($width, $minor-y-offset, $options) else ()
    return
      (parts:draw-major-y-tick($width, $y-offset, $options), $minor-ticks)
};

declare function parts:draw-y-axis-labels($width as xs:double, $height as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $data, $label-min)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $data, $label-max)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($height, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $height div $total-number-of-ticks
  let $_ := xdmp:log("Drawing y axis labels, major tick count = " || $major-tick-count)
  return
    for $idx in 1 to $major-tick-count
    let $_ := xdmp:log("Drawing label: " || xs:string($idx))
    let $tick-offset := fn:round($total-number-of-ticks * ($idx div $major-tick-count))
    let $y-offset := $height - $pixels-per-tick * $tick-offset
    let $label := $min-tick-value + $tick-offset - 1
    let $anchor := if ($idx ne $major-tick-count) then "text-anchor=middle" else "text-anchor=end"
    return
      (:
      drawing:text(0, 0, xs:string($label), ($anchor, "font-size=10", "font-weight=100", 
        "transform=rotate(90) translate(" || xs:string($width - 5) ||", "||$y-offset||")"))
      :)
      drawing:text($width - 10, $y-offset, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
        "transform=rotate(-90, "||xs:string($width - 10)||","||xs:string($y-offset)||")"))
};

declare function parts:draw-simple-line-plot($width as xs:double, $height as xs:double, $data as xs:double*, 
  $options as map:map) 
{
  let $min-value := fn:min($data)
  let $max-value := fn:max($data)
  let $point-spacing := $width div fn:count($data)
  let $line-width := map:get($options, "line-width")
  let $color := map:get($options, "series-colors")[1]
  let $points := for $point-idx in 1 to fn:count($data)
    return (($point-idx - 1) * $point-spacing, 
      (1 - ($data[$point-idx] - $min-value) div ($max-value - $min-value)) * $height)
  return
    drawing:polyline($points, ("stroke="||$color, "stroke-width="||$line-width))
};

declare function parts:draw-multi-series-line-plot($width as xs:double, $height as xs:double, $data as map:map, 
  $options as map:map) 
{
  let $global-max := fn:max(for $key in map:keys($data) return fn:max(map:get($data, $key)))
  let $global-min := fn:min(for $key in map:keys($data) return fn:min(map:get($data, $key)))
  let $max-count := fn:max(for $key in map:keys($data) return fn:count(map:get($data, $key)))
  let $point-spacing := $width div $max-count
  let $line-width := map:get($options, "line-width")
  let $series-colors := map:get($options, "series-colors")
  return
    for $key at $idx in map:keys($data)
    let $series-data := map:get($data, $key)
    let $color := $series-colors[(($idx - 1) mod fn:count($series-colors)) + 1]
    let $points := for $point-idx in 1 to fn:count($series-data)
      return (($point-idx - 1) * $point-spacing,
        (1 - ($series-data[$point-idx] - $global-min) div ($global-max - $global-min)) * $height)
    order by $key
    return
      drawing:polyline($points, ("class="||$key, "stroke="||$color, "stroke-width="||$line-width))

};

declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map) {
  typeswitch($data)
    case map:map return parts:draw-multi-series-line-plot($width, $height, $data, $options)
    default return parts:draw-simple-line-plot($width, $height, $data, $options)
};

(:
  series-colors - default (#CC0000, #00CC00 ... ) do about 20
  The color for each series line
:)
declare function parts:line-plot($markers as node()*, $options as xs:string*) {
  ()
};

(:
  Markers are things to draw on the chart in terms of the data, like
  add a star above the data point where X=3.  Markers should have a 
  fixed size, like 16px.  We may need an option to allow spacing for markers
  and a set of standard markers.
:)

(:
  best-fit-line - default none
  Show the best fit line

  best-fit-starting - the X value for the best fit start
  best-fit-slope - the slope of the best fit line
  best-fit-vertical - the vertical offset for the start of the best fit
  best-fit-ending - The max x value for the best fit
  best-fit-color
  best-fit-width
:)
declare function parts:scatter-plot($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:bar-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:stacked-bar-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:grouped-bar-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:area-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:pie-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:sparkline($options as xs:string*) {
  ()
};

declare function parts:gauge($options as xs:string*) {
  ()
};

declare function parts:star-review($options as xs:string*) {
  ()
};

declare function parts:title($options as xs:string*) {
  ()
};

declare function parts:legend($markers as node()*, $options as xs:string*) {
  ()
};






