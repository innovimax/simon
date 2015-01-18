xquery version "1.0-ml";

module namespace parts="http://marklogic.com/ps/chart-parts";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

declare namespace svg="http://www.w3.org/2000/svg";

declare variable $optimal-major-tick-width as xs:int := 50;

declare variable $fill-colors := ("#80A5E4", "#D45D5D", "#F2AE4E", "#D4D13F", "#2fb328",
  "#4221e1", "#873BE3", "#d78535", "#8bbf41", "#3fdfe3", "#254725", "#741c1e", "#9b6f35",
  "#6c6920", "#354631", "#100a33", "#412174", "#5e3a17", "#334618", "#19585a");


(: 
  UTILITY FUNCTIONS
  =======================================================================
  options-to-map 
  get-min-tick-value 
  get-max-tick-value
  get-optimal-major-ticks-count
  get-major-ticks-every
  get-minor-ticks-every
  set-x-axis-defaults
  set-y-axis-defaults
  set-line-plot-defaults
  set-bar-graph-defaults
:)
declare function parts:options-to-map($options as xs:string*) as map:map {
  map:new(
    for $option in $options
    let $parts := fn:tokenize($option, "=")
    return map:entry($parts[1], $parts[2]))
};

declare function parts:global-max-for-maps-of-doubles($data as map:map) as xs:double
{
  let $maxes := for $key in map:keys($data) return fn:max(map:get($data, $key))
  return fn:max($maxes)
};

declare function parts:global-min-for-maps-of-doubles($data as map:map) as xs:double
{
  let $mins := for $key in map:keys($data) return fn:min(map:get($data, $key))
  return fn:min($mins)
};

(:
  Returns the minimum tick value.  If the label source is ordinal, then it's 1,
  if it's data, it's the minimum data value.  If it's options, then it's whatever
  the defined minimum value is.  If it's options but no minimum is defined, it's 1.

  Tested
:)
declare function parts:get-min-tick-value($label-source, $label-min, $data) {
  if (fn:exists($label-min))
  then
    $label-min
  else if ($label-source eq "ordinal") 
  then
    1
  else if ($label-source eq "data")
  then
    typeswitch($data[1])
      case map:map return parts:global-min-for-maps-of-doubles($data)
      default return fn:min($data)
  else
    1
};

(:
  Returns the maximum tick value, given the source of the label, the data, and a maximum label
  value passed in through the options.  If the label is ordinal, then the the last tick mark
  is the nth tick.  If the data provides the tickers, then the last ticker is the max of the
  data.  If nothing is set, the default is the count of the data.

  Tested.
:)
declare function parts:get-max-tick-value($label-source, $label-max, $data) {
  if ($label-source eq "ordinal")
    then typeswitch($data[1])
      case map:map return fn:count(map:get($data, map:keys($data)[1]))
      default return fn:count($data)
  else if ($label-source eq "data")
    then typeswitch($data[1])
      case map:map return parts:global-max-for-maps-of-doubles($data)
      default return fn:max($data)
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
  xs:int(fn:floor(xs:double($width) div xs:double($optimal-tick-width)))
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
  Functions that set default values
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
    if (fn:not(map:contains($options, "rotation"))) then map:put($options, "rotation", 90) else (),
    $options
  )
};

declare function parts:set-line-plot-defaults($options as map:map) {
  if (fn:not(map:contains($options, "series-colors"))) then map:put($options, "series-colors", $fill-colors) else (),
  if (fn:not(map:contains($options, "line-width"))) then map:put($options, "line-width", 2) else (),
  if (fn:not(map:contains($options, "point-markers"))) then map:put($options, "point-markers", fn:false()) else (),
  if (fn:not(map:contains($options, "point-marker-radius"))) then map:put($options, "point-marker-radius", 5) else (),
  if (fn:not(map:contains($options, "fill"))) then map:put($options, "fill", "none") else (),
  $options
};

declare function parts:set-sparkline-defaults($options as map:map) {
  if (fn:not(map:contains($options, "series-colors"))) then map:put($options, "series-colors", $fill-colors) else (),
  if (fn:not(map:contains($options, "line-width"))) then map:put($options, "line-width", 1) else (),
  if (fn:not(map:contains($options, "point-markers"))) then map:put($options, "point-markers", fn:false()) else (),
  if (fn:not(map:contains($options, "point-marker-radius"))) then map:put($options, "point-marker-radius", 5) else (),
  $options
};

declare function parts:set-bar-graph-defaults($options as map:map) {
  if (fn:not(map:contains($options, "series-colors"))) then map:put($options, "series-colors", $fill-colors) else (),
  if (fn:not(map:contains($options, "min-value"))) then map:put($options, "min-value", 0) else (),
  $options
};

declare function parts:set-pie-chart-defaults($options as map:map) {
  if (fn:not(map:contains($options, "fill"))) then map:put($options, "fill", $fill-colors[1]) else (),
  if (fn:not(map:contains($options, "series-colors"))) then map:put($options, "series-colors", $fill-colors) else (),
  if (fn:not(map:contains($options, "threshold"))) then map:put($options, "threshold", 0.05) else (),
  $options
};

declare function parts:set-guage-defaults($options as map:map) {
  parts:set-pie-chart-defaults($options)
};

(:
  DRAWING AXES LINES
  =============================================================================
  draw-x-axis-line
  draw-y-axis-line
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
  DRAW TICK MARKS
  ===================================================================================
  draw-minor-tick
  draw-minor-y-tick
  draw-major-x-tick
  draw-major-y-tick
  draw-x-axis-ticks
  draw-y-axis-ticks
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


declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $label-min, $data)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $label-max, $data)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($width, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $width div ($total-number-of-ticks - 1)
  return
    for $idx in 1 to $major-tick-count
    let $tick-count := fn:round($total-number-of-ticks * ($idx div $major-tick-count))
    let $last-tick-count := fn:round($total-number-of-ticks * (($idx - 1) div $major-tick-count))
    let $x-offset := $pixels-per-tick * ($tick-count - 1)
    let $minor-tick-count := fn:round(($tick-count - $last-tick-count - 1) div 5)
    let $minor-ticks := for $minor-idx in 1 to 5
      let $minor-x-offset := $x-offset - $pixels-per-tick * $minor-tick-count * $minor-idx
      return if ($minor-idx ne 5) then parts:draw-minor-tick($minor-x-offset, $options) else ()
    return
      (parts:draw-major-x-tick($x-offset, $options), $minor-ticks)
};

declare function parts:draw-y-axis-ticks($width as xs:double, $height as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $min-tick-value as xs:double := xs:double(parts:get-min-tick-value($label-source, $label-min, $data))
  let $max-tick-value as xs:double := xs:double(parts:get-max-tick-value($label-source, $label-max, $data))
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

(:
  DRAWING LABELS
  ========================================================================
  x-axis-labels
  draw-y-axis-labels
  draw-y-axis-labels-all
  draw-bar-labels
:)
declare function parts:x-axis-labels($width, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  let $min-tick-value as xs:double := parts:get-min-tick-value($label-source, $label-min, $data)
  let $max-tick-value as xs:double := parts:get-max-tick-value($label-source, $label-max, $data)
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($width, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $width div ($total-number-of-ticks - 1)
  return
    for $idx in 1 to $major-tick-count
    let $tick-offset := fn:round($total-number-of-ticks * ($idx div $major-tick-count))
    let $x-offset := $pixels-per-tick * ($tick-offset - 1)
    let $label := $min-tick-value + $tick-offset - 1
    let $anchor := if ($idx ne $major-tick-count) then "text-anchor=middle" else "text-anchor=end"
    return
      drawing:text($x-offset, 17, xs:string($label), ($anchor, "font-size=10", "font-weight=100"))
};

declare function parts:draw-y-axis-labels($width as xs:double, $height as xs:double, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  let $min-tick-value as xs:double := xs:double(parts:get-min-tick-value($label-source, $label-min, $data))
  let $max-tick-value as xs:double := xs:double(parts:get-max-tick-value($label-source, $label-max, $data))
  let $major-tick-count as xs:int := parts:get-optimal-major-ticks-count($height, $optimal-major-tick-width)
  let $total-number-of-ticks := $max-tick-value - $min-tick-value + 1
  let $pixels-per-tick := $height div $total-number-of-ticks
  let $rotation := map:get($options, 'rotation')
  let $_ := xdmp:log(
    element parts:x-axis-labels {
      element label-source { $label-source },
      element label-min { $label-min },
      element label-max { $label-max },
      element min-tick-value { $min-tick-value },
      element max-tick-value { $max-tick-value },
      element major-tick-count { $major-tick-count },
      element total-number-of-ticks { $total-number-of-ticks }
    }
  )
  return
    for $idx in 1 to xs:int($major-tick-count)
    let $tick-offset := ($idx - 1) * fn:round($total-number-of-ticks div ($major-tick-count - 1))

    let $y-offset := $height - $height * (fn:max(($tick-offset - $min-tick-value, 0))) div ($max-tick-value - $min-tick-value)
    let $label := $tick-offset
    let $anchor := if ($rotation eq 0) then "text-anchor=end" 
      else if ($idx ne $major-tick-count) then "text-anchor=middle" 
      else "text-anchor=end"
    where $tick-offset <= $max-tick-value
    return
      if ($idx eq $major-tick-count) 
      then
        drawing:text($width - 10, $y-offset, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
          "text-anchor=end",
          "transform=rotate(-" || xs:string($rotation) || ", "||xs:string($width - 10)||","||xs:string($y-offset)||")"))
      else 
        drawing:text($width - 10, $y-offset, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
          "transform=rotate(-" || xs:string($rotation) || ", "||xs:string($width - 10)||","||xs:string($y-offset)||")"))
};

declare function parts:draw-y-axis-labels-all($width as xs:double, $height, $data, $options as map:map) {
  let $label-source as xs:string := map:get($options, "label-source")
  let $label-min := if (map:contains($options, "label-min")) then map:get($options, "label-min") else ()
  let $label-max := if (map:contains($options, "label-max")) then map:get($options, "label-max") else ()
  let $css-prefix := if (map:contains($options, "css-prefix")) then map:get($options, "css-prefix") else ()
  let $min-tick-value as xs:double := $label-min
  let $max-tick-value as xs:double := fn:max($data)
  let $major-tick-count as xs:int := xs:int(fn:round($max-tick-value - $min-tick-value + 1))
  let $total-number-of-ticks := $major-tick-count
  let $pixels-per-tick := $height div $total-number-of-ticks
  let $rotation := map:get($options, 'rotation')
  return
    for $idx in 1 to xs:int($major-tick-count)
    let $tick-offset := ($idx - 1) * fn:round($total-number-of-ticks div ($major-tick-count - 1))

    let $y-offset := $height - $height * (fn:max(($tick-offset - $min-tick-value, 0))) div ($max-tick-value - $min-tick-value)
    let $label := $tick-offset
    let $anchor := if ($rotation eq 0) then "text-anchor=end" 
      else if ($idx ne $major-tick-count) then "text-anchor=middle" 
      else "text-anchor=end"
    where $tick-offset <= $max-tick-value
    return
      if ($idx eq $major-tick-count)
      then 
        drawing:text($width - 10, $y-offset, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
          "text-anchor=end",
          "transform=rotate(-" || xs:string($rotation) || ", "||xs:string($width - 10)||","||xs:string($y-offset)||")"))
      else 
        drawing:text($width - 10, $y-offset, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
          "text-anchor=middle",
          "transform=rotate(-" || xs:string($rotation) || ", "||xs:string($width - 10)||","||xs:string($y-offset)||")"))
};

declare function parts:draw-bar-labels($width as xs:double, $labels, $options as map:map) {
  let $segment-width := $width div fn:count($labels)
  let $mid-point := $segment-width div 2.0
  let $rotation := if (map:get($options, "rotation")) then map:get($options, "rotation") else 0
  for $label at $label-idx in $labels
    let $x := $segment-width * ($label-idx - 1) + $mid-point
    let $y := 10
    let $anchor := if ($rotation gt 0) then "text-anchor=end" else "text-anchor=middle" 
    return
      drawing:text($x, $y, xs:string($label), ($anchor, "font-size=10", "font-weight=100",
        if ($rotation gt 0) 
        then 
          "transform=rotate(" || -$rotation || ", "||xs:string($x)||","||xs:string($y)||")"
        else ()))

};

(:
  LINE PLOTTING 
  =====================================================================
  draw-simple-line-plot
  draw-multi-series-line-plot
:)

declare function parts:draw-simple-line-plot($width as xs:double, $height as xs:double, $data as xs:double*, 
  $options as map:map) 
{
  let $min-value := fn:min($data)
  let $max-value := fn:max($data)
  let $point-spacing := $width div (fn:count($data) - 1)
  let $line-width := map:get($options, "line-width")
  let $color := map:get($options, "series-colors")[1]
  let $points := for $point-idx in 1 to fn:count($data)
    return (($point-idx - 1) * $point-spacing, 
      (1 - ($data[$point-idx] - $min-value) div ($max-value - $min-value)) * $height)
  return
    drawing:polyline($points, ("stroke="||$color, "stroke-width="||$line-width, "fill=none"))
};

declare function parts:draw-multi-series-line-plot($width as xs:double, $height as xs:double, $data as map:map, 
  $options as map:map) 
{
  let $global-max := fn:max(for $key in map:keys($data) return fn:max(map:get($data, $key)))
  let $global-min := fn:min(for $key in map:keys($data) return fn:min(map:get($data, $key)))
  let $max-count := fn:max(for $key in map:keys($data) return fn:count(map:get($data, $key)))
  let $point-spacing := $width div ($max-count - 1)
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
      drawing:polyline($points, ("class="||$key, "stroke="||$color, "stroke-width="||$line-width, "fill=none"))

};

declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map) {
  typeswitch($data)
    case map:map return parts:draw-multi-series-line-plot($width, $height, $data, $options)
    default return parts:draw-simple-line-plot($width, $height, $data, $options)
};



(:
  BAR CHARTS
  =============================================================================
  draw-bar-chart
:)
declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $options as map:map, $data as map:map) {
  let $all-values := map:get($data, "values")
  let $min-value := min(($all-values, xs:double(map:get($options, "min-value"))))
  let $max-value := max(($all-values, xs:double(map:get($options, "max-value"))))
  let $bar-gap := 3.0
  let $outer-width := $width div fn:count($all-values)
  let $bar-width := $outer-width - $bar-gap
  let $color := map:get($options, "series-colors")[1]
  return
    for $datum at $data-idx in $all-values
    let $y := (1 - (($datum - $min-value) div ($max-value - $min-value))) * $height
    let $bar-height := ($datum - $min-value) div ($max-value - $min-value) * $height
    let $x := ($data-idx - 1) * $outer-width + ($bar-gap div 2.0)
    return 
      drawing:rect($x, $y, $bar-width, $bar-height, ("fill="||$color))
};

declare function parts:convert-to-circle-x-y($center as xs:double*, $radius as xs:double, $arc-radians as xs:double) {
  let $x := $center[1] + math:sin($arc-radians) * $radius
  let $y := $center[2] - math:cos($arc-radians) * $radius
  return ($x, $y)
};

declare function parts:draw-pie-chart($width as xs:double, $height as xs:double, $data as xs:double*,
        $options as map:map)
{
  let $sum as xs:double := fn:sum($data)
  let $radians := for $datum in $data return ($datum div $sum) * 2.0 * math:pi()
  let $center := ($width div 2.0, $height div 2.0)
  let $radius := fn:min($center) - 2.0
  return
    for $idx in (1 to fn:count($radians))
    let $start := if ($idx eq 1) then 0.0 else fn:sum($radians[(1 to ($idx - 1))])
    let $end := $start + $radians[$idx]
    let $color := map:get($options, "series-colors")[$idx]
    return
      let $start-point := parts:convert-to-circle-x-y($center, $radius, $start)
      let $end-point := parts:convert-to-circle-x-y($center, $radius, $end)
      let $path := drawing:path()
      let $large-arc-flag := if ($end - $start gt math:pi()) then 1 else 0
      let $_ := drawing:add-move-to($path, $start-point[1], $start-point[2])
      let $_ := drawing:add-arc($path, $radius, $radius, 0, $large-arc-flag, 1, $end-point[1], $end-point[2])
      let $_ := drawing:add-line-to($path, $center[1], $center[2])
      let $_ := drawing:add-close-path($path)
      let $_ := drawing:set-fill($path, $color)
      return $path
};

declare function parts:draw-guage($width as xs:double, $height as xs:double, $current as xs:double, $max as xs:double, $options) {
  let $radians :=  ($current div $max) * 2.0 * math:pi()
  let $center := ($width div 2.0, $height div 2.0)
  let $outer-radius := fn:min($center) - 2.0
  let $inner-radius := fn:min(($outer-radius - 10, $outer-radius * 0.9))
  return
    let $outer-start-point := parts:convert-to-circle-x-y($center, $outer-radius, 0.0)
    let $outer-end-point   := parts:convert-to-circle-x-y($center, $outer-radius, $radians)
    let $inner-start-point := parts:convert-to-circle-x-y($center, $inner-radius, 0.0)
    let $inner-end-point   := parts:convert-to-circle-x-y($center, $inner-radius, $radians)

    let $path := drawing:path()
    let $large-arc-flag := if ($radians gt math:pi()) then 1 else 0
    let $_ := drawing:add-move-to($path, $outer-start-point[1], $outer-start-point[2])
    let $_ := drawing:add-arc($path, $outer-radius, $outer-radius, 0, $large-arc-flag, 1, $outer-end-point[1], $outer-end-point[2])
    let $_ := drawing:add-line-to($path, $inner-end-point[1], $inner-end-point[2])
    let $_ := drawing:add-arc($path, $inner-radius, $inner-radius, 0, $large-arc-flag, 0, $inner-start-point[1], $inner-start-point[2])
    let $_ := drawing:add-close-path($path)
    let $_ := drawing:set-fill($path, map:get($options, "fill"))

    let $text := drawing:text($center[1], $center[2] * 1.25, xs:string(fn:round($current)))
    let $_ := drawing:set-attribute($text, "font-size", $inner-radius)
    let $_ := drawing:set-attribute($text, "font-weight", 700)
    let $_ := drawing:set-attribute($text, "text-anchor", "middle")
    return ($path, $text)
};

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


declare function parts:stacked-bar-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:grouped-bar-chart($markers as node()*, $options as xs:string*) {
  ()
};

declare function parts:area-chart($markers as node()*, $options as xs:string*) {
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






