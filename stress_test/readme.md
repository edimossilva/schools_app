# install k6
https://grafana.com/docs/k6/latest/set-up/install-k6/

# run
- `k6 run index.js`

# Results

### Methods from SchoolsController


<table>
  <tr>
    <th></th>
    <th>index_fetch_only <br> (api_request)</th>
    <th>index_fetch_and_store_on_db <br> (db / api_request)</th>
    <th>index_fetch_and_store_on_cache_and_db <br> (cache / db / api_request)</th>
    <th>index <br> (Background workers / cache / db / api_request)</th>
  </tr>
  <tr>
    <td><b>HTTP requests handled</b></td>
    <td>33</td>
    <td>88</td>
    <td>88</td>
    <td><b>517</b></td>
  </tr>
  <tr>
    <td><b>http_req_duration (max)</b></td>
    <td><b>1.43s</b></td>
    <td>3.41s</td>
    <td>2.94s</td>
    <td>1.54s</td>
  </tr>
  <tr>
    <td><b>http_req_duration (min)</b></td>
    <td>1s</td>
    <td>24.27ms</td>
    <td>29.29ms</td>
    <td><b>23.36ms<b></td>
  </tr>
  <tr>
    <td><b>http_req_duration (avg)</b></td>
    <td>1.15s</td>
    <td>344.31ms</td>
    <td>341.97ms</td>
    <td><b>58.05ms</b></td>
  </tr>
</table>
