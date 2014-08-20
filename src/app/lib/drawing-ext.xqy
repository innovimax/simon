xquery version "1.0-ml";

module namespace drawing-ext="http://marklogic.com/ps/drawing-ext";

import module namespace drawing="http://marklogic.com/ps/drawing" at "/app/lib/drawing.xqy";

declare default element namespace "http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function drawing-ext:chevron($width as xs:double, $height as xs:double, $thickness as xs:double) as map:map {
  drawing:polygon(
    (0, $height, 
      0, $height - $thickness, 
      $width div 2.0, 0, 
      $width, $height - $thickness, 
      $width, $height, 
      $width div 2.0, $thickness), ("fill=#009900"))
};
