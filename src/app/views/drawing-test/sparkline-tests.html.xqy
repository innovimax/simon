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
        sparkline, sine wave.
        <code>declare function charts:draw-spark-line($width as xs:double, $height as xs:double, $data as map:map*, 
          $options as map:map*)</code>
      </td>
      <td>A middle finger</td>
      <td>
        {
          let $data := for $i in 1 to 360 return math:sin((xs:double($i) div 180.0) * (2.0 * 3.1415692)) 
          return 
            charts:draw-sparkline(200, 20, $data)
        }
      </td>
    </tr>
  </tbody>
</table>