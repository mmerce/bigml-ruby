# encoding: utf-8
#!/usr/bin/env ruby

module BigMLConstants

    # Base URL
    BIGML_URL = "https://bigml.io/andromeda/"

    SOURCE_PATH = 'source'
    DATASET_PATH = 'dataset'
    MODEL_PATH = 'model'
    PREDICTION_PATH = 'prediction'

    # Base Resource URLs
    SOURCE_URL = BIGML_URL + SOURCE_PATH
    DATASET_URL = BIGML_URL + DATASET_PATH
    MODEL_URL = BIGML_URL + MODEL_PATH
    PREDICTION_URL = BIGML_URL + PREDICTION_PATH

    SOURCE_RE = Regexp.new '^%s\/[a-f,0-9]{24}$' % SOURCE_PATH
    DATASET_RE = Regexp.new '^%s\/[a-f,0-9]{24}$' % DATASET_PATH
    MODEL_RE = Regexp.new '^%s\/[a-f,0-9]{24}$' % MODEL_PATH
    PREDICTION_RE = Regexp.new '^%s\/[a-f,0-9]{24}$' % PREDICTION_PATH

    # Headers
    SEND_JSON = {:content_type => 'application/json;charset=utf-8'}
    ACCEPT_JSON = {:accept => 'application/json;charset=utf-8'}

    # HTTP Status Codes
    HTTP_OK = 200
    HTTP_CREATED = 201
    HTTP_ACCEPTED = 202
    HTTP_NO_CONTENT = 204
    HTTP_BAD_REQUEST = 400
    HTTP_UNAUTHORIZED = 401
    HTTP_PAYMENT_REQUIRED = 402
    HTTP_FORBIDDEN = 403
    HTTP_NOT_FOUND = 404
    HTTP_METHOD_NOT_ALLOWED = 405
    HTTP_LENGTH_REQUIRED = 411
    HTTP_INTERNAL_SERVER_ERROR = 500

    # Resource status codes
    WAITING = 0
    QUEUED = 1
    STARTED = 2
    IN_PROGRESS = 3
    SUMMARIZED = 4
    FINISHED = 5
    FAULTY = -1
    UNKNOWN = -2
    RUNNABLE = -3

    STATUSES = {
        WAITING => "WAITING",
        QUEUED => "QUEUED",
        STARTED => "STARTED",
        IN_PROGRESS => "IN_PROGRESS",
        SUMMARIZED => "SUMMARIZED",
        FINISHED => "FINISHED",
        FAULTY => "FAULTY",
        UNKNOWN => "UNKNOWN",
        RUNNABLE => "RUNNABLE"
    }
end
