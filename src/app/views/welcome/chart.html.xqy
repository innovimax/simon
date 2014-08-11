xquery version "1.0-ml";

import module namespace chart="http://marklogic.com/ps/charting" at "/app/lib/charting.xqy";

<div>
{
	chart:line-chart(320, 200, (4, 3, 5, 6, 7, 5, 3, 2, 2, 4, 1, 2, 4, 2, 5))
}
</div>