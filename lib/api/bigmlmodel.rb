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
