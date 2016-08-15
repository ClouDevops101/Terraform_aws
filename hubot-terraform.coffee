# Description:
#  Execute Cloud-automation command coffee script.
#
# Dependencies:
#  None
#
# Configuration
#  
#
# Commands:
#  hubot deploy web_app dev 3 t2.micro 
#
# Author:
#  Abdelilah Heddar
#

# Module to deploy on Aws
module.exports = (robot) ->
 robot.respond /(deploy)\s([a-z]*)?\s([a-z].*)?\s(.*)?\s(.*)?$/i, (msg) ->
               #               <app><env>    <num_servers><server_size>
    app = msg.match[2]
    env = msg.match[3]
    num_serv = msg.match[4]
    serv_siz = msg.match[5]
    @exec = require('child_process').exec
    command = "cd /home/heddar/Terraform_aws/ && ./cloud-automation.sh #{app} #{env} #{num_serv} #{serv_siz}"

    msg.send "Starting deployement..."

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr
