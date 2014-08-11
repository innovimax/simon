xquery version "1.0-ml";

module namespace c="http://marklogic.com/roxy/controller/welcome";

declare function c:index() {
	()
};

declare function c:picture() {
	xdmp:set-response-content-type("image/svg+xml")
};

declare function c:chart() {
	()
};
