# Description
#   for deploy tars api/web
#
# Configuration:
#   1. need to have jenkins and specified git repo
#   2. need to have ssh access to AWS EC2
#
# Commands:
#   hubot deploy api to <int|production> <release-version> - deploy to tars api
#   hubot deploy web to <int|production> <release-version> - deploy to tars web
#
# Notes:
#   <release-version> need to have corresponding jar/zip file on AWS S3
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
    command = "ansible-playbook -v -i /var/lib/jenkins/jobs/tars-web/workspace/deployment/int /var/lib/jenkins/jobs/tars-web/workspace/deployment/deploy-fe.yml --extra-vars \"release_version=1.0.#{version} release_env=#{env}\""

    msg.send "deploying tars web to #{env} using version: #{version}"
    execCommand msg, command
