export rawBody = (req, res, next) =>
  req.setEncoding 'utf8'
  req.rawBody = ''
  req.on 'data', (chunk) ->
    req.rawBody += chunk
  req.on 'end', ->
    next()
