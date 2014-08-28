xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";
import module namespace parts="http://marklogic.com/ps/chart-parts" at "/app/lib/chart-parts.xqy";

<table class="testing">
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
        Draw a basic line with only the options
        <code>declare function parts:draw-x-axis-line($width as xs:double, $options as map:map)</code>
      </td>
      <td>
        1 pixel wide 200 pixels long, black
      </td>
      <td>
        {
          let $options := map:new()
          let $_ := parts:set-x-axis-defaults($options)
          return
            drawing:render(parts:draw-x-axis-line(200, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw a basic line setting the axis-line-color and axis-line-width
        <code>declare function parts:draw-x-axis-line($width as xs:double, $options as map:map)</code>
      </td>
      <td>
        3 pixels wide 200 pixels long, red
      </td>
      <td>
        {
          let $options := map:new((map:entry("axis-line-width", 3), map:entry("axis-line-color", "#990000")))
          let $_ := parts:set-x-axis-defaults($options)
          return
            drawing:render(parts:draw-x-axis-line(200, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw a basic line setting the axis line prefix but css only not set
        <code>declare function parts:draw-x-axis-line($width as xs:double, $options as map:map)</code>
      </td>
      <td>
        CSS Styling
      </td>
      <td>
        {
          let $options := map:new((map:entry("css-prefix", "hollaback")))
          let $_ := parts:set-x-axis-defaults($options)
          return
            drawing:render(parts:draw-x-axis-line(200, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw a basic line setting the axis line prefix but css only set.  No additional attributes are set.
        <code>declare function parts:draw-x-axis-line($width as xs:double, $options as map:map)</code>
      </td>
      <td>
        CSS Styling
      </td>
      <td>
        {
          let $options := map:new((map:entry("css-prefix", "hollaback"), map:entry("css-only", "true")))
          let $_ := parts:set-x-axis-defaults($options)
          return
            drawing:render(parts:draw-x-axis-line(200, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw major ticks
        <code>declare function parts:draw-major-x-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        5px vertical lines 1 px wide every 20 pixels.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-major-x-tick(($x - 1.0) * 20.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw major ticks set color to green using major-tick-color, width to 3px and length to 10px
        <code>declare function parts:draw-major-x-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        10px green vertical lines 3 px wide every 20 pixels.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new((map:entry("major-tick-size", 10), 
            map:entry("major-tick-width", 3), map:entry("major-tick-color", "#009900"))))
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-major-x-tick(($x - 1.0) * 20.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw major ticks set color to green using tick-color, width to 3px and length to 10px
        <code>declare function parts:draw-major-x-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        10px green vertical lines 3 px wide every 20 pixels.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new((map:entry("major-tick-size", 10), 
            map:entry("major-tick-width", 3), map:entry("tick-color", "#009900"))))
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-major-x-tick(($x - 1.0) * 20.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw major ticks set color to green using major-tick-color overrides tick color red, width to 3px 
        and length to 10px
        <code>declare function parts:draw-major-x-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        10px green vertical lines 3 px wide every 20 pixels.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new((map:entry("major-tick-size", 10), 
            map:entry("major-tick-width", 3), map:entry("tick-color", "#990000"),
            map:entry("major-tick-color", "#009900"))))
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-major-x-tick(($x - 1.0) * 20.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw minor ticks 
        <code>declare function parts:draw-minor-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        3px black vertical lines 1 px wide and 5 px apart.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-minor-tick(($x - 1.0) * 5.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Draw major ticks set color to green using major-tick-color overrides tick color red, width to 3px 
        and length to 7px
        <code>declare function parts:draw-minor-tick($x-offset as xs:double, $options as map:map)</code>
      </td>
      <td>
        7px green vertical lines 3 px wide and 5 px apart.
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new((map:entry("minor-tick-color", "#009900"), 
            map:entry("minor-tick-width", 3), map:entry("minor-tick-size", 7), 
            map:entry("tick-color", "#990000"))))
          let $ticks := for $x in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
            return parts:draw-minor-tick(($x - 1.0) * 5.0, $options)
          return drawing:render($ticks)
        }
      </td>
    </tr>

    <tr>
      <td>
        Default behavior for parts:draw-x-axis-ticks is major ticks 5 and 4 minor ticks betwen each 
        major tick.  The major ticks are 5 px high, 1px wide and black.  The minor ticks are 3 px high,
        1px wide and black with 100 data points.
        <code>declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map)</code>
      </td>
      <td>
        5 major ticks with 4 minor ticks between
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render(parts:draw-x-axis-ticks(200, $data, $options))
        }
      </td>
    </tr>

    <tr>
      <td>
        Default behavior for parts:draw-x-axis-ticks is major ticks 5 and 4 minor ticks betwen each 
        major tick.  The major ticks are 5 px high, 1px wide and black.  The minor ticks are 3 px high,
        1px wide and black with 1000 data points.
        <code>declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map)</code>
      </td>
      <td>
        5 major ticks with 4 minor ticks between
      </td>
      <td>
        {
          try {
            let $options := parts:set-x-axis-defaults(map:new())
            let $data := for $x in (1 to 1000) return $x
            return drawing:render(parts:draw-x-axis-ticks(200, $data, $options))
          } catch($e) {
            fn:string($e)
          }
        }
      </td>
    </tr>

    <tr>
      <td>
        Default behavior for parts:draw-x-axis-ticks is major ticks 5 and 4 minor ticks betwen each 
        major tick.  The major ticks are 5 px high, 1px wide and black.  The minor ticks are 3 px high,
        1px wide and black with 10 data points.
        <code>declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map)</code>
      </td>
      <td>
        5 major ticks with 1 minor ticks between
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 10) return $x
          return drawing:render(parts:draw-x-axis-ticks(200, $data, $options))          
        }
      </td>
    </tr>

    <tr>
      <td>
        Default behavior for parts:draw-x-axis-ticks is major ticks 5 and 4 minor ticks betwen each 
        major tick.  The major ticks are 5 px high, 1px wide and black.  The minor ticks are 3 px high,
        1px wide and black with 227 data points.
        <code>declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map)</code>
      </td>
      <td>
        5 major ticks with 1 minor ticks between
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 228) return $x
          return drawing:render(parts:draw-x-axis-ticks(200, $data, $options))          
        }
      </td>
    </tr>

    <tr>
      <td>
        Using the data values 27 through 234
        <code>declare function parts:draw-x-axis-ticks($width as xs:double, $data, $options as map:map)</code>
      </td>
      <td>
        5 major ticks with 1 minor tick between but offset for the start of the values.
      </td>
      <td>
        {
          
          let $options := parts:set-x-axis-defaults(map:new((map:entry("label-source", "data"))))
          let $data := for $x in (27 to 234) return $x
          return drawing:render(parts:draw-x-axis-ticks(200, $data, $options))          
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render(parts:x-axis-labels(200, $data, $options))          
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render((
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 1000) return $x
          return drawing:render((
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 10) return $x
          return drawing:render((
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 250) return $x
          return drawing:render((
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new((map:entry("label-source", "data"))))
          let $data := for $x in (27 to 234) return $x
          return drawing:render((
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the x axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-x-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render((
            parts:draw-x-axis-line(200, $options),
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options)))        
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the y axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-y-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render((parts:draw-y-axis-ticks(25, 200, $data, $options)))       
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the y axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-y-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render(50, 250, (
            parts:draw-y-axis-ticks(25, 200, $data, $options),
            parts:draw-y-axis-labels(25, 200, $data, $options)))       
          
        }
      </td>
    </tr>

    <tr>
      <td>
        Display the y axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-y-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render(50, 250, (
            parts:draw-y-axis-line(25, 200, $options),
            parts:draw-y-axis-ticks(25, 200, $data, $options),
            parts:draw-y-axis-labels(25, 200, $data, $options)))       
          
        }
      </td>
    </tr>
    <tr>
      <td>
        Display the y axis labels and ticks
        <code>declare function parts:x-axis-labels($options as xs:string*)</code>
      </td>
      <td>
        Draw the X axis labels
      </td>
      <td>
        {
          let $options := parts:set-y-axis-defaults(map:new())
          let $data := for $x in (1 to 100) return $x
          return drawing:render(250, 250, (
            parts:draw-x-axis-line(200, $options),
            parts:draw-x-axis-ticks(200, $data, $options),
            parts:x-axis-labels(200, $data, $options),
            parts:draw-y-axis-line(25, 200, $options),
            parts:draw-y-axis-ticks(25, 200, $data, $options),
            parts:draw-y-axis-labels(25, 200, $data, $options)))       
          
        }
      </td>
    </tr>
  </tbody>
</table>