import module namespace charts="http://marklogic.com/ps/charting" at "/app/lib/charting.xqy";


<div>
<div>
    <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
        <g transform="translate(0, 1)">
            <path d="M 50,0
                     A 50,50, 0, 1, 1, 32.8989928337166,96.9846310392954
                     L 50,50
                     Z" fill="none" stroke="black" stroke-width="0.5">
            </path>
            <path d="M 32.8989928337166,96.9846310392954
                     A 50,50, 0, 0, 1, 6.69872981077807, 25
                     L 50,50
                     Z" fill="none" stroke="black" stroke-width="0.5">
            </path>
            <path d="M 6.69872981077807,25
                     A 50,50, 0, 0, 1, 32.8989928337166,3.01536896070458
                     L 50,50
                     Z" fill="none" stroke="black" stroke-width="0.5">
            </path>
            <path d="M 32.8989928337166,3.01536896070458
                     A 50,50, 0, 0, 1, 50, 0
                     L 50,50
                     Z" fill="none" stroke="black" stroke-width="0.5">
            </path>
        </g>
    </svg>

    { charts:draw-pie-chart(100, 150, (10, 5, 2, 1)) }
</div>
<div>
    { charts:draw-pie-chart(500, 500, (20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)) }
    { charts:draw-pie-chart(500, 500, (1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, 1, 1, 1, 1, 1, 1, 1, 1)) }
</div>
</div>

