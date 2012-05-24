require 'rubygems'
require 'bigml'

list = BigMLSource.list('name=iris.csv')
if not list.nil?
  list[:objects].each() { |object|
      BigMLSource.update(object, {:name => "iris source", :source_parser => { :locale => "es-ES"}})
  }
end
list = BigMLDataset.list('name=iris\'%20dataset')
if not list.nil?
  list[:objects].each() { |object|
      BigMLDataset.update(object, {:name => "new iris dataset"})
  }
end
list = BigMLModel.list('name=iris\'%20dataset%20model')
if not list.nil?
  list[:objects].each() { |object|
      BigMLModel.update(object, {:name => "new iris dataset model"})
  }
end
list = BigMLPrediction.list('name=Prediction%20for%20species')

if not list.nil?
  list[:objects].each() { |object|
      BigMLPrediction.update(object, {:name => "new prediction for species"})
  }
end
