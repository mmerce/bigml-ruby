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

source = BigMLSource.new.create_source('./data/iris.csv')
dataset = BigMLDataset.new.create_dataset(source)
model = BigMLModel.new.create_model(dataset)
prediction = BigMLPrediction.new.create_prediction(model, {'sepal width': 1})
api.pprint(prediction)
=end

require 'rubygems'
require 'json'
require 'rest-client'
require 'logger'

require '../config/constants'

LOGGER = Logger.new('../BigML.log') 

class BigML

    @@auth = nil

    def initialize(username=ENV['BIGML_USERNAME'],
        api_key=ENV['BIGML_API_KEY'])
        #Initialize httplib and set up username and api_key.
        if not @@auth
            @@auth = "?username=#{username};api_key=#{api_key};"
        end
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
        begin

            response = RestClient.post url + @@auth, body, args
            code = response.code

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
                LOGGER.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            LOGGER.error("Connection error")
        rescue RestClient::RequestTimeout
            LOGGER.error("Request timed out")
        rescue ArgumentError
            LOGGER.error("Ambiguous exception occurred")
        rescue StandardError
            LOGGER.error("Malformed response")
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
                "message" => "The resource couldn't be retrieved"}}

        begin
            response = RestClient.get url + @@auth, ACCEPT_JSON
            code = response.code

            if code == HTTP_OK
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                resource_id = resource['resource']
                error = nil
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                LOGGER.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            LOGGER.error("Connection error")
        rescue RestClient::RequestTimeout
            LOGGER.error("Request timed out")
        rescue ArgumentError
            LOGGER.error("Ambiguous exception occurred")
        rescue StandardError
            LOGGER.error("Malformed response")

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
            response = RestClient.get url + @@auth + query_string, ACCEPT_JSON

            code = response.code

            if code == HTTP_OK
                resource = JSON.parse(response.body) # TODO: force_encoding to utf-8
                meta = resource['meta']
                resources = resource['objects']
                error = None
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                LOGGER.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            LOGGER.error("Connection error")
        rescue RestClient::RequestTimeout
            LOGGER.error("Request timed out")
        rescue ArgumentError
            LOGGER.error("Ambiguous exception occurred")
        rescue StandardError
            LOGGER.error("Malformed response")
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
            response = RestClient.put url + @@auth, body, SEND_JSON   

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
                LOGGER.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end

        rescue RestClient::ServerBrokeConnection
            LOGGER.error("Connection error")
        rescue RestClient::RequestTimeout
            LOGGER.error("Request timed out")
        rescue ArgumentError
            LOGGER.error("Ambiguous exception occurred")
        rescue StandardError
            LOGGER.error("Malformed response")
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
            response = RestClient.delete url + @@auth

            code = response.code

            if code == HTTP_NO_CONTENT:
                error = nil
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body) # TODO: force_encoding to utf-8
            else
                LOGGER.error("Unexpected error (#{code})")
                code = HTTP_INTERNAL_SERVER_ERROR
            end


        rescue RestClient::ServerBrokeConnection
            LOGGER.error("Connection error")
        rescue RestClient::RequestTimeout
            LOGGER.error("Request timed out")
        rescue ArgumentError
            LOGGER.error("Ambiguous exception occurred")
        rescue StandardError
            LOGGER.error("Malformed response")
        end

        return {
            :code => code,
            :error => error}
    end

    def _check_object_id(type, object)
        if object.is_a?(Hash) and object.has_key?(:resource)
            object_id = object[:resource]
        elsif object.is_a?(String) and eval(type.to_s.upcase+"_RE").match(object)
            object_id = object
        else
            LOGGER.error("Wrong "+type.to_s+" id")
            return false
        end
        return object_id
    end

    def _is_ready?(type, object)
        # Check whether an object's status is FINISHED.
        if not object_id = _check_object_id(type, object)
            return false
        end

        object = _get("#{BIGML_URL}#{object_id}")
        puts object.inspect
        return (object[:code] == HTTP_OK and
            object[:object]["status"]["code"] == FINISHED)
    end

end

##########################################################################
#
# Sources
# https://bigml.com/developers/sources
#
##########################################################################

class BigMLSource < BigML

    def initialize(username=ENV['BIGML_USERNAME'],
        api_key=ENV['BIGML_API_KEY'])
        # Initialize httplib and set up username and api_key.
        super(username, api_key)
    end

    def create(file_name, args=nil)
        # Create a new source.
        if args != nil and args.include? :source_parser
            args[:source_parser] = args[:source_parser].to_json
        end

        return _create(SOURCE_URL, {:file => File.new(File.expand_path("../..", __FILE__)+"/"+file_name)}, args)
    end

    def get(source)
        # Retrieve a source.
        if not source_id = _check_object_id(:source, source)
            return
        end

        return _get("#{BIGML_URL}#{source_id}")
    end

    def list(query_string='')
        # List all your sources.
        return _list(SOURCE_URL, query_string)
    end

    def update(source, changes)
        # Update a source.
        if not source_id = _check_object_id(:source, source)
            return
        end

        body = changes.to_json
        return _update("#{BIGML_URL}#{source_id}", body)
    end

    def delete(source)
        # Delete a source.
        if not source_id = _check_object_id(:source, source)
            return
        end

        return _delete("#{BIGML_URL}#{source_id}")
    end

end 

##########################################################################
#
# Datasets
# https://bigml.com/developers/datasets
#
##########################################################################

class BigMLDataset < BigML

    def initialize(username=ENV['BIGML_USERNAME'],
        api_key=ENV['BIGML_API_KEY'])
        # Initialize httplib and set up username and api_key.
        super(username, api_key)
    end

    def create(source, args=nil, wait_time=3)
        # Create a dataset.
        if not source_id = _check_object_id(:source, source)
            return
        end

        if wait_time > 0
            until _is_ready?(:source, source_id)
                time.sleep(wait_time)
            end
        end
        if args.nil?
            args = {}
        end
        args.update({
            :source => source_id})
        body = args.to_json
        return _create(DATASET_URL, body)
    end

    def get(dataset)
        # Retrieve a dataset.
        if not dataset_id = _check_object_id(:dataset, dataset)
            return
        end

        return _get("%s%s" % [BIGML_URL, dataset_id])
    end

    def list(query_string='')
        # List all your datasets.
        return _list(DATASET_URL, query_string)
    end

    def update(dataset, changes)
        # Update a dataset.
        if not dataset_id = _check_object_id(:dataset, dataset)
            return
        end

        body = changes.to_json
        return _update("%s%s" % [BIGML_URL, dataset_id], body)
    end

    def delete(dataset)
        # Delete a dataset.
        if not dataset_id = _check_object_id(:dataset, dataset)
            return
        end

        return _delete("%s%s" % [BIGML_URL, dataset_id])
    end
end


result = BigMLDataset.new.delete('dataset/4fb03f3f1552682d12000019')



