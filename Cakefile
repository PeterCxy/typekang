{spawn} = require 'child_process'

execLive = (cmd, callback) ->
  #exec cmd, sharedCallback(callback)
  #  .stdout.pipe process.stdout
  p = spawn cmd, [], { stdio: 'inherit', shell: true }
  p.on 'exit', =>
    callback() if callback? and callback instanceof Function
  p.on 'error', (err) =>
    callback err if callback? and callback instanceof Function
sharedCallback = (callback) -> (err) ->
  throw err if err
  callback() if callback? and callback instanceof Function

build = (callback) ->
  execLive 'node_modules/.bin/coffee -o mid -c src && node_modules/.bin/babel -d lib mid && rm -rf mid', callback

start = (callback) ->
  build => execLive 'yarn start', callback

task 'build', 'Build the project', build
task 'start', 'Build and run the project', start
