When /I update source's name to "(.*)" and locale to "(.*)"/ do |name, locale|
    changes = {:name => name, :source_parser => {:locale => locale}}
    @source = BigMLSource.update(@source, changes)
end

Then /the source's name has changed to "(.*)" and locale has changed to "(.*)"/ do |name, locale|
    assert_equal(@source[:object][:name], name)
    assert_equal(@source[:object][:source_parser][:locale], locale)
end

Then /the (dataset|model|prediction)'s name has changed to "(.*)"/ do |object, name|
    @object = eval("@%s" % object)
    @object = eval("BigML%s.get(@object[:resource])" % object.capitalize())
    assert_equal(@object[:object][:name], name)
end

And /I update (dataset|model|prediction)'s name to "(.*)"/ do |object, name|
    changes = {:name => name}
    @object = eval("@%s" % object)
    @object = eval("BigML%s.update(@object, changes)" % object.capitalize())
end
