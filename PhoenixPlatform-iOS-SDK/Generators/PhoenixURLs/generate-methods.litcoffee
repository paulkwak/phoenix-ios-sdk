add mapping information to the properties in JSON object tree
    
    fs = require 'fs'
    hashes = require 'hashes'
    _ = require('underscore')._
    mkdirp = require 'mkdirp'
    Handlebars = require 'handlebars'
    moment = require 'moment'
    Set = require 'Set'


TODO: put this in config.json
    
    files = [
        "output/Analytics.json",
        "output/Identity.json",
        "output/Messaging.json",
        "output/Commerce.json",
        "output/Media.json",
        "output/Syndicate.json",
        "output/Forum.json"
    ]
    
These are excluded because of duplication

**Project** is a class in Identitiy, which other modules re-uses.

EventLogAggregate is empty in Documentation site...

    excludedClasses = [
        'Analytics/Project',
      'Analytics/Action',
      'Analytics/EventLogAggregate',
        'Messaging/Project',
        'Commerce/Project',
        'Media/Project',
        'Syndicate/Project',
        'Commerce/Application',
      'Forum/Project'
    ]
    
A few outliers that don't follow convention


All generated models are saved in this object
    
    allObjCModels = {'modelNames':[]}

    modelsSet = new Set()
    
Load handlebar.js templates
    
    #Template for normal phoenix header file
    headerTemplateString = fs.readFileSync('PhoenixURLs/templates/header.hbs', 'utf8')
    headerTemplate = Handlebars.compile headerTemplateString 
    
    #Template for normal phoenix class file
    classTemplateString = fs.readFileSync('PhoenixURLs/templates/class.hbs', 'utf8')
    classTemplate = Handlebars.compile classTemplateString 

    #Template for phoenix identity header file (TSPhoenixIdentity.h and .c)
    identityModuleHeaderTemplateString = fs.readFileSync('PhoenixURLs/templates/ts-phoenix-identity-header.hbs', 'utf8')
    identityModuleHeaderTemplate = Handlebars.compile identityModuleHeaderTemplateString

    #Template for phoenix identity class file
    identityModuleClassTemplateString = fs.readFileSync('PhoenixURLs/templates/ts-phoenix-identity-class.hbs', 'utf8')
    identityModuleClassTemplate = Handlebars.compile identityModuleClassTemplateString

    #Template for TSModuleAbastract.h and .c
    moduleAbastractHeaderTemplateString = fs.readFileSync('PhoenixURLs/templates/module-abastract-header.hbs', 'utf8')
    moduleAbastractHeaderTemplate = Handlebars.compile moduleAbastractHeaderTemplateString

    moduleAbastractClassTemplateString = fs.readFileSync('PhoenixURLs/templates/module-abastract-class.hbs', 'utf8')
    moduleAbastractClassTemplate = Handlebars.compile moduleAbastractClassTemplateString

Handlebar.js template helper: generate today's date, used in comments at the top of source code
      
    Handlebars.registerHelper 'date', func = () ->
        moment().format 'MMMM Do YYYY'

Handlebars.js template helper: generate any related class name for .h file

    Handlebars.registerHelper 'generate_class_file_in_h', func = () ->
        str = "";
        for className in modelsSet.toArray()
            if className.substr(0, 2) is "TS"
                str += className
                str += ", "

        if (str.length > 0)
            str = "@class " + str.substr(0, str.length-2) + ";"
        str

Handlebars.js template helper: generate any related class name for .c file
    
    Handlebars.registerHelper 'generate_class_file_in_m', func = () ->
        str = "";
        for className in modelsSet.toArray()
            if className.substr(0, 2) is "TS"
                str += "#import \"" + className + ".h\"\n"
        str

Handlebars.js template helper: generate API name
    
    Handlebars.registerHelper 'api_method_name', func = () ->
        firstToLowerCase this.Name

Handlebars.js template helper: generate API parameters

    Handlebars.registerHelper 'generate_api_parameters', func = () ->
        str = " "

        requireBodyData = this.RequiredBodyData
        if requireBodyData
            dataName = firstToLowerCase requireBodyData.Type
            str += ( dataName + ":(" )
            str += getProperDataTypeName requireBodyData.Type
            str += ( " *)" + dataName ) + " "

        requiredPropertiesArray = this.RequiredProperties.reverse()
        uriString = this.Uri
        for requiredProp in requiredPropertiesArray
            lastIndexOpen = uriString.lastIndexOf "\{"
            lastIndexClose = uriString.lastIndexOf "\}"

            replaceString = uriString.substr(lastIndexOpen+1, (lastIndexClose-lastIndexOpen)-1)
            uriString = uriString.replace "\{" + replaceString + "\}", "%@"
            dataName = firstToLowerCase replaceString
            str += ( dataName + ":(" )
            str += getProperDataTypeName requiredProp.Type
            str += ( " *)" + dataName + " ") 
        str

Handlebars.js template helper: generate sub-path of URL
    
    Handlebars.registerHelper 'generate_url_path', func = () ->
        str = this.Uri
        params = "";
        requiredPropertiesArray = this.RequiredProperties.reverse()
        for requiredProp in requiredPropertiesArray
            lastIndexOpen = str.lastIndexOf "\{"
            lastIndexClose = str.lastIndexOf "\}"

            replaceString = str.substr(lastIndexOpen+1, (lastIndexClose-lastIndexOpen)-1)
            str = str.replace "\{" + replaceString + "\}", "%@"
            params = replaceString + "," + params
        
        result = "[NSString stringWithFormat:@\"" + str + "\", " + params.substr(0, params.length-1) + "]"

Handlebars.js template helper: generate

    Handlebars.registerHelper 'generate_request_parameters', func = () ->
        str = ''

        if this.UriVerb is 'POST' or this.UriVerb is 'PUT'
            requiredBodyData = this.RequiredBodyData

            if requiredBodyData
                str = "NSDictionary *parameters = @{ "

                subTypes = requiredBodyData.SubType
                for subType, i in subTypes
                    str += ( "@\"" + subType.Name + "\"" )
                    str += " : "
                    str += (firstToLowerCase requiredBodyData.Type + "." + formatParameterName subType.Name )

                    if (i isnt subTypes.length-1)
                        str += ", "
                str += "};"
        str

Handlebars.js template helper: generate parameters string for calling webservice method

    Handlebars.registerHelper 'request_parameters_result', func = () ->
        str = 'nil'

        if this.UriVerb isnt 'GET' and this.UriVerb isnt 'DELETE'
            str = 'parameters'
        str

Handlebars.js template helper: generate object type for success block

    Handlebars.registerHelper 'generate_success_response_object_type', func = () ->
        str = 'id'

        if this.listAPI
            str = "NSArray"
        else if this.createAPI or this.getAPI or this.deleteAPI or this.updateAPI
            str = getProperDataTypeName this.ResponseModelType 
        else

        str 

Handlebars.js template helper: generate object parameters for success block

    Handlebars.registerHelper 'generate_success_response_objects_parameters', func = () ->
        str = ''

        if this.listAPI
            str = "TSPaginator *paginator, NSArray *object,"
        else if this.createAPI or this.deleteAPI or this.getAPI or this.updateAPI
            str = getProperDataTypeName this.ResponseModelType + " *object, "
        else
            

        str

Handlebars.js template helper: generate object in the success block

    Handlebars.registerHelper 'generate_success_response_object_type', func = () ->
        getProperDataTypeName this.ResponseModelType

Helper function: converting first character to lower case
    
    firstToLowerCase = (str) -> 
        string = str.substr(0, 1).toLowerCase() + str.substr(1)
        string  

Helper function: converting proper data type name

    getProperDataTypeName = (str) ->
        if str is 'Int32'
            string = "NSNumber"
        else if str is "String"
            string = "NSString"
        else 
            string = "TS" + str

        string

Helper function: get all customise objects

    getAllCustomiseObject = (RequiredBodyData) ->
        objectType = getProperDataTypeName RequiredBodyData.Type

Helper function: change "Id" to "ID"

    formatParameterName = (variableName) ->
        str = firstToLowerCase variableName
        if str.substr(str.length-2, 2) is "Id"
            str = str.substr(0, str.length-2) + "ID"
        str

        
## entry point to this script

    outputFolder = 'PhoenixURLs/output/' + 'ObjC/'
    mkdirp outputFolder

    # generate TSPhoenixModuleAbastract .h and .c files
    result = moduleAbastractHeaderTemplate allObjCModels
    file = 'PhoenixURLs/output/' + 'ObjC/' + 'TSPhoenixModuleAbastract' + '.h'
    console.log('\nwriting to ' + file) 
    fs.writeFileSync(file, result)

    result = moduleAbastractClassTemplate allObjCModels
    file = 'PhoenixURLs/output/' + 'ObjC/' + 'TSPhoenixModuleAbastract' + '.m'
    console.log('writing to ' + file)
    fs.writeFileSync(file, result)

    #generate Phoenix API classes
    for file in files
        filePath = 'PhoenixURLs/' + file

        content = JSON.parse(fs.readFileSync(filePath, 'utf8'))
        apiMethods = content.apiMethods

        for apiMethod in apiMethods
            #RequiredBodyData
            if apiMethod.RequiredBodyData
                str = getAllCustomiseObject apiMethod.RequiredBodyData
                modelsSet.add str
            #ResponseModelType
            if apiMethod.ResponseModelType
                str = getProperDataTypeName apiMethod.ResponseModelType
                modelsSet.add str

        #generate Obj-C header file (.h)
        result = headerTemplate content
        outputFolder = 'PhoenixURLs/output/' + 'ObjC/'
        
        file = outputFolder + 'TSPhoenix' + content.moduleName + '.h'
        console.log('writing to ' + file)
        fs.writeFileSync(file, result)

        #generate Obj-C class file (.c)
        result = classTemplate content
        outputFolder = 'PhoenixURLs/output/' + 'ObjC/'

        file = outputFolder + 'TSPhoenix' + content.moduleName + '.m'
        console.log('writing to ' + file)
        fs.writeFileSync(file, result)
        