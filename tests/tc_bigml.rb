require 'test/unit'
require 'rubygems'
require 'bigml'

class TestBigML < Test::Unit::TestCase

    def setup
        @source_fields = {:"000002"=>{:optype=>"numeric", :name=>"petal length", :column_number=>2},
                   :"000003"=>{:optype=>"numeric", :name=>"petal width", :column_number=>3}, 
                   :"000000"=>{:optype=>"numeric", :name=>"sepal length", :column_number=>0}, 
                   :"000004"=>{:optype=>"categorical", :name=>"species", :column_number=>4}, 
                   :"000001"=>{:optype=>"numeric", :name=>"sepal width", :column_number=>1}}

        @dataset_fields = {:"000000"=>{:column_number=>0, :summary=>{:sum_squares=>5223.85, :maximum=>7.9, :median=>5.77889, :missing_count=>0, :minimum=>4.3, :population=>150, :sum=>876.5, :splits=>[4.51526, 4.67252, 4.81113, 4.89582, 4.96139, 5.01131, 5.05992, 5.11148, 5.18177, 5.35681, 5.44129, 5.5108, 5.58255, 5.65532, 5.71658, 5.77889, 5.85381, 5.97078, 6.05104, 6.13074, 6.23023, 6.29578, 6.35078, 6.41459, 6.49383, 6.63013, 6.70719, 6.79218, 6.92597, 7.20423, 7.64746]}, :name=>"sepal length", :optype=>"numeric", :datatype=>"double"}, :"000004"=>{:column_number=>4, :summary=>{:categories=>[["Iris-versicolor", 50], ["Iris-setosa", 50], ["Iris-virginica", 50]], :missing_count=>0}, :name=>"species", :optype=>"categorical", :datatype=>"string"}, :"000002"=>{:column_number=>2, :summary=>{:sum_squares=>2582.71, :maximum=>6.9, :median=>4.34142, :missing_count=>0, :minimum=>1, :population=>150, :sum=>563.7, :splits=>[1.25138, 1.32426, 1.37171, 1.40962, 1.44567, 1.48173, 1.51859, 1.56301, 1.6255, 1.74645, 3.23033, 3.675, 3.94203, 4.0469, 4.18243, 4.34142, 4.45309, 4.51823, 4.61771, 4.72566, 4.83445, 4.93363, 5.03807, 5.1064, 5.20938, 5.43979, 5.5744, 5.6646, 5.81496, 6.02913, 6.38125]}, :name=>"petal length", :optype=>"numeric", :datatype=>"double"}, :"000001"=>{:column_number=>1, :summary=>{:sum_squares=>1430.4, :maximum=>4.4, :counts=>[[2, 1], [2.2, 3], [2.3, 4], [2.4, 3], [2.5, 8], [2.6, 5], [2.7, 9], [2.8, 14], [2.9, 10], [3, 26], [3.1, 11], [3.2, 13], [3.3, 6], [3.4, 12], [3.5, 6], [3.6, 4], [3.7, 3], [3.8, 6], [3.9, 2], [4, 1], [4.1, 1], [4.2, 1], [4.4, 1]], :median=>3.02044, :missing_count=>0, :minimum=>2, :population=>150, :sum=>458.6}, :name=>"sepal width", :optype=>"numeric", :datatype=>"double"}, :"000003"=>{:column_number=>3, :summary=>{:sum_squares=>302.33, :maximum=>2.5, :counts=>[[0.1, 5], [0.2, 29], [0.3, 7], [0.4, 7], [0.5, 1], [0.6, 1], [1, 7], [1.1, 3], [1.2, 5], [1.3, 13], [1.4, 8], [1.5, 12], [1.6, 4], [1.7, 2], [1.8, 12], [1.9, 5], [2, 6], [2.1, 6], [2.2, 3], [2.3, 8], [2.4, 3], [2.5, 3]], :median=>1.32848, :missing_count=>0, :minimum=>0.1, :population=>150, :sum=>179.9}, :name=>"petal width", :optype=>"numeric", :datatype=>"double"}}
        
    end

    def test_prediction_create

        # source testing
        source = BigMLSource.create('../data/iris.csv')
        assert(source.is_a?(BigMLSource) &&  !source.id.nil?, "create: source creation failure")
        assert_equal(source.id, source.get[:resource], "get: source properties retrieval failure")
        assert_equal(@source_fields, source.fields, "fields: source's fields retrieval failure")
        assert_equal('new name', source.update({:name => 'new name'})[:object][:name], "update: source properties update failure")
        assert(BigML::STATUSES.has_value?(source.status), "status: <"+source.status+"> source's status retrieval failure")

        # dataset testing
        dataset = BigMLDataset.create(source)
        assert(dataset.is_a?(BigMLDataset) &&  !dataset.id.nil?, "create: dataset creation failure")
        assert_equal(dataset.id, dataset.get[:resource], "get: dataset properties retrieval failure")
        assert_equal(@dataset_fields, dataset.fields, "fields: dataset's fields retrieval failure")
        assert_equal('new name', dataset.update({:name => 'new name'})[:object][:name], "update: dataset properties update failure")
        assert(BigML::STATUSES.has_value?(dataset.status), "status: <"+dataset.status+"> dataset's status retrieval failure")

        # model testing
        model = BigMLModel.create(dataset)
        assert(model.is_a?(BigMLModel) &&  !model.id.nil?, "create: model creation failure")
        assert_equal(model.id, model.get[:resource], "get: model properties retrieval failure")
        assert_equal('new name', model.update({:name => 'new name'})[:object][:name], "update: model properties update failure")
        assert(BigML::STATUSES.has_value?(model.status), "status: <"+model.status+"> model's status retrieval failure")

        # prediction testing
        prediction = BigMLPrediction.create(model, {'sepal length' => 5, 
                                                    'sepal width' => 2.5})
        assert(prediction.is_a?(BigMLPrediction) &&  !prediction.id.nil?, "create: prediction creation failure")
        assert_equal(prediction.id, prediction.get[:resource], "get: prediction properties retrieval failure")
        assert_equal('new name', prediction.update({:name => 'new name'})[:object][:name], "update: prediction properties update failure")
        assert(BigML::STATUSES.has_value?(prediction.status), "status: <"+prediction.status+"> prediction's status retrieval failure")

        # test listing
        list = BigMLSource.list("resource="+source.id)[:objects][0][:resource]
        assert(list.include?(source.id), "list: source's list could not be retrieved")
        list = BigMLDataset.list("resource="+dataset.id)[:objects][0][:resource]
        assert(list.include?(dataset.id), "list: dataset's list could not be retrieved")
        list = BigMLModel.list("resource="+model.id)[:objects][0][:resource]
        assert(list.include?(model.id), "list: model's list could not be retrieved")
        list = BigMLPrediction.list("resource="+prediction.id)[:objects][0][:resource]
        assert(list.include?(prediction.id), "list: prediction's list could not be retrieved")

        # test resources's deletion
        source.delete
        assert_equal(nil, source.get[:resource], "delete: source could not be deleted")
        dataset.delete
        assert_equal(nil, dataset.get[:resource], "delete: dataset could not be deleted")
        model.delete
        assert_equal(nil, model.get[:resource], "delete: model could not be deleted")
        prediction.delete
        assert_equal(nil, prediction.get[:resource], "delete: prediction could not be deleted")

    end

end
