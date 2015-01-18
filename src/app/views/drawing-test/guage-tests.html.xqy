xquery version "1.0-ml";


import module namespace charts="http://marklogic.com/ps/charting" at "/app/lib/charting.xqy";


<div>
    <div>
        { charts:draw-clock-guage(100.0, 100.0, 20.0, 100.0)}
        { charts:draw-clock-guage(100.0, 100.0, 40.0, 100.0)}
        { charts:draw-clock-guage(100.0, 100.0, 60.0, 100.0)}
        { charts:draw-clock-guage(100.0, 100.0, 80.0, 100.0)}
        { charts:draw-clock-guage(100.0, 100.0, 100.0, 100.0)}
    </div>
</div>



