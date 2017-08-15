###
  This file is part of Posea.

  Posea is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Posea is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with Posea.  If not, see <http://www.gnu.org/licenses/>.
###

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

test = (callback) ->
  build =>
    execLive 'node_modules/.bin/coffee -o test_mid -c test && node_modules/.bin/babel -d test_js test_mid && rm -rf test_mid', =>
      execLive 'node_modules/.bin/mocha test_js', callback

task 'build', 'Build the project', build
task 'start', 'Build and run the project', start
task 'test', 'Run the test suite', test
