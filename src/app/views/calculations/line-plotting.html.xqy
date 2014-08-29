xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";
import module namespace parts="http://marklogic.com/ps/chart-parts" at "/app/lib/chart-parts.xqy";

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
        Basic line plot, 1 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $options := parts:set-line-plot-defaults(map:new())
          let $data := for $x in 1 to 100 return $x
          return 
            drawing:render(200, 200, parts:draw-line-plot(200, 200, $data, $options))
        }
      </td>
    </tr>
    <tr>
      <td>
        Basic line plot, 2 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>Two upward sloping straight lines, different colors</td>
      <td>
        {
          let $options := parts:set-line-plot-defaults(map:new())
          let $data := map:new((
            map:entry("series1", for $x in 1 to 100 return ($x * 0.9 + 10)),
            map:entry("series2", for $x in 1 to 100 return ($x * 0.9))))
          return 
            drawing:render(200, 200, parts:draw-line-plot(200, 200, $data, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic line plot, 10 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>Two upward sloping straight lines, different colors</td>
      <td>
        {
          let $options := parts:set-line-plot-defaults(map:new())
          let $data := map:new((
            map:entry("series1", for $x in 1 to 100 return ($x * 0.1)),
            map:entry("series2", for $x in 1 to 100 return ($x * 0.1 + 10)),
            map:entry("series3", for $x in 1 to 100 return ($x * 0.1 + 20)),
            map:entry("series4", for $x in 1 to 100 return ($x * 0.1 + 30)),
            map:entry("series5", for $x in 1 to 100 return ($x * 0.1 + 40)),
            map:entry("series6", for $x in 1 to 100 return ($x * 0.1 + 50)),
            map:entry("series7", for $x in 1 to 100 return ($x * 0.1 + 60)),
            map:entry("series8", for $x in 1 to 100 return ($x * 0.1 + 70)),
            map:entry("series9", for $x in 1 to 100 return ($x * 0.1 + 80)),
            map:entry("series10", for $x in 1 to 100 return ($x * 0.1 + 90))))
          return 
            drawing:render(200, 200, parts:draw-line-plot(200, 200, $data, $options))
        }
      </td>
    </tr>
  </tbody>
</table>