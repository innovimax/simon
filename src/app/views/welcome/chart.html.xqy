xquery version "1.0-ml";

import module namespace chart="http://marklogic.com/ps/charting" at "/app/lib/charting.xqy";

declare variable $line-chart := chart:line-chart(320, 200);
declare variable $bar-chart := chart:bar-chart(320, 200);
declare variable $random-values := for $i in 1 to 100 return xdmp:random(10);

<div>
  <h1>Chart Examples</h1>
  <div>{chart:plot($line-chart, (4, 3, 5, 6, 7, 5, 3, 2, 2, 4, 1, 2, 4, 2, 5))}</div>
  <div>{chart:plot($bar-chart, (4, 3, 5, 6, 7, 5, 3, 2, 2, 4, 1, 2, 4, 2, 5))}</div>
  <div>{chart:plot($line-chart, $random-values)}</div>
</div>