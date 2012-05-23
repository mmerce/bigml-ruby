require 'rubygems'
require 'bigml'

list = BigMLSource.list('name=iris.csv')
if not list.nil?
  list[:objects].each() { |object|
      BigMLSource.delete(object[:resource])
  }
end
list = BigMLDataset.list('name=iris\'%20dataset')
if not list.nil?
  list[:objects].each() { |object|
      BigMLDataset.delete(object[:resource])
  }
end
list = BigMLModel.list('name=iris\'%20dataset%20model')
if not list.nil?
  list[:objects].each() { |object|
      BigMLModel.delete(object[:resource])
  }
end
list = BigMLPrediction.list('name=Prediction%20for%20species')

if not list.nil?
  list[:objects].each() { |object|
      BigMLPrediction.delete(object[:resource])
  }
end
