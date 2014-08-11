xquery version "1.0-ml";

import module namespace drawing = "http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";


<div>
	<h1>Drawing test</h1>

	<div><img style="width:300px; height:200px;" src='/welcome/picture.svg'/></div>
	<div>
	{
		let $c1 := drawing:circle(30)
		let $c2 := drawing:circle(30, 30, 5)
		let $l1 := drawing:line(50, 75, 200, 75)
		let $_  := (drawing:set-stroke-dasharray($l1, (3, 5, 8, 13)), 
			drawing:set-stroke-width($l1, 5), drawing:set-stroke($l1, "rgb(255, 128, 96)"))
		let $_  := (drawing:set-stroke-dasharray($c1, (3, 5, 8, 13)), 
			drawing:set-stroke-width($c1, 5), drawing:set-stroke($c1, "rgb(255, 128, 96)"))

		let $g1 := drawing:make-group(($c1, $c2))
		let $_ := drawing:add-translate($g1, 100, 100)
		let $g2 := drawing:make-group(($c1, $c2))
		let $_ := (drawing:add-translate($g2, 150, 150), drawing:add-rotate($g2, 45, 0, 0))
		let $t := drawing:text(50, 50, "This is the time for all good men")

		return drawing:render(500, 500, ($l1, $c1, $c2, $g1, $g2, $t))
	}
	</div>
</div>