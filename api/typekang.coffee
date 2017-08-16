# Typekang Broser Interface

# Convenience method
# Not suggested because security risks
# Only use if you are sure there will be no credential information on the page
# Apply font to the whole body
renderBody = (baseURL, name, callback) ->
  renderElement baseURL, name, document.body, callback

# Apply font of {name} to some DOM element
renderElement = (baseURL, name, element, callback) ->
  renderFont baseURL, name, element.innerText, (err, fontName) ->
    callback err if err? and callback?
    element.style.fontFamily = fontName
    callback null, fontName if callback?

# Apply font of {name} to an array of elements
renderElements = (baseURL, name, elements, callback) ->
  text = ''
  for e in elements
    text += e.innerText
  renderFont baseURL, name, text, (err, fontName) ->
    callback err if err? and callback?
    for e in elements
      e.style.fontFamily = fontName
    callback null, fontName if callback?

# Generate font subset of {name} with {content} and return the resulting font-family to callback
renderFont = (baseURL, name, content, callback) ->
  if !callback?
    callback = ->
      # An empty function
  contentId = md5(content) # from md5.js
  path = "#{baseURL}/font/css/#{name}-#{contentId}/#{name}.css"
  requestForStatus path, 'GET', '', (status) =>
    if status is 404
      doGetFont baseURL, name, content, contentId, path, callback
    else
      appendFontCss path, name, contentId, callback

doGetFont = (baseURL, name, content, contentId, path, callback) ->
  url = "#{baseURL}/font/generate/#{name}/#{contentId}"
  requestForStatus url, 'POST', content, (status) =>
    if status is 200
      appendFontCss path, name, contentId, callback
    else
      callback new Error 'Status ' + status


appendFontCss = (path, name, contentId, callback) ->
  document.getElementsByTagName("head")[0].innerHTML += "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{path}\"/>"
  callback null, "minified-#{name}-#{contentId}"

requestForStatus = (path, method, body, callback) ->
  xhr = new XMLHttpRequest()
  xhr.open(method, path, true)
  xhr.onreadystatechange = =>
    if xhr.readyState isnt XMLHttpRequest.DONE
      return
    callback xhr.status
  xhr.send(body)
