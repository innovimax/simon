xquery version "1.0-ml";

import module namespace parts="http://marklogic.com/ps/chart-parts" at "/app/lib/chart-parts.xqy";

<table class='testing'>
  <thead>
    <tr>
      <th>Test</th>
      <th>Expected Result</th>
      <th>Actual Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        Set major ticks every 13, where options contains a value of 13, min-tick-value = 1, max-tick-value = 100 
        and $major-optimal-tick-count = 20
        <code>parts:get-major-ticks-every($options, $min-tick-value, $max-tick-value, $major-optimal-tick-count)</code>
      </td>
      <td>13</td>
      <td>
        {
          let $options := parts:options-to-map(("major-ticks-every=13"))
          return 
            parts:get-major-ticks-every($options, 100, 1, 20)
        }
      </td>
    </tr>
    <tr>
      <td>
        Set major ticks every 20, where min-tick-value = 1, max-tick-value = 100 and $major-optimal-tick-count = 20
        <code>parts:get-major-ticks-every($options, $min-tick-value, $max-tick-value, $major-optimal-tick-count)</code>
      </td>
      <td>5</td>
      <td>
        {
          parts:get-major-ticks-every(map:new(), 100, 1, 20)
        }
      </td>
    </tr>
    <tr>
      <td>
        Set minor ticks every 11, where options contains the value of 13, and major-ticks-every = 20
        <code>parts:get-minor-ticks-every($options, $major-ticks-every) as xs:int</code>
      </td>
      <td>11</td>
      <td>
      {
        let $options := parts:options-to-map(("minor-ticks-every=11"))
        return
          parts:get-minor-ticks-every($options, 20)
      } 
      </td>
    </tr>
    <tr>
      <td>
        Set minor ticks every 4, and major-ticks-every = 20
        <code>parts:get-minor-ticks-every($options, $major-ticks-every) as xs:int</code>
      </td>
      <td>4</td>
      <td>
      {
        let $options := parts:options-to-map(())
        return
          parts:get-minor-ticks-every($options, 20)
      } 
      </td>
    </tr>
    <tr>
      <td>
        Calculate the optimal width between major ticks, given the size of the axis.  300 pixels 
        wide, given a 50 px optimal width.
        <code>declare function parts:get-optimal-major-ticks-count($width as xs:double, 
          $optimal-tick-width) as xs:int</code>
      </td>
      <td>6</td>
      <td>
      {
        parts:get-optimal-major-ticks-count(300, 50)
      }
      </td>
    </tr>
    <tr>
      <td>
        Calculate the optimal width between major ticks, given the size of the axis.  333 pixels 
        wide, given a 50 px optimal width.
        <code>declare function parts:get-optimal-major-ticks-count($width as xs:double, 
          $optimal-tick-width) as xs:int</code>
      </td>
      <td>6</td>
      <td>
      {
        parts:get-optimal-major-ticks-count(333, 50)
      }
      </td>
    </tr>
    <tr>
      <td>
        Calculate the optimal width between major ticks, given the size of the axis.  349 pixels 
        wide, given a 50 px optimal width.
        <code>declare function parts:get-optimal-major-ticks-count($width as xs:double, 
          $optimal-tick-width) as xs:int</code>
      </td>
      <td>6</td>
      <td>
      {
        parts:get-optimal-major-ticks-count(349, 50)
      }
      </td>
    </tr>
    <tr>
      <td>
        Calculate the maximum tick value, based on the settings, the data and the type of label.
        Where the label source is "ordinal" and the $data contains 10 values.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>10</td>
      <td>
      {
        parts:get-max-tick-value("ordinal", (1, 2, 3, 4, 5, 6, 7, 8, 9, 10), ())
      }
      </td>
    </tr>
    <tr>
      <td>
        Calculate the maximum tick value, based on the settings, the data and the type of label.
        Where the label source is "data" and the $data contains ten values and the max value 9.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>9</td>
      <td>
      {
        parts:get-max-tick-value("data", (1, 2, 3, 7, 5, 6, 7, 8, 9, 4), ())
      }
      </td>
    </tr>
    <tr>
      <td>
        Calculate the maximum tick value, based on the settings, the data and the type of label.
        Where the label source is "options" and the $data contains ten values, and the defined 
        value is 12.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>12</td>
      <td>
      {
        parts:get-max-tick-value("options", (1, 2, 3, 7, 5, 6, 7, 8, 9, 4), 12)
      }
      </td>
    </tr>
    <tr>
      <td>
        Where the value is based on settings but the max value isn't set, which means use the
        count of data values as the default.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>10</td>
      <td>
      {
        parts:get-max-tick-value("options", (1, 2, 3, 7, 5, 6, 7, 8, 9, 4), ())
      }
      </td>
    </tr>
    <tr>
      <td>
        The label source is set to ordinal.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>1</td>
      <td>
      {
        parts:get-min-tick-value("ordinal", (1, 2, 3, 4), ()) 
      }
      </td>
    </tr>
    <tr>
      <td>
        The label source is set to data and the minimum value is 2.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>2</td>
      <td>
      {
        parts:get-min-tick-value("data", (5, 2, 3, 4), ()) 
      }
      </td>
    </tr>
    <tr>
      <td>
        The label source is set to options and the minimum value is set 0.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>0</td>
      <td>
      {
        parts:get-min-tick-value("options", (5, 2, 3, 4), 0) 
      }
      </td>
    </tr>
    <tr>
      <td>
        The label source is set to options and no minimum value is set.
        <code>declare function parts:get-max-tick-value($label-source, $data, $label-max)</code>
      </td>
      <td>1</td>
      <td>
      {
        parts:get-min-tick-value("options", (5, 2, 3, 4), ()) 
      }
      </td>
    </tr>
  </tbody>
</table>