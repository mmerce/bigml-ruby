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
# Datasets
# https://bigml.com/developers/datasets
#
##########################################################################

require 'bigml'

class BigMLDataset

    @@bigml = BigML.instance

    class << self

        def create(source, args=nil, wait_time=3)
            # Create a dataset.
            if not source_id = @@bigml._check_resource_id(source, :source)
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
            return @@bigml._create(BigML::DATASET_URL, body)
        end

        def get(dataset)
            # Retrieve a dataset.
            if not dataset_id = @@bigml._check_resource_id(dataset, :dataset)
                return
            end

            return @@bigml._get("%s%s" % [BigML::BIGML_URL, dataset_id])
        end

        def list(query_string='')
            # List all your datasets.
            return @@bigml._list(BigML::DATASET_URL, query_string)
        end

        def update(dataset, changes)
            # Update a dataset.
            if not dataset_id = @@bigml._check_resource_id(dataset, :dataset)
                return
            end

            body = changes.to_json
            return @@bigml._update("%s%s" % [BigML::BIGML_URL, dataset_id], body)
        end

        def delete(dataset)
            # Delete a dataset.
            if not dataset_id = @@bigml._check_resource_id(dataset, :dataset)
                return
            end

            return @@bigml._delete("%s%s" % [BigML::BIGML_URL, dataset_id])
        end

        def get_fields(dataset)
            # Get fields from dataset
            return @@bigml._get_fields(dataset)
        end

        def status(dataset)
            # Get dataset's status
            return @@bigml._status(dataset)
        end
    end
end

