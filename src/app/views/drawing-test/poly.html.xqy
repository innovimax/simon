xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

<div>
  <div>
    {
      drawing:render(100, 100, (
        drawing:polyline((10, 10, 90, 10, 90, 90, 10, 90, 10, 20, 80, 20, 80, 80, 20, 80, 20, 30, 70, 30, 70, 70, 30, 70), 
          ("stroke=#000000", "stroke-width=1", "fill=none"))))
    }
  </div>
  <div>
    {
      drawing:render(100, 100, (
        drawing:polygon((10, 10, 90, 10, 90, 90, 10, 90), ("stroke=#000000", "stroke-width=1", "fill=none"))))
    }
  </div>
  <div>
    {
      let $gradient := drawing:gradient("g1", "linear")
      let $_ := (drawing:add-stop($gradient, 0, "#CC0000"),
        drawing:add-stop($gradient, 0.15, "#CCCC00"),
        drawing:add-stop($gradient, 0.30, "#CCAA00"),
        drawing:add-stop($gradient, 0.45, "#00CC00"),
        drawing:add-stop($gradient, 0.60, "#0033CC"),
        drawing:add-stop($gradient, 0.75, "#000066"),
        drawing:add-stop($gradient, 1.0,  "#550055"))
      return 
        drawing:render(100, 100, (
          $gradient,
          drawing:rect(10, 10, 80, 80, ("fill=url(#g1)"))))
    }
  </div>
</div>