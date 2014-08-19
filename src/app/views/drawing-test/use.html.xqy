xquery version "1.0-ml";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

<div>
  {
    drawing:render(100, 100, (
      drawing:rect(0, 0, 100, 100, ("fill=rgb(85%, 85%, 85%)")),
      drawing:line(50, 0, 50, 100, ("stroke=rgb(30%, 30%, 30%)", "stroke-width=5")),
      drawing:circle(-20, -20, 10, ("id=the-circle", "stroke-width=4")),
        drawing:use("#the-circle", ("stroke=#33cc33", "fill=#119911", "transform=translate(70, 35)", "opacity=0.66")),
        drawing:use("#the-circle", ("stroke=#3333cc", "fill=#000099", "transform=translate(70, 65)", "opacity=0.66")),
        drawing:use("#the-circle", ("stroke=#cc3333", "fill=#990000", "transform=translate(70, 95)", "opacity=0.66"))))
  }
</div>