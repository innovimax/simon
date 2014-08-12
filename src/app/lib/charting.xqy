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

declare function chart:if-present($val as node(), $default as xs:string) as xs:string {
	if (fn:not(fn:exists($val))) 
	then 
		$default
	else
		$val/text()
};

declare function chart:make-data-set-settings($root) {
	let $ds-name                := chart:if-present($root/chart:data-set-name, "Default")
	let $ds-class-name          := chart:if-present($root/chart:data-set-class-name, fn:lower-case($ds-name))
	let $ds-stroke              := chart:if-present($root/chart:data-set-stroke, "#6699FF")
	let $ds-stroke-width        := chart:if-present($root/chart:data-set-stroke-width, "2")
	let $ds-fill                := chart:if-present($root/chart:data-set-fill, "none")
	let $ds-point-radius        := chart:if-present($root/chart:data-set-point-radius, "3")
	let $ds-point-fill          := chart:if-present($root/chart:data-set-point-fill, $ds-stroke)
	let $ds-point-stroke        := chart:if-present($root/chart:data-set-point-stroke, "#6699FF")
	let $ds-point-stroke-width  := chart:if-present($root/chart:data-set-point-stroke-width, "2")
	return (		
		<chart:data-set-name>{$ds-name}</chart:data-set-name>,
		<chart:data-set-class-name>{$ds-class-name}</chart:data-set-class-name>,
		<chart:data-set-stroke>{$ds-stroke}</chart:data-set-stroke>,
		<chart:data-set-stroke-width>{$ds-stroke-width}</chart:data-set-stroke-width>,
		<chart:data-set-fill>{$ds-fill}</chart:data-set-fill>,
		<chart:data-set-point-radius>{$ds-point-radius}</chart:data-set-point-radius>,
		<chart:data-set-point-fill>{$ds-point-fill}</chart:data-set-point-fill>,
		<chart:data-set-point-stroke>{$ds-point-stroke}</chart:data-set-point-stroke>,
		<chart:data-set-point-stroke-width>{$ds-point-stroke-width}</chart:data-set-point-stroke-width>)
};

declare function chart:bar-chart($width as xs:double, $height as xs:double) {
	<chart:chart>
		<chart:background-color>#E0E0E0</chart:background-color>
		<chart:type>bar</chart:type>
		<chart:size>
			<chart:width>{$width}</chart:width>
			<chart:height>{$height}</chart:height>
		</chart:size>
		<chart:data-sets>
			<chart:default-data-set>
				<chart:data-set-name>Default</chart:data-set-name>,
				<chart:data-set-class-name>default</chart:data-set-class-name>,
				<chart:data-set-stroke>#6699FF</chart:data-set-stroke>,
				<chart:data-set-stroke-width>1</chart:data-set-stroke-width>,
				<chart:data-set-fill>#6699FF</chart:data-set-fill>,
			</chart:default-data-set>
		</chart:data-sets>
		<chart:x-axis>
			<chart:height>20</chart:height>
			<chart:major-ticks-every>5</chart:major-ticks-every>
			<chart:minor-ticks-every>1</chart:minor-ticks-every>
			<chart:font-size>12</chart:font-size>
			<chart:label-type>ordinal</chart:label-type>
		</chart:x-axis>
		<chart:y-axis>
			<chart:width>20</chart:width>
			<chart:major-ticks-every>5</chart:major-ticks-every>
			<chart:minor-ticks-every>1</chart:minor-ticks-every>
			<chart:font-size>12</chart:font-size>
			<chart:label-type>values</chart:label-type>
		</chart:y-axis>
	</chart:chart>
};

declare function chart:line-chart($width as xs:double, $height as xs:double) {
	<chart:chart>
		<chart:background-color>#E0E0E0</chart:background-color>
		<chart:type>line</chart:type>
		<chart:size>
			<chart:width>{$width}</chart:width>
			<chart:height>{$height}</chart:height>
		</chart:size>
		<chart:data-sets>
			<chart:default-data-set>
				<chart:data-set-name>Default</chart:data-set-name>,
				<chart:data-set-class-name>default</chart:data-set-class-name>,
				<chart:data-set-stroke>#6699FF</chart:data-set-stroke>,
				<chart:data-set-stroke-width>2</chart:data-set-stroke-width>,
				<chart:data-set-fill>none</chart:data-set-fill>,
				<chart:data-set-point-radius>3</chart:data-set-point-radius>,
				<chart:data-set-point-fill>#6699FF</chart:data-set-point-fill>,
				<chart:data-set-point-stroke>#6699FF</chart:data-set-point-stroke>,
				<chart:data-set-point-stroke-width>1</chart:data-set-point-stroke-width>
			</chart:default-data-set>
		</chart:data-sets>
		<chart:x-axis>
			<chart:height>20</chart:height>
			<chart:major-ticks-every>5</chart:major-ticks-every>
			<chart:minor-ticks-every>1</chart:minor-ticks-every>
			<chart:font-size>12</chart:font-size>
			<chart:label-type>ordinal</chart:label-type>
		</chart:x-axis>
		<chart:y-axis>
			<chart:width>20</chart:width>
			<chart:major-ticks-every>5</chart:major-ticks-every>
			<chart:minor-ticks-every>1</chart:minor-ticks-every>
			<chart:font-size>12</chart:font-size>
			<chart:label-type>values</chart:label-type>
		</chart:y-axis>
	</chart:chart>
};

declare function chart:line-chart($width as xs:double, $height as xs:double, $options as node()) {
	<chart:chart>
		<chart:background-color>{chart:if-present($options//chart:background-color, "#E0E0E0")}</chart:background-color>
		<chart:type>line</chart:type>
		<chart:size>
			<chart:width>{$width}</chart:width>
			<chart:height>{$height}</chart:height>
		</chart:size>
		<chart:data-sets>
			<chart:default-data-set>
				{chart:make-data-set-settings($options//chart:default-data-set)}
			</chart:default-data-set>
		
			{
				for $data-set in $options//chart:data-set
				return
					<chart:data-set>
						{chart:make-data-set-settings($data-set)}
					</chart:data-set>
			}
		</chart:data-sets>
		<chart:x-axis>
			{
				let $root := $options//chart:x-axis
				return (
					<chart:height>{chart:if-present($root/chart:height, "20")}</chart:height>,
					<chart:major-ticks-every>{chart:if-present($root/chart:major-ticks-every, "5")}</chart:major-ticks-every>,
					<chart:minor-ticks-every>{chart:if-present($root/chart:minor-ticks-every, "1")}</chart:minor-ticks-every>,
					<chart:font-size>{chart:if-present($root/chart:font-size, "12")}</chart:font-size>,
					<chart:label-type>{chart:if-present($root/chart:label-type, "ordinal")}</chart:label-type>
				)
			}
		</chart:x-axis>
		<chart:y-axis>
			{
				let $root := $options//chart:x-axis
				return (
					<chart:width>{chart:if-present($root/chart:height, "20")}</chart:width>,
					<chart:major-ticks-every>{chart:if-present($root/chart:major-ticks-every, "5")}</chart:major-ticks-every>,
					<chart:minor-ticks-every>{chart:if-present($root/chart:minor-ticks-every, "1")}</chart:minor-ticks-every>,
					<chart:font-size>{chart:if-present($root/chart:font-size, "12")}</chart:font-size>,
					<chart:label-type>{chart:if-present($root/chart:label-type, "values")}</chart:label-type>
				)
			}
		</chart:y-axis>
	</chart:chart>
};

declare function chart:draw-line-plot($graph-bounds as map:map, $series-config as node(), $chart-size as node(), 
		$values as xs:anyAtomicType*) as map:map
{
	let $point-spacing := xs:double(map:get($graph-bounds, "width")) div (fn:count($values) - 1.0)
	let $chart-height := xs:double(map:get($graph-bounds, "height"))
	let $first-x := xs:double(map:get($graph-bounds, "x"))
	let $first-y := xs:double(map:get($graph-bounds, "y"))
	let $min-value := xs:double(fn:min($values))
	let $max-value := xs:double(fn:max($values))
	let $stroke := $series-config//chart:data-set-stroke
	let $stroke-width := $series-config//chart:data-set-stroke-width
	let $point-radius := $series-config//chart:data-set-point-radius
	let $point-fill := $series-config//chart:data-set-point-fill
	let $point-stroke := $series-config//chart:data-set-point-stroke
	let $point-stroke-width := $series-config//chart:data-set-point-stroke-width
	return drawing:make-group(
		for $idx in (2 to fn:count($values))
		return
			let $x1 := ($idx - 2) * $point-spacing + $first-x
			let $y1 := $chart-height - $chart-height * (($values[$idx - 1] - $min-value) div ($max-value - $min-value)) + $first-y
			let $x2 := ($idx - 1) * $point-spacing + $first-x
			let $y2 := $chart-height - $chart-height * (($values[$idx] - $min-value) div ($max-value - $min-value)) + $first-y
			let $segment := drawing:line($x1, $y1, $x2, $y2)
			let $_ := (drawing:set-stroke($segment, $stroke), drawing:set-stroke-width($segment, $stroke-width))
			let $points := (if ($idx eq 2) then drawing:circle($x1, $y1, $point-radius) else (), drawing:circle($x2, $y2, $point-radius))
			let $_ := for $point in $points return (drawing:set-fill($point, $point-fill), drawing:set-stroke($point, $point-stroke), 
				drawing:set-stroke-width($point, $point-stroke-width))
			return
				($segment, $points)
	)
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

declare function chart:centered-x-labels($x-axis-bounds as map:map, $x-axis-config as node(),
	$values as xs:anyAtomicType*) 
{
	let $spacing := 2.0
	let $axis-x := map:get($x-axis-bounds, "x")
	let $axis-y := map:get($x-axis-bounds, "y")
	let $axis-width := map:get($x-axis-bounds, "width")
	let $axis-height := map:get($x-axis-bounds, "height")
	let $major-mod as xs:int := $x-axis-config//chart:major-ticks-every
	let $minor-mod as xs:int := $x-axis-config//chart:minor-ticks-every
	let $tick-ival := $axis-width div fn:count($values)

	let $base-line := drawing:line($axis-x, $axis-y, $axis-x + $axis-width, $axis-y)
	let $ticks := for $idx in 1 to fn:count($values)
								let $is-major := ($idx mod $major-mod) eq 0
								let $is-minor := (fn:not($is-major) and ($idx mod $minor-mod) eq 0)
								let $x := $tick-ival * ($idx - 1) + $axis-x + ($tick-ival div 2.0)
								return if ($is-minor) 
									then
										drawing:line($x, $axis-y, $x, $axis-y + 3)
									else 
										drawing:line($x, $axis-y, $x, $axis-y + 5)
	let $_ := for $item in ($base-line, $ticks) return (drawing:set-stroke($item, "#000000"), drawing:set-stroke-width($item, 1))
	return
		drawing:make-group(($base-line, $ticks))
};

declare function chart:draw-x-axis($x-axis-bounds as map:map, $x-axis-config as node(), 
	$values as xs:anyAtomicType*) as map:map
{
	let $axis-x := map:get($x-axis-bounds, "x")
	let $axis-y := map:get($x-axis-bounds, "y")
	let $axis-width := map:get($x-axis-bounds, "width")
	let $axis-height := map:get($x-axis-bounds, "height")
	let $major-mod as xs:int := $x-axis-config//chart:major-ticks-every
	let $minor-mod as xs:int := $x-axis-config//chart:minor-ticks-every
	let $tick-ival := $axis-width div (fn:count($values) - 1)

	let $base-line := drawing:line($axis-x, $axis-y, $axis-x + $axis-width, $axis-y)
	let $ticks := for $idx in 1 to fn:count($values)
								let $is-major := ($idx mod $major-mod) eq 0
								let $is-minor := (fn:not($is-major) and ($idx mod $minor-mod) eq 0)
								let $x := $tick-ival * ($idx - 1) + $axis-x
								return if ($is-minor) 
									then
										drawing:line($x, $axis-y, $x, $axis-y + 3)
									else 
										drawing:line($x, $axis-y, $x, $axis-y + 5)
	let $_ := for $item in ($base-line, $ticks) return (drawing:set-stroke($item, "#000000"), drawing:set-stroke-width($item, 1))
	return
		drawing:make-group(($base-line, $ticks))
};

declare function chart:draw-y-axis($y-axis-bounds as map:map, $y-axis-config as node(), 
	$values as xs:anyAtomicType*) as map:map
{
	let $axis-x := map:get($y-axis-bounds, "x")
	let $axis-y := map:get($y-axis-bounds, "y")
	let $axis-width := map:get($y-axis-bounds, "width")
	let $axis-height := map:get($y-axis-bounds, "height")

	let $low-value := fn:floor(fn:min($values))
	let $high-value := fn:ceiling(fn:max($values))
	let $steps := xs:int($high-value - $low-value)

	let $major-mod as xs:int := $y-axis-config//chart:major-ticks-every
	let $minor-mod as xs:int := $y-axis-config//chart:minor-ticks-every
	let $tick-ival := $axis-height div $steps

	let $base-line := drawing:line($axis-width, $axis-y, $axis-width, $axis-y + $axis-height)
	let $ticks := for $idx in 1 to $steps
								let $is-major := ($idx mod $major-mod) eq 0
								let $is-minor := (fn:not($is-major) and ($idx mod $minor-mod) eq 0)
								let $y := $axis-height - $tick-ival * ($idx - 1)
								return if ($is-minor) 
									then
										drawing:line($axis-width - 3, $y, $axis-width, $y)
									else 
										drawing:line($axis-width - 5, $y, $axis-width, $y)
	let $_ := for $item in ($base-line, $ticks) return (drawing:set-stroke($item, "#000000"), drawing:set-stroke-width($item, 1))
	return
		drawing:make-group(($base-line, $ticks))
};


declare function chart:line-plot($chart as node(), $values as xs:anyAtomicType*) as map:map {
	let $chart-width := xs:double($chart//chart:size/chart:width)
	let $chart-height := xs:double($chart//chart:size/chart:height)
	let $y-axis-width := xs:double($chart//chart:y-axis/chart:width)
	let $x-axis-height := xs:double($chart//chart:x-axis/chart:height)

	let $y-axis-bounds := map:new((map:entry("x", 0.0), map:entry("y", 0.0), map:entry("width", $y-axis-width), 
		map:entry("height", $chart-height - $x-axis-height)))
	let $x-axis-bounds := map:new((map:entry("x", $y-axis-width), map:entry("y", $chart-height - $x-axis-height),
		map:entry("width", $chart-width - $y-axis-width),
		map:entry("height", $x-axis-height)))
	let $graph-bounds := map:new((map:entry("x", $y-axis-width + 1.0), map:entry("y", 0.0), 
		map:entry("width", $chart-width - $y-axis-width - 1.0), 
		map:entry("height", $chart-height - $x-axis-height - 1.0)))
	return drawing:make-group((
		chart:draw-line-plot($graph-bounds, $chart//chart:data-sets, $chart//chart:size, $values),
		chart:draw-x-axis($x-axis-bounds, $chart//chart:x-axis, $values), 
		chart:draw-y-axis($y-axis-bounds, $chart//chart:y-axis, $values)))
};

declare function chart:bar-plot($chart as node(), $values as xs:anyAtomicType*) as map:map {
	let $chart-width := xs:double($chart//chart:size/chart:width)
	let $chart-height := xs:double($chart//chart:size/chart:height)
	let $y-axis-width := xs:double($chart//chart:y-axis/chart:width)
	let $x-axis-height := xs:double($chart//chart:x-axis/chart:height)

	let $y-axis-bounds := map:new((map:entry("x", 0.0), map:entry("y", 0.0), map:entry("width", $y-axis-width), 
		map:entry("height", $chart-height - $x-axis-height)))
	let $x-axis-bounds := map:new((map:entry("x", $y-axis-width), map:entry("y", $chart-height - $x-axis-height),
		map:entry("width", $chart-width - $y-axis-width),
		map:entry("height", $x-axis-height)))
	let $graph-bounds := map:new((map:entry("x", $y-axis-width + 1.0), map:entry("y", 0.0), 
		map:entry("width", $chart-width - $y-axis-width - 1.0), 
		map:entry("height", $chart-height - $x-axis-height - 1.0)))
	return drawing:make-group((
		chart:draw-bar-plot($graph-bounds, $chart//chart:data-sets, $chart//chart:size, $values),
		chart:centered-x-labels($x-axis-bounds, $chart//chart:x-axis, $values), 
		chart:draw-y-axis($y-axis-bounds, $chart//chart:y-axis, $values)))
};


(:
	Plots the values defined in the chart
:)
declare function chart:plot($chart as node(), $values as xs:anyAtomicType*)  {
	let $width := $chart//chart:size/chart:width
	let $height := $chart//chart:size/chart:height
	return 
		if ($chart//chart:type/text() eq "line") 
		then
			drawing:render($width, $height, chart:line-plot($chart, $values))
		else if($chart//chart:type/text() eq "bar")
		then
			drawing:render($width, $height, chart:bar-plot($chart, $values))
		else ()
};

declare function chart:xxx-line-chart($width, $height, $values as xs:anyAtomicType*) as node()  {
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
