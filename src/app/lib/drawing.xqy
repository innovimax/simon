xquery version "1.0-ml";

module namespace drawing="http://marklogic.com/ps/drawing";

declare default element namespace "http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare variable $k-attr := "attributes";
declare variable $k-chld := "children";
declare variable $k-type := "type";

declare function drawing:make-group() as map:map {
	map:new((
		map:entry($k-type, "g"),
		map:entry($k-attr, map:new()),
		map:entry($k-chld, ())
	))
};

declare function drawing:make-group($children as map:map*) as map:map {
	map:new((
		map:entry($k-type, "g"),
		map:entry($k-attr, map:new()),
		map:entry($k-chld, $children)
	))
};

declare function drawing:append-child($group, $child as map:map) {
	map:put($group, $k-chld, (map:get($group, $k-chld), $child))
};


declare function drawing:make-primitive($type as xs:string) as map:map {
	map:new((
		map:entry($k-type, $type),
		map:entry($k-attr, map:new())
	))
};

declare function drawing:set-attribute($object as map:map, $attribute as xs:string, $value) {
	map:put(map:get($object, $k-attr), $attribute, $value)
};

declare function drawing:get-attribute($object as map:map, $attribute as xs:string) {
	map:get(map:get($object, $k-attr), $attribute)
};

declare function drawing:is-a-group($object as map:map) as xs:boolean {
	map:get($object, $k-type) eq "g"
};

declare function drawing:is-text($object as map:map) as xs:boolean {
	fn:exists(map:get(map:get($object, $k-attr), "text"))
};

declare function drawing:get-type($object as map:map) as xs:string {
	map:get($object, $k-type)
};

declare function drawing:circle($radius as xs:double) as map:map
{
	drawing:circle($radius, ())
};

declare function drawing:circle($x as xs:double, $y as xs:double, $radius as xs:double) as map:map {
	drawing:circle($x, $y, $radius, ())
};

declare function drawing:circle($radius as xs:double, $options as xs:string*) as map:map {
	let $c := drawing:make-primitive("circle")
	let $_ := (drawing:set-attribute($c, "r", $radius))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($c, $option-key-value[1], $option-key-value[2])
	return $c
};

declare function drawing:circle($x as xs:double, $y as xs:double, $radius as xs:double, $options as xs:string*) as map:map {
	let $c := drawing:make-primitive("circle")
	let $_ := (drawing:set-attribute($c, "cx", $x), drawing:set-attribute($c, "cy", $y), 
		drawing:set-attribute($c, "r", $radius))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($c, $option-key-value[1], $option-key-value[2])
	return $c
};

declare function drawing:rect($x as xs:double, $y as xs:double, $width as xs:double, $height as xs:double) as map:map {
	drawing:rect($x, $y, $width, $height, ())
};

declare function drawing:rect($x as xs:double, $y as xs:double, $width as xs:double, $height as xs:double, $options as xs:string*) as map:map {
	let $r := drawing:make-primitive("rect")
	let $_ := (
		drawing:set-attribute($r, "x", $x),
		drawing:set-attribute($r, "y", $y),
		drawing:set-attribute($r, "height", $height),
		drawing:set-attribute($r, "width", $width))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($r, $option-key-value[1], $option-key-value[2])
	return $r
};

declare function drawing:elipse($x as xs:double, $y as xs:double, $rx as xs:double, $ry as xs:double) as map:map {
	drawing:elipse($x, $y, $rx, $ry, ())
};

declare function drawing:elipse($x as xs:double, $y as xs:double, $rx as xs:double, $ry as xs:double, $options as xs:string*) as map:map {
	let $e := drawing:make-primitive("elipse")
	let $_ := (
		drawing:set-attribute($e, "cx", $x),
		drawing:set-attribute($e, "cy", $y),
		drawing:set-attribute($e, "rx", $rx),
		drawing:set-attribute($e, "ry", $ry))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($e, $option-key-value[1], $option-key-value[2])
	return $e
};

declare function drawing:line($x1 as xs:double, $y1 as xs:double, $x2 as xs:double, $y2 as xs:double) as map:map {
	drawing:line($x1, $y1, $x2, $y2, ())
};

declare function drawing:line($x1 as xs:double, $y1 as xs:double, $x2 as xs:double, $y2 as xs:double, $options as xs:string*) as map:map {
	let $l := drawing:make-primitive("line")
	let $_ := (
		drawing:set-attribute($l, "x1", $x1),
		drawing:set-attribute($l, "y1", $y1),
		drawing:set-attribute($l, "x2", $x2),
		drawing:set-attribute($l, "y2", $y2))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($l, $option-key-value[1], $option-key-value[2])
	return $l
};

declare function drawing:text($x as xs:double, $y as xs:double, $text as xs:string) as map:map {
	drawing:text($x, $y, $text, ())
};

declare function drawing:text($x as xs:double, $y as xs:double, $text as xs:string, $options as xs:string*) as map:map {
	let $t := drawing:make-primitive("text")
	let $_ := (
		drawing:set-attribute($t, "x", $x),
		drawing:set-attribute($t, "y", $y),
		drawing:set-attribute($t, "text", $text))
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($t, $option-key-value[1], $option-key-value[2])
	return $t
};

declare function drawing:path($options as xs:string*) as map:map {
	let $p := drawing:make-primitive("path")
	let $_ := for $option in $options 
		let $option-key-value := fn:tokenize($option, "=")
		return drawing:set-attribute($p, $option-key-value[1], $option-key-value[2])
	return $p
};

declare function drawing:path() {
	drawing:path(())
};

declare function drawing:add-path-command($path as map:map, $cmd as node()) {
	let $current-commands := drawing:get-attribute($path, "path-segments")
	return
		if (fn:count($current-commands) eq 0) 
		then
			drawing:set-attribute($path, "path-segments", ($cmd))
		else
			drawing:set-attribute($path, "path-segments", ($current-commands, $cmd))
};

declare function drawing:add-move-to($path as map:map, $x as xs:double, $y as xs:double) {
	drawing:add-path-command($path, element drawing:move-to {
		attribute x { $x }, attribute y { $y }
	})
};

declare function drawing:add-line-to($path as map:map, $x as xs:double, $y as xs:double) {
	drawing:add-path-command($path, element drawing:line-to {
		attribute x { $x }, attribute y { $y }
	})
};

declare function drawing:add-close-path($path as map:map) {
	drawing:add-path-command($path, element drawing:close-path { })
};

declare function drawing:add-quadratic($path as map:map, $cx as xs:double, $cy as xs:double, $x as xs:double, $y as xs:double) {
	drawing:add-path-command($path, element drawing:quadratic {
		element drawing:control-point { attribute x { $cx }, attribute y { $cy } },
		element drawing:end-point { attribute x { $x }, attribute y { $y } }
	})
};

declare function drawing:add-cubic($path as map:map, $c1x as xs:double, $c1y as xs:double, $c2x as xs:double, $c2y as xs:double,
	$x as xs:double, $y as xs:double) 
{
	drawing:add-path-command($path, element drawing:cubic {
		element drawing:control-point { attribute x { $c1x }, attribute y { $c1y } },
		element drawing:control-point { attribute x { $c2x }, attribute y { $c2y } },
		element drawing:end-point { attribute x { $x }, attribute y { $y } }
	})
};

declare function drawing:add-arc($path as map:map, $cx as xs:double, $cy as xs:double, $rotate as xs:double, $large-arc-flag as xs:int, 
	$sweep-flag as xs:int, $x as xs:double, $y as xs:double) 
{
	drawing:add-path-command($path, element drawing:arc {
		element drawing:control-point { attribute x { $cx }, attribute y { $cy } },
		element drawing:options { attribute rotate {$rotate }, attribute large-arc-flag { $large-arc-flag }, attribute sweep-flag { $sweep-flag } },
		element drawing:end-point { attribute x { $x }, attribute y { $y } }
	})
};

declare function drawing:make-point($segment-part as node()) as xs:string {
	fn:string($segment-part/@x)||","||fn:string($segment-part/@y)
};

declare function drawing:print-path($path-segments as node()*) as xs:string {
	let $parts := for $segment in $path-segments
		return
			typeswitch($segment) 
				case element(drawing:move-to) return "M "||drawing:make-point($segment)
				case element(drawing:line-to) return "L "||drawing:make-point($segment)
				case element(drawing:close-path) return "Z"
				case element(drawing:quadratic) return "Q "||drawing:make-point($segment/drawing:control-point)||" "||
					drawing:make-point($segment/drawing:end-point)
				case element(drawing:cubic) return "C "||drawing:make-point($segment/drawing:control-point[1])||" "||
					drawing:make-point($segment/drawing:control-point[2])||" "||drawing:make-point($segment/drawing:end-point)
				case element(drawing:arc) return "A "||drawing:make-point($segment/drawing:control-point)||", "||
					fn:string($segment/drawing:options/@rotate)||", "||fn:string($segment/drawing:options/@large-arc-flag)||", "||
					fn:string($segment/drawing:options/@sweep-flag)||", "||drawing:make-point($segment/drawing:end-point)
				default return ''
	return fn:string-join($parts, " ")
};

(:
	Set the stroke color on an object.
:)
declare function drawing:set-stroke($object as map:map, $color as xs:string) {
	drawing:set-attribute($object, "stroke", $color)
};

(:
	Set the fill color on an object.
:)
declare function drawing:set-fill($object as map:map, $color as xs:string) {
	drawing:set-attribute($object, "fill", $color)
};

(:
	Set the stroke width on an object
:)
declare function drawing:set-stroke-width($object as map:map, $width) {
	drawing:set-attribute($object, "stroke-width", $width)
};

(:
	Set the opacity on an object.
:)
declare function drawing:set-opacity($object as map:map, $opacity) {
	drawing:set-attribute($object, "opacity", $opacity)
};

(:
	Set the linecap style on an object.
:)
declare function drawing:set-stroke-linecap($object as map:map, $linecap as xs:string) {
	drawing:set-attribute($object, "stroke-linecap", $linecap)
};

(:
	Set the dasharray stroke property on an object.
:)
declare function drawing:set-stroke-dasharray($object as map:map, $vals as xs:int*) {
	let $pattern := fn:string-join(for $val in $vals return xs:string($val), ",")
	return drawing:set-attribute($object, "stroke-dasharray", $pattern)
};

(:
	Add a translation to an object or group.
:)
declare function drawing:add-translate($object as map:map, $x, $y) {
	let $transform-expression := "translate("||xs:string($x)||", "||xs:string($y)||")"
	return 
		if (fn:not(fn:exists(drawing:get-attribute($object, "transform"))))
		then
			drawing:set-attribute($object, "transform", $transform-expression)
		else
			drawing:set-attribute($object, "transform", drawing:get-attribute($object, "transform") || 
				"," || $transform-expression)
};

(:
	Add a rotation transformation to an object or group.
:)
declare function drawing:add-rotate($object as map:map, $degrees, $x, $y) {
	let $transform-expression := "rotate("||xs:string($degrees)||", "||xs:string($x)||", "||xs:string($y)||")"
	return 
		if (fn:not(fn:exists(drawing:get-attribute($object, "transform"))))
		then
			drawing:set-attribute($object, "transform", $transform-expression)
		else
			drawing:set-attribute($object, "transform", drawing:get-attribute($object, "transform") || 
				"," || $transform-expression)
};

(:
	Add a scale transformation to an object or a group
:)
declare function drawing:add-scale($object as map:map, $factor) {
	let $transform-expression := "scale("||xs:string($factor)||")"
	return 
		if (fn:not(fn:exists(drawing:get-attribute($object, "transform"))))
		then
			drawing:set-attribute($object, "transform", $transform-expression)
		else
			drawing:set-attribute($object, "transform", drawing:get-attribute($object, "transform") || 
				"," || $transform-expression)
};

(:
	Render a given object in terms of SVG.
:)
declare function drawing:render-object($object as map:map) {
	let $attributes := map:get($object, $k-attr)
	return element { drawing:get-type($object) } {
		for $key in map:keys($attributes)
		where $key ne "text"
		return 
			if ($key eq "path-segments")
			then
				attribute d { drawing:print-path(drawing:get-attribute($object, "path-segments")) }
			else 
				attribute { $key } { xs:string(map:get($attributes, $key)) },

		if (drawing:is-a-group($object))
		then
			for $child in map:get($object, $k-chld)
			return drawing:render-object($child)
		else if (drawing:is-text($object))
		then 
			map:get($attributes, "text")
		else ()
	}
};

(:
	Render into an SVG element without a fixed width and height.
:)
declare function drawing:render($objects as map:map*) {
	element svg {
		attribute xmlns { "http://www.w3.org/2000/svg" },
		for $object in $objects
		return drawing:render-object($object)
	}
};

(:
	Render into an SVG element with a defined width and height
:)
declare function drawing:render($width as xs:double, $height as xs:double, $objects as map:map*) {
	element svg {
		attribute xmlns { "http://www.w3.org/2000/svg" },
		attribute width { $width },
		attribute height { $height },
		for $object in $objects
		return drawing:render-object($object)
	}
};

