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

buildBackend = (callback) ->
  execLive 'node_modules/.bin/coffee -o mid -c src && node_modules/.bin/babel -d lib mid && rm -rf mid', callback

buildApi = (callback) ->
  execLive 'node_modules/.bin/coffee -b --print api/typekang.coffee | node_modules/.bin/babel --presets env --no-babelrc > data/js/typekang.js', =>
    execLive 'cat api/md5.js >> data/js/typekang.js', =>
      execLive 'node_modules/.bin/uglifyjs data/js/typekang.js -c -o data/js/typekang.min.js', callback

build = (callback) ->
  buildBackend => buildApi callback

start = (callback) ->
  build => execLive 'yarn start', callback

task 'build', 'Build the project', build
task 'start', 'Build and run the project', start
