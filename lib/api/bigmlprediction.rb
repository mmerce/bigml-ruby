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

##########################################################################
#
# Predictions
# https://bigml.com/developers/predictions
#
##########################################################################

require 'bigml'

class BigMLPrediction

    @@bigml = BigML.instance
    @resource_id = nil

    def initialize(params)
        #Initialize model instance.
        if prediction = params[:prediction] and not prediction.nil? and prediction_id = @@bigml._check_resource_id(prediction, :prediction)
            @resource_id = prediction_id
        end
        if model = params[:model] and not model.nil?
            input_data = params[:input_data]
            args = params[:args]
            wait_time = params[:wait_time]
            prediction = BigMLPrediction.create(model, input_data, args, wait_time)
            @resource_id = prediction[:resource]
        end
        if @resource_id.nil?
            raise("Either a dataset or a model_id is required.")
        end
    end

    def get_id
        return @resource_id
    end

    def get
        return BigMLPrediction.get(@resource_id) if not @resource_id.nil?
    end

    def update(changes)
        return BigMLPrediction.update(@resource_id, changes) if not @resource_id.nil?
    end

    def delete
        return BigMLPrediction.delete(@resource_id) if not @resource_id.nil?
    end

    def status
        return BigMLPrediction.status(@resource_id) if not @resource_id.nil?
    end
    class << self

        def create(model, input_data=nil, args=nil,
                wait_time=3)
            # Create a new prediction.
            if not model_id = @@bigml._check_resource_id(model, :model)
                return
            end

            wait_time = 3 if wait_time.nil?
            if wait_time > 0
                until @@bigml._is_ready?(model_id, :model)
                    sleep(wait_time)
                end
            end

            if input_data.nil?
                input_data = {}
            else
                new_input_data = {}
                fields = @@bigml._get_fields(model_id)
                inverted_fields = {}
                fields.each { |key, value|
                    inverted_fields[value[:name]] = key
                }      
                input_data.each { |key, value|
                    new_input_data[inverted_fields[key]] = value
                }
            end 

            if args.nil?
                args = {}
            end
            args.update({
                :model => model_id,
                :input_data => new_input_data})

            body = args.to_json
            return @@bigml._create(BigML::PREDICTION_URL, body)
        end

        def get(prediction)
            # Retrieve a prediction.
            if not prediction_id = @@bigml._check_resource_id(prediction, :prediction)
                return
            end

            return @@bigml._get("%s%s" % [BigML::BIGML_URL, prediction_id])
        end

        def list(query_string='')
            # List all your predictions.
            return @@bigml._list(BigML::PREDICTION_URL, query_string)
        end

        def update(prediction, changes)
            # Update a prediction.
            if not prediction_id = @@bigml._check_resource_id(prediction, :prediction)
                return
            end

            body = changes.to_json
            return @@bigml._update("%s%s" % [BigML::BIGML_URL, prediction_id], body)
        end

        def delete(prediction)
            # Delete a prediction.
            if not prediction_id = @@bigml._check_resource_id(prediction, :prediction)
                return
            end

            return @@bigml._delete("%s%s" %
                [BigML::BIGML_URL, prediction_id])
        end

        def status(prediction)
            # Get prediction's status
            return @@bigml._status(prediction)
        end
    end
end

