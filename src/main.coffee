import 'babel-polyfill'
import express from 'express'
import * as fs from 'fs'
import Fontmin from 'fontmin'
import { promisify } from 'util'
import { rawBody } from './misc'
existsAsync = promisify fs.exists
mkdirAsync = promisify fs.mkdir

main = ->
  app = express()
  app.use rawBody
  app.use '/font/css', express.static('data/css')
  app.post '/font/generate/:name/:id', generateFont
  app.listen 4567, =>
    console.log 'Listening on port 4567'

generateFont = (req, res) ->
  fontName = req.params.name
  contentId = req.params.id
  fontPath = "./data/font/#{fontName}.ttf"
  dirPath = "./data/css/#{fontName}-#{contentId}"
  if await existsAsync dirPath
    res.sendStatus 202
  else if not await existsAsync fontPath
    res.sendStatus 404
  else
    await mkdirAsync dirPath
    fontmin = new Fontmin()
      .src fontPath
      .use Fontmin.glyph text: req.rawBody
      .use Fontmin.ttf2woff()
      .use Fontmin.ttf2eot()
      .use Fontmin.ttf2woff()
      .use Fontmin.css
        fontFamily: "minified-#{fontName}-#{contentId}"
      .dest dirPath
    fontmin.run (err, files) ->
      throw err if err?
      res.sendStatus 200

main()
