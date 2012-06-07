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
# Sources
# https://bigml.com/developers/sources
#
##########################################################################
require 'bigml'

class BigMLSource 

    @@bigml = BigML.instance
    @resource_id = nil

    def initialize(source)
        # Initialize source instance.
        raise("A source id string is required to instantiate BigMLSource object") if source.nil?
        source = source.get_id if source.is_a? BigMLSource
        if source_id = @@bigml._check_resource_id(source, :source)
            @resource_id = source_id
        else 
            raise("A valid source id string is required to instantiate BigMLSource object")
        end
    end

    def get_id
        # get source's id
        return @resource_id
    end

    def get
        # get source's info 
        return BigMLSource.get(@resource_id) if not @resource_id.nil?
    end

    def update(changes)
        # update source's properties
        return BigMLSource.update(@resource_id, changes) if not @resource_id.nil?
    end

    def delete
        # delete source
        return BigMLSource.delete(@resource_id) if not @resource_id.nil?
    end

    def get_fields
        # get source's fields
       return BigMLSource.get_fields(@resource_id) if not @resource_id.nil?
    end

    def status
        # get source's status
        return BigMLSource.status(@resource_id) if not @resource_id.nil?
    end

    class << self

        def create(file_name, args=nil)
            # create a new source and instantiate the corresponding object
            source = BigMLSource.create_resource(file_name, args)
            return BigMLSource.new(source[:resource])
        end

        def create_resource(file_name, args=nil)
            # Create a new source.
            if args != nil and args.include? :source_parser
                args[:source_parser] = args[:source_parser].to_json
            end

            return @@bigml._create(BigML::SOURCE_URL, {:file => File.new(Dir.pwd+'/'+file_name)}, args)
        end

        def get(source)
            # Retrieve a source.
            if not source_id = @@bigml._check_resource_id(source, :source)
                return
            end

            return @@bigml._get("#{BigML::BIGML_URL}#{source_id}")
        end

        def list(query_string='')
            # List all your sources.
            return @@bigml._list(BigML::SOURCE_URL, query_string)
        end

        def update(source, changes)
            # Update a source.
            if not source_id = @@bigml._check_resource_id(source, :source)
                return
            end

            body = changes.to_json
            return @@bigml._update("#{BigML::BIGML_URL}#{source_id}", body)
        end

        def delete(source)
            # Delete a source.
            if not source_id = @@bigml._check_resource_id(source, :source)
                return
            end

            return @@bigml._delete("#{BigML::BIGML_URL}#{source_id}")
        end

        def get_fields(source)
            # Get fields from source
            return @@bigml._get_fields(source)
        end

        def status(source)
            # Get source's status
            return @@bigml._status(source)
        end
    end
end 

