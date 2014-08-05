#! /usr/bin/make -f

include makefile_definitions.mk

all:
	make generate-phoenix-SDK-UAT
	#make generate-phoenix-SDK-LIVE

generate-phoenix-SDK-UAT:
	make generate-phoenix-models-UAT
	make generate-phoenix-api-urls-UAT

	make package-up-xcode-UAT

	#make clean

generate-phoenix-SDK-LIVE:
	make generate-phoenix-models-LIVE
	make generate-phoenix-api-urls-LIVE

	make package-up-xcode-LIVE

	#make clean

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

	mkdir -p ./output/GeneratedCode/UAT
	cp -r ./PhoenixModels/output/ObjC/. ./output/GeneratedCode/UAT/.

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

	mkdir -p ./output/PhoenixModels-LIVE
	cp -r ./PhoenixModels/output/ObjC ./output/PhoenixModels-LIVE/.

endif

# Sub-rtask - generate phoenix api urls
generate-phoenix-api-urls-UAT:
ifeq ($(wildcard $(PHOENIX_APIS_ENV_UAT_JSON_FILE)), )
#This will stop the make trying to resolve HEADER_FILES for echo :)
	echo "ERROR: $(PHOENIX_APIS_ENV_UAT_JSON_FILE)"
else
	cp $(PHOENIX_APIS_ENV_UAT_JSON_FILE) ./PhoenixURLs/env-target.json

	mkdir -p ./PhoenixModels/output
	coffee ./PhoenixURLs/aggregate-methods.litcoffee

	mkdir -p ./PhoenixURLs/output/ObjC
	coffee ./PhoenixURLs/generate-objc.litcoffee

	mkdir -p ./output/GeneratedCode/UAT
	cp -r ./PhoenixURLs/output/ObjC/. ./output/GeneratedCode/UAT/.

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

	mkdir -p ./output/PhoenixURLs-LIVE
	cp -r ./PhonixURLs/output/ObjC ./output/PhoenixURLs-LIVE/.

endif

package-up-xcode-UAT:
	cp -r ./output/GeneratedCode/UAT/ObjC/. ./output/Workspace/TSPhoenixSDK/Pod/Classes
	cp -r ./output/GeneratedCode/UAT/ObjC/. ./output/Workspace/TSPhoenixSDK/Pod/Classes
	cd output/Workspace/TSPhoenixSDK
	pod install

package-up-xcode-LIVE:

clean:
	make clean-models
	make clean-urls

clean-models:
	# remove target JSON
	rm -f ./PhoenixModels/env-target.json
	rm -r ./PhoenixModels/output

clean-urls:
	rm -f ./PhoenixURLs/env-target.json
	rm -r ./PhoenixURLs/output