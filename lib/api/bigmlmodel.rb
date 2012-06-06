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
# Models
# https://bigml.com/developers/models
#
##########################################################################

require 'bigml'

class BigMLModel

    @@bigml = BigML.instance
    @resource_id = nil

    def initialize(params)
        #Initialize model instance.
        if model = params[:model] and not model.nil? and model_id = @@bigml._check_resource_id(model, :model)
            @resource_id = model_id
        end
        if dataset = params[:dataset] and not dataset.nil?
            args = params[:args]
            wait_time = params[:wait_time]
            model = BigMLModel.create(dataset, args, wait_time)
            @resource_id = model[:resource]
        end
        if @resource_id.nil?
            raise("Either a dataset or a model_id is required.")
        end
    end

    def get_id
        return @resource_id
    end

    def get
        return BigMLModel.get(@resource_id) if not @resource_id.nil?
    end

    def update(changes)
        return BigMLModel.update(@resource_id, changes) if not @resource_id.nil?
    end

    def delete
        return BigMLModel.delete(@resource_id) if not @resource_id.nil?
    end

    def status
        return BigMLModel.status(@resource_id) if not @resource_id.nil?
    end

    class << self

        def create(dataset, args=nil, wait_time=3)
            # Create a model.
            if not dataset_id = @@bigml._check_resource_id(dataset, :dataset)
                return
            end

            wait_time = 3 if wait_time.nil?
            if wait_time > 0
                until @@bigml._is_ready?(dataset_id, :dataset)
                    sleep(wait_time)
                end
            end

            if args.nil?:
                args = {}
            end
            args.update({
                :dataset => dataset_id})
            body = args.to_json
            return @@bigml._create(BigML::MODEL_URL, body)
        end

        def get(model)
            # Retrieve a model.
            if not model_id = @@bigml._check_resource_id(model, :model)
                return
            end

            return @@bigml._get("%s%s" % [BigML::BIGML_URL, model_id])
        end

        def list(query_string='')
            # List all your models.
            return @@bigml._list(BigML::MODEL_URL, query_string)
        end

        def update(model, changes)
            # Update a model.
            if not model_id = @@bigml._check_resource_id(model, :model)
                return
            end

            body = changes.to_json
            return @@bigml._update("%s%s" % [BigML::BIGML_URL, model_id], body)
        end

        def delete(model)
            # Delete a model.
            if not model_id = @@bigml._check_resource_id(model, :model)
                return
            end

            return @@bigml._delete("%s%s" % [BigML::BIGML_URL, model_id])
        end

        def status(model)
            # Get model's status
            return @@bigml._status(model)
        end
    end
end

