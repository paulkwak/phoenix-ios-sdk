#! /usr/bin/make -f

include makefile_definitions.mk

all:
	make generate-phoenix-SDK-UAT
	#make generate-phoenix-SDK-LIVE

generate-phoenix-SDK-UAT:
	#make generate-phoenix-models-UAT
	make generate-phoenix-api-urls-UAT

generate-phoenix-SDK-LIVE:
	make generate-phoenix-models-LIVE
	make generate-phoenix-api-urls-LIVE

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

	mkdir -p ./output/PhoenixModels-UAT
	cp -r ./PhoenixModels/output/ObjC ./output/PhoenixModels-UAT/.

	make clean-models

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

	make clean-models
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

	mkdir -p ./output/PhoenixURLs-UAT
	cp -r ./PhoenixURLs/output/ObjC ./output/PhoenixURLs-UAT/.

	#make clean-urls
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

	#make clean-urls
endif

clean-models:
	# remove target JSON
	rm -f ./PhoenixModels/env-target.json
	rm -r ./PhoenixModels/output

clean-urls:
	rm -f ./PhoenixURLs/env-target.json
	rm -r ./PhoenixURLs/output