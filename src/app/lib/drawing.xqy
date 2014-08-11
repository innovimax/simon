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
	let $c := drawing:make-primitive("circle")
	let $_ := (drawing:set-attribute($c, "r", $radius))
	return $c
};

declare function drawing:circle($x as xs:double, $y as xs:double, $radius as xs:double) as map:map {
	let $c := drawing:make-primitive("circle")
	let $_ := (drawing:set-attribute($c, "cx", $x), drawing:set-attribute($c, "cy", $y), 
		drawing:set-attribute($c, "r", $radius))
	return $c
};

declare function drawing:rect($x, $y, $width, $height) {
	let $r := drawing:make-primitive("rect")
	let $_ := (
		drawing:set-attribute($r, "x", $x),
		drawing:set-attribute($r, "y", $y),
		drawing:set-attribute($r, "height", $height),
		drawing:set-attribute($r, "width", $width))
	return $r
};

declare function drawing:elipse($x, $y, $rx, $ry) {
	let $e := drawing:make-primitive("elipse")
	let $_ := (
		drawing:set-attribute($e, "cx", $x),
		drawing:set-attribute($e, "cy", $y),
		drawing:set-attribute($e, "rx", $rx),
		drawing:set-attribute($e, "ry", $ry))
	return $e
};

declare function drawing:line($x1, $y1, $x2, $y2) {
	let $l := drawing:make-primitive("line")
	let $_ := (
		drawing:set-attribute($l, "x1", $x1),
		drawing:set-attribute($l, "y1", $y1),
		drawing:set-attribute($l, "x2", $x2),
		drawing:set-attribute($l, "y2", $y2))
	return $l
};

declare function drawing:text($x, $y, $text) {
	let $t := drawing:make-primitive("text")
	let $_ := (
		drawing:set-attribute($t, "x", $x),
		drawing:set-attribute($t, "y", $y),
		drawing:set-attribute($t, "text", $text))
	return $t
};

declare function drawing:set-stroke($object as map:map, $color as xs:string) {
	drawing:set-attribute($object, "stroke", $color)
};

declare function drawing:set-fill($object as map:map, $color as xs:string) {
	drawing:set-attribute($object, "fill", $color)
};

declare function drawing:set-stroke-width($object as map:map, $width) {
	drawing:set-attribute($object, "stroke-width", $width)
};

declare function drawing:set-opacity($object as map:map, $opacity) {
	drawing:set-attribute($object, "opacity", $opacity)
};

declare function drawing:set-stroke-linecap($object as map:map, $linecap as xs:string) {
	drawing:set-attribute($object, "stroke-linecap", $linecap)
};

declare function drawing:set-stroke-dasharray($object as map:map, $vals as xs:int*) {
	let $pattern := fn:string-join(for $val in $vals return xs:string($val), ",")
	return drawing:set-attribute($object, "stroke-dasharray", $pattern)
};

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


declare function drawing:render-object($object as map:map) {
	let $attributes := map:get($object, $k-attr)
	return element { drawing:get-type($object) } {
		for $key in map:keys($attributes)
		where $key ne "text"
		return attribute { $key } { xs:string(map:get($attributes, $key)) },

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

declare function drawing:render($objects as map:map*) {
	element svg {
		attribute xmlns { "http://www.w3.org/2000/svg" },
		for $object in $objects
		return drawing:render-object($object)
	}
};

declare function drawing:render($width, $height, $objects as map:map*) {
	element svg {
		attribute xmlns { "http://www.w3.org/2000/svg" },
		attribute width { $width },
		attribute height { $height },
		for $object in $objects
		return drawing:render-object($object)
	}
};

