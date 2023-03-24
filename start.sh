date_now=$(date "+%F")
curl -X GET "https://openapi.twse.com.tw/v1/exchangeReport/STOCK_DAY_ALL" -H "accept: text/csv" -H "If-Modified-Since: Mon, 26 Jul 1997 05:00:00 GMT" -H "Cache-Control: no-cache" -H "Pragma: no-cache" > ~/work/${date_now}.csv

