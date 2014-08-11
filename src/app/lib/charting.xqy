xquery version "1.0-ml";

module namespace chart="http://marklogic.com/ps/charting";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace options="chart:options";

declare variable $default-options := map:new((
	map:entry("foo", "bar")));

declare function chart:make-vertical($min as xs:double, $max as xs:double, $value as xs:double, 
	$point-range as xs:double) 
{
	$point-range - ($value - $min) div ($max - $min) * $point-range
};

declare function chart:make-points($min as xs:double, $max as xs:double, $point-range as xs:double, 
	$width as xs:double, $axis-offset as xs:double, $values as xs:anyAtomicType*)
{
	for $value at $idx in $values
	return
		element point {
			element x { ($idx - 1) * $width + $axis-offset },
			element y { chart:make-vertical($min, $max, $value, $point-range) }
		}
};

declare function chart:make-x-axis($width as xs:double, $height as xs:double, $tick-count as xs:double, 
		$x-offset as xs:double, $axis-height as xs:double) 
{
	let $drawable-width := $width - $x-offset
	let $spacing := $drawable-width div $tick-count
	let $line := drawing:line($x-offset, $height - $axis-height, $width, $height - $axis-height)
	let $_ := drawing:set-stroke($line, "rgb(0, 0, 0)")
	return 
		drawing:make-group((
			$line,
			for $idx in (1 to xs:int($tick-count))
			return 
				drawing:text($x-offset + (xs:double($idx) - 1.0) * $spacing, $height - $axis-height + 13.0 , xs:string($idx))))
};

(:
	Returns a line chart object based on the defaults and the passed in options
:)
(:
declare function chart:line-chart($width as xs:double, $height as xs:double, $options as node()) {
	<chart:chart>
		<chart:size><chart:width>{$width}</chart:width><chart:height>{$height}</chart:height></chart:size>
		<chart:x-axis>
			<chart:height>20</chart:height>
		</chart:x-axis>
		<chart:y-axis>
			<chart:width>30</chart:width>
		</chart:y-axis>
	</chart:chart>
};
:)

(:
	Plots the values defined in the chart
:)
declare function chart:plot($chart as node(), $values as xs:anyAtomicType) as node() {
	()
};

declare function chart:line-chart($width, $height, $values as xs:anyAtomicType*) as node()  {
	let $r := drawing:rect(0, 0, $width, $height)
	let $_ := (drawing:set-fill($r, "rgb(196, 196, 196)"))
	let $min := fn:min($values)
	let $max := fn:max($values)

	let $delta-x := ($width - 30) div xs:double(fn:count($values) - 1)

	let $points := chart:make-points($min, $max, $height - 20, $delta-x, 30, $values)
	let $lines := for $point at $idx in $points 
		let $old-point := $points[$idx - 1]
		where $idx gt 1
		return 
			drawing:make-group((
				if ($idx eq 2) then drawing:circle($old-point//x, $old-point//y, 1) else (),
				drawing:line($old-point//x, $old-point//y, $point//x, $point//y),
				drawing:circle($point//x, $point//y, 1)))

	let $_ := for $line in $lines return (drawing:set-stroke($line, "rgb(0,0,0)"), drawing:set-stroke-width($line, 1))

	return drawing:render($width, $height, ($r, $lines, chart:make-x-axis($width, $height, fn:count($values), 30, 20)))
};
