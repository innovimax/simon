xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";
import module namespace parts="http://marklogic.com/ps/chart-parts" at "/app/lib/chart-parts.xqy";
import module namespace charts="http://marklogic.com/ps/charting" at "/app/lib/charting.xqy";

<table class='testing'>
  <thead>
    <tr>
      <th>Test</th>
      <th>Expected Result</th>
      <th>Actual Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        Basic bar chart 4 values, min value of zero.
        <code>declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $data as map:map*, $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := map:new((
              map:entry("values", (3, 5, 3, 2)), map:entry("labels", ("one", "two", "three", "four"))))
          let $options := parts:set-bar-graph-defaults(map:new((map:entry("min-value", 0))))
          let $_ := xdmp:log($options, "notice")
          let $rects := parts:draw-bar-chart(200, 200, $options, $data)
          let $_ := xdmp:log($rects, "notice")
          return 
            drawing:render(200, 200, $rects)
        }
      </td>
    </tr>
    <tr>
      <td>
        Basic bar chart 4 values, min value of zero with labels
        <code>declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $data as map:map*, $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := map:new((
              map:entry("values", (3, 5, 3, 2)), map:entry("labels", ("one", "two", "three", "four"))))
          let $chart-options := parts:set-bar-graph-defaults(map:new((map:entry("min-value", 0))))
          let $rects := parts:draw-bar-chart(200, 200, $chart-options, $data)
          let $labels := drawing:make-group(parts:draw-bar-labels(200, map:get($data, "labels"), map:new()))
          let $_ := drawing:set-attribute($labels, "transform", "translate(0, 200)")
          return 
            drawing:render(200, 230, ($rects, $labels))
        }
      </td>
    </tr>
    <tr>
      <td>
        Basic bar chart 4 values, min value of zero with labels
        <code>declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $data as map:map*, $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := map:new((
              map:entry("values", (3, 5, 3, 2)), map:entry("labels", ("one", "two", "three", "four"))))
          let $chart-options := parts:set-bar-graph-defaults(map:new((map:entry("min-value", 0))))
          let $rects := parts:draw-bar-chart(200, 200, $chart-options, $data)
          let $labels := drawing:make-group(parts:draw-bar-labels(200, map:get($data, "labels"), 
            map:new((map:entry("rotation", 45)))))
          let $_ := drawing:set-attribute($labels, "transform", "translate(0, 200)")
          return 
            drawing:render(200, 230, ($rects, $labels))
        }
      </td>
    </tr>
    <tr>
      <td>
        Basic bar chart 4 values, min value of zero with labels
        <code>declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $data as map:map*, $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := map:new((
              map:entry("values", (3, 5, 3, 2)), map:entry("labels", ("one", "two", "three", "four"))))
          let $chart-options := parts:set-bar-graph-defaults(map:new((map:entry("min-value", 0))))
          let $rects := parts:draw-bar-chart(200, 200, $chart-options, $data)
          let $labels := drawing:make-group(parts:draw-bar-labels(200, map:get($data, "labels"), 
            map:new((map:entry("rotation", 90)))))
          let $_ := drawing:set-attribute($labels, "transform", "translate(0, 200)")
          return 
            drawing:render(200, 230, ($rects, $labels))
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic bar chart 4 values, min value of zero with labels
        <code>declare function parts:draw-bar-chart($width as xs:double, $height as xs:double, $data as map:map*, $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := map:new((
              map:entry("values", (3, 5, 3, 2)), map:entry("labels", ("one", "two", "three", "four"))))
          let $chart-options := parts:set-bar-graph-defaults(map:new((map:entry("min-value", 0))))
          let $bars := drawing:make-group(parts:draw-bar-chart(200, 200, $chart-options, $data))
          let $x-labels := drawing:make-group(parts:draw-bar-labels(200, map:get($data, "labels"), 
            map:new()))
          let $y-labels := drawing:make-group(parts:draw-y-axis-labels(30, 200, (3, 5, 3, 2), 
            map:new((map:entry("label-min", 0), map:entry("label-source", "data"), 
              map:entry('rotation', 0)))))
          let $_ := (drawing:set-attribute($x-labels, "transform", "translate(20, 200)"),
            drawing:set-attribute($bars, "transform", "translate(30, 0)"))
          return 
            drawing:render(230, 230, ($bars, $x-labels, $y-labels))
        }
      </td>
    </tr>
  </tbody>
</table>