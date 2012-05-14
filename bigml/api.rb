# encoding: utf-8
#!/usr/bin/env ruby
#
# Copyright 2012 BigML
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

=begin
BigML.io Python bindings.

This is a simple binding to BigML.io, the BigML API.

Example usage (assuming that you have previously set up the BIGML_USERNAME and
BIGML_API_KEY environment variables):

require 'bigml/api'

source = BigMLSource.create('./data/iris.csv')
dataset = BigMLDataset.create(source)
model = BigMLModel.create(dataset)
prediction = BigMLPrediction.create(model, {'sepal width': 1})

=end

require 'rubygems'
require 'json'
require 'rest-client'
require 'logger'
require 'singleton'

require '../config/constants'



class BigML

    include Singleton

    def initialize(username=ENV['BIGML_USERNAME'],
        api_key=ENV['BIGML_API_KEY'],
        log_file='../BigML.log')
        #Initialize httplib and set up username and api_key.
        @auth = "?username=#{username};api_key=#{api_key};"
        @logger = Logger.new(log_file) 
    end

    def _create(url, body, args=SEND_JSON)
        #Create a new resource. 
        code = HTTP_INTERNAL_SERVER_ERROR
        resource_id = nil
        location = nil
        resource = nil
        error = {
            :status => {
                :code => code,
                :message => "The resource couldn't be created"}}
        if args.nil?
            args = SEND_JSON
        end

        begin
            puts args
            puts body
            puts url + @auth
            response = RestClient.post url + @auth, body, args
            code = response.code
            puts response.body
            if code == HTTP_CREATED
                location = response.headers[:location]
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                resource_id = resource['resource']
                error = nil
            elsif [
                HTTP_BAD_REQUEST,
                HTTP_UNAUTHORIZED,
                HTTP_PAYMENT_REQUIRED,
                HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                @logger.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            @logger.error("Connection error")
        rescue RestClient::RequestTimeout
            @logger.error("Request timed out")
        rescue ArgumentError
            @logger.error("Ambiguous exception occurred")
        rescue StandardError
            @logger.error("Malformed response")
        end

        return {
            :code => code,
            :resource => resource_id,
            :location => location,
            :object => resource,
            :error => error} 
    end


    def _get(url)
        #Retrieve a resource
        
        code = HTTP_INTERNAL_SERVER_ERROR
        resource_id = nil
        location = url
        resource = nil
        error = {
            :status => {
                :code => HTTP_INTERNAL_SERVER_ERROR,
                :message => "The resource couldn't be retrieved"}}

        begin
            response = RestClient.get url + @auth, ACCEPT_JSON
            code = response.code

            if code == HTTP_OK
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                resource_id = resource['resource']
                error = nil
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                @logger.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            @logger.error("Connection error")
        rescue RestClient::RequestTimeout
            @logger.error("Request timed out")
        rescue ArgumentError
            @logger.error("Ambiguous exception occurred")
        rescue StandardError
            @logger.error("Malformed response")

        end

        return {
            :code => code,
            :resource => resource_id,
            :location => location,
            :object => resource,
            :error => error}
    end


    def _list(url, query_string='')
        #List resources
        
        code = HTTP_INTERNAL_SERVER_ERROR
        meta = nil
        resources = nil
        error = {
            :status => {
                :code => code,
                :message => "The resource couldn't be listed"}}
        begin
            response = RestClient.get url + @auth + query_string, ACCEPT_JSON

            code = response.code

            if code == HTTP_OK
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                meta = resource['meta']
                resources = resource['objects']
                error = None
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                @logger.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            @logger.error("Connection error")
        rescue RestClient::RequestTimeout
            @logger.error("Request timed out")
        rescue ArgumentError
            @logger.error("Ambiguous exception occurred")
        rescue StandardError
            @logger.error("Malformed response")
        end

        return {
            :code => code,
            :meta => meta,
            :objects => resources,
            :error => error}

    end

    def _update(url, body)
        #Update a resource
        
        code = HTTP_INTERNAL_SERVER_ERROR
        resource_id = None
        location = url
        resource = None
        error = {
            :status => {
                :code => code,
                :message => "The resource couldn't be updated"}}

        begin
            response = RestClient.put url + @auth, body, SEND_JSON   

            code = response.code

            if code == HTTP_ACCEPTED:
                location = response.headers[:location]
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                resource_id = resource['resource']
                error = nil
            elsif [
                HTTP_UNAUTHORIZED,
                HTTP_PAYMENT_REQUIRED,
                HTTP_METHOD_NOT_ALLOWED].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                @logger.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            @logger.error("Connection error")
        rescue RestClient::RequestTimeout
            @logger.error("Request timed out")
        rescue ArgumentError
            @logger.error("Ambiguous exception occurred")
        rescue StandardError
            @logger.error("Malformed response")
        end

        return {
            :code => code,
            :resource => resource_id,
            :location => location,
            :object => resource,
            :error => error}
    end

    def _delete(url)
        #Delete a resource
        
        code = HTTP_INTERNAL_SERVER_ERROR
        error = {
            :status => {
                :code => code,
                :message => "The resource couldn't be deleted"}}

        begin
            response = RestClient.delete url + @auth

            code = response.code

            if code == HTTP_NO_CONTENT:
                error = nil
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                @logger.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end


        rescue RestClient::ServerBrokeConnection
            @logger.error("Connection error")
        rescue RestClient::RequestTimeout
            @logger.error("Request timed out")
        rescue ArgumentError
            @logger.error("Ambiguous exception occurred")
        rescue StandardError
            @logger.error("Malformed response")
        end

        return {
            :code => code,
            :error => error}
    end

    ##########################################################################
    #
    # Utils
    #
    ##########################################################################

    def _check_object_id(object, type=nil)
        if object.is_a?(Hash) and object.has_key?(:resource)
            object_id = object[:resource]
        elsif object.is_a?(String)
            object_id = object
        else
            @logger.error("Wrong id format")
            return false
        end
        if type.nil?
            types = ['source', 'dataset', 'model', 'prediction']
            types.each { |vtype| 
                if eval(vtype.upcase+"_RE").match(object)
                    type = vtype
                end
                }
            if type.nil?
                @logger.error("Wrong id format")
                return false
            end
        elsif not eval(type.to_s.upcase+"_RE").match(object_id)
            @logger.error("Wrong "+type.to_s+" id")
            return false
        end

        return object_id
    end

    def _is_ready?(object, type)
        # Check whether an object's status is FINISHED.
        if not object_id = _check_object_id(object, type)
            return false
        end

        object = _get("#{BIGML_URL}#{object_id}")

        return (object[:code] == HTTP_OK and
            object[:object]["status"]["code"] == FINISHED)
    end

    def _get_fields(resource)
        # Return a dictionary of fields
        if not resource_id = _check_object_id(resource)
            return false
        end

        resource = _get("%s%s" % [BIGML_URL, resource_id])
        if resource[:code] == HTTP_OK
            if  MODEL_RE.match(resource_id)
                return resource[:object]['model']['fields']
            else
                return resource[:object]['fields']
            end
        end
        return nil
    end

end

##########################################################################
#
# Sources
# https://bigml.com/developers/sources
#
##########################################################################

class BigMLSource 

    @@bigml = BigML.instance

    class << self

        def create(file_name, args=nil)
            # Create a new source.
            if args != nil and args.include? :source_parser
                args[:source_parser] = args[:source_parser].to_json
            end

            return @@bigml._create(SOURCE_URL, {:file => File.new(File.expand_path("../..", __FILE__)+"/"+file_name)}, args)
        end

        def get(source)
            # Retrieve a source.
            if not source_id = @@bigml._check_object_id(source, :source)
                return
            end

            return @@bigml._get("#{BIGML_URL}#{source_id}")
        end

        def list(query_string='')
            # List all your sources.
            return @@bigml._list(SOURCE_URL, query_string)
        end

        def update(source, changes)
            # Update a source.
            if not source_id = @@bigml._check_object_id(source, :source)
                return
            end

            body = changes.to_json
            return @@bigml._update("#{BIGML_URL}#{source_id}", body)
        end

        def delete(source)
            # Delete a source.
            if not source_id = @@bigml._check_object_id(source, :source)
                return
            end

            return _delete("#{BIGML_URL}#{source_id}")
        end
    end
end 

##########################################################################
#
# Datasets
# https://bigml.com/developers/datasets
#
##########################################################################

class BigMLDataset

    @@bigml = BigML.instance

    class << self

        def create(source, args=nil, wait_time=3)
            # Create a dataset.
            if not source_id = @@bigml._check_object_id(source, :source)
                return
            end

            if wait_time > 0
                until @@bigml._is_ready?(source_id, :source)
                    time.sleep(wait_time)
                end
            end
            if args.nil?
                args = {}
            end
            args.update({
                :source => source_id})
            body = args.to_json
            return @@bigml._create(DATASET_URL, body)
        end

        def get(dataset)
            # Retrieve a dataset.
            if not dataset_id = @@bigml._check_object_id(dataset, :dataset)
                return
            end

            return @@bigml._get("%s%s" % [BIGML_URL, dataset_id])
        end

        def list(query_string='')
            # List all your datasets.
            return @@bigml._list(DATASET_URL, query_string)
        end

        def update(dataset, changes)
            # Update a dataset.
            if not dataset_id = @@bigml._check_object_id(dataset, :dataset)
                return
            end

            body = changes.to_json
            return _update("%s%s" % [BIGML_URL, dataset_id], body)
        end

        def delete(dataset)
            # Delete a dataset.
            if not dataset_id = @@bigml._check_object_id(dataset, :dataset)
                return
            end

            return @@bigml._delete("%s%s" % [BIGML_URL, dataset_id])
        end
    end
end

##########################################################################
#
# Models
# https://bigml.com/developers/models
#
##########################################################################

class BigMLModel

    @@bigml = BigML.instance

    class << self

        def create(dataset, args=nil, wait_time=3)
            # Create a model.
            if not dataset_id = @@bigml._check_object_id(dataset, :dataset)
                return
            end

            if wait_time > 0
                until @@bigml._is_ready?(dataset_id, :dataset)
                    time.sleep(wait_time)
                end
            end

            if args.nil?:
                args = {}
            end
            args.update({
                :dataset => dataset_id})
            body = args.to_json
            return @@bigml._create(MODEL_URL, body)
        end

        def get(model)
            # Retrieve a model.
            if not model_id = @@bigml._check_object_id(model, :model)
                return
            end

            return @@bigml._get("%s%s" % [BIGML_URL, model_id])
        end

        def list(query_string='')
            # List all your models.
            return @@bigml._list(MODEL_URL, query_string)
        end

        def update(model, changes)
            # Update a model.
            if not model_id = @@bigml._check_object_id(model, :model)
                return
            end

            body = changes.to_json
            return @@bigml._update("%s%s" % [BIGML_URL, model_id], body)
        end

        def delete(model)
            # Delete a model.
            if not model_id = @@bigml._check_object_id(model, :model)
                return
            end

            return @@bigml._delete("%s%s" % [BIGML_URL, model_id])
        end
    end
end

##########################################################################
#
# Predictions
# https://bigml.com/developers/predictions
#
##########################################################################
class BigMLPrediction

    @@bigml = BigML.instance

    class << self

        def create(model, input_data=nil, args=nil,
                wait_time=3)
            # Create a new prediction.
            if not model_id = @@bigml._check_object_id(model, :model)
                return
            end

            if wait_time > 0
                until @@bigml._is_ready?(model_id, :model)
                    time.sleep(wait_time)
                end
            end

            if input_data.nil?
                input_data = {}
            else
                new_input_data = {}
                fields = @@bigml._get_fields(model_id)
                inverted_fields = {}
                fields.each { |key, value|
                    inverted_fields[value[name]] = key
                }       
                input_data.each { |key, value|
                    new_input_data[inverted_fields[key]] = value
                }
                input_data = new_input_data
                # TODO: no KeyError in ruby? 
            end

            if args.nil?
                args = {}
            end
            args.update({
                :model => model_id,
                :input_data => input_data})
            body = args.to_json
            return @@bigml._create(PREDICTION_URL, body)
        end

        def get(prediction)
            # Retrieve a prediction.
            if not prediction_id = @@bigml._check_object_id(prediction, :prediction)
                return
            end

            return @@bigml._get("%s%s" % [BIGML_URL, prediction_id])
        end

        def list(query_string='')
            # List all your predictions.
            return @@bigml._list(PREDICTION_URL, query_string)
        end

        def update(prediction, changes)
            # Update a prediction.
            if not prediction_id = @@bigml._check_object_id(prediction, :prediction)
                return
            end

            body = changes.to_json
            return @@bigml._update("%s%s" % [BIGML_URL, prediction_id], body)
        end

        def delete(prediction)
            # Delete a prediction.
            if not prediction_id = @@bigml._check_object_id(prediction, :prediction)
                return
            end

            return @@bigml._delete("%s%s" %
                [BIGML_URL, prediction_id])
        end
    end
end



source = BigMLSource.create('./data/iris.csv')
if source.has_key?(:resource)
    dataset = BigMLDataset.create(source)
    if dataset.has_key?(:resource)
        model = BigMLModel.create(dataset)
        if model.has_key?(:resource)
            prediction = BigMLPrediction.create(model, {'sepal width' => 1})
        end
    end
end

