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

require 'bigml'

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
            response = RestClient.post url + @auth, body, args
            code = response.code
            if code == HTTP_CREATED
                location = response.headers[:location]
                resource = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
                resource_id = resource[:resource]
                error = nil
            elsif [
                HTTP_BAD_REQUEST,
                HTTP_UNAUTHORIZED,
                HTTP_PAYMENT_REQUIRED,
                HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
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
                resource = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
                resource_id = resource[:resource]
                error = nil
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
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
                resource = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
                meta = resource[:meta]
                resources = resource[:objects]
                error = None
            elsif [HTTP_BAD_REQUEST, HTTP_UNAUTHORIZED, HTTP_NOT_FOUND].include? code
                error = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
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
        resource_id = nil
        location = url
        resource = nil
        error = {
            :status => {
                :code => code,
                :message => "The resource couldn't be updated"}}

        begin
            response = RestClient.put url + @auth, body, SEND_JSON   

            code = response.code

            if code == HTTP_ACCEPTED:
                location = response.headers[:location]
                resource = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
                resource_id = resource[:resource]
                error = nil
            elsif [
                HTTP_UNAUTHORIZED,
                HTTP_PAYMENT_REQUIRED,
                HTTP_METHOD_NOT_ALLOWED].include? code
                error = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
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
                error = JSON.parse(response.body, :symbolize_names => true) # TODO: force_encoding to utf-8
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
            object[:object][:status][:code] == FINISHED)
    end

    def _get_fields(resource)
        # Return a dictionary of fields
        if not resource_id = _check_object_id(resource)
            return false
        end

        resource = _get("%s%s" % [BIGML_URL, resource_id])
        if resource[:code] == HTTP_OK
            if  MODEL_RE.match(resource_id)
                return resource[:object][:model][:fields]
            else
                return resource[:object][:fields]
            end
        end
        return nil
    end

end

