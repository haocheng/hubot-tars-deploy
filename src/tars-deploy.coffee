# Description
#   for deploy tars api/web
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   hclee <hclee@kkbox.com>

exec  = require('child_process').exec

execCommand = (msg, cmd) ->
  exec cmd, (error, stdout, stderr) ->
    msg.send error if error
    msg.send stdout
    msg.send stderr if stderr

checkAnsible = "which ansible-playbook"
exec checkAnsible, (error, stdout, stderr) ->
  if stdout == "" or stdout is "ansible-playbook not found"
    console.log "WARN: you don't have ansible-playbook in your $PATH, so this probably won't work....."


module.exports = (robot) ->

  robot.respond /deploy api to (int|production) (.*)$/i, (msg) ->
    env = msg.match[1]
    version = msg.match[2]
    command = "ansible-playbook -v -i /var/lib/jenkins/jobs/tars-server/workspace/vm/int /var/lib/jenkins/jobs/tars-server/workspace/vm/deploy-api.yml --extra-vars \"release_version=1.0.#{version} release_env=#{env}\""

    msg.send "deploying tars api to #{env} using version: #{version}"
    execCommand msg, command


  robot.respond /deploy web to (int|production) (.*)$/i, (msg) ->
    env = msg.match[1]
    version = msg.match[2]
    command = "ansible-playbook -v -i /var/lib/jenkins/jobs/tars-web/workspace/vm/int /var/lib/jenkins/jobs/tars-web/workspace/vm/deploy-fe.yml --extra-vars \"release_version=1.0.#{version} release_env=#{env}\""

    msg.send "deploying tars web to #{env} using version: #{version}"
    execCommand msg, command
