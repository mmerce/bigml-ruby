# BigML.io Ruby bindings

In this repository you'll find an open source Ruby module that gives
you a simple binding to interact with [BigML](https://bigml.io). You
can use it to easily create, retrieve, list, update, and delete BigML
resources (i.e., sources, datasets, models and, predictions).

This module is licensed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Support

Please, report problems and bugs to our
[BigML.io issue tracker](https://github.com/bigmlcom/io/issues)

Discussions about the different bindings take place in the general
[BigML mailing list](http://groups.google.com/group/bigml). Or join us
in our [Campfire chatroom](https://bigmlinc.campfirenow.com/f20a0)

## Requirements

The only mandatory dependencies are the
[json](http://rubygems.org/gems/json) and [rest-client] (http://rubygems.org/gems/rest-client) gems that can be installed via rubygems. 

## Installation

To install:

Build your own gem

```bash
$ gem build bigml.gemspec
```
and install the bindings
```bash
$ gem install bigml-0.0.1.gem
```

## Importing the module

```ruby
require 'rubygems'
require 'bigml'
```

```
## Authentication

All the requests to BigML.io must be authenticated using your username
and [API key](https://bigml.com/account/apikey) and are always
transmitted over HTTPS.

This module will look for your username and API key in the environment
variables `BIGML_USERNAME` and `BIGML_API_KEY` respectively.  You can
add the following lines to your `.bashrc` or `.bash_profile` to set
those variables automatically when you log in:


```bash
export BIGML_USERNAME=myusername
export BIGML_API_KEY=ae579e7e53fb9abd646a6ff8aa99d4afe83ac291
```

With that environment set up, connection to BigML will be automatically 
initialized when needed. Otherwise, you can autenticate explicitly
by instantiating the BigML class as follows.


```ruby
connection = BigML.instance.authenticate('myusername','ae579e7e53fb9abd646a6ff8aa99d4afe83ac291')
```

## Running the Tests

To run the tests you will need to install:
[cucumber](http://rubygems.org/gems/cucumber) and [test-unit](http://rubygems.org/gems/test-unit) gems.

```bash
$ gem install cucumber
$ gem install test-unit
```

and set up your authentication via environment variables, as explained
above.  With that in place, you can run the test suite simply by:

```bash
$ cd tests
$ cucumber
```

## Quick Start

Imagine that you want to use
[this csv file](https://static.bigml.com/csv/iris.csv) containing the
[Iris flower dataset](http://en.wikipedia.org/wiki/Iris_flower_data_set)
to predict the species of a flower whose `sepal length` is `5` and
whose `sepal width` is `2.5`. A preview of the dataset is shown
below. It has 4 numeric fields: `sepal length`, `sepal width`, `petal
length`, `petal width` and a categorical field: `species`. By default,
BigML considers the last field in the dataset as the objective field
(i.e., the field that you want to generate predictions for).

```csv
sepal length,sepal width,petal length,petal width,species
5.1,3.5,1.4,0.2,Iris-setosa
4.9,3.0,1.4,0.2,Iris-setosa
4.7,3.2,1.3,0.2,Iris-setosa
...
5.8,2.7,3.9,1.2,Iris-versicolor
6.0,2.7,5.1,1.6,Iris-versicolor
5.4,3.0,4.5,1.5,Iris-versicolor
...
6.8,3.0,5.5,2.1,Iris-virginica
5.7,2.5,5.0,2.0,Iris-virginica
5.8,2.8,5.1,2.4,Iris-virginica
```

You can easily generate a prediction following these steps:

```ruby
require 'rubygems'
require 'bigml'

source = BigMLSource.create('./data/iris.csv')
dataset = BigMLDataset.create(source)
model = BigMLModel.create(dataset)
prediction = BigMLPrediction.create(model, {'sepal length' => 5, 'sepal width' => 2.5})
```

## Fields

BigML automatically generates idenfiers for each field. To see the
fields and the ids and types that have been assigned to a source you
can use `get_fields`:

```ruby
require 'rubygems'
require 'bigml'
require 'pp'

source = BigMLSource.create('./data/iris.csv')
pp BigMLSource.get_fields(source)
```

and you'll get:

```ruby
{:"000001"=>{:column_number=>1, :optype=>"numeric", :name=>"sepal width"},
 :"000002"=>{:column_number=>2, :optype=>"numeric", :name=>"petal length"},
 :"000003"=>{:column_number=>3, :optype=>"numeric", :name=>"petal width"},
 :"000000"=>{:column_number=>0, :optype=>"numeric", :name=>"sepal length"},
 :"000004"=>{:column_number=>4, :optype=>"categorical", :name=>"species"}}
=> nil
```

## Dataset

If you want to get some basic statistics for each field you can
retrieve the `fields` from the dataset as follows:

```ruby
dataset = BigMLDataset.get(dataset)
pp BigMLDataset.get_fields(dataset)
```

You will get a dictionary keyed by field id:

```ruby
{:"000001"=>
  {:column_number=>1,
   :optype=>"numeric",
   :summary=>
    {:sum_squares=>1430.4,
     :median=>3.02044,
     :counts=>
      [[2, 1],
       [2.2, 3],
       [2.3, 4],
       [2.4, 3],
       [2.5, 8],
       [2.6, 5],
       [2.7, 9],
       [2.8, 14],
       [2.9, 10],
       [3, 26],
       [3.1, 11],
       [3.2, 13],
       [3.3, 6],
       [3.4, 12],
       [3.5, 6],
       [3.6, 4],
       [3.7, 3],
       [3.8, 6],
       [3.9, 2],
       [4, 1],
       [4.1, 1],
       [4.2, 1],
       [4.4, 1]],
     :minimum=>2,
     :missing_count=>0,
     :population=>150,
     :sum=>458.6,
     :maximum=>4.4},
   :name=>"sepal width",
   :datatype=>"double"},
 :"000002"=>
  {:column_number=>2,
   :optype=>"numeric",
   :summary=>
    {:sum_squares=>2582.71,
     :median=>4.34142,
     :minimum=>1,
     :missing_count=>0,
     :population=>150,
     :sum=>563.7,
     :splits=>
      [1.25138,
       1.32426,
       1.37171,
       1.40962,
       1.44567,
       1.48173,
       1.51859,
       1.56301,
       1.6255,

        ...  (snippet) ...

 :"000004"=>
  {:column_number=>4,
   :optype=>"categorical",
   :summary=>
    {:categories=>
      [["Iris-versicolor", 50], ["Iris-setosa", 50], ["Iris-virginica", 50]],
     :missing_count=>0},
   :name=>"species",
   :datatype=>"string"}}
=> nil
```

## Model

One of the greatest things about BigML is that the models that it
generates for you are fully white-boxed. To get the model for the
example above you can retrieve it as follows:

```ruby
model = BigMLModel.get(model)
pp model[:object][:model][:root]
```

You will get a explicit tree-like predictive model:

```ruby
{:count=>150,
 :distribution=>
  [["Iris-virginica", 50], ["Iris-versicolor", 50], ["Iris-setosa", 50]],
 :children=>
  [{:count=>100,
    :distribution=>[["Iris-virginica", 50], ["Iris-versicolor", 50]],
    :children=>
     [{:count=>48,
       :distribution=>[["Iris-virginica", 46], ["Iris-versicolor", 2]],
       :children=>
        [{:count=>38,
          :distribution=>[["Iris-virginica", 38]],
          :leaf=>true,
          :predicate=>{:value=>5.05, :field=>"000002", :operator=>">"},
          :output=>"Iris-virginica"},
         {:count=>10,
          :distribution=>[["Iris-virginica", 8], ["Iris-versicolor", 2]],
          :children=>
           [{:count=>4,
             :distribution=>[["Iris-virginica", 2], ["Iris-versicolor", 2]],
             :children=>
              [{:count=>3,
                :distribution=>[["Iris-virginica", 2], ["Iris-versicolor", 1]],
                :children=> ... (snippet) ...            
```

(Note that we have abbreviated the output in the snippet above for
readability: the full predictive model you'll get is going to contain
much more details).

## Creating Resources

Newly-created resources are returned in a dictionary with the
following keys:

* **code**: If the request is successful you will get a
    `bigml.api.HTTP_CREATED` (201) status code. Otherwise, it will be
    one of the standard HTTP error codes
    [detailed in the documentation](https://bigml.com/developers/status_codes).
* **resource**: The identifier of the new resource.
* **location**: The location of the new resource.
* **object**: The resource itself, as computed by BigML.
* **error**: If an error occurs and the resource cannot be created, it
    will contain an additional code and a description of the error. In
    this case, **location**, and **resource** will be `None`.

### Statuses

Please, bear in mind that resource creation is almost always
asynchronous (**predictions** are the only exception). Therefore, when
you create a new source, a new dataset or a new model, even if you
receive an immediate response from the BigML servers, the full
creation of the resource can take from a few seconds to a few days,
depending on the size of the resource and BigML's load. A resource is
not fully created until its status is `BigMLConstants::FINISHED`. See the
[documentation on status codes](https://bigml.com/developers/status_codes)
for the listing of potential states and their semantics.  So depending
on your application you might need to use the following constants.

```ruby
BigMLConstants::WAITING
BigMLConstants::QUEUED
BigMLConstants::STARTED
BigMLConstants::IN_PROGRESS
BigMLConstants::SUMMARIZED
BigMLConstants::FINISHED
BigMLConstants::FAULTY
BigMLConstants::UNKNOWN
BigMLConstants::RUNNABLE
```





---------------------- TODO: change from python to ruby ------------------





You can query the status of any resource with the `status` method.

```python
api.status(source)
api.status(dataset)
api.status(model)
api.status(prediction)
```

Before invoking the creation of a new resource, the library checks
that the status of the resource that is passed as a parameter is
`FINISHED`. You can change how often the status will be checked with
the `wait_time` argument. By default, it is set to 3 seconds.

### Creating sources

To create a source from a local data file, you can use the
`create_source` method. The only required parameter is the path to the
data file. You can use a second optional parameter to specify any of
the options for source creation described in the
[BigML API documentation](https://bigml.com/developers/sources).

Here's a sample invocation:

```python

from bigml.api import BigML
api = BigML()

source = api.create_source('./data/iris.csv',
    {'name': 'my source', 'source_parser': {'missing_tokens': ['?']}})
```

As already mentioned, source creation is asynchronous: the initial
resource status code will be either `WAITING` or `QUEUED`. You can
retrieve the updated status at any time using the corresponding get
method. For example, to get the status of our source we would use:

```python
api.status(source)
```

### Creating datasets

Once you have created a source, you can create a dataset. The only
required argument to create a dataset is a source id. You can add all
the additional arguments accepted by BigML and documented
[here](https://bigml.com/developers/datasets).

For example, to create a dataset named "my dataset" with the first
1024 bytes of a source, you can submit the following request:

```python
dataset = api.create_dataset(source, {"name": "my dataset", "size": 1024})
```

Upon success, the dataset creation job will be queued for execution,
and you can follow its evolution using `api.status(dataset)`.

### Creating models

Once you have created a dataset, you can create a model. The only
required argument to create a model is a dataset id. You can also
include in the request all the additional arguments accepted by BigML
and documented [here](https://bigml.com/developers/models).

For example, to create a model only including the first two fields and
the first 10 instances in the dataset, you can use the following
invocation:

```python
model = api.create_model(dataset, {
    "name": "my model", "input_fields": ["000000", "000001"], "range": [1, 10]})
```

Again, the model is scheduled for creation, and you can retrieve its
status at any time by means of `api.status(model)` .

### Creating predictions

You can now use the model resource identifier together with some input
parameters to ask for predictions, using the `create_prediction`
method. You can also give the prediction a name.

```python
prediction = api.create_prediction(model,
                                   {"sepal length": 5,
                                    "sepal width": 2.5},
                                    {"name": "my prediction"})
```

To see the prediction you can use `pprint`:

```python
api.pprint(prediction)
```

## Reading Resources

When retrieved individually, resources are returned as a dictionary
identical to the one you get when you create a new resource. However,
the status code will be `bigml.api.HTTP_OK` if the resource can be
retrieved without problems, or one of the HTTP standard error codes
otherwise.

## Listing Resources

You can list resources with the appropriate api method:

```python
api.list_sources()
api.list_datasets()
api.list_models()
api.list_predictions()
```

you will receive a dictionary with the following keys:

* **code**: If the request is successful you will get a
    `bigml.api.HTTP_OK` (200) status code. Otherwise, it will be one
    of the standard HTTP error codes. See
    [BigML documentation on status codes](https://bigml.com/developers/status_codes)
    for more info.
* **meta**: A dictionary including the following keys that can help
  you paginate listings:
    * **previous**: Path to get the previous page or `None` if there is
        no previous page.
    * **next**: Path to get the next page or `None` if there is no next
        page.
    * **offset**: How far off from the first entry in the resources is
        the first one listed in the resources key.
    * **limit**: Maximum number of resources that you will get listed
        in the resources key.
    * **total_count**: The total number of resources in BigML.
* **objects**: A list of resources as returned by BigML.
* **error**: If an error occurs and the resource cannot be created, it
    will contain an additional code and a description of the error. In
    this case, **meta**, and **resources** will be `None`.

### Filtering Resources

You can filter resources in listings using the syntax and fields
labeled as *filterable* in the
[BigML documentation](https://bigml.com/developers) for each resource.

A few examples:

#### Ids of the first 5 sources created before April 1st, 2012

```python
[source['resource'] for source in
  api.list_sources("limit=5;created__lt=2012-04-1")['objects']]
```

#### Name of the first 10 datasets bigger than 1MB

```python
[dataset['name'] for dataset in
  api.list_datasets("limit=10;size__gt=1048576")['objects']]
```

#### Name of models with more than 5 fields (columns)

```python
[model['name'] for model in api.list_models("columns__gt=5")['objects']]
```

#### Ids of predictions whose model has not been deleted

```python
[prediction['resource'] for prediction in
  api.list_predictions("model_status=true")['objects']]
```


### Ordering Resources

You can order resources in listings using the syntax and fields
labeled as *sortable* in the
[BigML documentation](https://bigml.com/developers) for each resource.

A few examples:

#### Name of sources ordered by size

```python
[source['name'] for source in api.list_sources("order_by=size")['objects']]
```

#### Number of instances in datasets created before April 1st, 2012 ordered by size

```python
[dataset['rows'] for dataset in
  api.list_datasets("created__lt=2012-04-1;order_by=size")['objects']]
```

#### Model ids ordered by number of predictions (in descending order).

```python
[model['resource'] for model in
  api.list_models("order_by=-number_of_predictions")['objects']]
```

#### Name of predictions ordered by name.

```python
[prediction['name'] for prediction in
  api.list_predictions("order_by=name")['objects']]
```

## Updating Resources

When you update a resource, it is returned in a dictionary exactly
like the one you get when you create a new one. However the status
code will be `bigml.api.HTTP_ACCEPTED` if the resource can be updated
without problems or one of the HTTP standard error codes otherwise.

```python
api.update_source(source, {"name": "new name"})
api.update_dataset(dataset, {"name": "new name"})
api.update_model(model, {"name": "new name"})
api.update_prediction(prediction, {"name": "new name"})
```

## Deleting Resources

Resources can be deleted individually using the corresponding method
for each type of resource.

```python
api.delete_source(source)
api.delete_dataset(dataset)
api.delete_model(model)
api.delete_prediction(prediction)
```

Each of the calls above will return a dictionary with the following
keys:

* **code** If the request is successful, the code will be a
  `bigml.api.HTTP_NO_CONTENT` (204) status code. Otherwise, it wil be
  one of the standard HTTP error codes. See the
  [documentation on status codes](https://bigml.com/developers/status_codes)
  for more info.
* **error** If the request does not succeed, it will contain a
  dictionary with an error code and a message. It will be `None`
  otherwise.