

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
        result = []
        for apiMethod in body
            str = apiMethod.Name
            if str.substr(0, 6) isnt "Equals"
                requiredProperties = apiMethod.RequiredProperties

                # get out of the "Data" property in the JSON and make it seperate attribute
                newRequiredProperties = []
                for requiredProperty in requiredProperties
                    if requiredProperty.Name is "Data"
                        requireDataBody = requiredProperty
                    else
                        newRequiredProperties.push requiredProperty

                apiMethod.RequiredProperties = newRequiredProperties
                apiMethod.RequiredBodyData = requireDataBody

                
                if str.substr(0, 6) is "Create"
                    apiMethod.createAPI = "Yes"
                else if str.substr(0, 4) is "List"
                    apiMethod.listAPI = "Yes"
                else if str.substr(0, 6) is "Delete"
                    apiMethod.deleteAPI = "Yes"
                else if str.substr(0, 3) is "Get"
                    apiMethod.getAPI = "Yes"
                else if str.substr(0, 6) is "Update"
                    apiMethod.updateAPI = "Yes"
                else
                    apiMethod.otherAPI = "Yes"

                result.push apiMethod

        filename =  url.split('=').pop()
        filename = firstToUpperCase filename

        #declare model in the JSON file
        model = {}
        model.apiMethods = []
        model.moduleName = filename
        #api methods
        model.apiMethods = result
        
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

      

    