add mapping information to the properties in JSON object tree
    
    fs = require 'fs'
    hashes = require 'hashes'
    _ = require('underscore')._
    mkdirp = require 'mkdirp'
    Handlebars = require 'handlebars'
    moment = require 'moment'
    async = require 'async'


TODO: put this in config.json
    
    files = [
    	# "output/Analytics.json",
    	# "output/Identity.json",
    	# "output/Messaging.json",
    	# "output/Commerce.json",
    	# "output/Media.json",
    	# "output/Syndicate.json",
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
    
    identifierOverride = {
    	'ProjectAccountMap': 'accountID',
    	'ArticleInteraction': 'createDate',
    	'ProjectModuleMap': 'moduleID'
    }
    
    collectionNameOverride = {
    	
    }

All generated models are saved in this object
    
    allObjCModels = {'modelNames':[]}
    
Load handlebar.js templates
    
    headerTemplateString = fs.readFileSync('PhoenixURLs/templates/header.hbs', 'utf8')
    headerTemplate = Handlebars.compile headerTemplateString 
    
    classTemplateString = fs.readFileSync('PhoenixURLs/templates/class.hbs', 'utf8')
    classTemplate = Handlebars.compile classTemplateString 

    moduleAbastractHeaderTemplateString = fs.readFileSync('PhoenixURLs/templates/module-abastract-header.hbs', 'utf8')
    moduleAbastractHeaderTemplate = Handlebars.compile moduleAbastractHeaderTemplateString

    moduleAbastractClassTemplateString = fs.readFileSync('PhoenixURLs/templates/module-abastract-class.hbs', 'utf8')
    moduleAbastractClassTemplate = Handlebars.compile moduleAbastractClassTemplateString

Handlebar.js template helper: generate today's date, used in comments at the top of source code
      
    Handlebars.registerHelper 'date', func = () ->
        moment().format 'MMMM Do YYYY'

Handlebar.js template helper: generate API methods

    Handlebars.registerHelper 'generate_api_method', func = () ->
        # get input parameters
        #requiredPropertiesArray = this.RequiredProperties
        #for (requiredProp in requiredPropertiesArray)
        #    if (requiredProp.Name == 'Data')
        #    else 


        # /* description */
        str = '/* ' + this.Description + ' */\n'

        # -(void)methodName
        str += '- (void)' + firstToLowerCase this.Name + ':' + 

        str += ' completion: (void (^)(' + 


        str += ' NSError *error))completion' 
        str += '\n{\n'
        str += '}\n\n'

        str

Handlebars.js template helper: generate API name
    
    Handlebars.registerHelper 'api_method_name', func = () ->
        firstToLowerCase this.Name

Handlebars.js template helper: generate API parameters

    Handlebars.registerHelper 'generate_api_parameters', func = () ->
        str = ""

        requiredPropertiesArray = this.RequiredProperties
        for requiredProp, i in requiredPropertiesArray
            str += " "

            dataName = ""
            if requiredProp.Name is "Data"
                dataName = firstToLowerCase requiredProp.Type
            else 
                dataName = firstToLowerCase requiredProp.Name
            
            str += ( dataName + ":(" )
            str += getProperDataTypeName requiredProp.Type
            str += ( " *)" + dataName )
        str

Handlebars.js template helper: generate API callback parameters

    Handlebars.registerHelper 'generate_api_output_callback', func = () ->
        str = ''

        str

Handlebars.js template helper: generate sub-path of URL
    
    Handlebars.registerHelper 'generate_url_path', func = () ->
        str = this.Uri
        params = "";

        requiredPropertiesArray = this.RequiredProperties
        for requiredProp in requiredPropertiesArray

            if requiredProp.Name isnt "Data"
                replaceString = firstToLowerCase requiredProp.Name
                str = str.replace "\{" + replaceString + "\}", "%@"
                params += replaceString + ", "
        
        result = "[NSString stringWithFormats:@\"" + str + "\", " + params.substr(0, params.length-3) + "]"

Handlebars.js template helper: generate

    Handlebars.registerHelper 'generate_request_parameters', func = () ->
        str = ''

        if this.UriVerb is 'POST' or this.UriVerb is 'PUT'
            requiredPropertiesArray = this.RequiredProperties

            isFound = false
            for requiredProp in requiredPropertiesArray
                if isFound is false
                    if requiredProp.Name is "Data"
                        isFound = true
                        str = "NSDictionary *parameters = @{ "

                        subTypes = requiredProp.SubType
                        for subType, i in subTypes
                            str += ( "\"" + subType.Name + "\"" )
                            str += " : "
                            str += (firstToLowerCase requiredProp.Type + "." + firstToLowerCase subType.Name)

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


Helper function: converting first character to lower case
    
    firstToLowerCase = (str) -> 
        string = str.substr(0, 1).toLowerCase() + str.substr(1)
        string  

Helper function: converting proper data type name

    getProperDataTypeName = (str) ->
        if str is 'Int32'
            string = 'NSNumber'
        else if str is 'String'
            string = 'NSString'
        else 
            string = 'TS' + str

        string
        
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
    console.log('\nwriting to ' + file)
    fs.writeFileSync(file, result)

    #generate Phoenix API classes
    for file in files
        filePath = 'PhoenixURLs/' + file

        content = JSON.parse(fs.readFileSync(filePath, 'utf8'))
        apiMethods = content.apiMethods

        #generate Obj-C header file
        result = headerTemplate content
        outputFolder = 'PhoenixURLs/output/' + 'ObjC/'
        
        file = outputFolder + 'TSPhoenix' + content.moduleName + '.h'
        console.log('writing to ' + file)
        fs.writeFileSync(file, result)


        console.log('start generate')

        #generate Obj-C class file
        result = classTemplate content
        outputFolder = 'PhoenixURLs/output/' + 'ObjC/'

        file = outputFolder + 'TSPhoenix' + content.moduleName + '.c'
        console.log('writing to ' + file)
        fs.writeFileSync(file, result)

        console.log('done')
