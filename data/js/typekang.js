// Typekang JavaScript interface

// DO NOT USE THIS UNLESS YOU ARE SURE THERE WILL BE NO CREDENTIAL INFORMATION ON THE PAGE
function renderBody(baseURL, name, callback) {
  renderFont(baseURL, name, document.body.innerText, function(err, fontName) {
    if (err) {
      callback(err)
    } else {
      document.body.style.fontFamily = fontName
      callback(null, fontName)
    }
  })
}

// Always use this if possible
function renderFont(baseURL, name, content, callback) {
  if (callback == null)
    callback = function () {}
  var contentId = md5(content)
  var path = baseURL + '/font/css/' + name + '-' + contentId + '/' + name + '.css'
  var xhr = new XMLHttpRequest()
  xhr.open('GET', path, true)
  xhr.onreadystatechange = function() {
    if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 404) {
      doGetFont(baseURL, name, content, contentId, path, callback)
    } else if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
      appendFontCss(path, name, contentId, callback)
    }
  }
  xhr.send()
}

function doGetFont(baseURL, name, content, contentId, path, callback) {
  var url = baseURL + '/font/generate/' + name + '/' + contentId
  var xhr = new XMLHttpRequest()
  xhr.open('POST', url, true)
  xhr.onreadystatechange = function() {
    if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
      appendFontCss(path, name, contentId, callback)
    } else if (xhr.readyState == XMLHttpRequest.DONE && xhr.status != 200) {
      callback(new Error('Status ' + xhr.status))
    }
  }
  xhr.send(content)
}

function appendFontCss(path, name, contentId, callback) {
  document.body.innerHTML += '<link rel="stylesheet" type="text/css" href="' + path + '"/>'
  callback(null, 'minified-' + name + '-' + contentId)
}
