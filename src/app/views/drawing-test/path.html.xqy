xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

<table>
  <tbody>
    <tr>
      <td>
        <div>Simple Path Line</div>
        {
          let $path := drawing:path(("stroke=#999999", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 10, 20), drawing:add-line-to($path, 30, 90))
          return 
            drawing:render(100, 100, $path)
        }
      </td>
      <td>
        <div>Compound Path</div>
        {
          let $path := drawing:path(("fill=none", "stroke=#cc9944", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 50, 10), drawing:add-line-to($path, 90, 90), 
            drawing:add-line-to($path, 10, 90), drawing:add-line-to($path, 50, 10))
          return 
            drawing:render(100, 100, $path)
        }
      </td>
      <td>
        <div>Close Path</div>
        {
          let $path := drawing:path(("fill=none", "stroke=#cc9944", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 50, 10), drawing:add-line-to($path, 90, 90), 
            drawing:add-line-to($path, 10, 90), drawing:add-close-path($path))
          return 
            drawing:render(100, 100, $path)
        }
      </td>
    </tr>
    <tr>
      <td>
        <div>Quadratic</div>
        {
          let $path := drawing:path(("fill=none", "stroke=#113399", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 10, 90), drawing:add-quadratic($path, 50, 10, 90, 90))
          return
            drawing:render(100, 100, $path)
        }
      </td>
      <td>
        <div>Cubic</div>
        {
          let $path := drawing:path(("fill=none", "stroke=#113399", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 10, 90), drawing:add-cubic($path, 40, 10, 60, 10, 90, 90))
          return
            drawing:render(100, 100, $path)
        }
      </td>
      <td>
        <div>Arc</div>
        {
          let $path := drawing:path(("fill=none", "stroke=#113399", "stroke-width=2"))
          let $_ := (drawing:add-move-to($path, 10, 90), drawing:add-arc($path, 25, 25, 0, 1, 1, 90, 90))
          return
            drawing:render(100, 100, $path)
        }
      </td>
    </tr>
  </tbody>
</table>