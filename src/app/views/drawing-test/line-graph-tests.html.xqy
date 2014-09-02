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
        Basic line plot, 1 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $data := for $x in 1 to 100 return $x
          return 
            charts:draw-line-plot(200, 200, $data)
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic line plot, 1 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $data := for $x in 1 to 100 return $x
          return 
            charts:draw-line-plot(400, 200, $data)
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic line plot, 1 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $data := for $x in 1 to 100 return $x
          return 
            charts:draw-line-plot(300, 300, $data)
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic line plot, 1 series, 100 points.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as map:map)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $data := for $x in 1 to 100 return $x
          return 
            charts:draw-line-plot(200, 400, $data)
        }
      </td>
    </tr>

    <tr>
      <td>
        Basic line plot, 1 series, 10 points.  Set series color to red and line width to 5.
        <code>declare function parts:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as xs:string*)</code>
      </td>
      <td>An upward sloping straight line</td>
      <td>
        {
          let $data := (1, 4, 9, 16, 25, 36, 49, 64, 81, 100)
          return 
            charts:draw-line-plot(320, 200, $data, ("series-colors=#CC0000", "line-width=5"))
        }
      </td>
    </tr>
  </tbody>
</table>