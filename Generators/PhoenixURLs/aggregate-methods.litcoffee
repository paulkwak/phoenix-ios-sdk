

    request = require 'request'
    fs = require 'fs'
    url = require 'url'

env.json defines a set of URLs containing Phoenix API documentations.


Helper function: converting first character to lower case
    
    firstToUpperCase = (str) -> 
        string = str.substr(0, 1).toUpperCase() + str.substr(1)
        string  

Helper function: fetch URL to get back JSON

    getJSONsSaveIntoDisk = (url) ->
      request.get { url, json: true }, (err, r, body) ->
        results = body
        filename =  url.split('=').pop()
        filename = firstToUpperCase filename

        #declare model in the JSON file
        model = {}
        model.apiMethods = []
        model.moduleName = filename
        #api methods
        model.apiMethods = results
        
        filename = filename + '.json'
        console.log('writing to ' + filename)
        serializedText = JSON.stringify model,undefined,4
        fs.writeFileSync("PhoenixURLs/output/" + filename, serializedText)

using different config.json allows us to switch between environments (live, uat, dev, whatever)

    config = JSON.parse(fs.readFileSync('./PhoenixURLs/env-target.json', 'utf8'))
    
    urls = config.urls
    

print out all URLs that this script is working with

    for aUrl in urls
      console.log aUrl

Unleash the workers     

    for url in urls
      getJSONsSaveIntoDisk url

      

    