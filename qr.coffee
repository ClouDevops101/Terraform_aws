# Description:
#   Turn a URL into a QR Code
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <url> - turn a URL into a QR Code
#
# Notes:
#   Makes use of Google's ChartAPI
#
# Author:
#  Abdelilah Heddar


module.exports = (robot) ->
  robot.hear /^((https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?)$/i, (msg) ->
    url = msg.match[1]
    msg.send "Get it on mobile " +  "https://chart.googleapis.com/chart?chs=178x178&cht=qr&chl=" + encodeURIComponent(url)

  robot.hear /^((https?:\/\/)?((?:[0-9]{1,3}\.){3}[0-9]{1,3}))$/i, (msg) ->
    url1 = msg.match[1]
    msg.send "Get it on mobile " +  "https://chart.googleapis.com/chart?chs=178x178&cht=qr&chl=" + encodeURIComponent(url1)
