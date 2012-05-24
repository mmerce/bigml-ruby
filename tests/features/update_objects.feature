Feature: Update Objects' attributes

    Scenario Outline: Successfully updating sources' attributes
        Given I create a data source uploading a "<data>" file
        And I wait until the source is ready less than <time_1> secs
        And I create a dataset
        And I wait until the dataset is ready less than <time_1> secs
        And I create a model
        And I wait until the model is ready less than <time_1> secs
        And I create a prediction for "<data_input>"
        When I update source's name to "<source_name>" and locale to "<locale>"
        And I update dataset's name to "<dataset_name>"
        And I update model's name to "<model_name>"
        And I update prediction's name to "<prediction_name>"
        Then the source's name has changed to "<source_name>" and locale has changed to "<locale>"
        And the dataset's name has changed to "<dataset_name>"
        And the model's name has changed to "<model_name>"
        And the prediction's name has changed to "<prediction_name>"
        Examples:
        | data                | time_1  | data_input |source_name    | dataset_name | model_name | prediction_name| locale |
        | ../data/iris.csv | 10      | {'petal length' => 1}| iris new source | iris new dataset | iris new model | iris new prediction | es-ES |

