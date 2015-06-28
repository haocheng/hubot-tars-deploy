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
    command = "ansible-playbook -v -i /var/lib/jenkins/jobs/tars-server-deploy-int/workspace/vm/int /var/lib/jenkins/jobs/tars-server-deploy-int/workspace/vm/deploy-api.yml --extra-vars \"release_version=1.0.#{version} release_env=#{env}\""
    version = msg.match[2]

    msg.send "deploying: tars-api to #{env}"
    execCommand msg, command
