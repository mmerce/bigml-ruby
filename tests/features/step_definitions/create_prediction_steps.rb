
Given /I create a data source uploading a "(.*)" file$/ do |file|
    @source = BigMLSource.create_resource(file)
end

And /I wait until the (source|dataset|model|prediction) is ready less than (\d+)/ do |object, secs|
    start = Time.now
    code1 = BigML::FINISHED
    code2 = BigML::FAULTY
    @object = eval("@%s" % [object])
    while (@object[:object][:status][:code] != code1 and
       @object[:object][:status][:code] != code2 and
       Time.now - start < secs.to_i) do
       sleep(3)
       @object = eval("BigML%s.get(@object[:resource])" % [object.capitalize])
    end
    assert_equal(@object[:object][:status][:code], code1)
end

And /I create a dataset$/ do

    @dataset = BigMLDataset.create_resource(@source[:resource])
end

And /I create a model$/ do

    @model = BigMLModel.create_resource(@dataset[:resource])
end

And /I create a prediction for "(.*)"/ do |data|
    @prediction = BigMLPrediction.create_resource(@model[:resource], eval(data))
end

Then /the prediction for "(.*)" is "(.*)"/ do |objective, prediction|
    assert_equal(@prediction[:object][:prediction][objective.to_sym], prediction)
end
