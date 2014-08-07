#! /usr/bin/make -f

include makefile_definitions.mk

all:
	make install-npm-package

	make generate-phoenix-SDK-UAT
	#make generate-phoenix-SDK-LIVE

install-npm-package:
	sudo npm install

generate-phoenix-SDK-UAT:
	make generate-phoenix-models-UAT
	make generate-phoenix-api-urls-UAT

	make package-up-xcode

	make clean

generate-phoenix-SDK-LIVE:
	make generate-phoenix-models-LIVE
	make generate-phoenix-api-urls-LIVE

	make package-up-xcode

	make clean

# Sub-task - generate phoenix models
generate-phoenix-models-UAT:
ifeq ($(wildcard $(PHOENIX_MODELS_ENV_UAT_JSON_FILE)), )
# This will stop the make trying to resolve HEADER_FILES for echo :)
	echo "ERROR: $(PHOENIX_MODELS_ENV_UAT_JSON_FILE)" 
else 
	# File exists, continue or do something else...
	cp $(PHOENIX_MODELS_ENV_UAT_JSON_FILE) ./PhoenixModels/env-target.json

	mkdir -p ./PhoenixModels/output
	coffee ./PhoenixModels/aggregate-models.litcoffee

	mkdir -p ./PhoenixModels/output/ObjC
	coffee ./PhoenixModels/add-mapping.litcoffee

	coffee ./PhoenixModels/generate-objc.litcoffee
endif

generate-phoenix-models-LIVE:
ifeq ($(wildcard $(PHOENIX_MODELS_ENV_LIVE_JSON_FILE)), )
# This will stop the make trying to resolve HEADER_FILES for echo :)
	echo "ERROR: $(PHOENIX_MODELS_ENV_LIVE_JSON_FILE)" 
else 
	# File exists, continue or do something else...
	cp $(PHOENIX_MODELS_ENV_LIVE_JSON_FILE) ./PhoenixModels/env-target.json

	mkdir -p ./PhoenixModels/output
	coffee ./PhoenixModels/aggregate-models.litcoffee

	mkdir -p ./PhoenixModels/output/ObjC
	coffee ./PhoenixModels/add-mapping.litcoffee

	coffee ./PhoenixModels/generate-objc.litcoffee
endif

# Sub-rtask - generate phoenix api urls
generate-phoenix-api-urls-UAT:
ifeq ($(wildcard $(PHOENIX_APIS_ENV_UAT_JSON_FILE)), )
#This will stop the make trying to resolve HEADER_FILES for echo :)
	echo "ERROR: $(PHOENIX_APIS_ENV_UAT_JSON_FILE)"
else
	cp $(PHOENIX_APIS_ENV_UAT_JSON_FILE) ./PhoenixURLs/env-target.json

	mkdir -p ./PhoenixURLs/output
	coffee ./PhoenixURLs/aggregate-methods.litcoffee

	mkdir -p ./PhoenixURLs/output/ObjC
	coffee ./PhoenixURLs/generate-objc.litcoffee
endif

generate-phoenix-api-urls-LIVE:
ifeq ($(wildcard $(PHOENIX_APIS_ENV_LIVE_JSON_FILE)), )
#This will stop the make trying to resolve HEADER_FILES for echo :)
	echo "ERROR: $(PHOENIX_APIS_ENV_LIVE_JSON_FILE)"
else
	cp $(PHOENIX_APIS_ENV_LIVE_JSON_FILE) ./PhoenixURLs/env-target.json

	mkdir -p ./PhoenixModels/output
	coffee ./PhoenixURLs/aggregate-methods.litcoffee

	mkdir -p ./PhoenixURLs/output/ObjC
	coffee ./PhoenixURLs/generate-objc.litcoffee

endif

package-up-xcode:
	#copy the static code from the directory
	cp -r ../StaticCodes/. ../Pod/Classes

	#copy the generated code
	cp -r ./PhoenixModels/output/ObjC/*/. ../Pod/Classes
	cp -r ./PhoenixModels/output/ObjC/TSPhoenixModels.h ../Pod/Classes
	
	cp -r ./PhoenixURLs/output/ObjC/. ../Pod/Classes

	cd ../Example && pod install

clean:
	make clean-models
	make clean-urls

	#make clean-pod-classes

clean-models:
	# remove target JSON
	rm -f ./PhoenixModels/env-target.json
	rm -r ./PhoenixModels/output

clean-urls:
	rm -f ./PhoenixURLs/env-target.json
	rm -r ./PhoenixURLs/output

clean-pod-classes:
	rm -f ../Pod/Classes/.