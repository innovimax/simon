xquery version "1.0-ml";

module namespace chart="http://marklogic.com/ps/charting";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";
import module namespace parts="http://marklogic.com/ps/chart-parts" at "/app/lib/chart-parts.xqy";

declare namespace svg="http://www.w3.org/2000/svg";
declare namespace options="chart:options";

declare function chart:parse-chart-options($options as xs:string*, $x-options as map:map, $y-options as map:map, 
	$chart-options as map:map) 
{
	for $option in $options
	let $option-parts := fn:tokenize($option, "=")
	let $option-name := $option-parts[1]
	let $option-value := $option-parts[2]
	return
		if (fn:starts-with($option-name, 'x-axis-'))
		then 
			let $x-axis-option-name := fn:substring($option-name, fn:string-length('x-axis-'))
			return map:put($x-options, $x-axis-option-name, $option-value)
		else if (fn:starts-with($option-name, 'y-axis-'))
		then
			let $y-axis-option-name := fn:substring($option-name, fn:string-length('y-axis-'))
			return map:put($y-options, $y-axis-option-name, $option-value)
		else if (fn:starts-with($option-name, 'axis-'))
		then
			let $axis-option-name := fn:substring($option-name, fn:string("axis-"))
			return (map:put($y-options, $axis-option-name, $option-value), 
				map:put($x-options, $axis-option-name, $option-value))
		else 
			map:put($chart-options, $option-name, $option-value)

};


declare function chart:draw-line-plot($width as xs:double, $height as xs:double, $data, $options as xs:string*) {
	let $x-axis-settings := map:new()
	let $y-axis-settings := map:new()
	let $chart-settings := map:new()

	let $_ := chart:parse-chart-options($options, $x-axis-settings, $y-axis-settings, $chart-settings)
	let $x-axis-options := parts:set-x-axis-defaults($x-axis-settings)
	let $y-axis-options := parts:set-y-axis-defaults($y-axis-settings)
	let $plot-options := parts:set-line-plot-defaults($chart-settings)

	let $default-y-axis-width := 25
	let $default-x-axis-height := 25
	let $x-axis-width := $width - $default-y-axis-width
	let $chart-height := $height - $default-x-axis-height
	let $chart-width := $width - $default-y-axis-width

	let $x-axis := drawing:make-group((parts:draw-x-axis-line($x-axis-width, $x-axis-options),
		parts:draw-x-axis-ticks($x-axis-width, $data, $x-axis-options),
		parts:x-axis-labels($x-axis-width, $data, $x-axis-options)))
	let $y-axis := drawing:make-group((parts:draw-y-axis-line($default-y-axis-width, $chart-height, $y-axis-options),
		parts:draw-y-axis-ticks($default-y-axis-width, $chart-height, $data, $y-axis-options),
		parts:draw-y-axis-labels($default-y-axis-width, $chart-height, $data, $y-axis-options)))
	let $plot := parts:draw-line-plot($chart-width, $chart-height, $data, $plot-options)
	let $_ := (drawing:set-attribute($x-axis, "transform", "translate("||xs:string($default-y-axis-width)||", "||xs:string($chart-height)||")"),
		drawing:set-attribute($plot, "transform", "translate("||$default-y-axis-width||", 0)"))
	return
		drawing:render($width, $height, ($plot, $x-axis, $y-axis))
};

declare function chart:draw-line-plot($width as xs:double, $height as xs:double, $data) {
	chart:draw-line-plot($width, $height, $data, ())
};

declare function chart:draw-bar-plot($graph-bounds as map:map, $series-config as node(), $chart-size as node(), 
		$values as xs:anyAtomicType*) as map:map
{
	let $spacing := 2.0
	let $bar-width := xs:double(map:get($graph-bounds, "width")) div fn:count($values) - $spacing
	let $chart-height := xs:double(map:get($graph-bounds, "height"))
	let $first-x := xs:double(map:get($graph-bounds, "x"))
	let $first-y := xs:double(map:get($graph-bounds, "y"))
	let $min-value := xs:double(fn:min($values))
	let $max-value := xs:double(fn:max($values))
	let $stroke := $series-config//chart:data-set-stroke
	let $stroke-width := $series-config//chart:data-set-stroke-width
	let $fill := $series-config//chart:data-set-fill
	return drawing:make-group(
		for $idx in (1 to fn:count($values))
		return
			let $x := ($idx - 1) * ($bar-width + $spacing) + $first-x + $spacing div 2.0
			let $y := $chart-height - $chart-height * (($values[$idx] - $min-value) div ($max-value - $min-value)) + $first-y
			let $height := $chart-height - $y
			let $rect := drawing:rect($x, $y, $bar-width, $height)
			let $_ := (drawing:set-stroke($rect, $stroke), drawing:set-stroke-width($rect, $stroke-width), 
					drawing:set-fill($rect, $fill))
			return
				$rect
	)
};

