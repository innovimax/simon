xquery version "1.0-ml";

import module namespace drawing = "http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

let $c1 := drawing:circle(30)
let $c2 := drawing:circle(30, 30, 5)
let $_ := (drawing:set-stroke($c1, "black"), drawing:set-stroke-width($c1, 3))

let $g1 := drawing:make-group(($c1, $c2))
let $_ := drawing:add-translate($g1, 100, 100)
let $g2 := drawing:make-group(($c1, $c2))
let $_ := (drawing:add-translate($g2, 150, 150), drawing:add-rotate($g2, 45, 0, 0))

return drawing:render(($c1, $c2, $g1, $g2))